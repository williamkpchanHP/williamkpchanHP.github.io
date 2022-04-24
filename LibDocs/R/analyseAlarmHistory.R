# view alarm report history, check history performance
# 00700
#  15:25:18 cXWAvDn 506 7095 -0.3
#  15:25:18 cX8_3Dn 506 7095 -0.3
#  15:27:18 cX700Dn 506 8901 0
#  report viewer

rm(list = ls())
options("encoding" = "native.enc")

  dirStr = "D:/Dropbox/STK/!!! STKMon !!!"
  setwd(dirStr)
  source("FetchHKKline.R")

library(crayon)
  ligSilver <- make_style("#889988")
  lime <- make_style("#10ff10")
  purple <- make_style("#9400D3")
  deeppink <- make_style("#FF1493")
  darkgreen <- make_style("#004000")
  magenta  <- make_style("#800080")
  orange  <- make_style("#D93B6A")
  pink  <- make_style("#E98B8A") # note dont change this code
  brown  <- make_style("#B8937C")
  gray  <- make_style("#385E6D")
  blue  <- make_style("#12BBEC")
  gold <- make_style("#eeae00")

#support functions
 # splitLine
   splitLine <<-function(astr){ return(unlist(strsplit(astr, " "))) }
 # askForCode
   askForCode <- function(){
     Selection = ""
     while(Selection == ""){
       cat("\n")
       Selection <- readline(prompt="View History enter code: ")
       Selection <- gsub(" ","",Selection)

       if((Selection!="") & (Selection!=" ")){
           if(is.na(suppressWarnings(as.numeric(Selection)))){ # avoid mis typing or by special names
             if(Selection %in% signalList){ return(Selection) } # signalList is names of signals
             else{Selection == ""}
           } else{
             if(nchar(Selection)<5){
               Selection = paste0("00000",Selection)
               Selection = substr(Selection, nchar(Selection)-4, nchar(Selection))
             }
           }
           return(Selection)
       }
     }
  }
  # printReport()
    printReport <- function(reportLine){
      reportLine = gsub("( ..:)"," \\1",reportLine)
      reportLine = unlist(strsplit(reportLine,"  "))

      pointer = grep(reportLine[1], codenameTable[,1])
      reportLineName = codenameTable[pointer,2]

        if(htmlFlag){
          cat("\ncode number: ", "<span class='pink' onclick = \"xunbao('", reportLine[1], "')\">",reportLine[1]," ",reportLineName,"</span>","\n", sep="")
        }else{
          cat("\ncode number: ", pink(reportLine[1]),pink(reportLineName,"\n"))
        }
      #cat("Time    ","signal","price","Amt ","changes\n")
      cat("Time","\t\tsignal","\tprice","\tAmt ","\tDchg","\tMchg","\tpctAmt\n")
      #cat(reportLine, sep="\n")

      if(length(reportLine)>1){ # avoid empty activity record
        for(i in 2:length(reportLine)){
          tempstr = unlist(strsplit(reportLine[i]," "))
          cat(tempstr[1],"\t")
  
          if(grepl("Up|up", tempstr[2])){
            if(htmlFlag){
              cat(paste0("<span class='red'>",tempstr[2],"</span>"),"\t",sep="")
            }else{
              cat(red(tempstr[2]),"\t",sep="")
            }
          }else if(grepl("Dn|dn", tempstr[2])){
                  if(htmlFlag){
                    cat(paste0("<span class='green'>",tempstr[2],"</span>"),"\t",sep="")
                  }else{
                    cat(gray(tempstr[2]),"\t",sep="")
                  }
          }else if(grepl("Grad-", tempstr[2])){
                  if(htmlFlag){
                    cat(paste0("<i class='orange'>",tempstr[2],"</i>"),"\t",sep="")
                  }else{
                    cat(orange(tempstr[2]),"\t",sep="")
                  }
          }else if(grepl("activ", tempstr[2])){
                  if(htmlFlag){
                    cat(paste0("<i class='deeppink'>",tempstr[2],"</i>"),"\t",sep="")
                  }else{
                    cat(deeppink(tempstr[2]),"\t",sep="")
                  }
          }else if(grepl("gtpdAmt", tempstr[2])){
                  if(htmlFlag){
                    cat(paste0("<span class='yellow'>",tempstr[2],"</span>"),"\t",sep="")
                  }else{
                    cat(gold(tempstr[2]),"\t",sep="")
                  }
          }else {cat(tempstr[2],"\t",sep="")}
          cat(tempstr[3:length(tempstr)],sep="\t")
          cat("\n")
        }
      }else{
          cat("no activities\n")
      }
    }

  # printCodeNum()
    printCodeNum <- function(reportLine){
      lapply(reportLine, function(x){
        anumber = unlist(strsplit(x," "))[1]
        pointer = grep(anumber, codenameTable[,1])
        aname = codenameTable[pointer,2]
        cat(gray(anumber), pink(aname), "")
      } )
    }

  # displaySignal
    displaySignal <- function(reportLine){
      print(table(signal))
      cat("\n")
    }
  # displaySignal
    displayVigor <- function(reportLine){
      for(i in 1:15){
        cat(vigorTable[i,1],vigorTableHead[i], vigorTableHeadName[i],"\n")
      }
      cat("\n")
    }

  # reload, load all files into histList, a list object
    reload <- function(){
    # load history list
      historyList <<- readLines("historyList.txt")
      histList <<- list()
      for(item in historyList){
        setwd(paste0(folderName,"/",item))
        alist = readLines("alarm history.txt")
        histList[[length(histList)+1]] <<- list(alist)
        setwd("..")
      }
      # to confirm include desktop folder
        Selection <- readline(prompt="include desktop folder? 1/0  ")
          if(tolower(Selection) == "1") {
            Selection <- readline(prompt="desktop folder ID(date): ")
            desktopFolder <<- paste0("C:/Users/User/Desktop/Allcode",Selection)
            if(dir.exists(desktopFolder)){
              setwd(desktopFolder)
              alist = readLines("alarm history.txt")
              histList[[length(histList)+1]] <<- list(alist)

              historyList <<- c(historyList, paste0("Allcode",Selection,sep=""))
              setwd(folderName)
              desktopFolderFlag <<- TRUE
            }else{
              cat("\nfolder not exist and ignored!\n")
            }
          }
    }


  # reload DesktopList
    reloadDesktopList <- function(){
      setwd(desktopFolder)
      alist = readLines("alarm history.txt")
      setwd(folderName)
      histList[[length(histList)]] <<- list(alist)
    }

    saveReport <- function(){
      setwd("C:/Users/User/Desktop")  # goto desktop to avoid double quote path when using shell
      htmlFlag <<- TRUE
      options("encoding" = "UTF-8")
      options(scipen=999)
      unlink("insertContent.js")
      sink("insertContent.txt")
      cat("textContent = `<pre>") # start of text lines
      cat("<span class='orange'>Report Time</span>: <span class='red'>",format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"</span>\n")
      cat("<h2><span class='gold' onclick = \"xunbao('", keyword,"')\">",keyword,"  ",codenameTable[grep(keyword, codenameTable[,1]),2],"</span></h2>",sep="")

      if(length(amtSummary)>5){
         # remove the 4 outliers
          tempAmtSummary = amtSummary
          tempAmtSummary = tempAmtSummary[tempAmtSummary < max(tempAmtSummary)]
          tempAmtSummary = tempAmtSummary[tempAmtSummary < max(tempAmtSummary)]
          tempAmtSummary = tempAmtSummary[tempAmtSummary > min(tempAmtSummary)]
          tempAmtSummary = tempAmtSummary[tempAmtSummary > min(tempAmtSummary)]

          minAmtSummary = min(tempAmtSummary)
          maxAmtSummary = max(tempAmtSummary)
          minPcDAmtSummary = min(pcDAmtSummary)
          maxPcDAmtSummary = max(pcDAmtSummary)

         # the min and max includes the real min and max, steps not include
          cat("<span class='gold'>Day logs: </span>", length(histList)," ")
          cat("\n<span class='red'>amtSummary</span>", amtSummary)

          cat("\n<span class='gold'>amtSummary counts: </span>", length(amtSummary)," ")
          cat("<span class='gold'>last day activities: </span>", length(lastAmtSummary)," ")
          cat("<span class='gold'>min amtSummary: </span>", min(amtSummary)," ")
          cat("<span class='gold'>max amtSummary: </span>", max(amtSummary),"\n")
          thesteps = seq(minAmtSummary, maxAmtSummary, (maxAmtSummary - minAmtSummary)/10)
          thesteps[1] = min(amtSummary)
          thesteps[length(thesteps)] = max(amtSummary)
          cat("\n<span class='red'>cut bar steps</span>", thesteps,sep="  ")

          cutAmtSummary <- table(cut(amtSummary, breaks = thesteps, dig.lab = 6, include.lowest = TRUE, right = TRUE))
          cutPcDAmtSummary <- table(cut(pcDAmtSummary, breaks = seq(minPcDAmtSummary, maxPcDAmtSummary, (maxPcDAmtSummary - minPcDAmtSummary)/10), dig.lab = 6, include.lowest = TRUE, right = TRUE))

          newname = gsub(",","    \t",names(cutAmtSummary))
          cat("\n<div class='inline'><span class='gold'>amt Summary Table</span>\n")
          for(i in 1:length(cutAmtSummary)){
            cat(i,"\t",cutAmtSummary[i],"\t",newname[i],"\n")
          }
          cat("\n</div>")

          newPcDname = gsub(",","\t",names(cutPcDAmtSummary))
          cat("<div class='inline'><span class='gold'>pcDAmt Summary Table</span>\n")
          for(i in 1:length(cutPcDAmtSummary)){
            cat(cutPcDAmtSummary[i],"\t",newPcDname[i],"\n")
          }
          cat("\n</div>\n")

          for(i in 1:length(histList)){
            cat("\n<span class='idx'>",historyList[i],"</span> ")

            # print kline data
            datestr = gsub("Allcode","",historyList[i])
            cat(weekdays(as.Date(datestr, format="%y%m%d")), "\n")  # print weekday
            arrowPtr = grep(datestr, klines[,"Date"])
            cat(klines[arrowPtr,])
            cat("\n")
            # find the code number
            reportPage = unlist(histList[[i]])
            resultLines = grep(keyword, reportPage, ignore.case=TRUE)
            if(length(resultLines)==0){
              cat("No Records Matched!\n")
            } else {
              printReport(reportPage[resultLines])
            }
          }
      }else{cat("<span class='red'>No amt data!</span>")}

      htmlFlag <<- FALSE
      cat("`;\n") # end of text

      cat("`\n")
      cat("function chkKey() {")
      cat("  var testkey = getChar(event);")
      cat("  if(testkey == 's'){ xunbao('",keyword,"');}", sep="")
      cat("  else{chkOtherKeys(testkey);}")
      cat("}`")
      sink()

      file.copy("insertContent.txt", "insertContent.js")
      options("encoding" = "native.enc")
    }

  # summariseReport()
    summariseReport <- function(reportLine){
      reportLine = gsub("( ..:)"," \\1",reportLine)
      reportLine = unlist(strsplit(reportLine,"  "))

      tempArray = matrix(, nrow = 0, ncol = 6)
      #cat("Time","\t\tsignal","\tprice","\tAmt ","\tDchg","\tMchg","\tpctAmt\n")
      if(length(reportLine)>1){ # avoid empty activity record
        for(i in 2:length(reportLine)){
          tempstr = unlist(strsplit(reportLine[i]," "))
          tempstr = tempstr[-2]
          tempArray <- rbind(tempArray, tempstr)
        }
          tempArray <- unique(tempArray)

          amtSummary <<- c(amtSummary, tempArray[,3])
          pcDAmtSummary <<- c(pcDAmtSummary, tempArray[,6])
      }
      return(tempArray[,3]) # return the last day amt 
    }

# program entry
  # load codenameTable
    codenameTable = readLines("codenameTable.txt", encoding="UTF-8", warn = FALSE)
    codenameTable = matrix(unlist(strsplit(codenameTable, split = "\\t")), ncol=2, byrow=TRUE)

   # init histList
    desktopFolder = character()
    folderName = "C:/Users/User/Desktop/Imp Mon Data/"
    setwd(folderName)

    historyList = character()
    histList = list()

    cat(gold("\nfind all Grad-w and ppct"))

  # looping = TRUE  # want to find all code this time
    allCode = readLines("amtHistory.txt")
    allCode = gsub(" .*", "", allCode) # clean up

    historyList = readLines("historyList.txt")
    lastDayRecordLoc = historyList[length(historyList)]
    alarmhistory = readLines(paste0(folderName, lastDayRecordLoc, "/alarm history.txt"))

      setwd("C:/Users/User/Desktop")  # goto desktop to avoid double quote path when using shell
      sink("result.txt")

    for(i in allCode){
      cat("\n")
      keyword = i

      # loop all the lists to give results
          printReport(reportPage[resultLines])
    }
    sink()
