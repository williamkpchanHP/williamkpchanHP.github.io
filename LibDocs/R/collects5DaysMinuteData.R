  fDayHead <- "http://web.ifzq.gtimg.cn/appstock/app/day/query?_var=fdminData&code=hk"

  source("retrieveData.R")
  source("calcWAve.R")

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
   fData = matrix(unlist(strsplit(fData, " ")), ncol=3,byrow=TRUE) # this is the resulting array
   fData[which(fData[,1]=="1600"),3] = "0" # set the last minute vol to zero
   return(fData) # the above data conversion complete, oldest data sit at top, newest at bottom, date, price, vol
  }

 # ArrLst rearranges the input array
  ArrLst <- function(dataLst){      
    dataLst = unlist(dataLst)
    if (dataLst[length(dataLst)]==""){dataLst = dataLst[-length(dataLst)]}
    dataLst = unlist(dataLst)
    return(dataLst)
  }
