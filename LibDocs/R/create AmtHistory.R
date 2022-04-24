#create a history of all amt summary in database
# intensive mon, load history, monitor and append record, compare with history
# use thesteps, switch, if outstanding, give alarm
  library(jsonlite)
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

  # to confirm data ready
    Selection <- readline(prompt="Please confirm 11 recent data folders and historyList ready? 1/0  ")
    if(Selection == "0"){ break }

# support functions
 # reload, load all files into histList, a list object
    reload <- function(){
      folderName = "C:/Users/william/Desktop/Imp Mon Data"
      setwd(folderName)
    # load history list
      historyList <<- readLines("historyList.txt")
      histList <<- list()
      for(item in historyList){
        setwd(paste0(folderName,"/",item))
        alist = readLines("alarm history.txt")
        histList[[length(histList)+1]] <<- list(alist)
        setwd("..")
      }
    }


  # summariseReport()
    summariseReport <- function(reportLine){
      reportLine = gsub("( ..:)"," \\1",reportLine)
      reportLine = unlist(strsplit(reportLine,"  "))

      tempArray = matrix(, nrow = 0, ncol = 6)
      #cat("Time","\t\tsignal","\tprice","\tAmt ","\tDchg","\tMchg","\tpcDAmt\n")
      if(length(reportLine)>1){ # avoid empty activity record
        for(i in 2:length(reportLine)){
          tempstr = unlist(strsplit(reportLine[i]," "))
          tempstr = tempstr[-2]
          tempArray <- rbind(tempArray, tempstr)
        }
          tempArray <- unique(tempArray)
          amtSummary <<- c(amtSummary, tempArray[,3])
      }
    }

# program entry
    # init histList
    historyList = character()
    histList = list()
    reload()  # load histList
    sumReport = character()
    keywordList = unlist(histList)      
    keywordList = unique(gsub(" .*","",keywordList))

    cat(red("Total stkcodes: ",length(keywordList)," no. of history files:", length(historyList), "\n"))
    keyindex = 0
    for(key in keywordList){
      keyindex = keyindex + 1
      amtSummary = character()
      cat(keyindex, key, " ")
      for(i in 1:length(histList)){
        # find the code number
        cat(".")
        reportPage = unlist(histList[[i]])
        resultLines = grep(key, reportPage, ignore.case=TRUE)
        if(length(resultLines)!=0){
          summariseReport(reportPage[resultLines])
        }
      }
      amtSummary = c(key, amtSummary)
      sumReport = c(sumReport, paste(amtSummary, collapse=" "))
    }
sink("amtHistory.txt")
   cat(sumReport, sep="\n")
sink()
cat(red("\nJob complete!\n"))
