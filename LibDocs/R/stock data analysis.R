# stock data analysis
# clean memory
  rm(list = ls())

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

 # format3digit
  format3digit  = function(value){ sprintf(value, fmt = '%#.3f')}

  Sys.setlocale(category = 'LC_ALL', 'Chinese')

  dirStr = "D:/yhzq/T0002/export/"
  setwd(dirStr)
    cat(pink("To analyse relationship between different set of trade data!\n"))
    #cat(green("enter data source filename from yhzq/T0002/export: "))
    #stkDataFile = readLine(prompt="enter txt filename without extension: ")
    #stkDataFile = paste0(stkDataFile, ".txt")
    stkDataFile = "20210203.txt"
    stkData = readLines(stkDataFile, warn = FALSE)
    stkData = matrix(unlist(strsplit(stkData,"\t")),ncol=12,byrow=TRUE)
    # stkcode, chiname, ud%, amt, curprice, high, low, prevPrice, open
    # eg. from classified list, "important" data
sourceData = c(
"6 :  00144 00322 00388 00425 00586 00665 00696 00754 00763 00867 01428 01658 01776 01788 01789 02238 02828 03606 03998",
"5 :  00291 00576 00656 00950 00960 01548 01753 01907 01958 02329 02607 02820 03320 03718 06158",
"4 :  00011 00027 00069 00135 00148 00175 00178 00220 00257 00267 00327 00347 00357 00358 00386 00467 00489 00558 00604 00669 00716 00822 00839 00914 00916 00939 00968 00992 01072 01138 01171 01288 01313 01585 01608 01798 01812 01813 01988 02039 02048 02128 02202 02208 02338 02388 02399 02601 02669 02688 02727 03319 03339 03396 03888 03968 06030 06098 06169 06185 06818 06836 06837 06862 09926 09999 00460 00658 00806 00853 00855 00945 01252 01755 01773 01811 01888 01995 02001 02362 02804 02883 03175 03323 03993 09074",
"3 :  0030 00083 00122 00152 00168 00270 00303 00323 00338 00371 00460 00743 00811 00832 00855 00856 00880 00884 01257 01308 01381 01508 01513 01638 01691 01811 01817 01821 01876 01877 01929 01981 01997 02018 02186 02233 02314 02318 02331 02666 02798 02799 02800 02804 02812 02826 03126 03301 03738 03808 03899 06060 06826 06869 08487 09074 00069 00175 00220 00257 00347 00357 00489 00819 00914 01072 01171 01359 01812 01836 02333 02359 02388 02601 02611 02688 02845 02866 02888 03718 03800 03868 06862 08275 09845 83188"
)

 # analyseData
  analyseData = function(){
    #targetCodes = "00700 00981 01810 00883 03690 00388 01211 02333 00175 01299 01888 06186 06969 00853 01918 02013 02020 00241 00291 02357 00016 00968 01347 01772 03800 00489 03888 06030 00881 03993 09999 00288 00763 00305 01833 02238 06865 00285 03606 09922 00916 02331 01585 01919 01913 01999 09923 00708 09926 01268 02400 03319 06823 06060 01316 01308 02500 00520 02883 03868 00570 01099 01821 02338 03669 01108 03808 00522 06088 00826 01114 02186 03738 03883 01137 00884 01813 00564 00636 00392 00302 09969 01882 00777 01907 02616 01199 00460 03983 01675 09911 08083 00818 06690 01611 01209 06618"
    #targetCodes <- readline(prompt="enter targetCodes separated by space: ")
    targetCodes = unlist(strsplit(targetCodes, " "))
    theDiffList = vector()
    for(acode in targetCodes){
      #cat(acode, " ")
      marker = grep(acode, stkData[,1])
      if(length(marker)==1){
        # stkcode, chiname, ud%, amt, curprice, high, low, prevPrice, open
        highPrice = as.numeric(stkData[marker,6])
        openPrice = as.numeric(stkData[marker,9])
        closePrice = as.numeric(stkData[marker,5])
        #theDIff = format3digit((closePrice - openPrice)*100 / openPrice)
        theDIff = (closePrice - openPrice)*100 / openPrice
        theDiffList = c(theDiffList, theDIff)
        #cat(theDIff, "\n")
      }else {
        cat(acode, "no data\n")
        theDiffList = c(theDiffList, 0)
      }
    }
    theDiffArrar = cbind(targetCodes, theDiffList)
    theUp = theDiffArrar[which(as.numeric(theDiffArrar[,2])>0),]
    theDn = theDiffArrar[which(as.numeric(theDiffArrar[,2])<0),]
    nochange = theDiffArrar[which(as.numeric(theDiffArrar[,2])==0),]
    cat(blue("total ", nrow(theDiffArrar),"theUp",nrow(theUp), "theDn", nrow(theDn), "no change", nrow(nochange),"\n"))
  }

 targetCodes = vector() # init vector

 # loop thru all lines
  for(lines in sourceData){
   lineName = gsub(" : .*", "", lines)
   cat(lineName, "\n")
   lineData = gsub("^.*> :  ", "", lines)
   lineData = unlist(strsplit(lineData, " "))
   lineDataMarker = grep("\\d{5}", lineData)
   targetCodes = lineData[lineDataMarker]
   analyseData() # analyse and print result
  }

