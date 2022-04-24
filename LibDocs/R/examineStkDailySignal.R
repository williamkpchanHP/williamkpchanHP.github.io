# to compare signals in 2 concsecutive days 

cat("\n\n\nTo examine single stock daily signals!\n\n")
library(crayon)
dataFolder = "C:/R programs/!!! STKMon !!!/resultTable"
setwd(dataFolder)
dataFileName = "filterResulitLib.txt"
dataFile = readLines(dataFileName)
dateStrIdx = grep("red blink", dataFile)
dateStr = dataFile[dateStrIdx]

dateStr = gsub('^.*?blink">', '', dateStr)
dateStr = gsub(' </span.*', '', dateStr)

fraudStkFolder = "C:/R programs/!!! STKMon !!!"
setwd(fraudStkFolder)
fraudSTK = readLines("fraudSTK.txt")

DesktopFolder = "C:/Users/william/Desktop/"
setwd(DesktopFolder)
resultfolder = "Inspection Results"
if(!dir.exists(resultfolder)){dir.create(resultfolder)}
setwd(resultfolder)

# rmItems(fmList, itemList) remove itemList from fmList
  rmItems <- function(fmList, itemList){
        commons = unique(fmList[fmList %in% itemList])
        for(item in commons){fmList = fmList[-(which(fmList == item))]}
        return(fmList)
  }

countFreq <-function(allStks, GroupStr, Freq){
  countResult = vector()
  for(i in allStks){
    count = grep(i, GroupStr)
    if(length(count)>= Freq){ countResult = c(countResult, i) }
  }
  return(countResult)
}

stkcode = "00338"
while(stkcode != ""){
  stkcode = as.numeric(readline(prompt="enter stkcode: "))
          if(nchar(stkcode)<5){
            stkcode = paste0("0000",stkcode)
            stkcode = substr(stkcode, nchar(stkcode)-4, nchar(stkcode))
          }

  dayNumbers = readline(prompt="Examine how many days? press enter for 10 days.")
  if(dayNumbers == ""){dayNumbers = 10}
  dayNumbers = as.numeric(dayNumbers)

  dateStrTemp = rev(tail(dateStr, dayNumbers+1))

  stkcodeStr = paste0("<k>", stkcode, "</k>")
  outBuffer = c("<b>stkcode</b>", stkcodeStr,"\n")

  for(examDate in dateStrTemp){
    cat(".")
    examDateIdx = grep(examDate, dateStrTemp)  # find out the dates first
    examDataIdx = grep(examDate, dataFile) # find out data
    examData = dataFile[examDataIdx]   # extracted the strings for inspection

    stkDataIdx = grep(stkcode, examData)
    stkDataStr = examData[stkDataIdx]
    stkDataStr = gsub('^.*<h2>','', stkDataStr)
    stkDataStr = gsub("</h2>.*",'', stkDataStr)
    stkDataStr = gsub("<img.*?goingUp.*?>",'<span class="cyan">goingUp</span>', stkDataStr)
    stkDataStr = gsub("<img.*?fire.*?>",'fire', stkDataStr)
    stkDataStr = gsub("<br>",'', stkDataStr)
    stkDataStr = gsub(examDate,'', stkDataStr)

    outBuffer = c(outBuffer, "\n",examDate, " <span class='navy1'>number of signals</span>:", length(stkDataStr), "\n", stkDataStr, "\n")
  }


  # display result
  outputName = paste0("singleStkDailySignals", stkcode,".html")

  htmlHeader = '<base target="_blank"><html><head><title>singleStkDailySignals</title>\n<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1"/>\n<link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css">\n<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n<script src="https://williamkpchan.github.io/lazyload.min.js"></script>\n<script src="https://williamkpchan.github.io/mainscript.js"></script>\n<script src="https://williamkpchan.github.io/commonfunctions.js"></script>\n<script src="https://d3js.org/d3.v4.min.js"></script>\n<style>\nbody{width:90%;margin-left: 5%; font-size:18px;}\nh1, h2 {color: gold;}\nstrong {color: orange;}\npre{width:100%;}\n#toc{color:cyan; font-size:20px;}\nimg {max-width:90%; display: inline-block; margin-top: 2%;margin-bottom: 1%; border-radius:3px; background-color:#044;}\n.k{color:red;}</style></head><body onkeypress="chkKey()" onload="docLoaded()"><center>\n<h2>daily signal analysis</h2>\n<pre>\n'
  htmlTail = '<script src="https://williamkpchan.github.io/LibDocs/readbook.js"></script>\n<script>var lazyLoadInstance = new LazyLoad({ elements_selector: ".lazy"});function changeCode(thecode) {\nurl = "https://williamkpchan.github.io/LibDocs/Random Charts.html" + "?" + thecode;\nwindow.open(url);}\n$("k").click(function() { changeCode($(this).text()) });\n</script>'

  sink(outputName)
  cat(htmlHeader)
  cat(outBuffer)
  cat(htmlTail)
  sink()
  shell(outputName)
}
