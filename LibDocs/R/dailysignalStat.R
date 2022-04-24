# statistics on daily signals
options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

library('plyr')
library(crayon)

 # commonCode extracts those commons from two lists
  commonCode <-function(List1, List12){ return(List1[List1 %in% List12]) }
  # intersect(intersect(a,b),c)
  # Reduce(intersect, list(a,b,c))

setwd("C:/R programs/!!! STKMon !!!/resultTable")

# load traindata
theFile = readLines("stkUpTrainData.txt", encoding="UTF-8")
codeIdx = grep("^0\\d{4}$", theFile)
theCodes = theFile[codeIdx]
codeEndIdx = codeIdx[-1] -1
codeEndIdx = c(codeEndIdx, length(theFile))

# define heed signals
allSignals = character()
symtomList = c("3X6", "cXWA", "upXWA", "upXWA10", "upXWA20", "upFLSZ", "cXWAnFL")

# stat signals on train data
cat(red("\nTotal stk codes in train data: ", length(codeIdx)))
cat(cyan("\n\nstkUpTrainData.txt qualified in symtomList:\n"))
for(i in 1:length(codeIdx)){
  signals = theFile[(codeIdx[i]+1): codeEndIdx[i]]
  signals = gsub("^.* ", "", signals)

  if(all(symtomList %in% signals)){
    cat(theCodes[i], " ")
  }

  allSignals = c(allSignals, signals)
}
cat("\n\nexamine allSignals\n")
print(sort(table(allSignals), decreasing = TRUE))
cat("\n")
freqList = sort(table(allSignals), decreasing = TRUE)
cat(red("\nsignal types: ",length(freqList), "\n\n"))
count(freqList)

# examine all data
filterLib = readLines("filterResulitLib.txt", encoding="UTF-8", warn=FALSE)

signalIdx = character()
while(length(signalIdx) == 0){
  SelectDate = readline(prompt=paste0(pink$bold$underline("enter stk date(eg. 220304): ")))
  signalIdx = grep(SelectDate, filterLib)
}

signalTable = filterLib[signalIdx]
signalTable = gsub(paste0(SelectDate, " </span>"), paste0(SelectDate, " blink"), signalTable)
signalTable = gsub('<img src="./img/goingUp.gif" style="max-width:20px; margin-top:-6px;">', 'upimg', signalTable)
signalTable = gsub('<img src="./img/fire.gif" style="max-width:20px; margin-top:-6px;">', 'heatimg', signalTable)
signalTable = gsub("'<h2>", "", signalTable)
signalTable = gsub("<i.*?>|<u.*?>|<span.*?>|</i>|</u>|</span>|<br>|',", "", signalTable)
signalTable = unlist(strsplit(signalTable, "</h2>"))
oddIdx<-seq(1,length(signalTable),2)
evenIdx<-seq(2,length(signalTable),2)
signalName = signalTable[oddIdx]
stksignal = signalTable[evenIdx]
allstks = unique(unlist(strsplit(stksignal, " ")))

# filter qualified stks
# Reduce(grep, list(a,b,c))
target = c(4, 5, 6, 7, 10, 14, 16)
cat(yellow("\nFound qualified on ", SelectDate, "\n"))
for( i in allstks){
  includeCount = 0
  for( j in target){
    if(length(grep(i, stksignal[j])) == 0){
       break
    }else{
       includeCount = includeCount +1
    }
  }
  if(includeCount == 5){ cat(i, "")}
}

# stat on all signals on that data
signalName = gsub("^.*? ","",signalName)
signalCounts = vector()
for(i in 1:length(stksignal)){
  signalLength = length(unlist(strsplit(stksignal[i], " ")))
  signalCounts = c(signalCounts, signalLength)
}
signalMat = matrix(signalCounts, ncol=1)
rownames(signalMat) = signalName

cat(cyan("\n\ndaily signal stat on ", SelectDate, "\n"))
print(signalMat[order(signalMat, decreasing = TRUE),])
cat(red("\nsignal types: ",nrow(signalMat), "\n\n"))

cat(red("\n Completed!\n"))
