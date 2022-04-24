# precheck data
  options("encoding" = "native.enc")
  library(jsonlite)
  library(tableHTML)
  library(dplyr)
  library(crayon)
  ligSilver <- make_style("#889988")
  lime <- make_style("#10ff10")
  gold <- make_style("#eeae00")
  purple <- make_style("#9400D3")
  deeppink <- make_style("#FF1493")
  darkgreen <- make_style("#004000")
  magenta  <- make_style("#800080")
  orange  <- make_style("#D93B6A")
  pink  <- make_style("#E98B8A") # note dont change this code
  brown  <- make_style("#B8937C")
  gray  <- make_style("#403E5D")
  blue  <- make_style("#12BBEC")

  dirStr = "C:/R programs/!!! STKMon !!!"
  setwd(dirStr)
  source("outputbuf.R", encoding="UTF-8")
  source("intenMonCheckKline.R", encoding="UTF-8")
  theHeader = "http://web.ifzq.gtimg.cn/appstock/app/hkfqkline/get?_var=kline_dayqfq&param=hk"
  theTail = ",day,,,10,qfq"  # 10 days
  tempChiName = character()
  klinereport = character()
  turnUpList = character()
  outputBuffer = character()
  matrixNcol = 12
  resultTable <- matrix(,ncol=matrixNcol, nrow=0)
  colnames(resultTable) = c("stkcode", "chiname", "Amt_wan","AmtDif%","C-LWAv%","pLWAv%","L-WAv%","H-WAv%","Msg2", "Msg4", "Msg6", "Msg8")
  arrayDate = format(Sys.Date(), format="%Y-%m-%d")
  allthecodes = character()
  alltheAmtcodeDiff = character()
  alltheAmtcodeDiffRange = character()
   # calcWAve
    calcWAve = function(theArray) { # calculate the WMA value
      sum = 0
      for( i in 1:length(theArray) ) {sum = sum + theArray[i] * i;}
      return (as.numeric(format3digit(sum / ((1 + length(theArray))*length(theArray)/2))))
    }
   # format4digit, note return a string
    format4digit = function(value){ sprintf(value, fmt = '%#.4f')}
   # format3digit
    format3digit  = function(value){ sprintf(value, fmt = '%#.3f')}
   # format1digit
    format1digit  = function(value){ sprintf(value, fmt = '%#.1f')}

 # checkTP(pprevC, prevC, curC)
  checkTP = function(pprevC, prevC, curC, trigValue){
    maxv = max(pprevC, prevC, curC)
    minv = min(pprevC, prevC, curC)
    diff = maxv- minv
    if ((pprevC >= prevC)&&(prevC < curC)){return("turn UP")
    }else if ((pprevC <= prevC)&&(prevC > curC)){return("turn DN")
    }else if ((pprevC < prevC)&&(prevC < curC)){return("keep UP")
    }else if ((pprevC > prevC)&&(prevC > curC)){return("keep DN")
    }else{return("")}
  }


 # rmItems(fmList, itemList) remove itemList from fmList
  rmItems <- function(fmList, itemList){
        commons = unique(fmList[fmList %in% itemList])
        for(item in commons){fmList = fmList[-(which(fmList == item))]}
        return(fmList)
  }

# FetchHKKline reads url, convert to data.frame, cal all parameters and detections
  FetchHKKline <- function(onecode){
     cat(".")
	thepage = readLines(paste0(theHeader,onecode,theTail), encoding="GB2312", warn=FALSE)	# data contain header and trailer
	thepage = gsub('kline_dayqfq=', "", thepage) # remove extra useless data
	thepage = fromJSON(thepage)
	# names(thepage) show the names of dataframe
	thepage = thepage["data"]
	thename = names(thepage[["data"]]) # hk03800
	thepage = thepage[["data"]]

	thepage = thepage[[thename]]
	datapage = thepage[[names(thepage[1])]]

  # extract name
	namepage = thepage[[names(thepage[2])]]
	namepage = namepage[1]
	chiName = namepage[[1]][2]
	tempChiName <<- gsub('\\u' , '&#x', chiName)  
  #extract price and volumn details
     cat(tempChiName," ")
     if(length(datapage)<10){return("invalid")}
	for(i in 1:length(datapage)){
	  tempdata = datapage[[i]][-7]  # remove list inside list
       if(length(tempdata)>8){
         tempdata = tempdata[-10]
         tempdata = tempdata[-9]
       }
	  datapage[[i]]= tempdata  # still a list
	}
	datapage = matrix(unlist(datapage),ncol=8,byrow=TRUE)
	datapage = datapage[,-7]  # this is all zeros

	# array manipulation complete
	colnames(datapage) <- c("Date", "Open", "Close", "High", "Low", "Vol", "Amt")
     return(datapage)
  }

# init

  cat("\n\n")
  codetable = readLines("allcodes.txt")
  fraudSTK = readLines("fraudSTK.txt")
  codetable = rmItems(codetable, fraudSTK)
  ignoreSTK = readLines("ignoreList.txt")
  codetable = rmItems(codetable, ignoreSTK)

  cat("\nTotal stks: ", length(codetable),"\nWorking...\n")
  for(n in 1:length(codetable)){
      if(n%%80 == 0){cat("\n", n, ": ")}

      enterCode = codetable[n]
      # remove 046xx
      enterCode = paste0("0000", enterCode)
      enterCode = substr(enterCode, nchar(enterCode)-5+1, nchar(enterCode))
      rmidx = grep("^046", enterCode)

      if((enterCode == "")|length(rmidx)>0) { 
       outputBuffer = c(outputBuffer, "\nwrong code\n")
       break
      }

    # working...
    thisCode = enterCode
    if(n%%80 == 0){cat("\n")}
    dataArray = FetchHKKline(enterCode) # note the return may be 11 rows
    if(dataArray != "invalid"){
      lastrow = nrow(dataArray)
      lastdayAmt = as.numeric(dataArray[lastrow,][7])
      plastdayAmt = as.numeric(dataArray[(lastrow-1),][7])
      lastdayAmtDiff = lastdayAmt - plastdayAmt

      dayClose = as.numeric(dataArray[lastrow,][3])
      if(lastrow >= 10 & dataArray[lastrow,1] == arrayDate & lastdayAmt>500){
        dayLowTable = dataArray[,5]
        dayLow = as.numeric(dayLowTable[lastrow])
        dayHighTable = dataArray[,4]
        dayHigh = as.numeric(dayHighTable[lastrow])

        amtTable = as.numeric(dataArray[,7])
        dayAmt = amtTable[lastrow]

          curC = as.numeric(dataArray[lastrow,3])
          trigValue = 0.001
          trigValue <- case_when(
            (curC >=200) ~ 0.2,
            (curC >=100 & curC <200) ~ 0.1,
            (curC >=20 & curC <100) ~ 0.05,
            (curC >=10 & curC <20) ~ 0.02,
            (curC >=0.5 & curC <10) ~ 0.01,
            (curC >=0.25 & curC <0.5) ~ 0.005,
            (curC >=0 & curC <0.25) ~ 0.001
           )

        # create Lwaves 2,4 6 8
        lastLWAve_2 = round(calcWAve(as.numeric(dayLowTable[(lastrow-1):lastrow])),3)
        prelastLWAve_2 = round(calcWAve(as.numeric(dayLowTable[(lastrow-2):(lastrow-1)])),3)
        pprelastLWAve_2 = round(calcWAve(as.numeric(dayLowTable[(lastrow-3):(lastrow-2)])),3)
        lastLWAve_4 = round(calcWAve(as.numeric(dayLowTable[(lastrow-3):lastrow])),3)
        prelastLWAve_4 = round(calcWAve(as.numeric(dayLowTable[(lastrow-4):(lastrow-1)])),3)
        pprelastLWAve_4 = round(calcWAve(as.numeric(dayLowTable[(lastrow-5):(lastrow-2)])),3)
        lastLWAve_6 = round(calcWAve(as.numeric(dayLowTable[(lastrow-5):lastrow])),3)
        prelastLWAve_6 = round(calcWAve(as.numeric(dayLowTable[(lastrow-6):(lastrow-1)])),3)
        pprelastLWAve_6 = round(calcWAve(as.numeric(dayLowTable[(lastrow-7):(lastrow-2)])),3)
        lastLWAve_8 = round(calcWAve(as.numeric(dayLowTable[(lastrow-7):lastrow])),3)
        prelastLWAve_8 = round(calcWAve(as.numeric(dayLowTable[(lastrow-8):(lastrow-1)])),3)
        pprelastLWAve_8 = round(calcWAve(as.numeric(dayLowTable[(lastrow-9):(lastrow-2)])),3)

        pLWAveDifPct = round( ((lastLWAve_2 - prelastLWAve_2)*100 /prelastLWAve_2), 1)
        L_WAveDifPct = round( ((dayLow - lastLWAve_2)*100 / lastLWAve_2), 1)
        H_LWAveDifPct = round( ((dayHigh - lastLWAve_2)*100 / lastLWAve_2), 1)
        pL_LDifPct = round( ((dayLow - as.numeric(dayLowTable[(lastrow-1)]))*100 / as.numeric(dayLowTable[(lastrow-1)])), 1)

        amtWAve =  round(calcWAve(amtTable),0)
        amtDifPct =  round( ((lastdayAmt - amtWAve)*100 / amtWAve), 0)

        dayCloseLWAvePct = round( ((dayClose - lastLWAve_2)*100 / lastLWAve_2), 1)

      # check the H waves
        # craete Hwaves 2,4 6 
        lastHWAve_2 = round(calcWAve(as.numeric(dayHighTable[(lastrow-1):lastrow])),3)
        prelastHWAve_2 = round(calcWAve(as.numeric(dayHighTable[(lastrow-2):(lastrow-1)])),3)
        pprelastHWAve_2 = round(calcWAve(as.numeric(dayHighTable[(lastrow-3):(lastrow-2)])),3)
        lastHWAve_4 = round(calcWAve(as.numeric(dayHighTable[(lastrow-3):lastrow])),3)
        prelastHWAve_4 = round(calcWAve(as.numeric(dayHighTable[(lastrow-4):(lastrow-1)])),3)
        pprelastHWAve_4 = round(calcWAve(as.numeric(dayHighTable[(lastrow-5):(lastrow-2)])),3)
        lastHWAve_6 = round(calcWAve(as.numeric(dayHighTable[(lastrow-5):lastrow])),3)
        prelastHWAve_6 = round(calcWAve(as.numeric(dayHighTable[(lastrow-6):(lastrow-1)])),3)
        pprelastHWAve_6 = round(calcWAve(as.numeric(dayHighTable[(lastrow-7):(lastrow-2)])),3)
        lastHWAve_8 = round(calcWAve(as.numeric(dayHighTable[(lastrow-7):lastrow])),3)
        prelastHWAve_8 = round(calcWAve(as.numeric(dayHighTable[(lastrow-8):(lastrow-1)])),3)
        pprelastHWAve_8 = round(calcWAve(as.numeric(dayHighTable[(lastrow-9):(lastrow-2)])),3)

        pHWAveDifPct = round( ((lastHWAve_2 - prelastHWAve_2)*100 /prelastHWAve_2), 1)
        H_HWAveDifPct = round( ((dayHigh - lastHWAve_2)*100 / lastHWAve_2), 1)


        # chk amtDif%, pLWAv%, L-WAv%
 
        if(amtDifPct>10 & pLWAveDifPct>0 & L_WAveDifPct> 0 & dayCloseLWAvePct>0 & pL_LDifPct>0 & dayClose > dayLow & lastdayAmtDiff>0){
           tempChiName = paste0('<k class="gold">  --- ', tempChiName, ' --- </k>')
           alltheAmtcodeDiff = c(alltheAmtcodeDiff, thisCode)
           alltheAmtcodeDiffRange = c(alltheAmtcodeDiffRange, round((dayHigh - dayLow)*100/dayLow,1))
        }else if(amtDifPct>10 & pLWAveDifPct>0 & L_WAveDifPct> 0 & dayCloseLWAvePct>0 & pL_LDifPct>0 & dayClose > dayLow){
           tempChiName = paste0('<k class="deeppink">  --- ', tempChiName, ' --- </k>')
        }else if(pLWAveDifPct>0 & pHWAveDifPct> 0 & lastdayAmt> 200 & H_HWAveDifPct>0& L_WAveDifPct> 0 & dayCloseLWAvePct>0 & pL_LDifPct>0){
           tempChiName = paste0('<k class="cyan">  -- ', tempChiName, ' -- </k>')
        }


        if(length(grep("--",tempChiName))>0){
          # chk Low tup, tdn
          checkTPMsg2 = checkTP(pprelastLWAve_2, prelastLWAve_2, lastLWAve_2, (trigValue/2))
          checkTPMsg4 = checkTP(pprelastLWAve_4, prelastLWAve_4, lastLWAve_4, (trigValue/2))
          checkTPMsg6 = checkTP(pprelastLWAve_6, prelastLWAve_6, lastLWAve_6, (trigValue/2))
          checkTPMsg8 = checkTP(pprelastLWAve_8, prelastLWAve_8, lastLWAve_8, (trigValue/2))

          TPMsg = xlateCheckTPMsg(checkTPMsg2,checkTPMsg4,checkTPMsg6,checkTPMsg8, thisCode, tempChiName)
          Msg2 = TPMsg[1]
          Msg4 = TPMsg[2]
          Msg6 = TPMsg[3]
          Msg8 = TPMsg[4]
          outputBufPart1(thisCode,tempChiName,dayClose,lastdayAmt,amtDifPct,pLWAveDifPct,L_WAveDifPct,H_LWAveDifPct,Msg2,Msg4,Msg6,Msg8)

          # chk High tup, tdn
          checkTPMsg2 = checkTP(pprelastHWAve_2, prelastHWAve_2, lastHWAve_2, (trigValue/2))
          checkTPMsg4 = checkTP(pprelastHWAve_4, prelastHWAve_4, lastHWAve_4, (trigValue/2))
          checkTPMsg6 = checkTP(pprelastHWAve_6, prelastHWAve_6, lastHWAve_6, (trigValue/2))
          checkTPMsg8 = checkTP(pprelastHWAve_8, prelastHWAve_8, lastHWAve_8, (trigValue/2))

          TPMsg = xlateCheckTPMsg(checkTPMsg2,checkTPMsg4,checkTPMsg6,checkTPMsg8,thisCode, tempChiName)
          Msg2 = TPMsg[1]
          Msg4 = TPMsg[2]
          Msg6 = TPMsg[3]
          Msg8 = TPMsg[4]

          outputBufPart2(pHWAveDifPct,H_HWAveDifPct,pL_LDifPct,Msg2,Msg4,Msg6,Msg8,dayCloseLWAvePct)
          allthecodes = c(allthecodes, thisCode)
        }
      }
    }
  }

  rangeTable = matrix()
  rangeTable = matrix(c(alltheAmtcodeDiff, alltheAmtcodeDiffRange), ncol = 2, byrow=FALSE)
  rangeTable <- rangeTable[order(as.numeric(rangeTable[,2]), decreasing = TRUE),]
  rangeTable5 <- rangeTable[as.numeric(rangeTable[, 2]) > 5,]

  totalCount = length(grep("onclick=changeCode",outputBuffer))
  tempdirStr = "C:/R programs/AstkAnalysis"
  setwd(tempdirStr)

  htmlPageHeader = readLines("htmlPageHeader.txt")
  htmlSScript = readLines("htmlSScript.txt")

  writedirStr = "C:/R programs/!!! STKMon !!!/resultTable"
  setwd(writedirStr)
  todayDate = format(Sys.Date(), format="%y%m%d")
  filename = paste0("checkStatus", todayDate, ".html")

  options("encoding" = "UTF-8")
  sink(filename)
         cat(htmlPageHeader, sep="\n")
         cat(format(Sys.time(), "%H:%M:%OSs "), format(Sys.Date(), format="%Y-%m-%d"), " Total: ",totalCount,"\n")
         cat(outputBuffer, sep="\n")

         outvec = gsub("(\\d{5})", "<k>\\1</k>", allthecodes)
         cat("<span class='pink'>allthecodes: </span>",length(allthecodes),"\n",outvec)

         outvec = gsub("(\\d{5})", "<k>\\1</k>", alltheAmtcodeDiff)
         cat("\n<span class='pink'>lastdayAmtUp: </span>", length(alltheAmtcodeDiff), "\n", outvec)

         outvec = gsub("(\\d{5})", "<k>\\1</k>", rangeTable[,1])
         cat("\n<span class='pink'>Sorted Range Table: </span>\n", outvec,"\n", rangeTable[,2], sep=" ")

         outvec = gsub("(\\d{5})", "<k>\\1</k>", rangeTable5[,1])
         cat("\n<span class='pink'>Range > 5: </span>\n", outvec, sep=" ")



         cat("\n\n", sep="\n")
         cat(htmlSScript, sep="\n")
  sink()

  shell(filename)

  cat(red("\nJob completed!\n\n\n"))
