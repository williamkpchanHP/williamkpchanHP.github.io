dataFolder = "C:/Users/william/Desktop/Imp Mon Data/Allcode220422"
setwd(dataFolder)
dataFileName = "alarm history.txt"
dataFileName1 = "alarm history1.txt"

dataFile = readLines(dataFileName, encoding="utf-8")
dataFile1 = readLines(dataFileName1, encoding="utf-8")

dataFile = gsub("^\\d{5}", "", dataFile)
dataFile = paste0(dataFile1, dataFile)

    sink(dataFileName)
      cat(dataFile, sep="\n")
    sink()
