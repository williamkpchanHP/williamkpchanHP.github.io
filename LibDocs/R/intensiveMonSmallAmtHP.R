# total 32 signals: ativUp,ativDn,cX_1Up,cX_1Dn,cX_2Up,cX_2Dn,cX_3Up,cX_3Dn,cX_4Up,cX_4Dn,cXmW1Up,cXmW1Dn,cXmW3Up,cXmW3Dn,cXWAvUp,cXWAvDn,DnTrig,dnXAmt,ExtImp,ExtImpPct,Grad-w!,Grad-ww,gtpdAmt,layerUp,layerDn,tUP,UpTrig,upXAmt,tDN,VlAmt,XmW3Up,XmW3Dn
# some stks with low trade amount may sudden rise and so mon amount
# should lower to below 800w and may put inside mustadd list
# statusCheck is the worker
# key point: klineWave <<- rbind(klineWave
# modify: check C cross WAve3, compare with klineWave
# modify: check minute cross
# check turning points
# locate the mixed signal
  options(timeout = 5*60)
  rm(list = ls())

# setup environments
  options("encoding" = "native.enc")
  options(max.print=2000)
  dirStr = "C:/R programs/!!! STKMon !!!"
  setwd(dirStr)
  library(jsonlite)
  library(dplyr)
  library(tableHTML)
  library(Hmisc)
  Sys.setlocale(category = 'LC_ALL', 'Chinese')
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
  # bgBlack, bgRed, bgGreen, bgYellow, bgBlue, bgMagenta, bgCyan, bgWhite
  library(stringr)
  # library(beepr)
  # library(audio)
  # add module
  source("C:/R programs/!!! STKMon !!!/appendText.R")
  source("C:/R programs/!!! STKMon !!!/precheckData.R")
  source("C:/R programs/!!! STKMon !!!/outputbuf.R", encoding="UTF-8")
  source("C:/R programs/!!! STKMon !!!/intenMonCheckKline.R")

  cat(magenta(format(Sys.time(), "%H:%M:%OS"),"\n"))
  todayDate = format(Sys.Date(), format="%Y-%m-%d") # for compare with datapage last trade date
 
  klineWave = data.frame() # WAve3,WAve9,WAve9,prevWAve3,prevWAve6,prevWAve9,criteriaSig
  wAveTable <- matrix(,ncol=3, nrow=0) # this is the price trend table
  minuteHistory <- matrix(,ncol=3, nrow=0) # minuteHistory: matrix of signal, codenumber, codechiname
  bombMatrix <- matrix(,ncol=2, nrow=0) # codenumber, bombCount
  almHistory = array()  # records all alarms
  bombCount = 0

  classifiedList = character()
  allUpTrigList = character()
  alllrgAmtList = character()
  allstarlrgAmtList = character()
  allstarlrgAmtmList = character()

  allUpAMt = character()
  allbrkUpTrig = character()
  allbrkUp = character()
  allDANGER = character()
  alltDN = character()
  alllayerDn = character()
  alllayerUp = character()
  allwatchUp = character()
  allImpAmtList = character()
  allComplexList = character()
  allmWaveUp = character()
  allcXallUp = character()
  alltriList = character()
  alltriListCount = character()
  allDayLineList = character()
  allExtImpPctList = character()
  ImpAlarmList = character()
  allcXmList0 = character()
  allheedList = character()
  allheedAmtList = character()
  allWAve3x6List = character()
  allWAve3v6List = character()
  allXWAvUp_N_XallUp = character()

  dayLineList = character()
  impList = character()
  watchList = character()
  abnormalList = character()

     extraImpList = character()
     allGradList = character()
     allStarGradList = character()
     allStarGradmList = character()
     starGradList = character()
     starGradmList = character()
     turnUpList = character()
     allturnUpList = character()
     turnDnList = character()
     allturnDnList = character()
     tUPList = character()
     UpRecList = character()
     prevUpRecList = character()
     tDNList = character()
     alltDNList = character()

countstarlrgAmtList = vector()
countstarlrgAmtmList = vector()
countlrgAmtList = vector()
countalertList = vector()
countactiveAmtList = vector()
countGradList = vector()
countVlAmtList = vector()
countgtpdAmtList = vector()
# countVlAmt_N_gtpdAmt = vector()
countVlAmt_N_cXallUp = vector()
countVlAmt_N_UpTrig = vector()
countupXAmtList = vector()
countcXallUpList = vector()
countUpTrigList = vector()
countcXWAvUpList = vector()
countcXWAvDnList = vector()
countXWAvUp_N_XallUp = vector()
countUpTrig_N_cXallUp = vector()
countStronUpList = vector()
countmWaveUpList = vector()
countcX_1DnList = vector()
countcXallDnList = vector()
countDnTrigList = vector()
countdnXAmtList = vector()
countVlAmt_N_cXallDn = vector()
countVlAmt_N_DnTrig = vector()
countStronDnList = vector()
countmWaveDnList = vector()
tUPListCnt = vector()
tDNListCnt = vector()

  shortintv = 3
  longintv = 10
  onecode = "00821"
 #==== Msg Definition
  # May consider open browser, but if frequency too high will be annoying
  # may collect data every min but report every 5 min, and give minute alarm instantly
  CMDCode='mshta javascript:alert(\"'
  CMDTail='\");close();'
  noticeTitle = "Monitor Status!"  # popup message
  LF = "\\n"
  popupKey = FALSE
  mustpopupKey = FALSE
  RptLog = character()
  mustPopLog = character()
  mustPopRec = character()
  mustPopRecBuffer = character()
  APC5UpLog = character()
  aLLUpLog = character()
  AAURec = character() # allallUp Record
  AAURecLog = character() # allallUp Record
  AADRec = character() # allallDn Record
  newcodeList = character()
  timemark = substr(format(Sys.time(), format="%y%m%d%H%M"), 1,9) # prepare for file cut interval

  # note this is for multi quote format: http://qt.gtimg.cn/?q=s_hkHSI,s_hk00700
  # and is prepared for bat quoting later
  theHeader = "http://sqt.gtimg.cn/q=r_hk"

  fDayHead <- "http://web.ifzq.gtimg.cn/appstock/app/day/query?_var=fdminData&code=hk"
   # "1008 386.00 1992315" time, price, vol(not price) in unit share


  CountNo = 1
  PtrendStatus = "Level"
  NowtrendStatus = "Level"

  PTStatus = "Level"
  NowTStatus = "Level"

  PbbgStatus = "Level"
  NowbbgStatus = "Level"

  #TDXfilename = "BIGCHIPS.blk" # file for TDX inspection

  IntervalMinutes = 1 # in minutes
  trendShort = 60 # in minutes
  onecode = "00700"
  fDayHead ="http://web.ifzq.gtimg.cn/appstock/app/day/query?_var=fdminData&code=hk"
   # "1008 386.00 1992315" time, price, vol(not price) in unit share
  opTime = 0
 # TP init
  TPupList = vector("character")
  TPupListCnt = 0
  TPdnList = vector("character")
  TPdnListCnt = 0

  SPupListTxt = vector("character")

  ShortupListTxt = vector("character")
  ShortupListCnt = 0
  checkList = vector("character")

# FetchKline reads url, convert to data.frame, cal all parameters and detections
  FetchKline <- function(onecode){
  # collect data
    theHeader = "http://web.ifzq.gtimg.cn/appstock/app/hkfqkline/get?_var=kline_dayqfq&param=hk"
    theTail = ",day,,,10,qfq"
    # cat(paste0(theHeader,onecode,theTail),"\n")
    thepage = readLines(paste0(theHeader,onecode,theTail), encoding="GB2312", warn=FALSE)    # data contain header and trailer
    # cat("OK\n")  
# extract data
    thepage = gsub('kline_dayqfq=', "", thepage) # remove extra useless data
    thepage = fromJSON(thepage)
    # names(thepage) show the names of dataframe
    thepage = thepage["data"]
    thestkCode = names(thepage[["data"]]) # hk03800
    thepage = thepage[["data"]]

    thepage = thepage[[thestkCode]]
    datapage = thepage[[names(thepage[1])]]

  # determine the last trade day, if current date is the last trade date
    lastTradeDate = datapage[[length(datapage)]][1]
    if(todayDate == lastTradeDate){ lastDayPoint = -1  # same day, lastday is -1
    }else{ lastDayPoint = 0} # today is different from the datapage last date
    # lastDayPoint = 0  # this causes wrong choice of data set
  # check new code
    if(length(datapage)<10){
      closeAllConnections()
      # cat(onecode, " newcode! ")
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

    # modify the typhoonDate amt , to avoid typhone date give 0 daily amt
     typhoonDateId = grep(typhoonDate, datapage)
     if(length(typhoonDateId)>0){
          datapage = datapage[-typhoonDateId,]
     }

    # array manipulation complete
    # colnames(thepage) <- c("Date", "Open", "Close", "High", "Low", "Vol", "Amt")
     # datapage[,3] is the close
    beginPt = length(datapage[,3]) - (shortintv-1) + lastDayPoint # change shortintv will change trend interval
    veryLastPt = length(datapage[,3])
    lastPt = veryLastPt + lastDayPoint

    theCurURL = paste0("http://web.sqt.gtimg.cn/q=r_hk", onecode)
    # cat("get theCurInfo: ", theCurURL, "\n")
    theCurInfo = readLines(theCurURL, encoding="GB2312", warn=FALSE)    # data contain header and trailer
    #cat("OK\n")
    theCurInfo = unlist(strsplit(theCurInfo, "~"))

    curHigh = as.numeric(theCurInfo[34]) # if not yet open trade, will it cause error?
    curPrice = as.numeric(theCurInfo[4])
    prevPrice = as.numeric(theCurInfo[5])

    pprevPrice = as.numeric(datapage[(lastPt-1),3])
    ppprevPrice = as.numeric(datapage[(lastPt-2),3])

    pctChange = round(((curPrice - prevPrice)*100/prevPrice),1) # to be returned

    curHigh = as.numeric(datapage[lastPt,4]) # to be returned
    prevHigh = as.numeric(datapage[(lastPt-0),4])
    pprevHigh = as.numeric(datapage[(lastPt-1),4])
    ppprevHigh = as.numeric(datapage[(lastPt-2),4])

    curLow = as.numeric(datapage[lastPt,5]) # to be returned
    prevLow = as.numeric(datapage[(lastPt-0),5])
    pprevLow = as.numeric(datapage[(lastPt-1),5])

    trendPrice = calcWAve(as.numeric(datapage[beginPt:veryLastPt,3]))
    curPriceTrendRatio = curPrice / trendPrice

    # select long period vol and amt, use longbeginPt
    longbeginPt = 3 + lastDayPoint # the period must be same for all wAves, the short period is 3
    meanVol = mean(as.numeric(datapage[longbeginPt:veryLastPt,6])) # to be returned

    # cal 10 days max and min
    max10H = max(as.numeric(datapage[(veryLastPt-9):veryLastPt,4])) # to be returned
    min10L = min(as.numeric(datapage[(veryLastPt-9):veryLastPt,5])) # to be returned

    curDayAmt = as.numeric(datapage[veryLastPt,7])  # already in w
    prevAmt = as.numeric(datapage[(lastPt),7])
    trendAmt = calcWAve(as.numeric(datapage[longbeginPt:(veryLastPt),7])) # count up to prev day

    # if(trendAmt>0){
    #     amtTrendRatio = round((curDayAmt *100/ trendAmt),0)
    # }else{
    #     amtTrendRatio = 0
    # }

  # create temp array to evaluate WAve, this is longbeginPt
    tempClosearray = as.numeric(datapage[longbeginPt:veryLastPt,3])
    prevtempClosearray = as.numeric(datapage[(longbeginPt-1):(veryLastPt-1),3])
    pprevtempClosearray = as.numeric(datapage[(longbeginPt-2):(veryLastPt-2),3])

    # datapage[,5] is the low
    tempLarray = as.numeric(datapage[longbeginPt:veryLastPt,5])
    prevtempLarray = as.numeric(datapage[(longbeginPt-1):(veryLastPt-1),5])
    pprevtempLarray = as.numeric(datapage[(longbeginPt-2):(veryLastPt-2),5])

    # datapage[,4] is the high
    tempHarray = as.numeric(datapage[longbeginPt:veryLastPt,4])
    prevtempHarray = as.numeric(datapage[(longbeginPt-1):(veryLastPt-1),4])
    pprevtempHarray = as.numeric(datapage[(longbeginPt-2):(veryLastPt-2),4])

    #=========================
  # evaluate WAve
    lastWAve = round(calcWAve(tempClosearray),3)
    prevWAve = round(calcWAve(prevtempClosearray),3)
    pprevWAve = round(calcWAve(pprevtempClosearray),3)

  # evaluate LWAve
    lastLWAve = round(calcWAve(tempLarray),3)
    prevLWAve = round(calcWAve(prevtempLarray),3)
    pprevLWAve = round(calcWAve(pprevtempLarray),3)

  # evaluate HWAve
    lastHWAve = round(calcWAve(tempHarray),3)
    prevHWAve = round(calcWAve(prevtempHarray),3)
    pprevHWAve = round(calcWAve(pprevtempHarray),3)

  # evaluate WAve3 ~ 9 for wAveTable
    WAve3array = as.numeric(datapage[(veryLastPt-2):veryLastPt,3]) # lastPt-2 is shortintv 3
    WAve6array = as.numeric(datapage[(veryLastPt-5):veryLastPt,3])
    WAve9array = as.numeric(datapage[(veryLastPt-8):veryLastPt,3])
    #WAve12array = as.numeric(datapage[(lastPt-11):lastPt,3]) # use for strength analysis
    #WAve15array = as.numeric(datapage[(lastPt-14):lastPt,3]) # use for strength analysis

  # evaluate LWAve3 ~ 9 for LwAveTable
    LWAve3array = as.numeric(datapage[(veryLastPt-2):veryLastPt,5]) # lastPt-2 is shortintv 3
    LWAve6array = as.numeric(datapage[(veryLastPt-5):veryLastPt,5])
    LWAve9array = as.numeric(datapage[(veryLastPt-8):veryLastPt,5])

  # evaluate HWAve3 ~ 9 for HwAveTable
    HWAve3array = as.numeric(datapage[(veryLastPt-2):veryLastPt,4]) # lastPt-2 is shortintv 3
    HWAve6array = as.numeric(datapage[(veryLastPt-5):veryLastPt,4])
    HWAve9array = as.numeric(datapage[(veryLastPt-8):veryLastPt,4])

    prevWAve3array = as.numeric(datapage[(veryLastPt-3):(veryLastPt-1),3])
    prevWAve6array = as.numeric(datapage[(veryLastPt-6):(veryLastPt-1),3])
    prevWAve9array = as.numeric(datapage[(veryLastPt-9):(veryLastPt-1),3])
    #prevWAve12array = as.numeric(datapage[(lastPt-12):(lastPt-1),3])
    #prevWAve15array = as.numeric(datapage[(lastPt-15):(lastPt-1),3])

    prevLWAve3array = as.numeric(datapage[(veryLastPt-3):(veryLastPt-1),5])
    prevLWAve6array = as.numeric(datapage[(veryLastPt-6):(veryLastPt-1),5])
    prevLWAve9array = as.numeric(datapage[(veryLastPt-9):(veryLastPt-1),5])

    prevHWAve3array = as.numeric(datapage[(veryLastPt-3):(veryLastPt-1),4])
    prevHWAve6array = as.numeric(datapage[(veryLastPt-6):(veryLastPt-1),4])
    prevHWAve9array = as.numeric(datapage[(veryLastPt-9):(veryLastPt-1),4])

    WAve3 = calcWAve(WAve3array)
    WAve6 = calcWAve(WAve6array)
    LWAve3 = calcWAve(LWAve3array)
    HWAve3 = calcWAve(HWAve3array)

    prevWAve3 = calcWAve(prevWAve3array)
    prevWAve6 = calcWAve(prevWAve6array)
    prevWAve9 = calcWAve(prevWAve9array)
    pWAve = c(prevWAve3,prevWAve6,prevWAve9)

    prevLWAve3 = calcWAve(prevLWAve3array)
    prevHWAve3 = calcWAve(prevHWAve3array)

    todayWAve = WAve3
    todaymax = max(todayWAve)
    todaymin = min(todayWAve)
    todayheight = todaymax-todaymin

    pmax = max(pWAve)
    pmin = min(pWAve)
    pheight = pmax-pmin

    strongSig = FALSE
    if( (HWAve3 > prevHWAve3) & (todayheight > pheight)){
       criteriaSig = TRUE
       # compare curLow, prevLow
        if((curLow > LWAve)& (prevLow > pprevLow)){
          strongSig = TRUE
        }else{
          strongSig = FALSE
        }
    }else(criteriaSig = FALSE)

    # WAve3, pWAve, criteriaSig,strongSig, LWAve3, prevLWAve3, prevHWAve3, HWAve3
    waveResult = c(todayWAve, pWAve, criteriaSig, strongSig, LWAve3, prevLWAve3, HWAve3, prevHWAve3) # total 10 items
    klineWave <<- rbind(klineWave, waveResult)  # store result to klineWave, total 10 items
  #=========================

    closeAllConnections()
     thestkCode = gsub("hk", "", thestkCode)
     #if(criteriaSig & (curPrice > WAve3)){cat("above trend: ", blue(thestkCode)," ")}

    triggerWave = backCalcWAve3Value(WAve3array, WAve6) # this is triger value of WAve3

   return(c(thestkCode, chiName, prevWAve3, prevPrice, pprevPrice, prevAmt, trendAmt, WAve3, max10H, min10L, triggerWave)) # add WAve3, max10H, min10L, triggerWave
  # ====== preprocess finished here
  }
# support functions

  # load history table
    loadHistoryAmt <- function(){
      folderName = "C:/Users/william/Desktop/Imp Mon Data"
      setwd(folderName)
      HistoryAmt = readLines("amtHistory.txt")
      Selection = readline(prompt=paste0(pink$bold$underline("enter last reference folder date: ")))
      Selection = paste0("/Allcode", Selection)

      printtimeStamp <- format(Sys.time(), "%H:%M:%OS")

      bombMatrixFile = readLines(paste0(folderName, Selection,"/","allSecRecList.txt",sep=""))
      bombMatrixIdx = grep("bombMatrix", bombMatrixFile)
      bombMatrixFile = bombMatrixFile[-(1:(bombMatrixIdx+1))]
      bombMatrixFile = gsub("^.*\\] ","",bombMatrixFile)
      bombMatrixFile = gsub(" {1,}$","",bombMatrixFile)
      bombMatrixFile = gsub(" {1,}"," ",bombMatrixFile)
      bombMatrix <<- matrix(unlist(strsplit(bombMatrixFile, " ")), ncol=2,byrow=TRUE)
      bombMatrix[,2] <<- as.numeric(bombMatrix[,2]) + 1000
      for(i in 1:length(bombMatrix[,2])){
         bombValue = as.numeric(bombMatrix[,2])
         if(bombValue > 4000){ bombMatrix[,2] <<- 4000}
         if(bombValue == 4000){ bombMatrix[,2] <<- 0}
         if((bombValue >= 3000)&(bombValue < 4000)){ bombMatrix[,2] <<- 3000}
         if((bombValue >= 2000)&(bombValue < 3000)){ bombMatrix[,2] <<- 2000}
         if((bombValue >= 1000)&(bombValue < 2000)){ bombMatrix[,2] <<- 1000}
      }
      setwd(dirStr)

      cat(red("loading History Amt...\n"))
      for(pointer in 1:length(HistoryAmt)){
        temp = unlist(strsplit(HistoryAmt[pointer], " "))
        amtHistoryCode[pointer] <<- temp[1]    # this is the code number

        # cannot remove the outliers
          tempAmtSummary = as.numeric(temp[-1])
          if(length(tempAmtSummary)>3){  # at least a min and a max
            minAmtSummary = min(tempAmtSummary)
            maxAmtSummary = max(tempAmtSummary)
            if(maxAmtSummary == minAmtSummary){maxAmtSummary = maxAmtSummary + 1}

           # the min and max includes the real min and max, steps not include
            thesteps = seq(minAmtSummary, maxAmtSummary, (maxAmtSummary - minAmtSummary)/10)
            amtHistory[pointer] <<- list(thesteps)
          }else{    # no data, create fake steps
            thesteps = seq(1, 10, 1)
            amtHistory[pointer] <<- list(thesteps)
          }
      }
      cat(pink("loading History Amt completed\n"))

    }

 # Grade the amt
    amtGrade <- function(codenumber, avalue){
      pointer = which(amtHistoryCode == codenumber)
      if(length(pointer)>0){
        return(
          case_when(
           avalue <= amtHistory[[pointer]][2] ~ 1,
           avalue > amtHistory[[pointer]][2] && avalue < amtHistory[[pointer]][3] ~ 2,
           avalue > amtHistory[[pointer]][3] && avalue < amtHistory[[pointer]][4] ~ 3,
           avalue > amtHistory[[pointer]][4] && avalue < amtHistory[[pointer]][5] ~ 4,
           avalue > amtHistory[[pointer]][5] && avalue < amtHistory[[pointer]][6] ~ 5,
           avalue > amtHistory[[pointer]][6] && avalue < amtHistory[[pointer]][7] ~ 6,
           avalue > amtHistory[[pointer]][7] && avalue < amtHistory[[pointer]][8] ~ 7,
           avalue > amtHistory[[pointer]][8] && avalue < amtHistory[[pointer]][9] ~ 8,
           avalue > amtHistory[[pointer]][9] && avalue < amtHistory[[pointer]][10] ~ 9,
           avalue > amtHistory[[pointer]][10] && avalue < amtHistory[[pointer]][11] ~ 10,
           TRUE ~ 11
          )
        )
      }else{
         cat(codenumber, red("no amt history!\n"))
         return(1)
      }
    }

 # check bombMatrix init or increase
  check_bombMatrix = function(codenumber){
             if(codenumber %in% bombMatrix[,1]){  # already recorded
              bombpointer = match(codenumber,bombMatrix[,1])
              bombMatrix[bombpointer,2] <<- as.numeric(bombMatrix[bombpointer,2]) + 1
              bombCount <<- bombMatrix[bombpointer,2]
             }else{
              bombMatrix <<- rbind(bombMatrix, c(codenumber, 1))
              bombCount <<- 1
             }
  }

 # read bombMatrix init or increase
  read_bombMatrix = function(codenumber){
             if(codenumber %in% bombMatrix[,1]){  # already recorded
              bombpointer = match(codenumber,bombMatrix[,1])
              return(as.numeric(bombMatrix[bombpointer,2]))
             }else{
              return(0)
             }
  }

 # askforfilename
  askforfilename <-function(){
    Selection = readline(prompt=paste0(pink$bold$underline("Keep List Short!!!"), "enter List name without extension: "))
    if(Selection == "") { 
     cat("\nblank name! exited!\n")
     break
    }
    return(Selection)		# if empty, calling program handle
  }

 # addItems
  addItems <- function(targetList, addItem){
		targetList = c(targetList, setdiff(addItem,targetList))
		return(targetList)
  }

 # send popup
  sendPages <- function(sendthepage, All_UpX_cnt, All_DnX_cnt){
    if(popupKey){ # popupKey is the switch to turn on popup
      AlertMsg = paste0(
         CMDCode,
         format(Sys.time(), "%H:%M:%OS"),"  ",codeTableName, "  All UpX: ",All_UpX_cnt,"  All DnX: ",All_DnX_cnt, LF,LF,
         paste0(sendthepage,LF,LF, collapse=""), 
         CMDTail)

      system(AlertMsg, invisible=T, wait=F)
    }
  }

 # mustsend popup
  mustsendPages <- function(sendthepage){
     AlertMsg = paste0(
         CMDCode,
         format(Sys.time(), "%H:%M:%OS"),"  ",codeTableName, LF,LF,
         paste0(sendthepage,LF,LF, collapse=""), 
         CMDTail)

     system(AlertMsg, invisible=T, wait=F)
  }

 # errorAlarm popup
  errorAlarm <- function(){
     AlertMsg = paste0(
         CMDCode, format(Sys.time(), "%H:%M:%OS")," Error Alarm !!!", LF,LF,
         CMDTail)
     system(AlertMsg, invisible=T, wait=F)
  }

 # filter signature from MinuteHistory, matrix of signal, codenumber, codechiname
  filterMinHist = function(signature){
    sigList = grep(signature, minuteHistory[,1])
    return(minuteHistory[sigList,2])       # get the stkcode
  }

 # commonCode extracts those commons from two lists
  commonCode <-function(List1, List12){ return(List1[List1 %in% List12]) }

 # printcodeNname print code and name of selected minuteHistory
  printcodeNname <-function(className,codeList){

     if((className == "XWAv + XallUp")|(className == "upXAmt")|(className == "complex")){
       cat("\n",bgRed(className, ": ",sep=""))  # print results
     }else if((className == "X_1Up")|(className == "X_1Dn")){
       cat("\n",lime(className, ": ",sep=""))  # print results
     }else if((className == "Lrg Amt")|(className == "ativ")|(className == "GradAmt")|(className == "*LrgUp Amt")|(className == "*LrgUpm Amt")|(className == "multiSig")){
       cat("\n",bgRed(className, ": ",sep=""))  # print results
     }else if((className == "dnXAmt")|(className == "important")|(className == "turnDn")){
       cat("\n",bgBlue(className, ": ",sep=""))  # print results
     }else if((className == "XallUp")|(className == "turnUp")){
       cat("\n",red(className, ": ",sep=""))  # print results
     }else{
       cat("\n",white(className, ": ",sep=""))  # print results
     }
     printtimeStamp <- format(Sys.time(), "%H:%M:%OS")
     classifiedList <<- c(classifiedList,"\n",printtimeStamp,className, ": ")


     for(item in codeList){
       pinpoint = which(minuteHistory[,2] == item) # search the minuteHistory record
       pinpoint = pinpoint[1]        # select only one
       cat(gray(minuteHistory[pinpoint,2]))

       if(minuteHistory[pinpoint,2] %in% strongSigList){ # code is one of strongSigList
             cat("",orange(minuteHistory[pinpoint,3]),"")   # print name diff color
       }else if((minuteHistory[pinpoint,2] %in% mustAdd) |
                (minuteHistory[pinpoint,2] %in% mustPopList)){
                cat("",gold(minuteHistory[pinpoint,3]),"")
       }else if(minuteHistory[pinpoint,2] %in% shortTerm){
             cat("",deeppink(minuteHistory[pinpoint,3]),"")
       }else if(minuteHistory[pinpoint,2] %in% heavyStk){
             cat("",purple(minuteHistory[pinpoint,3]),"")
       }else{
             cat("",pink(minuteHistory[pinpoint,3]),"")
       }
       classifiedList <<- c(classifiedList, minuteHistory[pinpoint,2], minuteHistory[pinpoint,3])
     }
  }

 # printText
  printText<-function(textDatVector){
    if(length(textDatVector)!=0){
     for(i in 1:length(textDatVector)){
      theOLine = textDatVector[i] # take out the line for processing
      if(grepl(" cAmt ", theOLine)){
       theOLine = gsub(" {1,}", " ", theOLine)
       theOLine = unlist(strsplit(theOLine, " "))

       # cat("\n",theOLine[1], " ") # time string
       cat("\n")
       if (grepl("WAvDn", theOLine[2])){ cat(purple(theOLine[2]))
       }else if(grepl("Dn", theOLine[2])){ cat(green(theOLine[2]))
       }else if(grepl("WAvUp", theOLine[2])){ cat(deeppink(theOLine[2]))
       }else if(grepl("Up", theOLine[2])){ cat(red(theOLine[2]))
       }else if(grepl("gtpdAmt", theOLine[2])){ cat(orange(theOLine[2]))
       }else if(grepl("ativ|Grad", theOLine[2])){ cat(gold(theOLine[2]))
       }else if(grepl("upXAmt", theOLine[2])){ cat(bgRed(theOLine[2]))
       }else if(grepl("dnXAmt", theOLine[2])){ cat(bgBlue(theOLine[2]))
       }else{ cat(pink(theOLine[2]))}

       if (theOLine[3] %in% mustAdd){ cat("\t", gold(theOLine[3]), " ", sep="")
       }else if(theOLine[3] %in% heavyStk){ cat("\t", purple(theOLine[3]), " ", sep="")
       }else if(theOLine[3] %in% shortTerm){ cat("\t", deeppink(theOLine[3]), " ", sep="")
       }else{ cat("\t", theOLine[3], " ", sep="")}

       theOLine[4] = substr(theOLine[4], 1, 4)
       #if(nchar(theOLine[4])<6){
       #  spcSTr = paste(rep(" ",(6 - nchar(theOLine[4]))), collapse = "") # must paste collapse
       #  theOLine[4] =paste(theOLine[4],spcSTr, collapse = "")
       #}
       cat(theOLine[4], "\t",collapse = "")
       curCpointer = grep("curC", theOLine)
       if (curCpointer>5){
         theOLine = theOLine[-c(5:(curCpointer-1))]
       }
       cat(theOLine[5]) # curC
       if(as.numeric(theOLine[6]) < 15){
         cat(orange(setFixedWidth(theOLine[6],6))) # value of curC
       } else { cat(pink(setFixedWidth(theOLine[6],6))) }

       cat(" ",theOLine[7], collapse = "")  # C%
       if(nchar(format1digit(as.numeric(theOLine[8])))<4){cat(" ")}
       printColorPct(theOLine[8])

       cat("\t", theOLine[9], "", collapse = "") # c%
       if(nchar(format1digit(as.numeric(theOLine[10])))<4){cat(" ")}
       printColorPct(theOLine[10])

       cat("", ligSilver(theOLine[21]), collapse = "") # rLv inserted here
       if(nchar(theOLine[22])<2){ cat(" ")}

       if(!is.na(as.numeric(theOLine[22]))){ # this is to avoid NA
         if(as.numeric(theOLine[22])<4){cat(deeppink(theOLine[22])) # rLv inserted here
         } else { cat(ligSilver(theOLine[22])) }
       }

       cat("", theOLine[11], "", collapse = "") # cAmt
       printCurAmt(theOLine[12])
       cat("\t", theOLine[13], " ", collapse = "") # almLv
       printAlmLv(theOLine[14])

       cat("",theOLine[15], collapse = "") # ppct
       if(nchar(theOLine[16])<2){cat(" ")}
       printPctValue(theOLine[16])

       cat(" ", theOLine[17], collapse = "") # DAmt
       cat("", ligSilver(theOLine[18]), collapse = "") # 
       cat("", theOLine[19], "", collapse = "") # pcDAmt
       printDpctValue(theOLine[20])
      }
     }
    }

    signalAnalysis()  # print selected signals
    mustPopup()
  }
 
 # signalAnalysis defines signals, filter signals and print, clear at end
  signalAnalysis <-function(textDatVector){
    # signal, codenumber, codechiname

    # defines and filter signals
     totalupList = filterMinHist("Up")
     upList = sort(table(totalupList), decreasing = TRUE)
     upList = upList[upList>=4] # make it harsher
     multiSigList = names(upList)

     GradList = filterMinHist("Grad")
     extraImpList <<- filterMinHist("ExtImp")
     starGradList <<- filterMinHist("Grad-ww")
     starGradmList <<- filterMinHist("Grad-w!")
     activeAmtList = unique(filterMinHist("ativUp"))
     turnUpList = filterMinHist("turnUp") # this is not yet mixed with global list
     tUPList <<- filterMinHist("tUP")
     tDNList <<- filterMinHist("tDN")

     tUPListCnt <<- c(tUPListCnt, length(tUPList)) # record count number for stat
     tDNListCnt <<- c(tDNListCnt, length(tDNList))

     ExtImpPctList <<- filterMinHist("ExtImpPct")

     # mustPop(paste("turnUp", paste(turnUpList ,collapse=" ")))
     cXWAvUpList = filterMinHist("cXWAvUp")
     cXWAvDnList = filterMinHist("cXWAvDn")
     cX_1UpList = filterMinHist("cX_1Up")
     cX_2UpList = filterMinHist("cX_2Up")
     cX_3UpList = filterMinHist("cX_3Up")
     cX_4UpList = filterMinHist("cX_4Up")
     StronUpList = filterMinHist("StronUp")
     cXmW1UpList = filterMinHist("cXmW1Up")
     cXmW3UpList = filterMinHist("cXmW3Up")
     XmW3UpList = filterMinHist("XmW3Up")

     cXallUpList = unique(c(cX_1UpList,cX_2UpList,cX_3UpList,cX_4UpList))  # _1 _2 350 700
     mWaveUpList = unique(c(cXmW1UpList,cXmW3UpList,XmW3UpList))

     cXmList0 = commonCode(cXmW1UpList, cXmW3UpList)  # this is important
     cXmList1 = commonCode(cXmList0, XmW3UpList)     # cXmW1UpList, cXmW3UpList, XmW3UpList exist same time
     cX1_4UpList = unique(c(cX_1UpList, cX_2UpList, cX_3UpList, cX_4UpList))

     turnDnList = filterMinHist("turnDn") # this is not yet mixed with global list
     # mustPop(paste("turnDn", paste(turnDnList ,collapse=" ")))
     cX_1DnList = filterMinHist("cX_1Dn")
     cX_2DnList = filterMinHist("cX_2Dn")
     cX_3DnList = filterMinHist("cX_3Dn")
     cX_4DnList = filterMinHist("cX_4Dn")
     StronDnList = filterMinHist("StronDn")
     cXmW1DnList = filterMinHist("cXmW1Dn")
     cXmW3DnList = filterMinHist("cXmW3Dn")
     XmW3DnList = filterMinHist("XmW3Dn")
     WAve3x6List = filterMinHist("WAve3x6")
     WAve3v6List = filterMinHist("WAve3v6")
     layerDnList = unique(filterMinHist("layerDn"))
     layerUpList = unique(filterMinHist("layerUp"))

     cXallDnList = unique(c(cX_2DnList,cX_3DnList,cX_4DnList))
     mWaveDnList = unique(c(cXmW1DnList,cXmW3DnList,XmW3DnList))

     upXAmtList = filterMinHist("upXAmt")
     dnXAmtList = filterMinHist("dnXAmt")

     VlAmtList = filterMinHist("VlAmt")
     gtpdAmtList = filterMinHist("gtpdAmt")

     UpTrigList0 = filterMinHist("UpTrig")
     UpTrigList = union(UpTrigList0,mWaveUpList) # this inclues UpTrigList and mWaveUpList

     DnTrigList0 = filterMinHist("DnTrig")
     DnTrigList = union(DnTrigList0,mWaveDnList) # this inclues DnTrigList and mWaveDnList

    # find common signals
     XWAvUp_N_XallUp = commonCode(cXWAvUpList, cXallUpList)  # find the commons
     # VlAmt_N_gtpdAmt = commonCode(VlAmtList, gtpdAmtList)   # gtpdAmt
     VlAmt_N_cXallUp = commonCode(VlAmtList, cXallUpList)   # Up
     VlAmt_N_cXallDn = commonCode(VlAmtList, cXallDnList)   # Dn
     UpTrig_N_cXallUp = commonCode(UpTrigList, cXallUpList)   # Dn

     VlAmt_N_UpTrig = commonCode(VlAmtList, UpTrigList)
     VlAmt_N_DnTrig = commonCode(VlAmtList, DnTrigList)

     alertList = unique(commonCode(XmW3UpList, cX_4UpList))  # condition 1

#     alertList = unique(union(activeAmtList, GradList))  # merge for output
#     alertList = unique(union(GradList, alertList))  # merge for output

#     alertList = commonCode(alertList, GradList)  # will stop reporting if previous day amt data is 0

     # lrgAmtList = union(GradList,activeAmtList) # exclude the activeAmtList
     upTrendList = union(mWaveUpList,cXallUpList)
     lrgAmtList = unique(commonCode(GradList,upTrendList)) # both up and amt conditions
     activeAmtList = unique(commonCode(activeAmtList,upTrendList)) # both up and amt conditions

     starlrgAmtList = unique(commonCode(starGradList,upTrendList))
     starlrgAmtmList = unique(commonCode(starGradmList,upTrendList))

     impList = unique(c(starlrgAmtList, starlrgAmtmList, extraImpList))  # select large amount
     impList <<- unique(commonCode(impList, cXallUpList))  # this is very possible to rise

    # print resulting signals, className, signal List
     cat("\n")
     if(length(multiSigList) != 0){
         #cat(orange(paste("multiSig", paste(multiSigList,collapse=" "))),"\n")
         #mustPop(paste("multiSig", paste(numWithName(multiSigList),collapse=" ")))
     }
#browser()
     if(length(starlrgAmtList) != 0){  # give popup alarm for 3 alarms
         #cat(orange(paste("*LrgUp Amt", paste(starlrgAmtList,collapse=" "))),"\n")
         #mustPop(paste("*LrgUp Amt!", paste(numWithName(starlrgAmtList),collapse=" ")))
     }
     if(length(cXallUpList) != 0){
         # mustPop(paste("XallUp", paste(numWithName(cXallUpList),collapse=" ")))
     }

     if(length(starlrgAmtmList) != 0){  # give popup alarm for 3 alarms
         #cat(orange(paste("*LrgUpm Amt", paste(starlrgAmtmList,collapse=" "))),"\n")
         #mustPop(paste("*LrgUpm Amt!", paste(numWithName(starlrgAmtmList),collapse=" ")))
     }
     if(length(lrgAmtList) != 0){  # give popup alarm for 3 alarms
         #cat(orange(paste("LrgUp Amt", paste(lrgAmtList,collapse=" "))),"\n")
         #mustPop(paste("LrgUp Amt!", paste(numWithName(lrgAmtList),collapse=" ")))
     }
     if(length(alertList) != 0){  # give popup alarm for 3 alarms
         #cat(deeppink(paste("complex", paste(alertList,collapse=" "))),"\n")
         printcodeNname("complex", alertList)
     }
     printcodeNname("important", impList)
     printcodeNname("tUP", tUPList)
     printcodeNname("multiSig", multiSigList)

     printcodeNname("*LrgUp Amt", starlrgAmtList)
     printcodeNname("*LrgUpm Amt", starlrgAmtmList)
     printcodeNname("Lrg Amt", lrgAmtList)
     printcodeNname("ativ",activeAmtList)
     printcodeNname("GradAmt",GradList)
     printcodeNname("VlAmt",VlAmtList)
     printcodeNname("gtpdAmt", gtpdAmtList)
     # printcodeNname("VlAmt + gtpdAmt", VlAmt_N_gtpdAmt)
     printcodeNname("VlAmt n cXallUp",VlAmt_N_cXallUp)
     printcodeNname("VlAmt n UpTrig",VlAmt_N_UpTrig)
     printcodeNname("turnUp",turnUpList)
     # mustPop(paste0("turnUp ", paste0(turnUpList, collapse=" ")))
     cat("\n")
     printcodeNname("XallUp",cXallUpList)
     printcodeNname("UpTrig",UpTrigList)
     printcodeNname("cXWAvUp",cXWAvUpList)
     printcodeNname("XWAv n XallUp",XWAvUp_N_XallUp)
     printcodeNname("UpTrig n XallUp",UpTrig_N_cXallUp)
     printcodeNname("strengUp",StronUpList)
     printcodeNname("mWaveUp",mWaveUpList)
     cat("\n")
     printcodeNname("X_1Dn",cX_1DnList)
     printcodeNname("XallDn", cXallDnList)
     printcodeNname("DnTrig",DnTrigList)
     printcodeNname("dnXAmt",dnXAmtList)
     printcodeNname("VlAmt n XallDn",VlAmt_N_cXallDn)
     printcodeNname("VlAmt n DnTrig",VlAmt_N_DnTrig)
     printcodeNname("turnDn",turnDnList)
     # mustPop(paste0("turnDn ", paste0(turnDnList, collapse=" ")))
     printcodeNname("strengDn",StronDnList)
     printcodeNname("mWaveDn",mWaveDnList)
     printcodeNname("tDN", tDNList)

    # signals statistics
      countstarlrgAmtList <<- c(countstarlrgAmtList, length(starlrgAmtList))
      countstarlrgAmtmList <<- c(countstarlrgAmtmList, length(starlrgAmtmList))
      countlrgAmtList <<- c(countlrgAmtList, length(lrgAmtList))
      countalertList <<- c(countalertList, length(alertList))
      countactiveAmtList <<- c(countactiveAmtList, length(activeAmtList))
      countGradList <<- c(countGradList, length(GradList))
      countVlAmtList <<- c(countVlAmtList, length(VlAmtList))
      countgtpdAmtList <<- c(countgtpdAmtList, length(gtpdAmtList))
      # countVlAmt_N_gtpdAmt <<- c(countVlAmt_N_gtpdAmt, length(VlAmt_N_gtpdAmt))
      countVlAmt_N_cXallUp <<- c(countVlAmt_N_cXallUp, length(VlAmt_N_cXallUp))
      countVlAmt_N_UpTrig <<- c(countVlAmt_N_UpTrig, length(VlAmt_N_UpTrig))
      countupXAmtList <<- c(countupXAmtList, length(upXAmtList))
      countcXallUpList <<- c(countcXallUpList, length(cXallUpList))
      countUpTrigList <<- c(countUpTrigList, length(UpTrigList))
      countcXWAvUpList <<- c(countcXWAvUpList, length(cXWAvUpList))
      countcXWAvDnList <<- c(countcXWAvDnList, length(cXWAvDnList))
      countXWAvUp_N_XallUp <<- c(countXWAvUp_N_XallUp, length(XWAvUp_N_XallUp))
      countUpTrig_N_cXallUp <<- c(countUpTrig_N_cXallUp, length(UpTrig_N_cXallUp))
      countStronUpList <<- c(countStronUpList, length(StronUpList))
      countmWaveUpList <<- c(countmWaveUpList, length(mWaveUpList))
      countcX_1DnList <<- c(countcX_1DnList, length(cX_1DnList))
      countcXallDnList <<- c(countcXallDnList, length(cXallDnList))
      countDnTrigList <<- c(countDnTrigList, length(DnTrigList))
      countdnXAmtList <<- c(countdnXAmtList, length(dnXAmtList))
      countVlAmt_N_cXallDn <<- c(countVlAmt_N_cXallDn, length(VlAmt_N_cXallDn))
      countVlAmt_N_DnTrig <<- c(countVlAmt_N_DnTrig, length(VlAmt_N_DnTrig))
      countStronDnList <<- c(countStronDnList, length(StronDnList))
      countmWaveDnList <<- c(countmWaveDnList, length(mWaveDnList))

  
    # clear signals
     minuteHistory <<- matrix(,ncol=3, nrow=0) # clear history

    # record lists
     allUpTrigList <<- unique(c(alertList, allUpTrigList)) # collect alertList, remove duplicates
     alllrgAmtList <<- unique(c(lrgAmtList, alllrgAmtList))
     allstarlrgAmtList <<- unique(c(starlrgAmtList, allstarlrgAmtList))
     allstarlrgAmtmList <<- unique(c(starlrgAmtmList, allstarlrgAmtmList))

     prevUpRecList <<- UpRecList # keep record of old list for comparison change of numbers
     #UpRecList <<- unique(c(tUPList, multiSigList, UpRecList)) # most update comes first
     UpRecList <<- unique(c(starlrgAmtList, starlrgAmtmList, lrgAmtList, multiSigList, UpRecList)) # change to amt list
     alltDNList <<- unique(c(tDNList, alltDNList))

     allGradList = unique(c(GradList, allGradList))
     allStarGradList = unique(c(starGradList, allStarGradList))
     allStarGradmList = unique(c(starGradmList, allStarGradmList))
     allturnUpList <<- union(turnUpList, allturnUpList)
     allturnDnList <<- union(turnDnList, allturnDnList)

     # large amt lists: VlAmtList, gtpdAmtList, ExtImpPctList, extraImpList, starGradList, starGradmList
     impAmtList = unique(c(extraImpList, starGradList, gtpdAmtList, starGradmList, GradList))
     watchList <<- unique(c(watchList, impAmtList))
     theUpList = commonCode(unique(multiSigList), impAmtList) # multiSigList counts multi up sig

     extraPush = unique(c(cXallUpList, mWaveUpList, tUPList))
     amtPush = unique(c(GradList, starGradList, starGradmList, extraImpList, ExtImpPctList, VlAmtList, gtpdAmtList))
     heedList = unique(commonCode(cXmList0, extraPush))
     heedAmtList = unique(commonCode(cXmList0, amtPush))

        #impPopCode = unique(c(cXWAvUpList, upXAmtList, tUPList))
        #impPopCode = commonCode(impPopCode, impAmtList)

     printtimeStamp <- format(Sys.time(), "%H:%M:%OS")


     popOutMsg = ""
        if(length(alertList) !=0){
          for(i in alertList){
            if(length(allComplexList)>0){
              freq = as.vector(table(allComplexList)[names(table(allComplexList)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          allComplexList <<- c(allComplexList, alertList)

          if(popOutMsg != ""){
            mustPop(paste("Complex", popOutMsg))
          }
       }

     popOutMsg = ""
     ImpAlarmMsg = ""
        if(length(impAmtList) !=0){
          for(i in impAmtList){
            if(length(allImpAmtList)>0){
              freq = as.vector(table(allImpAmtList)[names(table(allImpAmtList)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }

              if(i %in% ImpAlarm){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                ImpAlarmMsg = paste(ImpAlarmMsg, i, stkChiName)
                ImpAlarmList <<- c(ImpAlarmList, ImpAlarm)
              }

          }
          allImpAmtList <<- c(allImpAmtList, impAmtList)

          if(popOutMsg != ""){
            mustPop(paste('<span class="darksalmon goldbs">ImpAmt</span>', '<span class="tan1">tt',length(allImpAmtList),'</span>', '<span class="brown">',length(impAmtList),'</span>', popOutMsg))
          }
          if(ImpAlarmMsg != ""){
            mustPop(paste('<span class="red gold2bs">ImpAlarm</span>', ImpAlarmMsg))
          }
       }


     popOutMsg = ""
        if(length(layerUpList) !=0){
          for(i in layerUpList){
            if(length(alllayerUp)>0){
              freq = as.vector(table(alllayerUp)[names(table(alllayerUp)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          alllayerUp <<- c(alllayerUp, layerUpList)
          if(popOutMsg != ""){
            mustPop(paste("layerUp", '<span class="tan1">tt',length(alllayerUp),'</span>', popOutMsg))
          }
       }


     popOutMsg = ""
        if(length(ExtImpPctList) !=0){
          for(i in ExtImpPctList){
            if(length(allExtImpPctList)>0){
              freq = as.vector(table(allExtImpPctList)[names(table(allExtImpPctList)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allExtImpPctList <<- c(allExtImpPctList, ExtImpPctList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="red">ExtImpPctList</span>', '<span class="tan1">tt',length(allExtImpPctList),'</span>', '<span class="brown">',length(ExtImpPctList),'</span>', popOutMsg))
          }
       }

     popOutMsg = ""
        if(length(WAve3x6List) !=0){
          for(i in WAve3x6List){
            if(length(allWAve3x6List)>0){
              freq = as.vector(table(allWAve3x6List)[names(table(allWAve3x6List)) == i])
              if(length(freq)==0){freq = 1}  # note the freq may have to be modified
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allWAve3x6List <<- c(allWAve3x6List, WAve3x6List)
          if(popOutMsg != ""){
            mustPop(paste('<span class="gold red2bs">WAve3x6List</span>', '<span class="tan1">tt',length(allWAve3x6List),'</span>','<span class="brown">',length(WAve3x6List),'</span>', popOutMsg))
          }
       }

     popOutMsg = ""
        if(length(WAve3v6List) !=0){
          for(i in WAve3v6List){
            if(length(allWAve3v6List)>0){
              freq = as.vector(table(allWAve3v6List)[names(table(allWAve3v6List)) == i])
              if(length(freq)==0){freq = 1}  # note the freq may have to be modified
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allWAve3v6List <<- c(allWAve3v6List, WAve3v6List)
          if(popOutMsg != ""){
            mustPop(paste('<span class="green blue2bs">WAve3v6List</span>', '<span class="tan1">tt',length(allWAve3v6List),'</span>', '<span class="brown">',length(WAve3v6List),'</span>', popOutMsg))
          }
       }

     popOutMsg = ""
        if(length(heedList) !=0){
          for(i in heedList){
            if(length(allheedList)>0){
              freq = as.vector(table(allheedList)[names(table(allheedList)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allheedList <<- c(allheedList, heedList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="pink red2bs">heedList</span>',  '<span class="tan1">tt',length(allheedList),'</span>', '<span class="brown">',length(heedList),'</span>', popOutMsg))
          }
       }


     popOutMsg = ""
        if(length(heedAmtList) !=0){
          for(i in heedAmtList){
            if(length(allheedAmtList)>0){
              freq = as.vector(table(allheedAmtList)[names(table(allheedAmtList)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allheedAmtList <<- c(allheedAmtList, heedAmtList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="white red2bs">heedAmtList</span>', popOutMsg))
          }
       }

     popOutMsg = ""
        if(length(theUpList) !=0){
          for(i in theUpList){
            if(length(allUpAMt)>0){
              freq = as.vector(table(allUpAMt)[names(table(allUpAMt)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          allUpAMt <<- c(allUpAMt, theUpList)
          if(popOutMsg != ""){
            mustPop(paste("UpAMt", '<span class="tan1">tt',length(allUpAMt),'</span>', popOutMsg))
          }
       }

     # combine 3 groups
     tUP_UpTrig = commonCode(UpTrigList0, tUPList)
     brkUpTrigList = commonCode(UpTrigList0, cX1_4UpList)
     cX1_4_mWaveUpList = commonCode(UpTrigList0, cX1_4UpList)

     brkUpTrigList = unique(c(brkUpTrigList, tUP_UpTrig, cX1_4_mWaveUpList))

     popOutMsg = ""
        if(length(brkUpTrigList) !=0){
          for(i in brkUpTrigList){
            if(length(allbrkUpTrig)>0){
              freq = as.vector(table(allbrkUpTrig)[names(table(allbrkUpTrig)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allbrkUpTrig <<- c(allbrkUpTrig, brkUpTrigList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="floralwhite">brkUpTrig</span>', '<span class="tan1">tt',length(allbrkUpTrig),'</span>', popOutMsg))
          }
        }


     popOutMsg = ""
        if(length(cXmList0) !=0){
          for(i in cXmList0){
            if(length(allcXmList0)>0){
              freq = as.vector(table(allcXmList0)[names(table(allcXmList0)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          allcXmList0 <<- c(allcXmList0, cXmList0)
          if(popOutMsg != ""){
            mustPop(paste('<span class="floralwhite">cXmList0</span>', popOutMsg))
          }
        }

     brkUpList = commonCode(cXmList1, cX1_4UpList)
     popOutMsg = ""
        if(length(brkUpList) !=0){
          for(i in brkUpList){
            if(length(allbrkUp)>0){
              freq = as.vector(table(allbrkUp)[names(table(allbrkUp)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          allbrkUp <<- c(allbrkUp, brkUpList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="floralwhite">brkUp</span>', popOutMsg))
          }
        }


        DNList = unique(c(tDNList, DnTrigList0, cXmW1DnList))
        watchList <<- rmItems(watchList, DNList) # exclude the turndn items
        dangerList = commonCode(DNList, impAmtList)
        popOutMsg = ""
        if(length(dangerList) !=0){
          for(i in dangerList){
            if(length(allDANGER)>0){
              freq = as.vector(table(allDANGER)[names(table(allDANGER)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          allDANGER <<- c(allDANGER, dangerList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="green redbs">DANGER</span>', '<span class="tan1">tt',length(allDANGER),'</span>', popOutMsg))
          }
        }


        # tDNList
        popOutMsg = ""
        if(length(tDNList) !=0){
          for(i in tDNList){
            if(length(alltDN)>0){
              freq = as.vector(table(alltDN)[names(table(alltDN)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          alltDN <<- c(alltDN, tDNList)

          if(popOutMsg != ""){
            mustPop(paste('<span class="sapphire">tDN</span>', '<span class="tan1">tt',length(alltDN),'</span>', popOutMsg))
          }
        }

        # layerDnList
        popOutMsg = ""
        if(length(layerDnList) !=0){
          for(i in layerDnList){
            if(length(alllayerDn)>0){
              freq = as.vector(table(alllayerDn)[names(table(alllayerDn)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          alllayerDn <<- c(alllayerDn, layerDnList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="sapphire">layerDn</span>', '<span class="tan1">tt',length(alllayerDn),'</span>', popOutMsg))
          }
        }

        # watchUpList
        watchUpList = commonCode(unique(totalupList), watchList)
        popOutMsg = ""
        if(length(watchUpList) !=0){
          for(i in watchUpList){
            if(length(allwatchUp)>0){
              freq = as.vector(table(allwatchUp)[names(table(allwatchUp)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allwatchUp <<- c(allwatchUp, watchUpList)
          if(popOutMsg != ""){
            mustPop(paste('<span class="orangered">watchUp</span>', popOutMsg))
          }
        }

     popOutMsg = ""
        if(length(mWaveUpList) !=0){
          for(i in mWaveUpList){
            if(length(allmWaveUp)>0){
              freq = as.vector(table(allmWaveUp)[names(table(allmWaveUp)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allmWaveUp <<- c(allmWaveUp, mWaveUpList)

          if(popOutMsg != ""){
            mustPop(paste('<span class="orangered">mWaveUp</span>', popOutMsg))
          }
       }


     popOutMsg = ""
        if(length(XWAvUp_N_XallUp) !=0){
          for(i in XWAvUp_N_XallUp){
            if(length(allXWAvUp_N_XallUp)>0){
              freq = as.vector(table(allXWAvUp_N_XallUp)[names(table(allXWAvUp_N_XallUp)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allXWAvUp_N_XallUp <<- c(allXWAvUp_N_XallUp, XWAvUp_N_XallUp)

          if(popOutMsg != ""){
            mustPop(paste('<span class="brick">XWAvallUp</span>', popOutMsg))
          }
       }


     popOutMsg = ""
        if(length(cXallUpList) !=0){
          for(i in cXallUpList){
            if(length(allcXallUp)>0){
              freq = as.vector(table(allcXallUp)[names(table(allcXallUp)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
              if(freq > 2){
                abnormalList <<- c(abnormalList, i)
              }
            }
          }
          allcXallUp <<- c(allcXallUp, cXallUpList)

          if(popOutMsg != ""){
            mustPop(paste('<span class="orangered">cXallUp</span>', '<span class="tan1">tt',length(allcXallUp),'</span>', '<span class="brown">',length(cXallUpList),'</span>', popOutMsg))
          }
       }


        # triList, put at end of test
        triList = commonCode(alertList, brkUpList)
        triList = commonCode(watchUpList, triList)

        # triList of: UpTrigList0, alertList, mWaveUpList
        triUpTrigAlert = commonCode(UpTrigList0, brkUpList)
        triUpTrigAlert = commonCode(triUpTrigAlert, mWaveUpList)

        # quadList, put at end of test
        amtList = unique(c(starGradmList, starlrgAmtList, starlrgAmtmList, extraImpList))
        quad_List = commonCode(amtList, upXAmtList)
        quad_List = commonCode(quad_List, cXWAvUpList)
        quad_List = commonCode(quad_List, ExtImpPctList)

        # tri_List, put at end of test
        tri_List = commonCode(cXallUpList, amtList)
        tri_List = commonCode(upXAmtList, tri_List)

        # put triList, tri_List, quadList together
        triList = unique(c(triUpTrigAlert, quad_List, triList, tri_List, abnormalList))

        # reset abnormalList
        abnormalList <<- character()

        popOutMsg = ""
        if(length(triList) !=0){
          for(i in triList){
            if(length(alltriList)>0){
              freq = as.vector(table(alltriList)[names(table(alltriList)) == i])
              if(length(freq)==0){freq = 0}
              if(freq > 0){
                codePointer = which(resultTable[,1] == i) # search the resultTable record
                stkChiName = resultTable[codePointer,2]        # select name
                popOutMsg = paste(popOutMsg, freq, i, stkChiName)
              }
            }
          }
          alltriList <<- c(alltriList, triList)
          cat("\nalltriList ", popOutMsg)
          if(popOutMsg != ""){
            mustPop(paste('<span class="gold purple2bs borRad10">Note</span>', '<span class="tan1">tt',length(alltriList),'</span>', '<span class="brown">',length(triList),'</span>', popOutMsg))
          }
        }

        # dayLineList
        checkList <<- unique(checkList)
        checkList <<- rmItems(checkList, alreadyPopList)
        checkList <<- rmItems(checkList, allDayLineList)
        # for(i in checkList){ checkKline(i) } # this is not so meaningful
        checkList <<- character()
        alreadyPopList <<- unique(alreadyPopList)
        dayLineList = unique(dayLineList)

        popOutMsg = ""
        if(length(dayLineList) !=0){
          for(i in dayLineList){
                codePointer = which(resultTable[,1] == i)
                stkChiName = resultTable[codePointer,2]
                popOutMsg = paste(popOutMsg, i, stkChiName)
          }
          allDayLineList <<- c(allDayLineList, dayLineList)
          cat("\ndayLine ", popOutMsg)
          if(popOutMsg != ""){
            mustPop(paste("dayLine", popOutMsg))
          }
        }


      # status report
      cat( red("\n\nComplex"), length(alertList), 
           red("theUpList"), length(theUpList), red("brkUpTrigList"), length(brkUpTrigList), 
           red("brkUpList"), length(brkUpList), red("watchUpList"), length(watchUpList), 
           red("mWaveUp"), length(mWaveUpList), red("cXallUp"), length(cXallUpList), red("Note"), length(triList),
           red("dayLine"), length(dayLineList), 

           red("\nlayerUpList"), length(layerUpList), green("layerDnList"), length(layerDnList), 
           green("tDNList"), length(tDNList), green("dangerList"), length(dangerList),
           pink("impAmtList"), length(impAmtList),

           red("\n\nallComplex"), length(allComplexList), 
           red("allUpAMt"), length(allUpAMt), red("allbrkUpTrig"), length(allbrkUpTrig), 
           red("allbrkUp"), length(allbrkUp), red("allwatchUp"), length(allwatchUp), 
           red("allmWaveUp"), length(allmWaveUp), red("allcXallUp"), length(allcXallUp), pink("allNote"), length(alltriList),

           red("\nalllayerUp"), length(alllayerUp), green("alllayerDn"), length(alllayerDn), 
           green("alltDN"), length(alltDN), green("allDANGER"), length(allDANGER),
           magenta("allImpAmtList"), length(allImpAmtList),
           pink("alldayLine"), length(allDayLineList), "\n"  )

           dayLineList <<- character() # clear buffer before next turn
  }
 # set FixedWidth by prepending space
   setFixedWidth = function(valStr, digitNum){
     valStr = as.character(valStr)
     if(nchar(valStr)<digitNum){
       spcSTr = paste(rep(" ",(digitNum - 1 - nchar(valStr))), collapse = "") # must paste collapse
       valStr = paste(spcSTr, valStr, collapse = "")
     }
     return(valStr)
   }

 # check nan
   checkNan = function(value){
     if(is.nan(value)){ value = 0 }
     return(as.numeric(value))
   }
 # printDpctValue, print DpctValue
   printDpctValue = function(value){
     DpctValue = as.numeric(value)
     DpctValue = checkNan(DpctValue)
     if(DpctValue > 10){ cat(deeppink(DpctValue))
     } else { cat(pink(DpctValue)) }
   }

 # printPctValue, print color value
   printPctValue = function(value){
     pctValue = as.numeric(value)
     pctValue = checkNan(pctValue)
     if(pctValue > 99){ cat(deeppink("99"))
     } else if(pctValue > 30){ cat(deeppink(pctValue))
     } else if(pctValue < 4) { cat(darkgreen(pctValue))
     } else if((pctValue >= 4)&(pctValue < 10)) { cat(brown(pctValue))
     } else { cat(brown(pctValue)) }
   }

 # printAlmLv, print AlmLv
   printAlmLv = function(value){
     AlmLvValue = as.numeric(value)
     AlmLvValue = checkNan(AlmLvValue)
     if(AlmLvValue < 3){ cat(" ",deeppink(AlmLvValue), sep="")
     } else if((AlmLvValue >= 3)&(AlmLvValue < 10)){ cat(" ",pink(AlmLvValue), sep="")
     } else{ cat(pink(AlmLvValue))}
   }

 # printCurAmt, print color value
   printCurAmt = function(value){
     curAmt = as.numeric(value)
     curAmt = checkNan(curAmt)
     if(curAmt > 5000){ cat(deeppink(curAmt))
     } else if((curAmt > 1200) & (curAmt <= 5000)) { cat(orange(curAmt))
     } else if(curAmt <= 100) { cat(darkgreen(curAmt))
     } else { cat(lime(curAmt)) }
   }

 # printColorPct, print color value
   printColorPct = function(value){
     pctChange = as.numeric(value);
     pctChange = checkNan(pctChange)
     if(pctChange > 1){ cat(red(format1digit(pctChange))) #
     } else if((pctChange > 0) & (pctChange <= 1)) { cat(orange(format1digit(pctChange)))
     } else if((pctChange <= 0) & (pctChange > -1)) { cat(green(format1digit(pctChange)))
     } else { cat(purple(format1digit(pctChange))) }
   }


 # format4digit, note return a string
  format4digit = function(value){ sprintf(value, fmt = '%#.4f')}

 # format3digit
  format3digit  = function(value){ sprintf(value, fmt = '%#.3f')}
 # format1digit
  format1digit  = function(value){ sprintf(value, fmt = '%#.1f')}

 # calcWAve
  calcWAve = function(theArray) { # calculate the WMA value
    sum = 0
    for( i in 1:length(theArray) ) {sum = sum + theArray[i] * i;}
    return (as.numeric(format3digit(sum / ((1 + length(theArray))*length(theArray)/2))))
  }


 # backCalcWAve3Value, input theArray and targetValue
  backCalcWAve3Value = function(theArray, targetValue) { # calculate the required theArray[3] value
    reqValue = (targetValue * 6 -theArray[1] * 1 - theArray[2] * 2)/3
    return (reqValue)
  }

 # checkSpace(checkTable), pre check table validity
  checkSpace <- function(checkTable) {
     codeLength = nchar(checkTable)
     if(any(codeLength> 5)){
          cat("\ninvalid codetable table, code too long, process stopped!\n\n")
          stop()
     }
     if(any(grepl("[^0-9]", checkTable))){
          cat("\ninvalid codetable table, spaces character in table, process stopped!\n\n")
          stop()
     }
     if(any(grepl("^$", checkTable))){
          cat("\ninvalid codetable table, empty lines in table, process stopped!\n\n")
          stop()
     }
     if(any(grepl("\\n046\\d\\d", checkTable))){
          cat("\n046.. in codetable table, process stopped!\n\n")
          stop()
     }
  }

 # rmItems(fmList, itemList) remove itemList from fmList
  rmItems <- function(fmList, itemList){
        commons = unique(fmList[fmList %in% itemList])
        for(item in commons){fmList = fmList[-(which(fmList == item))]}
        return(fmList)
  }


 # retrieveData(urlAddr) will retry if error
  retrieveData <- function(urlAddr){
  retryCounter = 0
  while(retryCounter < 20) {
    cat(yellow("."),retryCounter," ") 
    retriveFile <- tryCatch(readLines(urlAddr, warn=F), 
        warning = function(w){return("code param error")}, 
        error = function(e) {return("code param error")}
        )
    if (grepl("code param error", retriveFile[1])) {
      cat("Error in connection, try 5 secs later!\n")
      beepbad(2)
      errorAlarm()
      retryCounter <- retryCounter + 1
      Sys.sleep(12)
      beepbad(2)
      retriveFile = ""  # if end of loop this will be returned
    }else{
      retryCounter = 200  # to jump out of loop
    }
  }
  return(retriveFile)
  }

 # beepgood(n) sound, beepbad(n) beepbad
  beepgood <- function(rptCnt){
    #system(paste("WScript", '"D:/Dropbox/STK/!!! STKMon !!!/playGood.vbs"', sep = " "))
  }
  beepbad <- function(rptCnt){
    #system(paste("WScript", '"D:/Dropbox/STK/!!! STKMon !!!/playSound.vbs"', sep = " "))
  }
  beepAmt <- function(){ # dedicated for big amt
    #system(paste("WScript", '"D:/Dropbox/STK/!!! STKMon !!!/playAmt.vbs"', sep = " "))
  }

 # calpageWAve returns curWAve_1, curWAve_2, curWAve_3, curWAve_4, lastC
  # input page is page of 3D array
   calpageWAve <- function(page, lastRow){
    coldata = fDayDataList[[page]][((lastRow - 59):lastRow),2] # prepare column data
    curWAve_1 = format4digit(calcWAve(as.numeric(coldata)))

    coldata = fDayDataList[[page]][((lastRow - 119):lastRow),2]
    curWAve_2 = format4digit(calcWAve(as.numeric(coldata)))

    coldata = fDayDataList[[page]][((lastRow - 239):lastRow),2]
    curWAve_3 = format4digit(calcWAve(as.numeric(coldata)))

    coldata = fDayDataList[[page]][((lastRow - 479):lastRow),2]
    curWAve_4 = format4digit(calcWAve(as.numeric(coldata)))

    lastC = fDayDataList[[page]][lastRow,2]
    return(c(curWAve_1, curWAve_2, curWAve_3, curWAve_4, lastC))
   }

# various checks: checkX, checkUpDn, checkTP, checkFlag, testFlag, checkTrigger, chkAmt
 # checkX up down cross level and continues trend
  checkX = function(prevL, prevS, curL, curS){
    prevL = as.numeric(format3digit(as.numeric(prevL)))
    prevS = as.numeric(format3digit(as.numeric(prevS)))
    curL = as.numeric(format3digit(as.numeric(curL)))
    curS = as.numeric(format3digit(as.numeric(curS)))
    ratioX = as.numeric(format3digit((curS/curL)*100))
    resultStr = ""
    # cat("\nprevL: ", prevL, "prevS: ", prevS, "curL: ", curL, "curS: ", curS, "ratioX: ", ratioX)
    if (curS == curL){resultStr = "critical"}
    if (((prevL == prevS) && (curS > curL )) || ((prevL>prevS) && (curS > curL ))){
      if(curC>prevC){resultStr ="UpCross"}
    }
    if (((prevL == prevS) && (curS < curL )) || ((prevL<prevS) && (curS < curL ))){
      if(curC<prevC){resultStr = "DownCross"}
    }
    if ((prevL<prevS) && (curS > curL ) && (curC>prevC)){
      resultStr = 'cont.Up'
    }
    if ((prevL>prevS) && (curS < curL ) && (curC<prevC)){
      resultStr = 'cont.Dn'
    }
    return(resultStr)
  }

 # checkUpDn compares prevC, curC and return up down msg
  checkUpDn = function(prevC, curC){
    if (prevC == curC){return("level")}
    if (prevC< curC){return("<span class='redword'>Up</span>")
    } else {return("<span class='greenword'>Down</span>")}
  }

 # checkTP(pprevC, prevC, curC) can be used to check H, C, L
  checkTP = function(pprevC, prevC, curC, trigValue){
    maxv = max(pprevC, prevC, curC)
    minv = min(pprevC, prevC, curC)
    diff = maxv- minv
    if ((pprevC >= prevC)&&(prevC < curC)){return("turn UP")
    }else if ((pprevC <= prevC)&&(prevC > curC)){return("turn DN")
    }else if ((pprevC < prevC)&&(prevC < curC)){return("keep Up")
    }else if ((pprevC > prevC)&&(prevC > curC)){return("keep DN")
    }else{return("")}
  }

 # check and set flag: if change status, set and alarm it, else forget it
  checkFlag = function(rowPtr, flagName, newStatus){
    currentStatus = flags[rowPtr, flagName]

    if(currentStatus != newStatus){
     # status changed
      flags[rowPtr, flagName] <<- newStatus
      return("setAlarm")
      #if(currentStatus == "unknown"){
      #  flags[rowPtr, flagName] <<- "noted"
      #  return("quiet")
      #}else{
      #  flags[rowPtr, flagName] <<- newStatus
      #  return("setAlarm")
      #}
    }else{
     return("quiet")
    }
  }

 # test flag: report change of status without altering 
  testFlag = function(rowPtr, flagName, newStatus){
    currentStatus = flags[rowPtr, flagName]
    if(currentStatus != newStatus){
     # status changed
      return("yes flipped")
    }else{
      return("no flip")
    }
  }

  # check schmidtTrigger
   checkTrigger = function(rowPtr, prevC, curC){
    counterVal = upDnCounter[rowPtr]
    retMsg = "noTrig"
    if(curC > prevC){
      if(counterVal >= 2){retMsg = "UpTrig"}
      if((counterVal >= 0)&(counterVal <=1)){counterVal = counterVal + 1}
      if(counterVal < 0){counterVal = 0}
    } else if(prevC > curC){
      if(counterVal <= -2){retMsg = "DnTrig"}
      if((counterVal <= 0)&(counterVal >= -1)){counterVal = counterVal - 1}
      if(counterVal > 0){counterVal = 0}
    }
    upDnCounter[rowPtr] <<- counterVal
    return(retMsg)
   }

 # chkAmt(cAmt, pctAmt) to investigate current amount, return 1-10
  chkAmt <- function(currentAmt, AmtPercentage,codenumber, codechiname){
    alarmValue <- 14
    alarmValue <- case_when(
      (currentAmt <= 50) ~ 13,
      (currentAmt > 50 & currentAmt<100 & AmtPercentage<3) ~ 12,
      (currentAmt > 50 & currentAmt<100 & AmtPercentage>=3 & AmtPercentage <10) ~ 11,
      (currentAmt > 50 & currentAmt<100 & AmtPercentage>=10) ~ 10,

      (currentAmt >= 100 & currentAmt<500 & AmtPercentage<3) ~ 9,
      (currentAmt >= 100 & currentAmt<500 & AmtPercentage>=3 & AmtPercentage <10) ~ 8,
      (currentAmt >= 100 & currentAmt<500 & AmtPercentage>=10) ~ 7,

      (currentAmt >= 500 & currentAmt<1000 & AmtPercentage<3) ~ 6,
      (currentAmt >= 500 & currentAmt<1000 & AmtPercentage>=3 & AmtPercentage <10) ~ 5,
      (currentAmt >= 500 & currentAmt<1000 & AmtPercentage>=10) ~ 4,

      (currentAmt >= 1000 & currentAmt<5000 & AmtPercentage<3) ~ 3,
      (currentAmt >= 1000 & currentAmt<5000 & AmtPercentage>=3 & AmtPercentage <10) ~ 2,
      (currentAmt >= 1000 & currentAmt<5000 & AmtPercentage>=10) ~ 1,

      (currentAmt >= 5000 & AmtPercentage<10) ~ 1,
      (currentAmt >= 5000 & AmtPercentage>=10) ~ 0,
      TRUE ~ 14
    )
    return(alarmValue)
  }
# ends various check functions


 # updateStatus send Msg to console
  updateStatus <- function(){
  debugMsg(paste0("updateStatus begin! ", "PtrendStatus: ", PtrendStatus))
  }

 # notifyMsg compares prev status, id diff, notify and update status
  notifyMsg <- function(Msg){
    if (NowtrendStatus != PtrendStatus){ sendMsg(Msg) }
    PtrendStatus <<- NowtrendStatus
  }

  sendMsg <- function(Msg){ RptLog <<- c(RptLog, Msg) } # sendMsg to popup
  recAAU <- function(Msg){ AAURec <<- c(AAURec, Msg) }

  # record alarm history and minute history
   #recAlmHist <- function(rowPtr, Msg, pctMDiff){
   recAlmHist <- function(rowPtr, Msg){
     # record alarm history
      almHistory[rowPtr] <<- paste(almHistory[rowPtr], Msg)

     # record minuteHistory
      signal = gsub("^.*? ","",Msg)  # stop at space
      signal = gsub(" .*","",signal)

     # signal, codenumber, codechiname
      minuteHistory <<- rbind(minuteHistory, c(signal, substr(almHistory[rowPtr], 1, 5), resultTable[rowPtr,2]))
   }

 # popupRpt RptLog
  popupRpt <- function(){
   if(length(RptLog) > 0){
     AAURec = gsub("\\\\n", "", AAURec)
     AAURecLog = c(AAURecLog,AAURec)
     printText(AAURec)

    # appendText record only at early stages, this is not executed every minute
     now_time <- unclass(as.POSIXlt(Sys.time()))
     nowTS <- now_time[3]$hour*100 + now_time[2]$min

     # this part is closed, only for research purpose
     # if ( ((nowTS>=930) & (nowTS<=1000)) | ((nowTS>=1300) & (nowTS<=1315)) | ((nowTS>=1530) & (nowTS<=1600)) ){
     #  appendText(AAURec)
     #}

    #  record alarm history and classifiedList every 30 minutes
     nowTS <- now_time[3]$hour*100 + now_time[2]$min

     if ((now_time[2]$min %% 30) == 0 | nowTS == 1610){
       sink("alarm history.txt")
         cat(almHistory, sep="\n")
       sink()

       sink("classifiedList.txt")
         cat(classifiedList)
       sink()

       #sink("testRpt.txt", append = TRUE)
       #  cat(testRpt)
       #  testRpt <<- character()
       #sink()

       source("C:/R programs/!!! STKMon !!!/sinkallSecRecList.R")

       #if(length(prevUpRecList) != length(UpRecList)){ # ensure there is differences
       #  sink("UpTrig.js")  # write to js
       #    if(length(allturnUpList)>0){
       #      cat("thestkList = '")
       #      cat(UpRecList)
       #      cat("';theList = thestkList.split(' ');")
       #    }
       #  sink()
       #}

       cat(red("\n4 files updated inside folder\n"))
     }

       # sink every minute
       sink("popupRecords.html", append = TRUE)
         mustPopRecBuffer <<- gsub("\\\\n", "", mustPopRecBuffer)
         mustPopRecBuffer <<- gsub("(\\d\\d:\\d\\d:\\d\\d)", "<span class='white'>\\1</span>", mustPopRecBuffer)
         mustPopRecBuffer <<- gsub("(\\d{5})", "<k>\\1</k>", mustPopRecBuffer)
         mustPopRecBuffer <<- gsub('ExtImpPct ', '<span class="red">ExtImpPct</span> ', mustPopRecBuffer)
         mustPopRecBuffer <<- gsub('tDN_AMt ', '<span class="sapphire green2bs">tDN_AMt</span> ', mustPopRecBuffer)
         mustPopRecBuffer <<- gsub('gtpdAmt ', '<span class="pink">gtpdAmt</span> ', mustPopRecBuffer)
         mustPopRecBuffer <<- gsub('ExtImp ', '<span class="pink">ExtImp</span> ', mustPopRecBuffer)
         cat(mustPopRecBuffer, sep="\n")
         alltriListCount <<- c(alltriListCount, length(alltriList))
         # cat("<span class='coral'>alltriListCount:\n", alltriListCount, "</span>\n")
         if(length(alltriList)>0){
           thetable = table(alltriList)
           thetable = thetable[order(thetable, decreasing = TRUE)]
           headthetable = head(thetable, 10)
           tailthetable = tail(thetable, 10)
           headoutvec = capture.output(print(headthetable))
           headoutvec = gsub("(\\d{5})", "<k>\\1</k>", headoutvec)
           tailoutvec = capture.output(print(tailthetable))
           tailoutvec = gsub("(\\d{5})", "<k>\\1</k>", tailoutvec)

           cat("<span class='smallsize orange'>\n")
           cat("Leading ",headoutvec, sep="\n")
           cat("\n")
           cat("Trailing ", tailoutvec, sep="\n")
           cat("</span>\n")

           cat("<span class='smallsize tomato'>")
           cat("updnXAmt:", sum(countupXAmtList), sum(countdnXAmtList), " ")
           if(sum(countdnXAmtList) != 0){
             xAmtCountRatio = round((sum(countupXAmtList) / sum(countdnXAmtList)), 2)
             cat(xAmtCountRatio, " ")
           }

           cat("tUPDNCnt:", sum(tUPListCnt), sum(tDNListCnt), " ")
           if(sum(tDNListCnt) != 0){
             tUPCountRatio = round((sum(tUPListCnt) / sum(tDNListCnt)), 2)
             cat(tUPCountRatio, " ")
           }

           cat("layerUpDn:", length(alllayerUp), length(alllayerDn), " ")
           if(length(alllayerDn) != 0){
             layerUpDnRatio = round((length(alllayerUp) / length(alllayerDn)), 2)
             cat(layerUpDnRatio, " ")
           }

           cat("cXWAvUpDn:", sum(countcXWAvUpList), sum(countcXWAvDnList), " ")
           if(sum(countcXWAvDnList) != 0){
             cXWAvUpDnRatio = round((sum(countcXWAvUpList) / sum(countcXWAvDnList)), 2)
             cat(cXWAvUpDnRatio, " ")
           }

           cat("WAve3x6 3v6:", length(allWAve3x6List), length(allWAve3v6List), " ")
           if(length(allWAve3v6List) != 0){
             allWAve3x6CountRatio = round((length(allWAve3x6List) / length(allWAve3v6List)), 2)
             cat(allWAve3x6CountRatio)
           }

           cat("</span>\n")


         }

         mustPopRecBuffer <<- character()
       sink()
     if ((now_time[2]$min %% 3) == 0 ){
       shell("C:/Users/william/Desktop/vbscript/testsound.vbs", invisible=T, wait=F)
     }


    # send popup each max 17 lines
     page = 1; groupPageNum = 5
     if(length(RptLog)%%groupPageNum==0){
       pageNo = length(RptLog)%/%groupPageNum }
     else{ pageNo = length(RptLog)%/%groupPageNum +1 }
    
     for(page in 1:pageNo){
       if(length(RptLog) > groupPageNum){
     	thepage= RptLog[1:groupPageNum]; RptLog= RptLog[-(1:groupPageNum)]
          sendPages(thepage, All_UpX_cnt, All_DnX_cnt);  page = page + 1 }
       else{ sendPages(RptLog, All_UpX_cnt, All_DnX_cnt) }
     }
    } # popupRpt finished and clean up the log
    RptLog <<- character(); APC5UpLog <<- character()
  }

  mustRec <- function(Msg){ mustPopRec <<- c(mustPopRec, Msg) }
 # mustPop will popup mustPopLog
  mustPop <- function(Msg){
    mustPopLog <<- c(mustPopLog, Msg) # no action on mustPopLog yet, maybe in future 
  }
 # mustPop will popup mustPopLog
  mustPopup <- function(){
    # records messages for saving to file later
     mustPopRecBuffer <<- c(mustPopRecBuffer, format(Sys.time(), "%H:%M:%OS"), mustPopLog)

    # send popup each max 17 lines
    if(length(mustPopLog)>0 & mustpopupKey == TRUE){
      # create popup pages
      page = 1; groupPageNum = 5
    
      if(length(mustPopLog)%%groupPageNum==0){
        popPageNo = length(mustPopLog)%/%groupPageNum }
      else{ popPageNo = length(mustPopLog)%/%groupPageNum +1 }
    
      for(page in 1:popPageNo){
        if(length(mustPopLog) > groupPageNum){
      	thePopPage= mustPopLog[1:groupPageNum]
      	mustPopLog= mustPopLog[-(1:groupPageNum)]
          mustsendPages(thePopPage)
      	page = page + 1 }
        else{ mustsendPages(mustPopLog) }
      }
    }

    mustPopLog <<- character() # clear buffer before exit
  }

 # debugMsg send Msg to r console
  debugMsg <- function(Msg){
   cat("\n",sub(".* | .*", "", Sys.time()), " ", Msg, "\n")
  }

 # ArrLst rearranges the input array
  ArrLst <- function(dataLst){      
    dataLst = unlist(dataLst)
    if (dataLst[length(dataLst)]==""){dataLst = dataLst[-length(dataLst)]}
    dataLst = unlist(dataLst)
    return(dataLst)
  }

 # numWithName find the code and retuen code with name
  numWithName <- function(anumList){
     numNameList = character()
     for(item in anumList){
       # minuteHistory: matrix of signal, codenumber, codechiname
       pinpoint = which(minuteHistory[,2] == item) # search the minuteHistory record
       pinpoint = pinpoint[1]        # select only one
       numNameList = c(numNameList, minuteHistory[pinpoint,2], minuteHistory[pinpoint,3])
     }
     return(numNameList)
  }

 # createURLLst
  createURLLst <- function(CodeTable){
  theURLHeader = "http://sqt.gtimg.cn/q="
  theURLLst = theURLHeader  # this is the batch collect address
  listlen = length(CodeTable)
  strList = character()
  count = 1
  while(count <= listlen){
    thecode = CodeTable[count]
    theURLLst = paste0(theURLLst, "r_hk",thecode,",") # arrange the URL, not used now
    if(count%%64 == 0){
      strList = c(strList, theURLLst); theURLLst = theURLHeader }

    count = count + 1
  }
  strList = c(strList, theURLLst) # do once more to complete the last loop
  return(strList)
  }

 # collectData collects 5 days minute data
  collectData <- function(onecode){
   fDayAddr = paste0(fDayHead, onecode)
   fDayFile = retrieveData(fDayAddr)

   fDayData = fromJSON(gsub("fdminData=","",fDayFile))
   names(fDayData[["data"]]) = "codename"
   fData = fDayData[["data"]]$codename
   fData = fData["data"]
   fData = fData[["data"]]$data
   fData = c(ArrLst(fData[5]),ArrLst(fData[4]),ArrLst(fData[3]),ArrLst(fData[2]),ArrLst(fData[1]))
   fData = matrix(unlist(strsplit(fData, " ")), ncol=4,byrow=TRUE) # this is the resulting array
   fData[which(fData[,1]=="1600"),3] = "0" # set the last minute vol to zero
   return(fData) # the above data conversion complete, oldest data sit at top, newest at bottom, date, price, vol
  }


 # updateData collect code, chiname, price, Vol, Amt from theURLReqList
  updateData <- function(theURLReqList){
   theTempT <- data.frame(stkcode=character(), codename=character(), price=numeric(), Vol=numeric(), Amt=numeric(), stringsAsFactors=FALSE) 
   for(line in 1:length(theURLReqList)){ # every line in theURLReqList contain at most 64 codes
    mostUpdate = retrieveData(theURLReqList[line])    # the returned is strings of mutiple lines
    pagenum = line - 1  # this is to set the pointer in the page
    for(code in 1:length(mostUpdate)){  # extract the data into different stkcode lines 
      linenum = pagenum * 64 + code
      Info=unlist(strsplit(mostUpdate[code],"~"))  # get the data line by line
      theTempT[linenum,1] = Info[3]  # code
      theTempT[linenum,2] = Info[2]      # chiname
      theTempT[linenum,3] = as.numeric(Info[4])  # price
      theTempT[linenum,4] = as.numeric(Info[7])  # Vol
      theTempT[linenum,5] = as.numeric(Info[38])  # Amt, should item 38
      # hi and lo needed
      todayHiLo[linenum,] <<- c(as.numeric(Info[34]), as.numeric(Info[35]))
    }
   }
   return(theTempT) # code, chiname, price, Vol, Amt
  }

  # # # # # # # # # # # # # # # # # # # 

 # statusCheck and write the report
  statusCheck = function(){
   # init the statistics counters and reportPage
    s5X20Up = 0  # s stands for stat
    s5X20Dn = 0
    s5X_2Up = 0
    s5X_2Dn = 0
    s20X_2Up = 0
    s20X_2Dn = 0
    s20X320Up = 0
    s20X320Dn = 0
    s_2X320Up = 0
    s_2X320Dn = 0
    sXwAve_1Up = 0
    sXwAve_1Dn = 0
    sXwAve10Up = 0
    sXwAve10Dn = 0
    TPupList <<- character()
    TPupListCnt <<- 0
    TPdnList <<- character()
    TPdnListCnt <<- 0
    SPupList <<- character()
    ShortupList <<- character()
    ShortupListCnt <<- 0
    checkList <<- character()
    alreadyPopList <<- character()

    ReportPage = paste0("<hr>",format(Sys.time(), "%H:%M:%OS"),"<br>")
    # ReportPageTxt = paste(format(Sys.time(), "%H:%M:%OS"),"\n")
    timeStamp <- format(Sys.time(), "%H:%M:%OS")
    amtAlmRpt <- character()
    spcAlmRpt <- character()
    APC5UpLog <<- timeStamp

   # the main loop
    for(rowPtr in 1:nrow(curWAveTable)){
      # init prevC, curC, WAves, codenum
       # lastC = fDayDataList[[page]][lastRow,2], datalist is 3D from top to bot as price range: [page], time, price, vol

       # LastRow = nrow(fDayDataList[[rowPtr]])
       # last five C is in
      # fDayDataList[[rowPtr]][lastRow,2] ~ fDayDataList[[rowPtr-4]][lastRow,2] 
      LastRow = nrow(fDayDataList[[rowPtr]])
      #browser()
      last10c = c(fDayDataList[[rowPtr]][(lastRow - 9):lastRow,2])
      last5c = c(fDayDataList[[rowPtr]][(lastRow - 4):lastRow,2])
      maxlevel = max(as.numeric(last10c))
      minlevel = min(as.numeric(last10c))
      maxlast5c = max(as.numeric(last5c))
      minlast5c = min(as.numeric(last5c))
      pricelast5cRange = round((maxlast5c - minlast5c),3)

      VolMsg <- character()
      curVol <- abs(as.numeric(theMostUpdateData[rowPtr, "Vol"]) - as.numeric(fDayDataList[[rowPtr]][(lastRow - 1), 3]))
      # to access Code: LastDayTable[item, "Code"], Code,Close,High,Low,Vol
      # browser()
      codenumber = theMostUpdateData[rowPtr,1]
      codechiname = theMostUpdateData[rowPtr,2]
      #cat(codenumber, codechiname)
      pAmt <- as.numeric(resultTable[rowPtr,6]) / 10000 # unit already in 10 thousands, but cAmt is  x10000
      #cat(codechiname)
      #codechiname = substr(codechiname, 1, 5) # limit name to 5 chars
      todayAmt = round(as.numeric(theMostUpdateData[rowPtr,5])/10000) # accumulated amt today
      if(pAmt == 0){pAmt = 10000} # pAmt is previous day amount, set to 200 to avoid ppct error
      # pAmt may cause error and should be filled with a prev non zero amt

      prevC <<- as.numeric(resultTable[rowPtr,4])
      curC <<- as.numeric(curWAveTable[rowPtr,5]) # same as current table

      if(prevC!=0){ # to avoid divide by 0
        pctC <<- round(((curC - prevC) *100/ prevC),1) # not to use lastDayC, unreliable
      } else{
        pctC <<- 999
      }

      prevMC = as.numeric(fDayDataList[[rowPtr]][(lastRow - 1),2])
      theMDiff = curC - prevMC
      pctMDiff = round(((curC - prevMC)*100/ prevMC), 1)

      curAmt <- sprintf(round(curVol * curC / 10000), fmt = "%s") # this is string
      cAmt <- as.numeric(curAmt) # this is numeric

      pctAmt <- round((cAmt / pAmt) / 100) # this is the percentage compare with previous day
      pctDAmt <- round((cAmt / todayAmt) * 100) # this is the percentage compare with today day amount
       # since minute dat do not have H record

      # cal relative Level
      max10H = as.numeric(resultTable[rowPtr,9])
      min10L = as.numeric(resultTable[rowPtr,10])
      rLv = round( ( (curC - min10L) * 10 / (max10H - min10L) ),0 ) # 0 digit

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
       # 100*0.2 / 200 #0.1%
       # 100*0.1 / 100 #0.1%
       # 100*0.05 / 20 #0.25%
       # 100*0.02 / 10 #0.2%
       # 100*0.01 / 0.5 #2%
       # 100*0.005 / 0.25 #2%
       # below 0.25
       # 100*0.001 / 0.25 #2%

      state = "level"
      if((curC - prevC)>0){state = "up"}
      if((curC - prevC)<0){state = "down"}

      # minute: 60 240 350 700 curWAve_1, curWAve_2, curWAve_3, curWAve_4, lastC
      pprevwAve_1 = round(as.numeric(pprvWAveTable[rowPtr,2]),1)
      prevwAve_1 = round(as.numeric(prvWAveTable[rowPtr,2]),1)
      lastwAve_1 = round(as.numeric(curWAveTable[rowPtr,2]),1)

      pprevwAve_2 = round(as.numeric(pprvWAveTable[rowPtr,2]),2)
      prevwAve_2 = round(as.numeric(prvWAveTable[rowPtr,2]),2)
      lastwAve_2 = round(as.numeric(curWAveTable[rowPtr,2]),2)

      pprevwAve_3 = round(as.numeric(pprvWAveTable[rowPtr,2]),3)
      prevwAve_3 = round(as.numeric(prvWAveTable[rowPtr,2]),3)
      lastwAve_3 = round(as.numeric(curWAveTable[rowPtr,2]),3)

      pprevwAve_4 = round(as.numeric(pprvWAveTable[rowPtr,2]),4)
      prevwAve_4 = round(as.numeric(prvWAveTable[rowPtr,2]),4)
      lastwAve_4 = round(as.numeric(curWAveTable[rowPtr,2]),4)

      # this lastwAve_1 is added to smooth the trend curve
      # lastwAve_1 = calcWAve(c(pprevwAve_1, prevwAve_1, lastwAve_1))
      TPupData = ""
      TPdnData = ""
      checkTPMsg1 = ""
      checkTPMsg2 = ""

      amtMsg = chkAmt(cAmt, pctAmt,codenumber, codechiname)

     ###############################
     # if fulfill minimum amount, starts all inspections

      if(cAmt > 20){
       # check grade
         amountGrade = amtGrade(codenumber, cAmt)
         bombCount <<- read_bombMatrix(codenumber) # this is an indicator to trigger further action

         # alreadyAlarmed = FALSE
         if(testFlag(rowPtr, "alreadyAlarmedFlag", "unknown") == "no flip"){
           alreadyAlarmed = FALSE
         }else if(testFlag(rowPtr, "alreadyAlarmedFlag", "Yes") == "no flip"){
           alreadyAlarmed = TRUE
         }else{
           alreadyAlarmed = FALSE
         }

         alarmSignal = "none"

        # large amt grade
         if((amountGrade>6)|(pctAmt>3)){  # pctAmt is the % compare with previous day
           if(cAmt >= dealerTrigAmt){
             # record it in bombMatrix
             check_bombMatrix(codenumber)
             if((cAmt >= 2000) & (pctAmt>20)){
               alarmSignal = "ExtImp"
               mustPop(paste("ExtImp", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             } else{
               alarmSignal = "Grad-ww"
               #mustPop(paste("Grad-ww", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             }

             recAAU(paste(timeStamp, alarmSignal, codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, alarmSignal,curC,curAmt,pctC,pctMDiff,pctAmt))

           }else if((cAmt > 100)&(pctAmt >= dealerTrigAmtPct)){
             check_bombMatrix(codenumber)

             alarmSignal = "Grad-w!"
             #mustPop(paste("Grad-w!", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             recAAU(paste(timeStamp, alarmSignal, codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, alarmSignal,curC,curAmt,pctC,pctMDiff,pctAmt))
             if((bombCount > 0) & !alreadyAlarmed) {
                # mustPop(paste(alarmSignal, codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                # alreadyAlarmed = TRUE
                # popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
             }
           }
         }else{
          # in active list
           if((codenumber %in% activeList) & (amountGrade>3)){
             if(pctMDiff >= 0){
               recAAU(paste(timeStamp, "ativUp", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
               recAlmHist(rowPtr, paste(timeStamp, paste0("ativUp", amountGrade, sep=""),curC,curAmt,pctC,pctMDiff,pctAmt))
             }else{
               recAAU(paste(timeStamp, "ativDn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
               recAlmHist(rowPtr, paste(timeStamp, paste0("ativDn", amountGrade, sep=""),curC,curAmt,pctC,pctMDiff,pctAmt))
             } 
           }
         }


  
       # ====== check turning points, note that no recAAU executed
         alarmStr = c("ExtImp", "Grad-w!", "Grad-ww")
         checkTPMsg1 = checkTP(pprevwAve_1, prevwAve_1, lastwAve_1, (trigValue/2))
         checkTPMsg2 = checkTP(pprevwAve_2, prevwAve_2, lastwAve_2, (trigValue/2))
         checkTPMsg3 = checkTP(pprevwAve_3, prevwAve_3, lastwAve_3, (trigValue/2))
         checkTPMsg4 = checkTP(pprevwAve_4, prevwAve_4, lastwAve_4, (trigValue/2))
         TPMsg = c(checkTPMsg1, checkTPMsg2, checkTPMsg3)
         TPUpCount = length(grep("turn UP|keep Up", TPMsg))
         TPDnMsg = c(checkTPMsg1, checkTPMsg2)
         TPDNCount = length(grep("turn DN", TPDnMsg))

       # ======
           if( TPUpCount>0){
              alarmCmd = checkFlag(rowPtr, "tUPFlag", "Yes") # check is it flagged
              if(alarmCmd == "setAlarm"){
                  recAlmHist(rowPtr, paste(timeStamp, "tUP",curC,curAmt,pctC,pctMDiff,pctAmt))
                  if(codenumber %in% activeList  & amtMsg < 8 & pctDAmt>5 & pctAmt >5){
                    mustPop(paste("ActiUP", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                    recAlmHist(rowPtr, paste(timeStamp, "tUP",curC,curAmt,pctC,pctMDiff,pctAmt))
                  }

                  checkList<<- c(checkList, codenumber)
              }
              alarmCmd = checkFlag(rowPtr, "tDNFlag", "No") # reset flag
           }

       # ======

           if( TPDNCount>0){
              alarmCmd = checkFlag(rowPtr, "tDNFlag", "Yes") # check is it flagged
              if(alarmCmd == "setAlarm"){
                  recAlmHist(rowPtr, paste(timeStamp, "tDN",curC,curAmt,pctC,pctMDiff,pctAmt))
                  if( alarmSignal %in% alarmStr){
                    mustPop(paste("tDN_AMt", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                  }else{
                    #mustPop(paste("tDN", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                  }
              }
              alarmCmd = checkFlag(rowPtr, "tUPFlag", "No") # reset flag
           }


       # ====== check lamination
           if((curC> lastwAve_1) & (lastwAve_1> lastwAve_2) & (lastwAve_2> lastwAve_3)){
              alarmCmd = checkFlag(rowPtr, "tUPFlag", "Yes") # check is it flagged
              if(alarmCmd == "setAlarm"){
                  recAlmHist(rowPtr, paste(timeStamp, "layerUp",curC,curAmt,pctC,pctMDiff,pctAmt))
                  #mustPop(paste("layerUp", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                  checkList<<- c(checkList, codenumber)
              }
              alarmCmd = checkFlag(rowPtr, "tDNFlag", "No") # reset flag
           }

           if((curC< lastwAve_1) & (lastwAve_1< lastwAve_2) & (lastwAve_2< lastwAve_3)){
              alarmCmd = checkFlag(rowPtr, "tDNFlag", "Yes") # check is it flagged
              if(alarmCmd == "setAlarm"){
                  recAlmHist(rowPtr, paste(timeStamp, "layerDn",curC,curAmt,pctC,pctMDiff,pctAmt))
              }
              alarmCmd = checkFlag(rowPtr, "tUPFlag", "No") # reset flag
           }


       # ====== check schmidtTrigger
         # checkTrigger: rowPtr, prevC, curC
         trigStatus = checkTrigger(rowPtr, prvWAveTable[rowPtr,5], curC)
         if((trigStatus == "UpTrig")|(trigStatus == "DnTrig")){
              alarmCmd = checkFlag(rowPtr, "schmidtFlag", trigStatus)
              if(alarmCmd == "setAlarm"){
                if((trigStatus == "UpTrig")&(cAmt>10)){
                  recAAU(paste(timeStamp, "UpTrig", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
                  recAlmHist(rowPtr, paste(timeStamp, "UpTrig",curC,curAmt,pctC,pctMDiff,pctAmt))
                  # if((bombCount > 0) & !alreadyAlarmed & (codenumber %in% mustPopList))
                  #  {mustPop(paste("UpTrig", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                  #  alreadyAlarmed = TRUE
                  #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
                  # }
                }
                else if((trigStatus == "DnTrig")&(cAmt>10)){
                  recAAU(paste(timeStamp, "DnTrig", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
                  recAlmHist(rowPtr, paste(timeStamp, "DnTrig",curC,curAmt,pctC,pctMDiff,pctAmt))
                  # if((bombCount > 0) & !alreadyAlarmed& (codenumber %in% mustPopList))
                  #   {mustPop(paste("DnTrig", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
                  #  alreadyAlarmed = TRUE
                  #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
                  # }
                }
              }
         }
        # ====== check schmidtTrigger completed


      # check bigMDiff difference
       if(abs(pctMDiff > 1) & amtMsg < 8 & pctDAmt>5 & pctAmt >5){
          mustPop(paste("ExtImpPct", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
          checkList<<- c(checkList, codenumber)
          recAlmHist(rowPtr, paste(timeStamp, "ExtImpPct",curC,curAmt,pctC,pctMDiff,pctAmt))
       }
        # ====== check bigRise completed

      # check 3x6 cross
       if( curC >= as.numeric(resultTable[rowPtr,11]) & 
           curC >= as.numeric(resultTable[rowPtr,8]) ){
              alarmCmd = checkFlag(rowPtr, "WAve3x6", "Yes") # check is it flagged
              if(alarmCmd == "setAlarm"){
                  recAlmHist(rowPtr, paste(timeStamp, "WAve3x6",curC,curAmt,pctC,pctMDiff,pctAmt))
              }
              # alarmCmd = checkFlag(rowPtr, "WAve3x6", "No") # reset flag
       }
        # ====== check 3x6 cross completed

      # check 3v6 dncross
       if( curC < as.numeric(resultTable[rowPtr,11]) & 
           curC < as.numeric(resultTable[rowPtr,8]) ){
              alarmCmd = checkFlag(rowPtr, "WAve3v6", "Yes") # check is it flagged
              if(alarmCmd == "setAlarm"){
                  recAlmHist(rowPtr, paste(timeStamp, "WAve3v6",curC,curAmt,pctC,pctMDiff,pctAmt))
              }
              # alarmCmd = checkFlag(rowPtr, "WAve3v6", "No") # reset flag
       }
        # ====== check 3v6 dncross completed



      # check minute cross
       if(
        (((curC - minlevel) > trigValue) | ((maxlevel - curC) > trigValue)) &
        (pricelast5cRange > trigValue) & 
        (abs(curC - lastwAve_1) > trigValue)
        ){

        # check cX_1
         # prevL,prevS, curL, curS,(c index 5, _1 index 1)
         ccX_1 = checkX(prvWAveTable[rowPtr,1],prvWAveTable[rowPtr,5], curWAveTable[rowPtr,1], curWAveTable[rowPtr,5])
         if(ccX_1 == "UpCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cX_1 UpX", codenumber, " ",codechiname)}
         if(ccX_1 == "critical"){ccX_1 = ""}
         if(ccX_1 == "cont.Up"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cX_1 cont.Up", codenumber, " ",codechiname)}
         if(ccX_1 == "cont.Dn"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cX_1 cont.Dn", codenumber, " ",codechiname)}
         if(ccX_1 == "DownCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cX_1 DnX", codenumber, " ",codechiname)}

        # check cX_2
         # prevL,prevS, curL, curS,(c index 5, _2 index 2)
         ccX_2 = checkX(prvWAveTable[rowPtr,2],prvWAveTable[rowPtr,5], curWAveTable[rowPtr,2], curWAveTable[rowPtr,5])
         if(ccX_2 == "UpCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_2 UpX", codenumber, " ",codechiname)}
         if(ccX_2 == "critical"){ccX_2 = ""}
         if(ccX_2 == "cont.Up"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_2 cont.Up", codenumber, " ",codechiname)}
         if(ccX_2 == "cont.Dn"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_2 cont.Dn", codenumber, " ",codechiname)}
         if(ccX_2 == "DownCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_2 DnX", codenumber, " ",codechiname)}

        # check cX_3
         # prevL,prevS, curL, curS,(c index 5, 350 index 3)
         ccX_3 = checkX(prvWAveTable[rowPtr,3],prvWAveTable[rowPtr,5], curWAveTable[rowPtr,3], curWAveTable[rowPtr,5])
         if(ccX_3 == "UpCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_3 UpX", codenumber, " ",codechiname)}
         if(ccX_3 == "critical"){ccX_3 = ""}
         if(ccX_3 == "cont.Up"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_3 cont.Up", codenumber, " ",codechiname)}
         if(ccX_3 == "cont.Dn"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_3 cont.Dn", codenumber, " ",codechiname)}
         if(ccX_3 == "DownCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_3 DnX", codenumber, " ",codechiname)}

        # check cX_4
         # prevL,prevS, curL, curS,(c index 5, 700 index 4)
         ccX_4 = checkX(prvWAveTable[rowPtr,4],prvWAveTable[rowPtr,5], curWAveTable[rowPtr,4], curWAveTable[rowPtr,5])
         if(ccX_4 == "UpCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_4 UpX", codenumber, " ",codechiname) }
         if(ccX_4 == "critical"){ccX_4 = ""}
         if(ccX_4 == "cont.Up"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_4 cont.Up", codenumber, " ",codechiname)}
         if(ccX_4 == "cont.Dn"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_4 cont.Dn", codenumber, " ",codechiname)}
         if(ccX_4 == "DownCross"){amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC," cx_4 DnX", codenumber, " ",codechiname)}

        # check C cross minute WAve ===============
         # calculate minute WAve, base on fDayDataList
         lastm_1c = as.numeric(c(fDayDataList[[rowPtr]][(lastRow - 59):lastRow,2]))
         lastm_2c = as.numeric(c(fDayDataList[[rowPtr]][(lastRow - 178):lastRow,2]))
         plastm_1c = as.numeric(c(fDayDataList[[rowPtr]][(lastRow - 60):(lastRow-1),2]))
         plastm_2c = as.numeric(c(fDayDataList[[rowPtr]][(lastRow - 179):(lastRow-1),2]))
         mwAve_1 = calcWAve(as.numeric(lastm_1c))
         mWAve_2 = calcWAve(as.numeric(lastm_2c))
         pmwAve_1 = calcWAve(as.numeric(plastm_1c))
         pmWAve_2 = calcWAve(as.numeric(plastm_2c))
         # prevL,prevS, curL, curS,(pmwAve_1,prevC,mwAve_1,curC)
         ccXmwAve_1 = checkX(pmwAve_1,prevC,mwAve_1,curC)
         ccXmWAve_2 = checkX(pmWAve_2,prevC,mWAve_2,curC)
         c5XmWAve_2 = checkX(pmWAve_2,pmwAve_1,mWAve_2,mwAve_1)

         if(((ccXmwAve_1 == "UpCross")|(ccXmwAve_1 == "cont.Up"))&(cAmt > 10)){
            alarmCmd = checkFlag(rowPtr, "cXmwAve_1Flag", "cXmwAve_1 UpX")
            if(alarmCmd == "setAlarm"){
             #mustPop(paste("cXmW1Up", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #recAAU(paste(timeStamp, "cXmW1Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cXmW1Up",curC,curAmt,pctC,pctMDiff,pctAmt))
             # if((bombCount > 0) & !alreadyAlarmed & (codenumber %in% mustPopList))
             # {mustPop(paste("cXmW1Up", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #  alreadyAlarmed = TRUE
             #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes"
             # }
            }
         }
         if((ccXmwAve_1 == "DownCross")|(ccXmwAve_1 == "cont.Dn")){
            alarmCmd = checkFlag(rowPtr, "cXmwAve_1Flag", "cXmwAve_1 DnX")
            if(alarmCmd == "setAlarm"){
             #mustPop(paste("cXmW1Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #recAAU(paste(timeStamp, "cXmW1Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cXmW1Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
             # if((bombCount > 0) & !alreadyAlarmed & (codenumber %in% mustPopList))
             # {mustPop(paste("cXmW1Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #  alreadyAlarmed = TRUE
             #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
             # }
            }
         }

         if(((ccXmWAve_2 == "UpCross")|(ccXmWAve_2 == "cont.Up"))&(cAmt > 10)){
            alarmCmd = checkFlag(rowPtr, "cXmWAve_2Flag", "cXmWAve_2 UpX")
            if(alarmCmd == "setAlarm"){
             #recAAU(paste(timeStamp, "cXmW3Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cXmW3Up",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }
         if((ccXmWAve_2 == "DownCross")|(ccXmWAve_2 == "cont.Dn")){
            alarmCmd = checkFlag(rowPtr, "cXmWAve_2Flag", "cXmWAve_2 DnX")
            if(alarmCmd == "setAlarm"){
             #recAAU(paste(timeStamp, "cXmW3Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cXmW3Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }

         if(((c5XmWAve_2 == "UpCross")|(c5XmWAve_2 == "cont.Up"))&(cAmt > 10)){
            alarmCmd = checkFlag(rowPtr, "c5XmWAve_2Flag", "c5XmWAve_2 UpX")
            if(alarmCmd == "setAlarm"){
             #recAAU(paste(timeStamp, "XmW3Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             checkList<<- c(checkList, codenumber)
             recAlmHist(rowPtr, paste(timeStamp, "XmW3Up",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }
         if((c5XmWAve_2 == "DownCross")|(c5XmWAve_2 == "cont.Dn")){
            alarmCmd = checkFlag(rowPtr, "c5XmWAve_2Flag", "c5XmWAve_2 DnX")
            if(alarmCmd == "setAlarm"){
             #recAAU(paste(timeStamp, "XmW3Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             checkList<<- c(checkList, codenumber)
             recAlmHist(rowPtr, paste(timeStamp, "XmW3Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }

         # check C cross minute WAve complete ===============

        # check C cross WAve3
         # calculate current WAve, base on daily Kline
         # resultTable[,4 is prevPrice, 5 is pprevPrice
         newArray = c(resultTable[rowPtr,5], resultTable[rowPtr,4], curC)
         curWAve3 = calcWAve(as.numeric(newArray))

         wAveL = klineWave[rowPtr,7]
         pwAveL = klineWave[rowPtr,8]
         wAveH = klineWave[rowPtr,10]
         pwAveH = klineWave[rowPtr,9]
         todayHigh = todayHiLo[rowPtr,1]
         todayLow = todayHiLo[rowPtr,2]
         # check trend status
         todayStat = (todayLow > pwAveL)&(todayLow > wAveL)&(todayHigh > pwAveH)&(todayHigh > wAveH)
         mwAve_1Stat = (ccXmwAve_1 == "UpCross")|(ccXmwAve_1 == "cont.Up")
         amtStat = (alarmSignal %in% alarmStr)
         minuteUp = curC >= prvWAveTable[rowPtr,5]

         # resultTable:
         # thestkCode, chiName, prevWAve3, prevPrice, pprevPrice, prevAmt, trendAmt, WAve3, max10H, min10L
         # prevL,prevS, curL, curS,(resultTable[rowPtr,3],prevC,curWAve3,curC)
         ccXWAve3 = checkX(resultTable[rowPtr,8], prevC, curWAve3, curC)
         if(((ccXWAve3 == "UpCross")|(ccXWAve3 == "cont.Up"))&(cAmt > 30) & todayStat & amtStat & minuteUp){
            alarmCmd = checkFlag(rowPtr, "cXWAve3Flag", "cXWAve3 UpX")
            if(alarmCmd == "setAlarm"){
             #mustPop(paste("cXWAvUp", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             recAAU(paste(timeStamp, "cXWAvUp", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cXWAvUp",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }
         if((ccXWAve3 == "DownCross")|(ccXWAve3 == "cont.Dn")){
            alarmCmd = checkFlag(rowPtr, "cXWAve3Flag", "cXWAve3 DnX")
            if(alarmCmd == "setAlarm"){
             #mustPop(paste("cXWAvDn", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             recAAU(paste(timeStamp, "cXWAvDn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cXWAvDn",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }
         # check C cross WAve3 complete=====================

        ### detect strongSigFlag condition ============================
         # klineWave[rowPtr,7] criteriaSig
         # klineWave[rowPtr,8] strongSig

         if((todayAmt > 400) &(cAmt > 10)& (klineWave[rowPtr,7] == TRUE) &
            (curC >= curWAve3) & (curC > prvWAveTable[rowPtr,5])){
            alarmCmd = checkFlag(rowPtr, "strongSigFlag", "strongSigFlag Up")
            if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "StronUp", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "StronUp",curC,curAmt,pctC,pctMDiff,pctAmt))
             # if((bombCount > 0) & !alreadyAlarmed & (codenumber %in% mustPopList))
             # {mustPop(paste("StronUp", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             # alreadyAlarmed = TRUE
             #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
             # }
            }
         }
         if((todayAmt > 400) & (klineWave[rowPtr,7] == TRUE) &
            (curC < curWAve3) & (curC < prvWAveTable[rowPtr,5])){
            alarmCmd = checkFlag(rowPtr, "strongSigFlag", "strongSigFlag Dn")
            if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "StronDn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "StronDn",curC,curAmt,pctC,pctMDiff,pctAmt))
            }
         }

         ### detect strongSigFlag complete ============================

        ### detect cX_4 cross condition ============================
          cX_4UpSwitch = FALSE
          if((ccX_4 == "UpCross")|(ccX_4 == "cont.Up")&
             (curC >= prvWAveTable[rowPtr,5])&(cAmt > 10)){       # ensure no price drop
            alarmCmd = checkFlag(rowPtr, "cX_4Flag", "cX_4 UpX")
            if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "cX_4Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cX_4Up",curC,curAmt,pctC,pctMDiff,pctAmt))
             # if((bombCount > 0) & !alreadyAlarmed)
             # {mustPop(paste("cX_4Up", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #  alreadyAlarmed = TRUE
             #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
             # }
             TPupListCnt <<- TPupListCnt + 1
             cX_4UpSwitch = TRUE
            }
          }

          cX_4DnSwitch = FALSE
          if((ccX_4 == "DownCross")|(ccX_4 == "cont.Dn")&
             (curC <= prvWAveTable[rowPtr,5])){       # ensure no price up
           alarmCmd = checkFlag(rowPtr, "cX_4Flag", "cX_4 DnX")
           if(alarmCmd == "setAlarm"){
            recAAU(paste(timeStamp, "cX_4Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
            recAlmHist(rowPtr, paste(timeStamp, "cX_4Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
            TPdnListCnt <<- TPdnListCnt + 1
            cX_4DnSwitch = TRUE
		 }
          }
         ### detect cX_4 cross complete ============================


        ### detect cX_3 cross condition ============================
         cX_3UpSwitch = FALSE
         if((!cX_4UpSwitch)&   # not c700
            ((ccX_3 == "UpCross")|(ccX_3 == "cont.Up"))&
             (curC >= prvWAveTable[rowPtr,5])&(cAmt > 10)){       # ensure no price drop
            alarmCmd = checkFlag(rowPtr, "cX_3Flag", "cX_3 UpX")
            if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "cX_3Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             checkList<<- c(checkList, codenumber)
             recAlmHist(rowPtr, paste(timeStamp, "cX_3Up",curC,curAmt,pctC,pctMDiff,pctAmt))
             # if((bombCount > 0) & !alreadyAlarmed & (codenumber %in% mustPopList))
             # {mustPop(paste("cX_3Up", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #  alreadyAlarmed = TRUE
             #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
             # }
             cX_3UpSwitch = TRUE
            }
	    }

         cX_3DnSwitch = FALSE
         if((!cX_4DnSwitch)&
            ((ccX_3 == "DownCross")|(ccX_3 == "cont.Dn"))&
             (curC <= prvWAveTable[rowPtr,5])){       # ensure no price up
           alarmCmd = checkFlag(rowPtr, "cX_3Flag", "cX_3 DnX")
           if(alarmCmd == "setAlarm"){
            recAAU(paste(timeStamp, "cX_3Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
            checkList<<- c(checkList, codenumber)
            recAlmHist(rowPtr, paste(timeStamp, "cX_3Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
            cX_3DnSwitch = TRUE
		 }
         }
         ### detect cX_3 cross complete ============================

        ### detect cX_2 cross condition ============================
         cX_2UpSwitch = FALSE
          if((!cX_3UpSwitch)&(!cX_4UpSwitch)&
             ((ccX_2 == "UpCross")|(ccX_2 == "cont.Up"))&
              (curC >= prvWAveTable[rowPtr,5])&(cAmt > 10)){       # ensure no price drop
            alarmCmd = checkFlag(rowPtr, "cX_2Flag", "cX_2 UpX")
            if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "cX_2Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             checkList<<- c(checkList, codenumber)
             recAlmHist(rowPtr, paste(timeStamp, "cX_2Up",curC,curAmt,pctC,pctMDiff,pctAmt))
             cX_2UpSwitch = TRUE
            }
          }

         cX_2DnSwitch = FALSE
          if((!cX_3DnSwitch)&(!cX_4DnSwitch)&
             ((ccX_2 == "DownCross")|(ccX_2 == "cont.Dn"))&
              (curC <= prvWAveTable[rowPtr,5])){       # ensure no price up
           alarmCmd = checkFlag(rowPtr, "cX_2Flag", "cX_2 DnX")
           if(alarmCmd == "setAlarm"){
            recAAU(paste(timeStamp, "cX_2Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
            recAlmHist(rowPtr, paste(timeStamp, "cX_2Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
            cX_2DnSwitch = TRUE
		 }
          }

         #}
         ### detect cX_2 cross complete ============================

        ### detect cX_1 cross condition ============================
         cX_1UpSwitch = FALSE
          if((!cX_3UpSwitch)&(!cX_4UpSwitch)&(!cX_2UpSwitch)&
             ((ccX_1 == "UpCross")|(ccX_1 == "cont.Up"))&
              (curC >= prvWAveTable[rowPtr,5])&(cAmt > 10)){       # ensure no price drop
            alarmCmd = checkFlag(rowPtr, "cX_1Flag", "cX_1 UpX")
            if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "cX_1Up", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             recAlmHist(rowPtr, paste(timeStamp, "cX_1Up",curC,curAmt,pctC,pctMDiff,pctAmt))
             cX_1UpSwitch = TRUE
            }
          }

         cX_1DnSwitch = FALSE
          if((!cX_3DnSwitch)&(!cX_4DnSwitch)&(!cX_2DnSwitch)&
             ((ccX_1 == "DownCross")|(ccX_1 == "cont.Dn"))&
              (curC <= prvWAveTable[rowPtr,5])){       # ensure no price up
           alarmCmd = checkFlag(rowPtr, "cX_1Flag", "cX_1 DnX")
           if(alarmCmd == "setAlarm"){
            recAAU(paste(timeStamp, "cX_1Dn", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
            recAlmHist(rowPtr, paste(timeStamp, "cX_1Dn",curC,curAmt,pctC,pctMDiff,pctAmt))
            cX_1DnSwitch = TRUE
		 }
          }

         #}
         ### detect cX_1 cross complete ============================

       }
      # check cross complete

      # check very large amount or special mustPopList activity
         if(
            ((cAmt > 1000)&(pctAmt>5)) |
            ((cAmt > 500)&(pctAmt>10)) |
            ((cAmt > 100)&(pctAmt>40)) |
            ((codenumber %in% mustPopList)&(cAmt > 100)&(pctAmt>5)) |
            ((codenumber %in% mustPopList)&(cAmt > 50)&(pctAmt>20))
           ){
           amtAlmRpt <- paste(amtAlmRpt, "\n",timeStamp, " Amt: ", round(cAmt), " Pct ", pctAmt, " almLv ",amtMsg, " curC ", curC, " C% ", pctC,"VlAmt", codenumber, " ",codechiname)
           sendMsg(paste("VlAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))

            flagStatusUp1 = testFlag(rowPtr, "cXWAve3Flag", "cXWAve3 UpX")
            flagStatusUp2 = testFlag(rowPtr, "cX_4Flag", "cX_4 UpX")
            flagStatusUp3 = testFlag(rowPtr, "cX_3Flag", "cX_3 UpX")
            flagStatusUp4 = testFlag(rowPtr, "cX_2Flag", "cX_2 UpX")

            flagStatusDn1 = testFlag(rowPtr, "cXWAve3Flag", "cXWAve3 DnX")
            flagStatusDn2 = testFlag(rowPtr, "cX_4Flag", "cX_4 DnX")
            flagStatusDn3 = testFlag(rowPtr, "cX_3Flag", "cX_3 DnX")
            flagStatusDn4 = testFlag(rowPtr, "cX_2Flag", "cX_2 DnX")
            if((flagStatusUp1 == "no flip")|(flagStatusUp2 == "no flip")|
               (flagStatusUp3 == "no flip")|(flagStatusUp4 == "no flip")&
               (curC > prvWAveTable[rowPtr,5])){       # ensure no price drop
              recAAU(paste(timeStamp, "upXAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
              checkList<<- c(checkList, codenumber)
              recAlmHist(rowPtr, paste(timeStamp, "upXAmt",curC,curAmt,pctC,pctMDiff,pctAmt))
              # mustPop(paste("upXAmt ", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
            } else if((flagStatusDn1 == "no flip")|(flagStatusDn2 == "no flip")|
                      (flagStatusDn3 == "no flip")|(flagStatusDn4 == "no flip")&
              (curC < prvWAveTable[rowPtr,5])){       # ensure no price up
              recAAU(paste(timeStamp, "dnXAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
              recAlmHist(rowPtr, paste(timeStamp, "dnXAmt",curC,curAmt,pctC,pctMDiff,pctAmt))
              # mustPop(paste("dnXAmt ", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
            }else{
              recAAU(paste(timeStamp, "VlAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
              recAlmHist(rowPtr, paste(timeStamp, "VlAmt",curC,curAmt,pctC,pctMDiff,pctAmt))
            }


           # recAAD(paste(timeStamp, "VlAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
           #if(codenumber %in% mustPopList){
           #  mustPop(paste("*VlAmt ", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
           #}else{
           #}
         }
       # check very large amount complete

      # check total amount more than prev day amt
         tAmt = todayAmt /10000 # to match pAmt, unit in yi

         if( tAmt > 0.02 & pAmt>0.02 & tAmt > pAmt & amtMsg < 8 & pctDAmt>5 & pctAmt >5){
          alarmCmd = checkFlag(rowPtr, "gtpdAmtFlag", "greater")
           if(alarmCmd == "setAlarm"){
             recAAU(paste(timeStamp, "gtpdAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," c% ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " DAmt ",todayAmt, " pcDAmt ",pctDAmt," rLv ",rLv))
             checkList<<- c(checkList, codenumber)
             recAlmHist(rowPtr, paste(timeStamp, "gtpdAmt",curC,curAmt,pctC,pctMDiff,pctAmt))
             mustPop(paste("gtpdAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))

             # if((bombCount > 0) & !alreadyAlarmed)
             # {mustPop(paste("gtpdAmt", codenumber, codechiname," curC ", curC, " C% ", pctC," ",pctMDiff,"\\ncAmt", curAmt, " almLv ",amtMsg, " ppct ", pctAmt, " bombCount ",bombCount))
             #  alreadyAlarmed = TRUE
             #  popupFlag = checkFlag(rowPtr, "alreadyAlarmedFlag", "Yes")
             # }
		 }
         }

      # check total amount more than prev day amt complete

	 }  # fulfill minimum amount
    }    # the main loop
 }       # statusCheck

# repeatcheck function is the main workhorse
  repeatCheck = function(){
    AAURec <<- character() # clear buffer
    cat(red(codeTableName), "collecting data ")
    theMostUpdateData <<- updateData(theURLReqList) # a 2D complete data.frame: code, chiname, price, Vol, Amt, only 5 items
    # to access the third object, first element: theMostUpdateData[[3]][1]
    # combine the theMostUpdateData into the 3D table
     for(page in 1:length(CodeTable)){
      newvec = c(gsub(":","",format(Sys.time(), '%H:%M')), # time, price, Vol
        theMostUpdateData[page,3], 
        theMostUpdateData[page,4]  # note the Amt [page,5] not included in the table
      )
      tempPage=fDayDataList[[page]]
      tempPage=rbind(fDayDataList[[page]],newvec)
      fDayDataList[[page]] <<- tempPage
      # the last row is fDayDataList[[page]][nrow(fDayDataList[[page]]),]
      tableLastRow = nrow(fDayDataList[[page]])
      # the last row index is nrow(fDayDataList[[page]])
      fDayDataList[[page]] <<- fDayDataList[[page]][((tableLastRow - 800):tableLastRow),] # chop a part off
     }

    # find out the operation time lapsed
     ar1600 = which(fDayDataList[[1]][,1]=="1600")
     opTime <<- pageHeight - ar1600[length(ar1600)]

    # this calculate all minute WAves, returns a table
       # curWAve_1, curWAve_2, curWAve_3, curWAve_4, lastC
      curWAveTable <<- matrix(,ncol=5, nrow=0) # this reset the table to remove previous data
      for(page in 1:length(CodeTable)){
        lastRow = nrow(fDayDataList[[page]])
        curWAveTable <<- rbind(curWAveTable, calpageWAve(page, lastRow))
      }

    # perform comparisons here
     cat("checking status .. \n")
     statusCheck()
     popupRpt()
     #cat("\nTPupCnt ",TPupListCnt," TPdnCnt ",TPdnListCnt,"\n")
     # beepgood(TPupListCnt)
     Sys.sleep(1)
     # beepbad(TPdnListCnt)
     pprvWAveTable <<- prvWAveTable  # copy to pprevious table
     prvWAveTable <<- curWAveTable  # copy to previous table
     cat("\n\n", pink(codeTableName), "repeatCheck complete . ")
  }

# ==============================================
# Main Loop, not program entry, includes time check
  MonTrend <- function(){
    for(i in 1:1000){
      ProcessStartTime = Sys.time()
      the_time <- unclass(as.POSIXlt(Sys.time()))
      timeis <- the_time[3]$hour*100 + the_time[2]$min
      if (((timeis>=929) & (timeis<=1201)) | ((timeis>=1259) & (timeis<=1611))){
        repeatCheck()
      }else{debugMsg("not trading hour!")}
      # repeatCheck() for testing purpose only
      ProcessEndTime = Sys.time()
      LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
      cat("loop time: ",LoopTime,"\n")
      SleepTime= IntervalMinutes*60 - LoopTime - 1
      if(SleepTime<0){SleepTime=0}
      debugMsg("Waiting for next turn! ")
      Sys.sleep(SleepTime)
    }
  }

# ==============================================
# Program entry
 # Datasets init ======================

  # to confirm amtHistory tables ready
  Selection <- readline(prompt="Please confirm amtHistory ready? 1/0  ")
    if(Selection == "0"){ break }
  # to confirm all code tables updated
  Selection <- readline(prompt="Please confirm code tables updated? 1/0  ")
    if(Selection == "0"){ break }
  # ask for min dealer trig amt
  Selection <- readline(prompt="Enter the min dealer trig amt: ")
    dealerTrigAmt = 1000
    if(Selection == "0"){ break
    } else{
      if(as.numeric(Selection)>0){ dealerTrigAmt = as.numeric(Selection)
      } else{cat(red("trig amt set to 1000 w!\n"))}
    }
  # ask for min dealer trig amt pct
  Selection <- readline(prompt="Enter the min dealer trig amt pct: ")
    dealerTrigAmtPct = 10
    if(Selection == "0"){ break
    } else{
      if(as.numeric(Selection)>0){ dealerTrigAmtPct = as.numeric(Selection)
      } else{cat(red("trig amt pct set to 10!\n"))}
    }

  # ask for popup permit
  Selection <- readline(prompt="Allow popup? 1/0 ")
    if(Selection == "1"){ mustpopupKey = TRUE
    } else{ mustpopupKey = FALSE}

  todayStr = format(Sys.Date(), format="%y%m%d")
  typhoonDate = readLines("typhoonDate.txt")

  soundlist = c("ping","coin", "shotgun", "facebook", "sword")
  soundlistLength = length(soundlist) 

  codeTableName = askforfilename() # this will be used in output filename
  CodeTable = readLines(paste0(codeTableName,".txt"))
  ImpAlarm = readLines("ImpAlarm.txt")

  checkSpace(CodeTable)

	 # remove all code start with 046
       invalidIdx = grep("^046..",CodeTable)
       if(length(invalidIdx)!=0){
         cat("\nremove invalid code: ", CodeTable[invalidIdx],"\n")
         CodeTable = CodeTable[-invalidIdx]
       }


  cat("\ncodeTableName: ",codeTableName,"\n")
  cat(orange("Original CodeTable Length: "), length(CodeTable), "\n")

# to confirm include attachment tables
  Selection <- readline(prompt="include attachment tables? 1/0  ")
    if(Selection == "0"){
        cat("\n", red("excluded attachment tables!\n"))

        # clear following lists
        heavyStk = ""
        mustAdd = ""
        mustPopList = ""
    } else{
      cat("\n", green("Including attachment tables!\n"))

        heavyStk = readLines("heavyStk.txt")
        cat("No. of heavyStk: ", length(heavyStk), "\n Add heavyStk, ")
        CodeTable = addItems(CodeTable, heavyStk)
        cat("after added heavyStk CodeTable length is: ",length(CodeTable),"\n")

        #shortTerm = readLines("shortTerm.txt")
        #cat("No. of shortTerm: ", length(shortTerm), "\n Add shortTerm, ")
        #CodeTable = addItems(CodeTable, shortTerm)
        #cat("after added shortTerm CodeTable length is: ",length(CodeTable),"\n")
        mustAdd = readLines("mustAdd.txt")
        cat("No. of mustAdd: ", length(mustAdd), "\n Add mustAdd, ")
        CodeTable = addItems(CodeTable, mustAdd)
        cat("included mustAdd CodeTable length is: ",length(CodeTable),"\n")
    }

     # the followings must be added
        activeList = readLines("activeList.txt") # activeList is manually created list to monitor and colored
        # to avoid mixed color catagories, remove duplicates
        activeList = rmItems(activeList, mustAdd) # remove duplicated items
        activeList = rmItems(activeList, heavyStk) # remove duplicated items
        #heavyStk = rmItems(heavyStk, mustAdd) # remove duplicated items

        cat("No. of activeList: ", length(activeList), "\n Add activeList, ")
        CodeTable = addItems(CodeTable, activeList)
        cat("Result CodeTable length is: ",length(CodeTable),"\n")


        fraudSTK = readLines("fraudSTK.txt")
        checkSpace(fraudSTK)
        cat("No. of fraudSTK: ", length(fraudSTK), "\n")
         # remove fraudSTK & forgetLst
          # note, if CodeTable does not contain fraudSTK, error
          CodeTable = rmItems(CodeTable, fraudSTK)
          cat(orange("after removed fraudSTK, CodeTable Length: "), length(CodeTable), "\n")

        mustPopList = readLines("mustPopList.txt")
        cat("No. of mustPopList: ", length(mustPopList), "\n Add mustPopList, ")
        CodeTable = addItems(CodeTable, mustPopList)
        cat("included mustPopList CodeTable length is: ",length(CodeTable),"\n")

        mustPopList = unique(c(mustPopList, activeList)) # merge together
        ImpAlarm = c(ImpAlarm, mustAdd)  # to be highlighted in report

  # not fraudSTK, but ignore it
  #ignoreSTK = readLines("ignoreLongList.txt")
  ignoreSTK = readLines("ignoreList.txt")
  cat("No. of ignoreSTK: ", length(ignoreSTK), "\n Remove ignoreSTK, ")
  CodeTable = rmItems(CodeTable, ignoreSTK)
  cat("Result CodeTable length is: ",length(CodeTable),"\n")

  #coldbench = readLines("coldbench.txt")
  #cat("No. of coldbench: ", length(coldbench), "\n Remove coldbench, ")
  #CodeTable = rmItems(CodeTable, coldbench)
  #cat("Result CodeTable length is: ",length(CodeTable),"\n")


  # this is the Kline table, diff from fday data
   resultTable = array()
  # init amt history table and bombMatrix
    amtHistoryCode = character()
    amtHistory = list()
    loadHistoryAmt()

 # loop to call to FetchKline
  cat(red("FetchKline...\n"))
  cat(magenta("\n",format(Sys.time(), "%H:%M:%OS"),"\n"))
  for(codes in 1:length(CodeTable)){
    cat(CodeTable[codes],"")
    #Sys.sleep(0.45)
    #if(codes%%10 == 0){Sys.sleep(1)}

    tempResult = FetchKline(CodeTable[codes])
    if(tempResult[1] == "newcode!"){
        newcodeList = c(newcodeList, CodeTable[codes])
        cat(yellow("\nnewcode! "), CodeTable[codes],"\n")
    } else if(tempResult[1] == "amount ignored!"){
        newcodeList = c(newcodeList, CodeTable[codes])
        cat("\namount ignored! \n")
    } else {
        # thestkCode, chiName, prevWAve3, prevPrice, pprevPrice, prevAmt, trendAmt, WAve3, max10H, min10L, triggerWave
        resultTable = rbind(resultTable, tempResult) # this is total results
    }
  }

 # resultTable: thestkCode, chiName, prevWAve3, prevPrice, pprevPrice, prevAmt, trendAmt, WAve3, max10H, min10L
   resultTable = resultTable[-1,] # remove empty line
   CodeTable = rmItems(CodeTable, newcodeList) # curWAveTable is based on CodeTable
   cat("\nafter removed newcodes, CodeTable Length: ",length(CodeTable), "\nresultTable Length: ", nrow(resultTable))
   cat(magenta("\n",format(Sys.time(), "%H:%M:%OS"),"\n"))
   cat(red("fetch kline complete"),"\n")

 # theprevdata: the previous day data, only previous amt and price is used
   # so change theprevdata to resultTable will be ok
   # prevPrice is resultTable[,4] and prevAmt is resultTable[,6]
   # theprevdata is the realigned result
   # theprevdata structure: code,name,%,amt,price,sell,prevC
   # prevAmt = as.numeric(theprevdata[,4])

 # init variables
   codeTableLen = length(CodeTable)
   cat("\nCodeTable length: ",codeTableLen,"\n")

  # init almHistory
    for(i in 1:nrow(resultTable)){
       almHistory[i] = resultTable[i,1]
    }
  # create a stk list of trend to display
    shortTerm = unname(resultTable[,1][which(klineWave[,7]==TRUE)])
    cat(deeppink("uptrend list length: "),length(shortTerm), "\n")
    cat(deeppink("uptrend list: "),gray(shortTerm))
    cat("\n")

  strongSigList = unname(resultTable[,1][which(klineWave[,8]==TRUE)])
  cat(deeppink("strongSigList length: "),length(strongSigList), "\n")
  cat(deeppink("strongSigList: "),gray(strongSigList))
  cat("\n")

  htmlsp = "&emsp;"
  prevC = numeric()
  curC = numeric()

  #basetable = readLines("codetable.txt")
  #extratable = setdiff(CodeTable,basetable)
  #CodeTable = rmItems(CodeTable, extratable)

 # load wAveTable.txt
 #cat("load wAveTable.txt\n")
 #wAveTable = read.csv("wAveTable.txt", header=TRUE, sep="\t", colClasses=c('character', 'character', 'character'))
 # wAveTable = read.csv("wAveTable.txt", header=TRUE, sep="\t")
 # check whether wAveTable contain required code data
 # if(!all(CodeTable %in% wAveTable[,1])){
 #   cat("wAveTable not included: ",CodeTable[!(CodeTable %in% wAveTable[,1])])
 #   CodeTable = rmItems(CodeTable, CodeTable[!(CodeTable %in% wAveTable[,1])],"CodeTable", "Not in wAveTable")
 #   cat("\nremove items: ", length(CodeTable[!(CodeTable %in% wAveTable[, 1])]), "\n")
 #   sink("filteredCodetable.txt")
 #    cat(CodeTable, sep = "\n")
 #   sink()
 #   cat("\nthe real Codetable is recorded as filteredCodetable.txt\n")
 # }

 # extract useful data and discard non relevent, note the sequence in %in%
 # wAveTable = filter(wAveTable, wAveTable[,1] %in% CodeTable)

 # set initials status flag
    flagNum = 32
    flags <- matrix(rep("unknown", flagNum*codeTableLen), nrow = codeTableLen, ncol = flagNum) # note this depends on flagNum
    colnames(flags) <- c("cX_1Flag","cX_2Flag","cX_3Flag","cX_4Flag","tDNFlag","tUPFlag","5X320Flag","20X_2Flag","20X320Flag","_2X320Flag","AllFlag","XwAve_1Flag","XwAve10Flag","FLSZFlag","DWFLFlag","Amt5Pct2Flag","Amt8Pct1Flag","Amt5Pct25Flag","Xw5_Xw10Flag","BBGFlag","schmidtFlag","QkFlag","cX1400Flag","gtpdAmtFlag","cXWAve3Flag","strongSigFlag", "cXmwAve_1Flag", "cXmWAve_2Flag","c5XmWAve_2Flag","alreadyAlarmedFlag","WAve3x6","WAve3v6") # do not modify this, remember to modify flagNum

 # init upDnCounter, for schmidtTrigger
    upDnCounter <- matrix(rep(0, codeTableLen), nrow = codeTableLen, ncol = 1)
    colnames(upDnCounter) <- "upDnCount"

 # collect fDayData and put in a 3D list of minute data
  fDayDataList <- list()
  cat(red(codeTableName), red("collecting fDay\n"))
  beginTime = Sys.time()
  for(item in 1:length(CodeTable)){
    cat(item, CodeTable[item])
    theMinuteData = collectData(CodeTable[item]) # time, price, vol
    lastRow = nrow(theMinuteData)
    theMinuteData = theMinuteData[((lastRow - 800):lastRow),]
    fDayDataList[[item]] = theMinuteData
  }
  finishTime = Sys.time()
  cat(magenta("\n",format(Sys.time(), "%H:%M:%OS"),"\n"))
  cat(orange("\ncollect fDayData spent: "), trunc(as.numeric((finishTime - beginTime), units="secs")), orange("secs\n"))

   pageHeight = nrow(fDayDataList[[1]]) # this is the page height of the 3D list
    # to access the last row: fDayDataList[[1]][pageHeight,],  date, price, vol, Note: vol, not amt!

 # this list contain multiple address each with 64 codes or less
  theURLReqList = createURLLst(CodeTable)
 # init several tables
  todayHiLo <- matrix(,ncol=2, nrow=length(CodeTable)) # high, low
  colnames(todayHiLo) = c("high", "low")
  prvStatusTable <- matrix("",ncol=7, nrow=length(CodeTable))
  curStatusTable <- matrix("",ncol=7, nrow=length(CodeTable))

  prvWAveTable <- matrix(,ncol=5, nrow=0) # prvWAveTable is the previous table
  colnames(prvWAveTable) <- c('wAve_1','WAve_2','WAve_3','WAve_4','Price')
  pprvWAveTable = prvWAveTable # pprvWAveTable is one more previous
    # setup prvWAveTable
   for(page in 1:length(CodeTable)){
    lastRow = nrow(fDayDataList[[page]])
    prvWAveTable = rbind(prvWAveTable, calpageWAve(page, lastRow))
   }
  # setup pprvWAveTable
   for(page in 1:length(CodeTable)){
    lastRow = nrow(fDayDataList[[page]])-1 # to evaluate pprev values
    pprvWAveTable = rbind(pprvWAveTable, calpageWAve(page, lastRow))
   }

# this is the start up point
 source("C:/R programs/!!! STKMon !!!/create desktopFolder.R") # switch to new folder to record messages
 MonTrend()
