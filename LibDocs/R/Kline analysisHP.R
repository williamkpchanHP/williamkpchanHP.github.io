# detect upcross 5days, cont up2days, upcross multilines, vice sersa
  # ("Code","Close", "High","Low","Vol")
  # write.table(theADataTable, file = paste0(dataFolderPath,"OHLCA.txt"), sep="\t",quote=F,row.names = F)
  # clear all lists to free memory
# clean memory
  rm(list = ls())

# to confirm codetable is ready
  Selection <- readline(prompt="Codetable Is Ready? 1/0  ")
	if(tolower(Selection) != "1") {
		cat("\n", "Codetable Not Ready, Process Ended\n") 
		break
	}
# setup environments
  dirStr = "C:/R programs/!!! STKMon !!!"
  setwd(dirStr)
  library(jsonlite)
  library(dplyr)
  library(tableHTML)
  library(Hmisc)
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

  Sys.setlocale(category = 'LC_ALL', 'Chinese')
  OHLCTable <- matrix(,ncol=5, nrow=0)
  trendAmtTable <- matrix(,ncol=2, nrow=0)
  minMaxTable <- matrix(,ncol=3, nrow=0)
  wAveTable <- matrix(,ncol=3, nrow=0) # this is the price trend table
  HwAveTable <- matrix(,ncol=3, nrow=0) # this is the H trend table
  StrengthTable <- matrix(,ncol=20, nrow=0) # this is the strength table
  intv = 10
  onecode = "00821"
  activeStkList = vector() # amount active record, FLSZ, DWFL
  amtTriggerLevel = 100 # min amt to raise attention, may change reflect mkt
  cat(red("\namtTriggerLevel: 100, intv: 10\n"))
# FetchKline reads url, convert to data.frame, cal all parameters and detections
  FetchKline <- function(onecode){
  # collect data
	theHeader = "http://web.ifzq.gtimg.cn/appstock/app/hkfqkline/get?_var=kline_dayqfq&param=hk"

	theTail = ",day,,,40,qfq"
	cat(" ")
	thepage = readLines(paste0(theHeader,onecode,theTail), encoding="GB2312", warn=FALSE)	# data contain header and trailer
  # extract data
	thepage = gsub('kline_dayqfq=', "", thepage) # remove extra useless data
	thepage = fromJSON(thepage)
	# names(thepage) show the names of dataframe
	thepage = thepage["data"]
	thename = names(thepage[["data"]]) # hk03800
	thepage = thepage[["data"]]

	thepage = thepage[[thename]]
	datapage = thepage[[names(thepage[1])]]

  # check new code
    if(length(datapage)<40){
      closeAllConnections()
      return("newcode!")
    }
  # extract name
	namepage = thepage[[names(thepage[2])]]
	namepage = namepage[1]
	chiName = namepage[[1]][2]
	chiName = gsub('\\u' , '&#x', chiName)  
  #extract price and volumn details
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
	#  colnames(thepage) <- c("Date", "Open", "Close", "High", "Low", "Vol", "Amt")

  ### calculate all parameters ###
  #==============================
	## need to detect datapage[1] which is the date to check trade exist today

    # modify the typhoonDate amt , to avoid typhone date give 0 daily amt
     typhoonDateId = grep(typhoonDate, datapage)
     if(length(typhoonDateId)>0){
          datapage = datapage[-typhoonDateId,]
     }

	theMax = max(as.numeric(datapage[,4])) # to be returned
	theMin = min(as.numeric(datapage[,5])) # to be returned
	bottomRatio = round((theMin/theMax)*100,0) # to be returned

	beginPt = length(datapage[,3]) - intv
	lastPt = length(datapage[,3])

	curHigh = as.numeric(datapage[lastPt,4])
	curPrice = as.numeric(datapage[lastPt,3]) # to be returned
	curRatio = round((curPrice/theMax)*100,0) # to be returned

	relPosition = round(((curPrice - theMin) / (theMax - theMin))*100,0) # to be returned

	prevPrice = as.numeric(datapage[(lastPt-1),3])
	pprevPrice = as.numeric(datapage[(lastPt-2),3])
	ppprevPrice = as.numeric(datapage[(lastPt-3),3])
	pctChange = round(((curPrice - prevPrice)*100/prevPrice),1) # to be returned

	curHigh = as.numeric(datapage[lastPt,4]) # to be returned
	prevHigh = as.numeric(datapage[(lastPt-1),4])
	pprevHigh = as.numeric(datapage[(lastPt-2),4])
	ppprevHigh = as.numeric(datapage[(lastPt-3),4])
	curLow = as.numeric(datapage[lastPt,5]) # to be returned
	prevLow = as.numeric(datapage[(lastPt-1),5])
	pprevLow = as.numeric(datapage[(lastPt-2),5])
	ppprevLow = as.numeric(datapage[(lastPt-3),5])

	trendPrice = calcWAve(as.numeric(datapage[beginPt:lastPt,3]))
	curPriceTrendRatio = curPrice / trendPrice

	meanVol = mean(as.numeric(datapage[beginPt:lastPt,6])) # to be returned

	curAmt = as.numeric(datapage[lastPt,7]) # to be returned
	prevAmt = as.numeric(datapage[(lastPt-1),7])

	trendAmt = calcWAve(as.numeric(datapage[beginPt:lastPt,7])) # to be returned

	if(trendAmt > 0){
		amtTrendRatio = round((curAmt *100/ trendAmt),0)
	}else{
		amtTrendRatio = 0
	}
	curAmt = round(curAmt,0)
	prevAmt = round(prevAmt,0)
  # detect min trade amount today
    minTradeAmt = amtTriggerLevel
	if((curAmt<minTradeAmt)& !(onecode %in% mustAdd)){
		closeAllConnections()
		return("amount ignored!")
	}

	trendAmt = round(trendAmt,0)

  # record the trendAmt table
	# Total 2 columns: Code,trendAmt
	recTAmt(onecode, trendAmt) 

  ### check signatures
  #===================
  # check DWFL
	recentMax = max(as.numeric(datapage[beginPt:lastPt,4]))
	recentMin = min(as.numeric(datapage[beginPt:lastPt,5]))
	if((recentMax - recentMin)!=0){
		rctrelPos = round(((curPrice - recentMin) / (recentMax - recentMin))*100,0)
	}else{
		rctrelPos = 0
	}
	if((amtTrendRatio > 130) && (curAmt >100) && (rctrelPos<15)){
		reportit(paste(curAmt," DWFL - " ), makeLink(thename, chiName))
		hkcode = substr(thename, 3, 7)
		recActiveItem(curAmt, hkcode)
          chiName  = paste0(chiName, '<span class="blue"> DWFL</span>')
	}

  # record the minMax table
	# Total 3 columns: Code,recentMax,recentMin
	recminMax(onecode,recentMax,recentMin)

  # check FLSZ
	if((amtTrendRatio > 130) && (curAmt >100) && (curPrice >prevPrice)){
		reportit(paste(curAmt, " FLSZ - " ), makeLink(thename, chiName))
		hkcode = substr(thename, 3, 7)
          if(curAmt <5000){
            FLSZ5List <<- c(FLSZ5List, hkcode)
          }else{
		  FLSZList <<- c(FLSZList, hkcode)
          }
		recActiveItem(curAmt, hkcode)
          chiName  = paste0(chiName, '<span class="deeppink"> FLSZ</span>')
	}

  # check FLXD
	if((amtTrendRatio > 130) && (curAmt >100) && (curPrice <prevPrice)){
		hkcode = substr(thename, 3, 7)
          if(curAmt <5000){
            FLXD5List <<- c(FLXD5List, hkcode)
          }else{
		  FLXDList <<- c(FLXDList, hkcode)
          }
	}

  # create temp array to evaluate WAve, note intv is 10
	tempClosearray = as.numeric(datapage[beginPt:lastPt,3])
	prevtempClosearray = as.numeric(datapage[(beginPt-1):(lastPt-1),3])
	pprevtempClosearray = as.numeric(datapage[(beginPt-2):(lastPt-2),3])

	#=========================
  # evaluate WAve
	lastWAve = round(calcWAve(tempClosearray),3)
	prevWAve = round(calcWAve(prevtempClosearray),3)
	pprevWAve = round(calcWAve(pprevtempClosearray),3)


  # evaluate AmtWAve5 ~ 40 for wAveTable
	AmtWAve5array = as.numeric(datapage[(lastPt-4):lastPt,7])
	AmtWAve10array = as.numeric(datapage[(lastPt-9):lastPt,7])
	AmtWAve20array = as.numeric(datapage[(lastPt-19):lastPt,7])
	AmtWAve40array = as.numeric(datapage[(lastPt-39):lastPt,7])
	AmtprevWAve5array = as.numeric(datapage[(lastPt-5):(lastPt-1),7])
	AmtprevWAve10array = as.numeric(datapage[(lastPt-10):(lastPt-1),7])
	AmtprevWAve20array = as.numeric(datapage[(lastPt-20):(lastPt-1),7])
	AmtprevWAve40array = as.numeric(datapage[(lastPt-nrow(datapage)):(lastPt-1),7])   # may create problem because of typhoon

	AmtWAve5 = calcWAve(AmtWAve5array)
	AmtWAve10 = calcWAve(AmtWAve10array)
	AmtWAve20 = calcWAve(AmtWAve20array)
	AmtWAve40 = calcWAve(AmtWAve40array)

	AmtprevWAve5 = calcWAve(AmtprevWAve5array)
	AmtprevWAve10 = calcWAve(AmtprevWAve10array)
	AmtprevWAve20 = calcWAve(AmtprevWAve20array)
	AmtprevWAve40 = calcWAve(AmtprevWAve40array)
  # evaluate the Amt strengths
	if(prevAmt == 0){prevAmt = 1}
     AmtDiff = curAmt - prevAmt
	AmtChgPct = format1digit((100*curAmt/prevAmt)-100)
	AmtWAve5Diff = round((curAmt - AmtWAve5),0)
	AmtWAve5ChgPct = format1digit((100*AmtWAve5/AmtprevWAve5)-100)

	AmtWAve10Diff = round((curAmt - AmtWAve10),0)
	AmtWAve10ChgPct = format1digit((100*AmtWAve10/AmtprevWAve10)-100)

	AmtWAve40Diff = round((curAmt - AmtWAve40),0)
	AmtWAve40ChgPct = format1digit((100*AmtWAve40/AmtprevWAve40)-100)


  # evaluate WAve5 ~ 40 for wAveTable
	WAve5array = as.numeric(datapage[(lastPt-4):lastPt,3])
	WAve10array = as.numeric(datapage[(lastPt-9):lastPt,3])
	WAve20array = as.numeric(datapage[(lastPt-19):lastPt,3])
	WAve40array = as.numeric(datapage[(lastPt-39):lastPt,3]) # use for strength analysis
	prevWAve5array = as.numeric(datapage[(lastPt-5):(lastPt-1),3])
	prevWAve10array = as.numeric(datapage[(lastPt-10):(lastPt-1),3])
	prevWAve20array = as.numeric(datapage[(lastPt-20):(lastPt-1),3])
	prevWAve40array = as.numeric(datapage[(lastPt-nrow(datapage)):(lastPt-1),3])  # may create problem because of typhoon

	pprevWAve5array = as.numeric(datapage[(lastPt-6):(lastPt-2),3])
	pprevWAve10array = as.numeric(datapage[(lastPt-11):(lastPt-2),3])

	WAve5 = calcWAve(WAve5array)
	WAve10 = calcWAve(WAve10array)
	WAve20 = calcWAve(WAve20array)
	WAve40 = calcWAve(WAve40array)
	prevWAve5 = calcWAve(prevWAve5array)
	prevWAve10 = calcWAve(prevWAve10array)
	prevWAve20 = calcWAve(prevWAve20array)
	prevWAve40 = calcWAve(prevWAve40array)

	pprevWAve5 = calcWAve(pprevWAve5array) # ready for wAve turn point
	pprevWAve10 = calcWAve(pprevWAve10array) # ready for wAve turn point

  # evaluate WAve3 ~ 6 for wAveTable
	WAve3array = as.numeric(datapage[(lastPt-2):lastPt,3]) # lastPt-2 is intv 3
	WAve6array = as.numeric(datapage[(lastPt-5):lastPt,3])
	prevWAve3array = as.numeric(datapage[(lastPt-3):(lastPt-1),3])
	prevWAve6array = as.numeric(datapage[(lastPt-6):(lastPt-1),3])
	WAve3 = calcWAve(WAve3array)
	WAve6 = calcWAve(WAve6array)
	prevWAve3 = calcWAve(prevWAve3array)
	prevWAve6 = calcWAve(prevWAve6array)

  # evaluate WAve5 & 10 High for High wAveTable
	HWAve5array = as.numeric(datapage[(lastPt-4):lastPt,4])
	HWAve10array = as.numeric(datapage[(lastPt-9):lastPt,4])
	HWAve20array = as.numeric(datapage[(lastPt-19):lastPt,4])
	prevHWAve5array = as.numeric(datapage[(lastPt-5):(lastPt-1),4])
	prevHWAve10array = as.numeric(datapage[(lastPt-10):(lastPt-1),4])
	HWAve5 = calcWAve(HWAve5array)
	HWAve10 = calcWAve(HWAve10array)
	HWAve20 = calcWAve(HWAve20array)
	prevHWAve5 = calcWAve(prevHWAve5array)
	prevHWAve10 = calcWAve(prevHWAve10array)

  # evaluate WAve5 Low Low wAveTable, datapage[,5] is low value
	LWAve5array = as.numeric(datapage[(lastPt-4):lastPt,5])
	prevLWAve5array = as.numeric(datapage[(lastPt-5):(lastPt-1),5]) 
	pprevLWAve5array = as.numeric(datapage[(lastPt-6):(lastPt-2),5]) 
	LWAve5 = calcWAve(LWAve5array)
	prevLWAve5 = calcWAve(prevLWAve5array)
	pprevLWAve5 = calcWAve(pprevLWAve5array)

  # record the wAveTable
	ptwAve = nrow(datapage)
	recwAve(gsub('hk', "", thename), format3digit(WAve5), format3digit(WAve10)) 
	recHwAve(gsub('hk', "", thename), format3digit(WAve5), format3digit(WAve10)) 

  # checkTP, if TPup record it, this test must go below evaluate WAve and before evaluate the strengths

    checkTPC = checkTP(pprevPrice,prevPrice,curPrice)
    checkTPH = checkTP(pprevHigh,prevHigh,curHigh)
    checkTPL = checkTP(pprevLow,prevLow,curLow)
    checkTPW = checkTP(pprevWAve,prevWAve,lastWAve)

    checkTPWAve10 = checkTP(pprevWAve10,prevWAve10,WAve10)

    # check turn UP
    if((checkTPC == "turn UP") &&
       (checkTPH == "turn UP") &&
       (checkTPL == "turn UP") &&
       # (checkTPW == "turn UP") &&
       (curPrice >= prevPrice) &&
       (curAmt > 100) &&
       (curHigh > prevHigh))
	{
		codenum = substr(thename, 3, 7)
		TPupList <<- c(TPupList, codenum)
		TPupListCnt <<- TPupListCnt + 1
	  	TPupAmt <<- c(TPupAmt, curAmt)
		cat("\n\n",red(onecode),orange(" TP: pp "), pprevWAve," p ",prevWAve," l ",lastWAve, " pc ", prevPrice," c ", curPrice, " amt ", curAmt, " pH ", prevHigh, " cH ",curHigh,"\n\n")
          chiName = paste0(chiName, '<span class="red"> TP</span>')
          if(curHigh > as.numeric(WAve10)){
             chiName = paste0(chiName, '<span class="red"> H>W10</span>')
          }
          if(curHigh > as.numeric(WAve5)){
             chiName = paste0(chiName, '<span class="red"> H>W5</span>')
          }
	}

    # check turn DN
    if((checkTPC == "turn DN") &&
       (checkTPH == "turn DN") &&
       (checkTPL == "turn DN") &&
       # (checkTPW == "turn DN") &&
       (curPrice <= prevPrice) &&
       (curAmt > 100) &&
       (curLow <= prevLow))
	{
		codenum = substr(thename, 3, 7)
		TPdnList <<- c(TPdnList, codenum)
		TPdnListCnt <<- TPdnListCnt + 1
	  	TPdnAmt <<- c(TPdnAmt, curAmt)
		cat("\n\n",darkgreen(onecode),blue(" TP: pp "), pprevWAve," p ",prevWAve," l ",lastWAve, " pc ", prevPrice," c ", curPrice, " amt ", curAmt, " pH ", prevHigh, " cH ",curHigh,"\n\n")
          chiName = paste0(chiName, '<span class="green"> T&darr;</span>')
          if(curHigh < as.numeric(WAve10)){
             chiName = paste0(chiName, '<span class="green"> H&lt;W10</span>')
          }
          if(curHigh < as.numeric(WAve5)){
             chiName = paste0(chiName, '<span class="green"> H&lt;W5</span>')
          }
	}

  # check Low wAve5 turn UP
    checkLWAve5Tup = checkTP(pprevLWAve5, prevLWAve5, LWAve5)

    if((checkLWAve5Tup == "turn UP") & (curPrice>WAve5)){
		codenum = substr(thename, 3, 7)
		LWAve5TupList <<- c(LWAve5TupList, codenum)
    }

  # evaluate the strengths
     PriceDiff = format3digit(curPrice - prevPrice)
	PriceChgPct = format1digit((100*curPrice/prevPrice)-100)
	WAve5Diff = format1digit(curPrice - WAve5)
	WAve5ChgPct = format1digit((100*WAve5/prevWAve5)-100)
	WAve10Diff = format1digit(curPrice - WAve10)
	WAve10ChgPct = format1digit((100*WAve10/prevWAve10)-100)
	WAve40Diff = format1digit(curPrice - WAve40)
	WAve40ChgPct = format1digit((100*WAve40/prevWAve40)-100)
     if(curAmt>1000 & curAmt<=5000){
          AmtMsg = paste0('<span class="orange">',curAmt,'</span>')
     }else if(curAmt>5000 & curAmt<=10000){
          AmtMsg = paste0('<span class="red">',curAmt,'</span>')
     }else if(curAmt>10000){
          AmtMsg = paste0('<span class="deeppink">',curAmt,'</span>')
     }else{
          AmtMsg = curAmt
     }

	StrengthTable <<- rbind(StrengthTable, c(gsub('hk', "", thename), 
		chiName,curPrice, AmtMsg, 
		addColor(PriceDiff), addColor(PriceChgPct), 
		addColor(WAve5Diff), addColor(WAve5ChgPct), 
		addColor(WAve10Diff), addColor(WAve10ChgPct), 
		addColor(WAve40Diff), addColor(WAve40ChgPct),
		addColor(AmtDiff), addColor(AmtChgPct),
		addColor(AmtWAve5Diff), addColor(AmtWAve5ChgPct),
		addColor(AmtWAve10Diff), addColor(AmtWAve10ChgPct),
		addColor(AmtWAve40Diff), addColor(AmtWAve40ChgPct)
	))
     # later the strength table will be written to file in excel format
     # curLow
     # prevLow
     # pprevLow
     # ppprevLow

  # check BBG
  # curPrice, prevPrice, pprevPrice, curHigh, prevHigh, pprevHigh
    if((curHigh> prevHigh) & (prevHigh > pprevHigh)&
     (curLow> prevLow) & (prevLow > pprevLow)&
     (curAmt>100))
	{
       BBGList <<- c(BBGList, thename)
       if((pprevHigh > ppprevHigh)&(pprevLow > ppprevLow)){ DBBGList <<- c(DBBGList, thename) }
     }

  # check BBD
  # curPrice, prevPrice, pprevPrice, curHigh, prevHigh, pprevHigh
    if((curHigh< prevHigh) & (prevHigh < pprevHigh)&
     (curLow< prevLow) & (prevLow < pprevLow)&
     (curAmt>100))
	{
       BBDList <<- c(BBDList, thename)
       if((pprevHigh < ppprevHigh)&(pprevLow < ppprevLow)){ DBBDList <<- c(DBBDList, thename) }
     }

  # check rising up state
    if((curPrice>WAve5)&
	  (WAve5>WAve10)&
	  #(WAve10>WAve20)&  to raise sensitivity
	  (curPrice>HWAve5)&
	  (curHigh>HWAve5)&
	  (curAmt>100)&
	  #(HWAve10>HWAve20) to raise sensitivity
	  (HWAve5>HWAve10)){
         risingList <<- c(risingList, paste(thename, curPrice,format3digit(WAve5),
         format3digit(WAve10),
         format3digit(WAve20),
         format3digit(curHigh),
         format3digit(HWAve5),
         format3digit(HWAve10),
         format3digit(HWAve20)))
         Rising <<- c(Rising, thename)

       }

  # compare with prevWAves
    if(
		(WAve5>prevWAve5)&
		(WAve10>prevWAve10)&
		(curPrice>WAve5)&
		(((WAve5-prevWAve5)/prevWAve5)>0.01)
		){
		strongList <<- c(strongList, paste0(makeLink(thename, chiName),"<br>"))
		strongAmt <<- c(strongAmt, curAmt)
		strongListCnt <<- strongListCnt + 1
          Strong <<- c(Strong, thename)
	}

  # checkX, if upX record it, vice versa

   # check the Close wAve cross
    checkCXWAve = checkX(prevWAve5, prevPrice, WAve5, curPrice)
    if(checkCXWAve == "UpCross"){
		codenum = substr(thename, 3, 7)
		cUpXWAve <<- c(cUpXWAve, codenum)
 	}

   # check the Close wAve10 cross
    checkCXWAve10 = checkX(prevWAve10, prevPrice, WAve10, curPrice)
    if(checkCXWAve10 == "UpCross"){
		codenum = substr(thename, 3, 7)
		cUpXWAve10 <<- c(cUpXWAve10, codenum)
 	}

   # check the Close wAve20 cross
    checkCXWAve20 = checkX(prevWAve20, prevPrice, WAve20, curPrice)
    if(checkCXWAve20 == "UpCross"){
		codenum = substr(thename, 3, 7)
		cUpXWAve20 <<- c(cUpXWAve20, codenum)
          # check wAve20 cross and wAve10 turn up
          # check WAve10 turn UP, checkTPWAve10
          if(((checkTPWAve10 == "turn UP") ||
              (checkTPWAve10 == "keep Up"))&& (curAmt > 100))
          { xWAve20WAve10TP <<- c(xWAve20WAve10TP, codenum) }
 	}

   # check the wAve cross
    checkXResult = checkX(prevWAve10,prevWAve5,WAve10,WAve5)
    if(checkXResult=="UpCross"){
		codenum = substr(thename, 3, 7)
		XList <<- c(XList, codenum)
		XListCnt <<- XListCnt + 1
	  	XAmt <<- c(XAmt, curAmt)
 	}

    checkX3Result = checkX(prevWAve6,prevWAve3,WAve6,WAve3)
    if(checkX3Result=="UpCross"){
		codenum = substr(thename, 3, 7)
		X3List <<- c(X3List, codenum)
 	}
    if(checkX3Result=="DownCross"){
		codenum = substr(thename, 3, 7)
		DX3List <<- c(DX3List, codenum)
 	}
    if((checkX3Result=='<span class="brownword">cont.Up</span>')&
       (curPrice> prevPrice)){
		codenum = substr(thename, 3, 7)
		CU3List <<- c(CU3List, codenum)
 	}
    if((checkX3Result=='<span class="limeword">cont.Dn</span>')&
       (curPrice < prevPrice)){
		codenum = substr(thename, 3, 7)
		CD3List <<- c(CD3List, codenum)
 	}

   # check the High wAve cross
    if (checkX(prevHWAve10, prevHWAve5, HWAve10, HWAve5) == "UpCross") {
	    codenum <- substr(thename, 3, 7)
	    XList <<- c(XList, codenum)
	    XListCnt <<- XListCnt + 1
	    XAmt <<- c(XAmt, curAmt)
	}
   # check today's high whether crossing both High wAves
    if((curHigh>HWAve5)&(curHigh>HWAve10)){
		strongList <<- c(strongList, paste0(makeLink(thename, chiName),"<br>"))
		strongAmt <<- c(strongAmt, curAmt)
		strongListCnt <<- strongListCnt + 1
	}


   # evaluate trend, prev trend, and trenddiff
	trend = lastWAve - prevWAve # to be returned
	ptrend = prevWAve - pprevWAve # to be returned
	trenddiff = format3digit(trend - ptrend)

   # evaluate TP
	# turningPt = 0
	# if((ptrend <= 0 && trend>0) || (ptrend>0 && trend <=0)  ){turningPt = 1} # to be returned

	#=========================
   # record the OHLC table
	# Total 5 columns: Code,Close,High,Low,Vol
	ptOHLC = nrow(datapage)
	recOHLC(gsub('hk', "", thename), datapage[ptOHLC,3], datapage[ptOHLC,4], datapage[ptOHLC,5], datapage[ptOHLC,6]) 

  #=========================

	closeAllConnections()
	return(c(
		thename, 
		chiName, 
		theMax, 
		theMin, 
		curPrice, 
		format3digit(curPriceTrendRatio), 
		bottomRatio, 
		curRatio, 
		relPosition, 
		curAmt, 
		trendAmt, 
		amtTrendRatio,
		format3digit(trend), 
		format3digit(ptrend), 
		trenddiff,
		pctChange))
  # ====== preprocess finished here
   cat("the is is",BBGList)
 }
# support functions
 # color negative value
   addColor = function(aValue){
     aValue = as.numeric(aValue)
     if(is.na(aValue)){ return(aValue) }
     if(aValue >= 1){
        aValue = paste0('<span class="red">', aValue, '</span>')
     }else if( (aValue > 0) & (aValue < 1) ){
        aValue = paste0('<span class="orange">', aValue, '</span>')
     }else if( (aValue > -1 ) & (aValue <= 0) ){
        aValue = paste0('<span class="cyan">', aValue, '</span>')
     }else if( aValue <= -1 ){
        aValue = paste0('<span class="purple">', aValue, '</span>')
     }
     return(aValue)
   }
 # create links
   makeLink = function(codeNum, chiName){
	codeNum = substr(codeNum, 3, 7)
	return(paste0('<span onclick=xunbao("',codeNum, '\")>',codeNum," ",chiName,'</span>'))
   }

 # record Active item
  amtList = vector('numeric')
  codeList = vector()
  recActiveItem = function(amount, codenum){
	  amtList <<- c(amtList, amount)
	  codeList <<- c(codeList, codenum)
  }

 # updateData is the multiquote function, name, code, price, vol, amt
  updateData <- function(theURLReqList){
	theTempT <- data.frame(codename=character(),codenum=character(), price=numeric(), Vol=numeric(), Amt=numeric(), stringsAsFactors=FALSE) 
	for(line in 1:length(theURLReqList)){
cat("\n", line,"\n")
cat(theURLReqList[line])
		mostUpdate = readLines(theURLReqList[line], warn = F)		# theURLLst composed in last loop
		pagenum = line - 1
		for(code in 1:length(mostUpdate)){
			linenum = pagenum * 64 + code
			Info=unlist(strsplit(mostUpdate[code],"~"))	# get the data line by line
			# name, code, price, vol, amt
			theTempT[linenum,1] = Info[2]
			theTempT[linenum,2] = Info[3]
			theTempT[linenum,3] = as.numeric(Info[4])
			theTempT[linenum,4] = as.numeric(Info[7])
			theTempT[linenum,5] = as.numeric(Info[8])
		}
	}
	return(theTempT)
  }

 # create the theURLLst
  createURLLst <- function(coldList){
	theURLHeader = "http://qt.gtimg.cn/?q="
	theURLLst = theURLHeader	# this is the batch collect address
	listlen = length(coldList)
	strList = character()
	count = 1
	while(count <= listlen){
		thecode = coldList[count]
		theURLLst = paste0(theURLLst, "s_hk",thecode,",")	# arrange the URL, not used now
	    if(count%%64 == 0){
			strList = c(strList, theURLLst)
			theURLLst = theURLHeader
		}
		count = count + 1
	}
	strList = c(strList, theURLLst)	# do once more to complete the last loop
	return(strList)
  }

 # function to quick check coldList amount
  chkColdList <- function(){
	theColdList <- readLines("coldbench.txt")
	coldListlength = length(theColdList)
	theURLReqList = createURLLst(theColdList)
	theMostUpdateData = updateData(theURLReqList)
	b4chkL = length(CodeTable)
	cat("\nPre check the coldbench! the coldListlength is: ",coldListlength, "\n", "Original CodeTable length is: ",b4chkL,"\nthe following from coldlist are added to CodeTable: \n")

	if(coldListlength>0){ # avoid zero error
       cat("coldListlength: ",coldListlength)
	  for(thecode in 1:coldListlength){
          cat(thecode, " ")
		if(theMostUpdateData[thecode,5] / 10000 > amtTriggerLevel){
			cat(" ",theMostUpdateData[thecode,2], " ")
			CodeTable <<- c(CodeTable, theMostUpdateData[thecode,2])
		}
	  }
	}
	cat("\nafter purging the updated CodeTable length is: ",length(CodeTable), "\nadded from coldbench: ", length(CodeTable)-b4chkL,"\n")
     cat("\nthe CodeTable is :", CodeTable)

	 # update theColdList by removing CodeTable from theColdList
	  # theColdList = rmItems(theColdList, CodeTable)

	  #cat("\nupdated length of theColdList from file is: ",length(theColdList),"\n")

	  #sink("coldbench.txt")
	  # cat(theColdList, sep="\n")
	  #sink()
	  #cat("theColdList updated!\n")
  }


 # addToCodeList(aList, udCodeList)
  addToCodeList =function(aList, udCodeList){
	  tempList = readLines(udCodeList)
	  tempList = c(tempList, aList)
	  tempList = unique(tempList)
	  write.table(tempList, file = udCodeList, sep="\t",quote=F,row.names = F, col.names = F)
  } 

 # checkX(prevL, prevS, curL, curS), up down cross level and continues trend
	checkX = function(prevL, prevS, curL, curS){
		if (curS == curL){return("critical")}
		if (((prevL == prevS) && (curS > curL )) || ((prevL>prevS) && (curS > curL ))){return("UpCross")}
		if (((prevL == prevS) && (curS < curL )) || ((prevL<prevS) && (curS < curL ))){return("DownCross")}
		if ((prevL<prevS) && (curS > curL )){return('<span class="brownword">cont.Up</span>')} # and c must > prevC, this is not correct, further check for condition
		if ((prevL>prevS) && (curS < curL )){return('<span class="limeword">cont.Dn</span>')}
	}

 # checkUpDn(prevC, curC) can be used to check H, C, L
	checkUpDn = function(prevC, curC){
		if (prevC == curC){return("level")}
		if (prevC< curC){return("<span class='redword'>Up</span>")
		} else {return("<span class='greenword'>Down</span>")}
	}

 # checkTP(pprevC, prevC, curC) can be used to check H, C, L
	checkTP = function(pprevC, prevC, curC){
		if ((pprevC >= prevC)&&(prevC < curC)){return("turn UP")
		 }else if ((pprevC <= prevC)&&(prevC > curC)){return("turn DN")
		 }else if ((pprevC < prevC)&&(prevC < curC)){return("keep Up")
		 }else if ((pprevC > prevC)&&(prevC > curC)){return("keep DN")
		 }else{return("unknown")
		}
	}

 # genChart(XAmt, XcodeList, outName) create html js chart
  genChart <- function(XAmt, XcodeList, outName){
	# the caller prepares data
	 # XcodeList <<- c(XcodeList, codenum)
	 # XcodeListCnt <<- XcodeListCnt + 1
  	 # XAmt <<- c(XAmt, amount)
	# scriptPage should be ready
	# prepare htmlCssHeader in advance
	# prepares output data
	 upXdf = data.frame(XAmt,XcodeList)
	 upXdf = unique(upXdf[order(XAmt),])
 	 upXcodeList = c(paste0("'", upXdf[,2],"'")) # for showmultiplechart.js

	# show charts msg
	 showChartsMsg = paste0(
	 '<br><span id="dateAndTime" onclick="showDateAndTime()"><script>showDateAndTime();</script></span><br>',
	 '<script>theList.push(',
	 paste0(upXcodeList,collapse=","),
	 ')</script>',
	 '<br><b class="goldword" onclick="window.scrollTo(0,document.body.scrollHeight);">Go Bottom</b>',
	 '<p id ="codelist"></p>'
	 )

	# write to file, todayStr is global
	 outputName = paste0(outName, todayStr, '.html')
	 sink(outputName)
	 cat(htmlCssHeader, sep="\n") # htmlCssHeader is the HTML header
	 cat(scriptPage, sep="\n") # scriptPage is the show chart script
	 cat(showChartsMsg, sep="\n") # showChartsMsg contains the data and script
	 sink()
	 unlink(paste0(outName, '.html'))
      file.copy(outputName, paste0(outName, '.html'))
  }
 # show report message to html
  reportit = function(aMsg, thelink){
	resultMsg <<- paste(resultMsg, aMsg, thelink, "<br>\n")
	resultMsgNo <<- resultMsgNo + 1
  }
 # format3digit
  format3digit  = function(value){ sprintf(value, fmt = '%#.3f')}
 # format1digit
  format1digit  = function(value){ sprintf(value, fmt = '%#.1f')}
 # calcWAve
  calcWAve = function(theArray) { # calculate the WMA value
	sum = 0
     test <- theArray
     testNA = is.na(test)
     theArray = test[!testNA]
	for( i in 1:length(theArray) ) {sum = sum + theArray[i] * i;}
     WAveValue = sum / ((1 + length(theArray))*length(theArray)/2)
     return (WAveValue)
  }

 # this record the OHLC
  recOHLC <- function(CodeNo,CloseV,HighV,LowV,VolV){
	OHLCTable <<- rbind(OHLCTable, c(CodeNo,CloseV,HighV,LowV,VolV))
  }
 # this record the trendAmt
  recTAmt <- function(CodeNo,trendAmt){
	trendAmtTable <<- rbind(trendAmtTable, c(CodeNo,trendAmt))
  }
  recminMax <- function(CodeNo,recentMax,recentMin){
	minMaxTable <<- rbind(minMaxTable, c(CodeNo,recentMax,recentMin))
  }

 # this record the wAveTable
  recwAve <- function(CodeNo, WAve5, WAve10) {
	wAveTable <<- rbind(wAveTable, c(CodeNo, WAve5, WAve10) )
  }
 # this record the HwAveTable
  recHwAve <- function(CodeNo, HWAve5, HWAve10) {
	HwAveTable <<- rbind(HwAveTable, c(CodeNo, HWAve5, HWAve10) )
  }
 # checkSpace(checkTable), pre check table validity
  checkSpace <- function(checkTable) {
 	if(any(grepl("[^0-9]", checkTable))){
 	 	cat("\ninvalid codetable table, spaces character in table, process stopped!\n\n")
 	 	stop()
 	 }
 	if(any(grepl("^$", checkTable))){
 	 	cat("\ninvalid codetable table, empty lines in table, process stopped!\n\n")
 	 	stop()
 	 }
  }

 # rmItems(fmList, itemList) remove itemList from fmList
  rmItems <- function(fmList, itemList){
		commons = fmList[fmList %in% itemList]
		for(item in commons){fmList = fmList[-(which(fmList == item))]}
		return(fmList)
  }

 # addItems(targetList, addItem) add addItem to targetList
  addItems <- function(targetList, addItem){
		targetList = c(targetList, setdiff(addItem,targetList))
		return(targetList)
  }

 # Datasets init ======================
 
  todayStr = format(Sys.Date(), format="%y%m%d")
  fraudSTK = readLines("fraudSTK.txt")
  checkSpace(fraudSTK)
  coldbench = readLines("coldbench.txt")
  checkSpace(coldbench)
  newcode = readLines("newcode.txt")
  checkSpace(newcode)
  mustAdd = readLines("mustAdd.txt")
  typhoonDate = readLines("typhoonDate.txt")
  checkSpace(newcode)
  ignoreLongList = readLines("ignoreLongList.txt")
  checkSpace(newcode)

 # debug mode
 # sink("screenReport.txt")
  CodeTableName = "allcodes.txt"
  cat(pink("\nCodeTableName is: ", CodeTableName, "\n"))

  CodeTable = readLines(CodeTableName)
  checkSpace(CodeTable)

	 # remove all code start with 046
       invalidIdx = grep("^046..",CodeTable)
       if(length(invalidIdx)> 0){
         cat(red("\nInvalid code removed: ", CodeTable[invalidIdx]))
         CodeTable = CodeTable[-invalidIdx]
       }

  cat("\nlength of CodeTable from file is: ",length(CodeTable),"\n")
  cat("\nlength of fraudSTK from file is: ",length(fraudSTK),"\n")
  cat("\nlength of coldbench from file is: ",length(coldbench),"\n")
  cat("\nlength of newcode from file is: ",length(newcode),"\n")
  cat("\nlength of mustAdd from file is: ",length(mustAdd),"\n")
  cat("\nlength of ignoreLongList from file is: ",length(ignoreLongList),"\n")

 # remove coldbench
  # CodeTable = rmItems(CodeTable, coldbench)

 # remove newcode
  # CodeTable = rmItems(CodeTable, newcode)

 # remove fraudSTK & forgetLst
  CodeTable = rmItems(CodeTable, fraudSTK)

 # remove ignoreList
  ignoreList = readLines("ignoreList.txt", warn=FALSE)
  CodeTable = rmItems(CodeTable, ignoreList)


 # add mustadd
  CodeTable = unique(addItems(CodeTable, mustAdd))
  cat("\nlength of CodeTable after purging and adding is: ",length(CodeTable),"\n")

 # chkColdList, disable to avoid problems
  # chkColdList()

 # update ignoreLongList by removing CodeTable from ignoreLongList
 # not to ignore sudden change in amt, permanent ignore
 # ignoreLongList = rmItems(ignoreLongList, CodeTable)
 # cat("\nupdated length of ignoreLongList from file is: ",length(ignoreLongList),"\n")

 # sink("ignoreLongList.txt")
 #  cat(ignoreLongList, sep="\n")
 # sink()
 # cat("ignoreLongList updated!\n")

 # setup output results
  resultMsg = ""
  resultMsgNo = 0
  resultTable <- matrix(,ncol=16, nrow=0)
  ignoreList = vector()
  newcodeList = vector()
  strongList = vector("character")
  Strong = vector("character")
  strongListCnt = 0
  strongAmt = vector('numeric')
  risingList = vector("character")
  Rising = vector("character")
  BBGList = vector("character")
  DBBGList = vector("character")
  BBDList = vector("character")
  DBBDList = vector("character")
  XList = vector("character")
  X3List = vector("character")
  DX3List = vector("character")
  CU3List = vector("character")
  CD3List = vector("character")
  FLSZList = vector("character")
  FLSZ5List = vector("character")
  FLXDList = vector("character")
  FLXD5List = vector("character")
  XListCnt = 0
  cUpXWAve = vector("character")
  cUpXWAve10 = vector("character")
  cUpXWAve20 = vector("character")
  xWAve20WAve10TP = vector("character")
  XAmt = vector('numeric')
  TPupList = vector("character")
  TPupListCnt = 0
  TPupAmt = vector('numeric')
  TPdnList = vector("character")
  TPdnListCnt = 0
  TPdnAmt = vector('numeric')
  LWAve5TupList = character()

 # prepare htmlCssHeader
  htmlCssHeader = readLines("htmlCssHeader.html", warn=FALSE)

 # loop to call to FetchKline
  for(codes in 1:length(CodeTable)){
	cat(CodeTable[codes]," ")
	tempResult = FetchKline(CodeTable[codes])
	if(tempResult[1] == "newcode!"){
		cat("\nnewcode! \n")
		newcodeList = c(newcodeList, CodeTable[codes]) # prepare for removal
	} else if(tempResult[1] == "amount ignored!"){
		cat("\namount ignored! \n")
		# ignoreList = c(ignoreList, CodeTable[codes]) # prepare for removal
	} else {
		resultTable = rbind(resultTable, tempResult)
	}
  }

 #sink() # stop screen recording

  # screen out ObjTarget and nonObjTarget
   ObjTarget = resultTable[which(as.numeric(resultTable[,10])>=100),]
   ObjTarget = ObjTarget[which(as.numeric(ObjTarget[,10])<7000),]
   ObjTarget = ObjTarget[which(as.numeric(ObjTarget[,5])>0.5),]
   ObjTarget = ObjTarget[which(as.numeric(ObjTarget[,5])<11),]
   ObjTarget = gsub("hk","",ObjTarget[,1])
   cat(red("ObjTarget number: ",length(ObjTarget), "\n"))
   
   sink("ObjTarget.txt")
     cat(ObjTarget,sep="\n")
   sink()
   
   nonObjTarget = gsub("hk","",resultTable[,1])
   nonObjTarget = rmItems(nonObjTarget, ObjTarget)
   cat(red("nonObjTarget number: ",length(nonObjTarget), "\n"))
   sink("nonObjTarget.txt")
     cat(nonObjTarget,sep="\n")
   sink()

   cat(red("ObjTarget and nonObjTarget have been saved to file!\n"))

 # prepare for report
  rownames(resultTable) <- NULL
  colnames(resultTable) <- c(
	'Name',
	'chiName', 
	'Max', 
	'Min', 
	'curPrice', 
	'P T Ratio', 
	'botRatio', 
	'curRatio', 
	'relPos', 
	'curAmt', 
	'trendAmt', 
	'Amt T Ratio',
	'cTrend', 
	'pTrend', 
	'Tdiff',
	'%chg')

 # create active list, amtList, codeList are ready for this action 
	activedf = data.frame(amtList,codeList)
	activedf = activedf[order(amtList),] 
 	activeStkList = c(paste0("'", activedf[,2],"'")) # this is for the showmultiplechart.js

  outputFileName = paste0('KlineAnalysisResult ', todayStr, '.html')

 # note! the chiname encoding is ok inside R, but will be wrong when write to file by local pc locale
 # note: write a file first and then append table
  write_tableHTML(tableHTML(resultTable), file = outputFileName) #and to export in a file, cannot show chinese 

# generate StrengthTable html table
 rownames(StrengthTable) <- NULL
 colnames(StrengthTable) <- c(
	'Code','Name',
	'Price','Amt',
	'C Diff','C ChgPct',
	'W 5 Diff','W 5 ChgPct',
	'W 10 Diff','W 10 ChgPct',
	'W 40 Diff','W 40 ChgPct',
	'Amt Diff','Amt ChgPct',
	'AmtW5 Diff','AmtW5 ChgPct',
	'AmtW10 Diff','AmtW10 ChgPct',
	'AmtW40 Diff','AmtW40 ChgPct')
 write_tableHTML(tableHTML(StrengthTable), file = "StrengthTable.html") #and to export in a file, cannot show chinese 

# generate htmlpage
 # htmlpage = gsub(".*'>|</span>.*", "", htmlpage)

 # this is output html header
 htmloutputHeader = readLines("htmloutputHeader.txt", warn=FALSE)

 # this relaod StrengthTable html table
 s_htmlpage = readLines("StrengthTable.html", warn=FALSE)
 s_htmlpage = gsub('&#60;', "<", s_htmlpage)
 s_htmlpage = gsub('&#62;', ">", s_htmlpage)
 # identify the stkcodes
 linenum = grep('tableHTML_column_1">', s_htmlpage)
 theKeys = s_htmlpage[linenum]
 # replace with modified code
 theKeyId = gsub('.*">|</td>.*', "", theKeys)
 theTDhead = '<td id="tableHTML_column_1"><span onclick=xunbao("'
 theKeyId = paste0(theTDhead, theKeyId,  '\")>', theKeyId, "</span></td>")
 s_htmlpage[linenum] = theKeyId

 s_htmlpage = s_htmlpage[-(1:2)]
 s_htmlpage = c(s_htmlpage, "<br><br>")
 sink("StrengthTable.html")
   Sys.setlocale("LC_TIME", "English")
   cat(format(Sys.time(), "%H:%M:%OS  %a %d %b %Y"),"\n")
   cat(htmloutputHeader, sep="\n")
   cat(s_htmlpage, sep="\n")
 sink()


 # this relaod html table
 htmlpage = readLines(outputFileName, warn=FALSE)
 htmlpage = gsub('&#60;', "<", htmlpage)
 htmlpage = gsub('&#62;', ">", htmlpage)
 # identify the stkcodes
 linenum = grep('tableHTML_column_1">hk', htmlpage)
 theKeys = htmlpage[linenum]
 # replace with modified code
 theKeyId = gsub(".*>hk|</td>.*", "", theKeys)
 theTDhead = '<td id="tableHTML_column_1"><span onclick=xunbao("'
 theKeyId = paste0(theTDhead, theKeyId,  '\")>', theKeyId, "</span></td>")
 htmlpage[linenum] = theKeyId

 htmlpage = htmlpage[-(1:2)]
 htmlpage = c(htmlpage, "<br><br>")

# pieChart function =====================
 pieChart <- function(titleName, indexCol, breaks){
  # pieChart <- function(titleName, indexCol, breaks){

	chartDiv = paste0('<canvas id="cvs', todayStr, '" width="600" height="500"></canvas><br>')

	# stat of relPos, min max, 10 bars
	counts = table( cut2(as.numeric(resultTable[,indexCol]), breaks)) # counts is a table object, having x range and y freq interger
	# counts = table( cut(as.numeric(resultTable[,indexCol]), 10)) # counts is a table object, having x range and y freq interger
	countsdata = paste0('data: [', capture.output(cat(counts, sep = ",")), '],')

	countsname = capture.output(cat(names(counts), sep = ","))
	countsname = gsub("\\(","\"", countsname)
	countsname = gsub("\\)","\"", countsname)
	countsname = gsub("\\]","\"", countsname)
	countsname = gsub("\\[","\"", countsname)
	countsname = gsub(" ","", countsname)
	countsname = paste0('labels: [', countsname, '],')

	chartJsTitle = paste0('title: "', titleName,'",')

	chartJsHead = c(
	'<script>',
	'var pie = new RGraph.Pie({',
	paste0('id: "cvs', todayStr, '",')
	)

	chartJsMid = c(
	'options: {',
	'radius: 160,',
	'linewidth: 1,',
	'shadow: true,',
	'gutterTop: 80,',
	'gutterLeft: 80,',
	'exploded: [40,30,30,30,30,30,30,30,30,30,30,30,30],'
	)

	chartJsTail = c(
	'labelsSticksList: false,',
	'textFont: "Arial",',
	'textSize: 12,',
	'textColor: "green",',
	'textAccessible: true',
	'}',
	'}).draw();',
	'</script>'
	)

	maxValue = max(as.numeric(resultTable[,indexCol]))
	minValue = min(as.numeric(resultTable[,indexCol]))
	rangeStr = paste0("max:", maxValue, " min:", minValue, "<br><br>")

	chartJs = c(chartDiv, rangeStr, chartJsHead, countsdata, chartJsMid, countsname, chartJsTitle, chartJsTail)
	return(chartJs)
 }
# hbarChart function =====================
 hbarChart <- function(titleName, indexCol, breaks){
	chartDiv = paste0('<canvas id="cvs', indexCol, '" width="1050" height="850"></canvas><br>')

	# stat of relPos, min max, 10 bars
    #  counts = table( cut(as.numeric(resultTable[,indexCol]), 10)) # counts is a table object, having x range and y freq interger
	counts = table( cut2(as.numeric(resultTable[,indexCol]), breaks)) # counts is a table object, having x range and y freq interger
	countsdata = paste0('data: [', capture.output(cat(counts, sep = ",")), '],')

	countsname = capture.output(cat(names(counts), sep = ","))
	countsname = gsub("\\(","\"", countsname)
	countsname = gsub("\\]","\"", countsname)
	countsname = paste0('labels: [', countsname, '],')

	chartJsTitle = paste0('title: "', titleName,'",')
	chartJsHead = c(
	'<script>',
	'myGraph = new RGraph.HBar({',
	paste0('id: "cvs', indexCol, '",')
	)

	chartJsMid = 'options: {'
    # countsname = paste0('labels: [', countsname, '],')

	chartJsTail = c(
		'gutterLeft: 100,',
		'vmargin: 5,',
		'titleY: 15,',
		"variant: '3d',",
		"gutterLeft: 100,",
		"shadow: true,",
		"shadowOffsety:  5,",
		"shadowOffsetx: 13,",
		"shadowBlur: 10,",
		'}}).draw();',
		'</script>'
	)

	maxValue = max(as.numeric(resultTable[,indexCol]))
	minValue = min(as.numeric(resultTable[,indexCol]))
	rangeStr = paste0("max:", maxValue, " min:", minValue, "<br><br>")

	chartJs = c(chartDiv, rangeStr, chartJsHead, countsdata, chartJsMid, countsname, chartJsTitle, chartJsTail)
	return(chartJs)
 }

# countUpDn function
 countUpDn <- function(indexNo){	# countUpDn return a string
	statResult = table(resultTable[,indexNo]>0)
	return(paste0("below zero: ", statResult[1], " above zero: ", statResult[2]))
 }

# set up count Trend diff and UpDn counts
  TrendDiffCnt = paste0("<br><br>Tdiff: ", countUpDn(15), "<br>\n",
	"UpDN count: ", countUpDn(16), "<br><br><br><br><br>\n")

# show charts msg
    showSpcCharts = paste0(
	 '<br><span id="dateAndTime" onclick="showDateAndTime()"><script>showDateAndTime();</script></span><br>',
     '<script>theList.push(',
	 paste0(activeStkList,collapse=","),
	 ')</script>',
     '<br><b class="goldword" onclick="window.scrollTo(0,document.body.scrollHeight);">Go Bottom</b>',
     '<p id ="codelist"></p>'
	)

# set up scriptPage
 scriptPage = readLines("aachartScript.js", warn=FALSE)

# final page assembly
 breaks = c(0,10,20,30,40,50,60,70,80,90,100)
 htmlpage = c(htmloutputHeader, htmlpage, 
 	pieChart("relPos Distribution", 9, breaks),

	# hbarChart("P T ratio Distribution", 6), 
	# hbarChart("curAmt Distribution", 10), 
	# hbarChart("amt T ratio distribution", 12), 
	# hbarChart("cTrend distribution", 13), 
	# hbarChart("Tdiff distribution", 15), 

	hbarChart("P T ratio Distribution", 6,breaks =c(seq(0.9, 1.1, by = 0.01))), 
	hbarChart("amt T ratio distribution", 12, breaks =c(seq(0, 100, by = 10))), 
	hbarChart("cTrend distribution", 13, breaks =c(seq(-0.25, 0.25, by = 0.02))), 
	hbarChart("Tdiff distribution", 15, breaks =c(seq(-0.2, 0.2, by = 0.02))), 
	TrendDiffCnt,

	scriptPage,
     "</center>",
	resultMsg, # this is the extra stat report paragraph
	showSpcCharts
 )


# functions to generate the output
 # generate major output file
  genOutput <- function(){
   sink(outputFileName)
   Sys.setlocale("LC_TIME", "English")
   cat(format(Sys.time(), "%H:%M:%OS  %a %d %b %Y"),"\n")
   cat(htmlpage, sep="\n") # htmlpage is the main content
   sink()
   unlink("KlineAnalysisResult.html")
   file.copy(outputFileName, "KlineAnalysisResult.html")
  }

 # update the activeLog
  update_activeLog <- function(){
   sink("activeLog.html",append = TRUE,)
   cat("\n",todayStr,"\n")
   cat("active counts: ", resultMsgNo,"\n")
   resultMsg = gsub('<br>' , '', resultMsg)
   cat(resultMsg)	# this is the new stat report append to activeLlog
   sink()
  }

 # generate OHLC record
  genOHLC <- function(){
   OHLCFileName = 'OHLC.txt'
   colnames(OHLCTable) <- c("Code", "Close", "High", "Low", "Vol")
   write.table(OHLCTable, file = OHLCFileName, sep="\t",quote=F,row.names = F)
  }

 # generate trendAmt record
  gentrendAmt <- function(){
   trendAmtFileName = 'trendAmt.txt'
   colnames(trendAmtTable) <- c("Code", "trendAmt")
   write.table(trendAmtTable, file = trendAmtFileName, sep="\t",quote=F,row.names = F)
  }
 # generate minMax record
  genMinMax <- function(){
   minMaxFileName = 'minMax.txt'
   colnames(minMaxTable) <- c("Code", "recentMax", "recentMin")
   write.table(minMaxTable, file = minMaxFileName, sep="\t",quote=F,row.names = F)
  }

 # generate the wAveTable and HwAveTable results
  genwAveTable <- function(){
   colnames(wAveTable) <- c("Code", "WAve5", "WAve10") 
   write.table(wAveTable, file = "wAveTable.txt", sep="\t",quote=F,row.names = F)
   write.table(HwAveTable, file = "HwAveTable.txt", sep="\t",quote=F,row.names = F)
   #write.table(StrengthTable, file = "StrengthTable.txt", sep="\t",quote=F,row.names = F)
  }

 # update the piechart
  update_piechart <- function(){
   breaks = c(0,10,20,30,40,50,60,70,80,90,100)
   sink("piechart.html",append = TRUE,)
   cat("\n<br>",todayStr,"\n<br>")
   cat(pieChart("relPos Distribution", 9, breaks))
   sink()
  }

 # update the % change piechart
  update_pctChange_piechart <- function(){
   breaks = c(-90,-10,-7,-5,-3,-1,0,1,3,5,7,10,90)
   sink("pctChange_piechart.html",append = TRUE,)
   cat("\n<br>",todayStr,"\n<br>")
   cat(pieChart("pctChange Distribution", 16, breaks))
   sink()
  }

 # update the price Range piechart
  update_pRange_piechart <- function(){
   breaks = c(0.05,0.1,0.5,1,3,5,10,30,50,100)
   sink("priceRange_piechart.html",append = TRUE,)
   cat("\n<br>",todayStr,"\n<br>")
   cat(pieChart("price Range Distribution", 5, breaks))
   sink()
  }

 # update the trade amount Range piechart
  update_AmtRange_piechart <- function(){
   breaks = c(500,1000,5000,10000,50000,500000)
   sink("AmtRange_piechart.html",append = TRUE,)
   cat("\n<br>",todayStr,"\n<br>")
   cat(pieChart("Amount Range Distribution", 10, breaks))
   sink()
  }

 # update the stronglist
  update_strongList <- function(){
   sink("strongList.html",append = TRUE,)
   cat("\n<br>",todayStr,"\n<br>")
   cat("Today Total: ", strongListCnt,"<br>\n")
   # strongList = unique(strongList)
   strongListdf = data.frame(strongAmt,strongList)
   strongListdf = unique(strongListdf)
   strongListdf = strongListdf[order(strongAmt),] 
   write.table(strongListdf, col.names=FALSE, row.names=FALSE, quote=FALSE) 
   sink()
  }

# final output
  genOutput()
#  update_activeLog()
#  genOHLC()
#  gentrendAmt()
#  genMinMax()
#  genwAveTable()
#  update_piechart()
#  update_pctChange_piechart()
#  update_pRange_piechart()
#  update_AmtRange_piechart()
#  update_strongList()
  # XList = unique(XList) this makes number different
#  genChart(XAmt, XList, "upX")
#  genChart(TPupAmt, TPupList, "TPup")
 
  addToCodeList(ignoreList, "coldbench.txt")
  addToCodeList(newcodeList, "newcode.txt")
  # rmItems
   rmItems(ignoreList,CodeTable)
   rmItems(newcodeList,CodeTable)
   CodeTable = unique(addItems(CodeTable, mustAdd)) # include the mustAdd
  #write.table(CodeTable, file = "codetable.txt", sep="\t",quote=F,row.names = F, col.names = F)
  #write.table(ignoreList, file = "ignoreList.txt", sep="\t",quote=F,row.names = F, col.names = F)
  #write.table(newcodeList, file = "newcodeList.txt", sep="\t",quote=F,row.names = F, col.names = F)

  # remove low amt from heavyStk
  heavyStk = readLines("heavyStk.txt")
  heavyStk = intersect(heavyStk, CodeTable)
  #write.table(heavyStk, file = "heavyStk.txt", sep="\t",quote=F,row.names = F, col.names = F)

  # remove low amt from activeList
  activeList = readLines("activeList.txt") # activeList is manually created list to monitor and colored
  activeList = intersect(activeList, CodeTable)
  #write.table(activeList, file = "activeList.txt", sep="\t",quote=F,row.names = F, col.names = F)

  # remove low amt from mylist
  mylist = readLines("mylist.txt") 
  mylist = intersect(mylist, CodeTable)
  #write.table(mylist, file = "mylist.txt", sep="\t",quote=F,row.names = F, col.names = F)

  cat("final CodeTable length: ", length(CodeTable),"\n")

  #save to rda file, Name, chiName, Max, Min, curPrice, P T Ratio, botRatio, curRatio, relPos, curAmt, trendAmt, Amt T Ratio,cTrend, pTrend, Tdiff, %chg
   save(resultTable, file = "resultTable.rda")
   # load the rda file load(file = "resultTable.rda")
   # hkcode = substr(thename, 3, 7)

  # copy backup
   file.copy("StrengthTable.html", paste0("StrengthTable ",todayStr,".html"))

# complete message
  cat("\n\n",todayStr, " Kline analysis completed!\n")

  file.copy("StrengthTable.html", "D:/Dropbox/Public/LibDocs/StrengthTable.html", overwrite = TRUE)
  file.copy("upX.html", "D:/Dropbox/Public/LibDocs/upX.html", overwrite = TRUE)
  file.copy("TPup.html", "D:/Dropbox/Public/LibDocs/TPup.html", overwrite = TRUE)


# show the report
  startstr="start chrome.exe --start-fullscreen \""
  shell(paste0(startstr, dirStr,"/", outputFileName))
  shell(paste0(startstr, dirStr,"/", "upX.html"))
  shell(paste0(startstr, dirStr,"/", "TPup.html"))

  cat(red("\n'<h2><span class=\"red blink\">",todayStr,"</span></h2>"), FLSZList)
  cat(red("\n'<h2><span class=\"red\">",todayStr,"-5</span></h2>"), FLSZ5List)
  X3List = union(X3List, cUpXWAve)
  X3List = union(X3List, CU3List)
  upFLSZList = intersect(X3List, FLSZList)
  cat(orange("\n'<h2>",todayStr,"upFLSZ</h2>"),upFLSZList)
  cat(red("\n'<h2>",todayStr,"upXWA</h2>"), cUpXWAve) # Close cross wAve
  cat(orange("\n'<h2>",todayStr,"cXWA</h2>"),intersect(cUpXWAve, X3List))
  cat(orange("\n'<h2><span class=\"brown\">",todayStr,"upXWA10</span></h2>"),cUpXWAve10)
  cat(orange("\n'<h2><span class=\"brown\">",todayStr,"upXWA20</span></h2>"),cUpXWAve20)
  cat(red("\n'<h2><span class=\"brown\">",todayStr,"10TPWAve20</span></h2>"),xWAve20WAve10TP)

  tempList = union(FLSZList, FLSZ5List)
  intersectList = intersect(cUpXWAve, X3List)
  intersectList = intersect(intersectList, tempList)
  cat(orange("\n'<h2>",todayStr,"cXWAnFL</h2>"), intersectList) # intersets the FLSZ

  cat(red("\n'<h2>",todayStr,"3X6</h2>"), X3List)   # WAve3 cross WAve6
  cat(red("\n'<h2>",todayStr,"CU3</h2>"), CU3List) # this is not correct
  cat(green("\n'<h2>",todayStr,"DnX3</h2>"), DX3List)
  cat(green("\n'<h2>",todayStr,"CD3</h2>"), CD3List) # this is not correct

  Rising = gsub("hk","",Rising)
  Strong = gsub("hk","",Strong)
  TPupList = gsub("hk","",TPupList)
  TPdnList = gsub("hk","",TPdnList)
  BBGList = gsub("hk","",BBGList)
  DBBGList = gsub("hk","",DBBGList)

  BBDList = gsub("hk","",BBDList)
  DBBDList = gsub("hk","",DBBDList)

  cat(red("\n'<h2>",todayStr,"<img src=\"./img/goingUp.gif\" style=\"max-width:20px; margin-top:-6px;\"></h2>"), Rising)
  cat(red("\n'<h2><span class=\"red\">",todayStr,"<img src=\"./img/fire.gif\" style=\"max-width:20px; margin-top:-6px;\"></span></h2>"), Strong)
  cat(yellow("\n'<h2><u class=\"yellow\">",todayStr,"TPup</u></h2>"), TPupList)
  cat(red("\n'<h2><i class=\"brown\">",todayStr,"BBG</i></h2>"), BBGList)
  cat(red("\n'<h2><i class=\"brown\">",todayStr,"DBBG</i></h2>"), DBBGList)

  cat(blue("\n'<h2><u class=\"lime\">",todayStr,"TPdn</u></h2>"), TPdnList)
  cat(blue("\n'<h2><i class=\"lime\">",todayStr,"BBD</i></h2>"), BBDList)
  cat(blue("\n'<h2><i class=\"lime\">",todayStr,"DBBD</i></h2>"), DBBDList)
  cat(blue("\n'<h2><i class=\"lime\">",todayStr,"FLXD</i></h2>"), FLXDList)
  cat(blue("\n'<h2><i class=\"lime\">",todayStr,"FLXD5</i></h2>"), FLXD5List)
  cat(blue("\n'<h2><i class=\"pink\">",todayStr,"LWAv5up</i></h2>"), LWAve5TupList)

  cat(yellow("\nmust note cXWA\n"))
  cat(pink("\nStatistics:\n"))
  cat(pink("FLSZList:"), length(FLSZList))
  cat(pink(" cUpXWAve:"), length(cUpXWAve)) # Close cross wAve
  cat(pink(" CU3List:"), length(CU3List))
  cat(pink(" DnX3List:"), length(DX3List))
  cat(pink(" CD3List:"), length(CD3List))
  cat(pink(" WAv3XWAv6:"), length(X3List))   # WAve3 cross WAve6
  cat(pink(" LWAve5Tup:"), length(LWAve5TupList),"\n")   # Low WAve5 TurnUp

# create freq count table
  srcList = unique(c(FLSZList, FLSZ5List, X3List, cUpXWAve, CU3List, DX3List, CD3List, gsub("hk","",Rising), gsub("hk","",Strong), gsub("hk","",TPupList), gsub("hk","",BBGList), gsub("hk","",DBBGList), gsub("hk","",BBDList), gsub("hk","",DBBDList)))
  
  totalList = list(FLSZList, FLSZ5List, X3List, upFLSZList, cUpXWAve, cUpXWAve10, cUpXWAve20, intersectList, X3List, CU3List, DX3List, CD3List, gsub("hk","",Rising), gsub("hk","",Strong), gsub("hk","",TPupList), gsub("hk","",BBGList), gsub("hk","",DBBGList), gsub("hk","",BBDList), gsub("hk","",DBBDList), LWAve5TupList)
  
  cntRec <- matrix(, ncol=2)
  cntRec = cntRec[-1,]
    for(item in srcList){
      freqCount = 0
      for(j in 1:length(totalList)){
          if(length(grep(item, totalList[[j]]))>0) freqCount = freqCount + 1
      }
      if(freqCount>1) cntRec = rbind(cntRec, c(item, freqCount))
    }
  cntRec = cntRec[order(as.numeric(cntRec[,2]),decreasing=TRUE),]
  
  folderName = "C:/Users/william/Desktop/Imp Mon Data/"
  setwd(folderName)
  
  newfilename = paste0("filteredCounnt", todayStr, ".txt")
  write.table(cntRec, file = newfilename, quote = FALSE,  row.names = FALSE, sep = "\t")


# join all vectors and table it, # allDnList will be required in future
allUpList = c(FLSZList, FLSZ5List, X3List, upFLSZList, cUpXWAve, intersectList, CU3List, Rising, Strong,TPupList, BBGList, DBBGList)
allUpList = gsub("hk", "", allUpList)

allUpListTable <- table(allUpList)
allUpListTable = sort(allUpListTable, decreasing = T)
listLabels = rownames(allUpListTable)
sink(paste0("allUpListTable", todayStr, ".txt"))
  for(i in 1:length(allUpListTable)){
    cat(listLabels[i],allUpListTable[i],"\n")
  }
sink()
cat(red("allUpListTable.txt written to disk!"))

shell(paste0(
  startstr,
  "C:/Users/william/Desktop/Imp Mon Data/",
  paste0("allUpListTable", todayStr, ".txt")
))

#  startstr="start launcher.exe --start-fullscreen \""
#  shell(paste0(startstr, dirStr,"/", outputFileName))

# comparison index raw data table:
# Date, 
# activity above 200W No, this is the final codetable length
# UP No, 
# Dn No, 
# Lv No,
# P above wAve5 No, 
# P below wAve5 No, 
# P above wAve10 No, 
# P below wAve10 No, 
# relPos above 50 No, 
# relPos below 50 No, 
# above prevH No, 
# below prevL No

# Total: 13 variables, minus date item, ramains 12 variables

# init 13 variables
# write a rawDat function to record data

# finally write to table
