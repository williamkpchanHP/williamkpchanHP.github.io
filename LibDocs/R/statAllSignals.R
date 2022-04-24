# stat on all signals, find which are 3x6 etc,
# need to span multiple alarmlist to inspect multiple daily activities

library(crayon)
DesktopFolder = "C:/Users/william/Desktop/"
setwd(DesktopFolder)
cat(red("\n\nTo inspect alarm history!\n"))

AllCodedirList = "C:/Users/william/Desktop/Imp Mon Data/AllCodedirList.txt"
MonDataDir = "C:/Users/william/Desktop/Imp Mon Data/"

AllCodedir = readLines(AllCodedirList)
wholeRecord = character()

  for(Codedir in AllCodedir){

    theFileName = paste0(MonDataDir, Codedir, "/alarm history.txt")
    cat(theFileName, "\n")
    theFile = readLines(theFileName)

    # statistics on all signals
    allSignals = character()
    for(theLine in theFile){
      # split by time stamp
      signalDetail = unlist(strsplit(theLine, "( \\d\\d:\\d\\d:\\d\\d)"))
      signalDetail = signalDetail[-1]
      signalDetail = gsub("^ ", "", signalDetail)
      signalDetail = gsub(" .*", "", signalDetail)
      allSignals = c(allSignals, signalDetail)
    }

    allsignalCat = unique(allSignals)
    allsignalCounts = length(allsignalCat)

    signalCount = length(allSignals)

    signalFreq = sort(table(allSignals), decreasing = TRUE)
    signalFreqNames = names(signalFreq)

    tUPIndex = which(signalFreqNames == "tUP")
    tDNIndex = which(signalFreqNames == "tDN")
    tUPtDNRatio = round((signalFreq[tUPIndex] / signalFreq[tDNIndex]), 2)

    UpTrigIndex = which(signalFreqNames == "UpTrig")
    DnTrigIndex = which(signalFreqNames == "DnTrig")
    UpTrigDnTrigRatio = round((signalFreq[UpTrigIndex] / signalFreq[DnTrigIndex]), 2)

    upXAmtIndex = which(signalFreqNames == "upXAmt")
    dnXAmtIndex = which(signalFreqNames == "dnXAmt")
    upXAmtdnXAmtRatio = round((signalFreq[upXAmtIndex] / signalFreq[dnXAmtIndex]), 2)

    # wholeRecord = c(wholeRecord, "\n<span class='green'>signal types:\n</span>", allsignalCat)
    wholeRecord = c(wholeRecord, "<h2>", Codedir, "</h2>")
    wholeRecord = c(wholeRecord, "<span class='green'>signal type counts: </span>", length(allsignalCat))
    wholeRecord = c(wholeRecord, "<span class='orange'>Total signal counts: </span>", signalCount)
    wholeRecord = c(wholeRecord, paste("<span class='brown'>tUPtDNRatio:", tUPtDNRatio, "</span>"))
    wholeRecord = c(wholeRecord, paste("<span class='brown'>UpTrigDnTrigRatio:", UpTrigDnTrigRatio, "</span>"))
    wholeRecord = c(wholeRecord, paste("<span class='brown'>upXAmtdnXAmtRatio:", upXAmtdnXAmtRatio, "</span>"))

      outTable = capture.output(print(signalFreq))
    wholeRecord = c(wholeRecord, "\n<span class='smallsize tomato'>", outTable, "</span>",sep="\n")
  }

    # display result
    outputName = paste0("AlarmHistoryStat.html")
    htmlHeader = '<base target="_blank"><html><head><title>Inspection Report</title>\n<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1"/>\n<link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css">\n<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n<script src="https://williamkpchan.github.io/lazyload.min.js"></script>\n<script src="https://williamkpchan.github.io/mainscript.js"></script>\n<script src="https://williamkpchan.github.io/commonfunctions.js"></script>\n<script src="https://d3js.org/d3.v4.min.js"></script>\n<style>\nbody{width:90%;margin-left: 5%; font-size:18px;}\nh1, h2 {color: gold;}\nstrong {color: orange;}\npre{width:100%;}\n#toc{color:cyan; font-size:20px;}\nimg {max-width:90%; display: inline-block; margin-top: 2%;margin-bottom: 1%; border-radius:3px; background-color:#044;}\n</style></head><body onkeypress="chkKey()"><center>\n<h1>Inspection Report</h1>\n<div id="toc"></div><br><pre>\n'
    htmlTail = '<script src="https://williamkpchan.github.io/LibDocs/readbook.js"></script>\n<script>var lazyLoadInstance = new LazyLoad({ elements_selector: ".lazy"});</script>'
    sink(outputName)
      cat(htmlHeader)
      cat(wholeRecord, sep="\n")
      cat(htmlTail)
    sink()
    shell(outputName)
