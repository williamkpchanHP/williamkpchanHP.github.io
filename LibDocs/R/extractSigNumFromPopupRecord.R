# extract signals numbers from popupRecords 
# updnXAmt, tUPDNCnt, layerUpDn, cXWAvUpDn, WAve3x6_3v6, WAve3x6_

options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

cat("\n\n\nTo extract signals numbers from popupRecords!\n\n")
library(crayon)
dataFolder = "C:/Users/william/Desktop/Imp Mon Data"
setwd(dataFolder)
dataFileName = "popupRecords.html"
theFile = choose.files(dataFileName)

repeatLoop = ""
while(repeatLoop == ""){
    dataFile = readLines(theFile, encoding="utf-8")
    dataStrIdx = grep("updnXAmt", dataFile)
    dataStr = dataFile[dataStrIdx]

    updnXAmtStr = gsub('^.*?updnXAmt: ', '', dataStr)
    updnXAmtStr = gsub('  .*', '', updnXAmtStr)
    updnXAmtMat = matrix(unlist(strsplit(updnXAmtStr, " ")), ncol=2, byrow = TRUE)
    updnXAmtU = updnXAmtMat[,1]
    updnXAmtD = updnXAmtMat[,2]

    tUPDNCntStr = gsub('^.*?tUPDNCnt: ', '', dataStr)
    tUPDNCntStr = gsub('  .*', '', tUPDNCntStr)
    tUPDNCntMat = matrix(unlist(strsplit(tUPDNCntStr, " ")), ncol=2, byrow = TRUE)
    tUPDNCntU = tUPDNCntMat[,1]
    tUPDNCntD = tUPDNCntMat[,2]

    layerUpDnStr = gsub('^.*?layerUpDn: ', '', dataStr)
    layerUpDnStr = gsub('  .*', '', layerUpDnStr)
    layerUpDnMat = matrix(unlist(strsplit(layerUpDnStr, " ")), ncol=2, byrow = TRUE)
    layerUpDnU = layerUpDnMat[,1]
    layerUpDnD = layerUpDnMat[,2]

    cXWAvUpDnStr = gsub('^.*?cXWAvUpDn: ', '', dataStr)
    cXWAvUpDnStr = gsub('  .*', '', cXWAvUpDnStr)
    cXWAvUpDnMat = matrix(unlist(strsplit(cXWAvUpDnStr, " ")), ncol=2, byrow = TRUE)
    cXWAvUpDnU = cXWAvUpDnMat[,1]
    cXWAvUpDnD = cXWAvUpDnMat[,2]

    WAve3x6_3v6Str = gsub('^.*?WAve3x6 3v6: ', '', dataStr)
    WAve3x6_3v6Str = gsub('  .*', '', WAve3x6_3v6Str)
    WAve3x6_3v6Mat = matrix(unlist(strsplit(WAve3x6_3v6Str, " ")), ncol=2, byrow = TRUE)
    WAve3x6_3v6U = WAve3x6_3v6Mat[,1]
    WAve3x6_3v6D = WAve3x6_3v6Mat[,2]

    tooltipsarrIdx = grep("<span class='white'>", dataFile)
    tooltipsarrStr = dataFile[tooltipsarrIdx]
    tooltipsarr = gsub("<span class='white'>|</span>", "", tooltipsarrStr)
    tooltipsarr = paste0('"', tooltipsarr, '"')

    dataFolder = "C:/R programs/!!! STKMon !!!/resultTable"
    setwd(dataFolder)

    sink("multilinechart.js")
      strU = paste0(updnXAmtU, collapse=" ")
      strD = paste0(updnXAmtD, collapse=" ")
      str = paste0('updnXAmt = "', strU, ',', strD, '"\n')
      cat(str)

      strU = paste0(tUPDNCntU, collapse=" ")
      strD = paste0(tUPDNCntD, collapse=" ")
      str = paste0('tUPDNCnt = "', strU, ',', strD, '"\n')
      cat(str)

      strU = paste0(layerUpDnU, collapse=" ")
      strD = paste0(layerUpDnD, collapse=" ")
      str = paste0('layerUpDn = "', strU, ',', strD, '"\n')
      cat(str)

      strU = paste0(cXWAvUpDnU, collapse=" ")
      strD = paste0(cXWAvUpDnD, collapse=" ")
      str = paste0('cXWAvUpDn = "', strU, ',', strD, '"\n')
      cat(str)

      strU = paste0(WAve3x6_3v6U, collapse=" ")
      strD = paste0(WAve3x6_3v6D, collapse=" ")
      str = paste0('WAve3x6_3v6 = "', strU, ',', strD, '"\n')
      cat(str)

      cat("tooltipsarr=[")
      cat(tooltipsarr, sep=",")
      cat("]\n")
    sink()

    cat(format(Sys.time(), "%H:%M:%OS"),red("\nJob complete!\nmultilinechart.js saved, pls open multiLineWdiff.html\n"))
    shell("multiLineWdiff.html")
    #repeatLoop = readline(prompt=paste0(pink$bold$underline("press enter to repeat again or any character to exit: ")))
    repeatLoop = readline(prompt="press enter to repeat again or any character to exit: ")
}
