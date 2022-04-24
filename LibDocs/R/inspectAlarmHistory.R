#inspect alarm history

library(crayon)
DesktopFolder = "C:/Users/william/Desktop/"
setwd(DesktopFolder)
cat(red("\n\nTo inspect alarm history!\n"))
cat(yellow("\nplease select file for inspection!\n\n"))

      htmlHeader = '<base target="_blank"><html><head><title>Inspection Report</title>\n<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1"/>\n<link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css">\n<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n<script src="https://williamkpchan.github.io/lazyload.min.js"></script>\n<script src="https://williamkpchan.github.io/mainscript.js"></script>\n<script src="https://williamkpchan.github.io/commonfunctions.js"></script>\n<script src="https://d3js.org/d3.v4.min.js"></script>\n<style>\nbody{width:90%;margin-left: 5%; font-size:18px;}\nh1, h2 {color: gold;}\nstrong {color: orange;}\npre{width:100%;}\n#toc{color:cyan; font-size:20px;}\nimg {max-width:90%; display: inline-block; margin-top: 2%;margin-bottom: 1%; border-radius:3px; background-color:#044;}\n.k{color:green;}\n</style></head><body onkeypress="chkKey()"><center>\n<h1>Inspection Report</h1>\n<pre>\n'
      htmlTail = '\nlayerDn layerUp Grad-w! Grad-ww ExtImpPct VlAmt ExtImp gtpdAmt tUP tDN DnTrig UpTrig cXmW1Up cXmW3Up cXmW1Dn cXmW3Dn cX_1Up cX_2Up cX_3Up cX_4Up cX_1Dn cX_2Dn cX_3Dn cX_4Dn upXAmt dnXAmt XmW3Up XmW3Dn cXWAvDn cXWAvUp ativUp4 ativDn4 ativUp5 ativDn5 ativUp6 ativDn6 WAve3x6 WAve3v6\n<script src="https://williamkpchan.github.io/LibDocs/readbook.js"></script>\n<script>var lazyLoadInstance = new LazyLoad({ elements_selector: ".lazy"});\nfunction changeCode(thecode) {url = "https://williamkpchan.github.io/LibDocs/Random Charts.html" + "?" + thecode;window.open(url);}\n$("k").click(function() { changeCode($(this).text()) });\nfunction chkKey() {\n var testkey = getChar(event);\n if(testkey == "\'"){window.open("https://williamkpchan.github.io/LibDocs/swipeChart.html");}\n if(testkey == ";"){window.open("https://williamkpchan.github.io/LibDocs/minuteLayersAcc.html");}\n if(testkey == "X"){window.open("https://williamkpchan.github.io/LibDocs/Random Charts.html");}\n if(testkey == "i"){window.open("https://williamkpchan.github.io/LibDocs/InspectChart.html");}\n if(testkey == "s"){$("k").click();}\n}\nfunction getChar(event) {\n if (event.which!=0 && event.charCode!=0) {\n   return String.fromCharCode(event.which)\n } else {\n   return null\n }\n}\n</script>'
      outputName = paste0("InspectAlarmHistory.html")

    theFileName = choose.files("alarm history.txt")
    cat(theFileName, "\n")
  
    setwd("C:/Users/william/Desktop")
    newfolder = "Inspection Results"
    if(!dir.exists(newfolder)){dir.create(newfolder)}
    setwd(newfolder)

    askForCode <-function(){
        codeNum = readline(prompt="enter 5 digits stock code(eg.00700): ")
        if(is.na(suppressWarnings(as.numeric(theCode)))){
          return(codeNum)
        }
        else if(nchar(codeNum)<5){
          codeNum = paste0("0000",codeNum)
          codeNum = substr(codeNum, nchar(codeNum)-4, nchar(codeNum))
        }
        return(codeNum)
    }

    # look for code
    lookForCode <-function(){
      cat("lookForCode: ", theCode)
      theLineIdx = grep(theCode, theFile)
      theLine = theFile[theLineIdx]
      # split by time stamp
      theDetail = gsub("( \\d\\d:)", "\n\\1", theLine)
      theDetail = gsub("(^\\d{5})", "<k class='brown'>\\1</k>", theDetail)

        allSignals = unlist(strsplit(theLine, "( \\d\\d:\\d\\d:\\d\\d)"))
        allSignals = allSignals[-1]
        allSignals = gsub("^ ", "", allSignals)
        allSignals = gsub(" .*", "", allSignals)

        allsignalCat = unique(allSignals)
        signalCount = length(allSignals)
        signalFreq = sort(table(allSignals), decreasing = TRUE)

      # display result
      sink(outputName)
        cat(htmlHeader)
        cat("\n",theFileName)
        cat("\n<span class='pink'>theDetails </span>",theDetail, sep="\n")
        cat("\n<span class='green'>signal types:\n</span>", allsignalCat)
        cat("\n<span class='green'>signal type counts:\n</span>", length(allsignalCat))

        cat("\n\n<span class='orange'>Total signal counts:\n</span>", signalCount)

        outTable = capture.output(print(signalFreq))
        cat("\n\n<span class='smallsize tomato'>", outTable, "</span>",sep="\n")
        cat(htmlTail)
      sink()
    }

    # locate signal
    locateSignal <-function(key){
        theLineIdx = grep(key, theFile)
        theLine = theFile[theLineIdx]
        theDetail = gsub(" .*", "", theLine)
        return(theDetail)
    }

    # look for signal
    lookForsignal <-function(){
      keys = unlist(strsplit(theCode, " "))
      allTheDetail = locateSignal(keys[1])
      cat(" firstNum:", length(allTheDetail))

      for(i in keys){
        cat("\n", i)
        newlist = locateSignal(i)
        cat(" listLen ",length(newlist), "\n")
        allTheDetail = intersect(allTheDetail, newlist)
        cat(" common:", length(allTheDetail))
      }

      DetailLength = length(allTheDetail)

      allTheDetail = gsub("(^\\d{5})", "<k class='pink'>\\1</k>", allTheDetail)
      # display result
      sink(outputName)
        cat(htmlHeader)
        cat("\n",theFileName)
        cat("\n<span class='pink'>the keys: </span>", keys, sep=" ")
        cat("\n<span class='pink'>Total: </span>", DetailLength, sep="\n")
        cat("\n<span class='pink'>theDetails\n</span>", allTheDetail, sep=" ")
        cat(htmlTail)
      sink()
    }

    lookForTimeStamp <-function(){
      cat("lookForTimeStamp: ", theCode, "\n")
      keys = unlist(strsplit(theCode, " "))
      # clean text before timestamp
      theDetail = gsub(paste0(" ",".*?",keys[1]), paste0(" ",keys[1]), theFile)
      theLineIdx = grep(paste0(keys[1],":.. ", keys[2]), theDetail)
      theDetail = theDetail[theLineIdx]
      theDetail = gsub(" .*", "", theDetail)
      DetailLength = length(theDetail)

      theDetail = gsub("(^\\d{5})", "<k class='pink'>\\1</k>", theDetail)
      # display result
      sink(outputName)
        cat(htmlHeader)
        cat("\n",theFileName)
        cat("\n<span class='pink'>the keys: </span>", keys, sep=" ")
        cat("\n<span class='pink'>Total: </span>", DetailLength, sep="\n")
        cat("\n<span class='pink'>theDetails\n</span>", theDetail, sep=" ")
        cat(htmlTail)
      sink()
    }

  theCode = "."
  while(theCode != ""){
    theCode = askForCode()
    if(theCode  ==  "as.raw(27)" | theCode  ==  "0000") {
      cat("Break!\n")
      sink()
      break
    }

    theFile = readLines(theFileName) # renew data file

    if(is.na(suppressWarnings(as.numeric(theCode)))){
      if(length(grep(":",theCode))>0){
        lookForTimeStamp()
      }else{
        lookForsignal()
      }
    }else{
      lookForCode()
    }
    shell(outputName)
  }
