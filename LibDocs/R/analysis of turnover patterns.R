# analysis of turnover patterns
#          amt, changes, price
# amt             X        X
# changes X                X
# price   X       X
# amt ~ changes plot chart

library(crayon)
rm(list = ls())
  dirStr = "D:/yhzq/T0002/export/"
  setwd(dirStr)
dataList = readLines("a20201124.txt")
dataList = dataList[-1]
dataList = dataList[-(781:length(dataList))]
dataMatrix = matrix(unlist(strsplit(dataList, "\t")), ncol=12, byrow = TRUE)
dataMatrix = dataMatrix[,-(6:ncol(dataMatrix))]
changes = as.numeric(dataMatrix[,3])
amount = as.numeric(dataMatrix[,4])
price = as.numeric(dataMatrix[,5])
plot(changes, amount)


par("mar")
To change that write:

par(mar=c(1,1,1,1))
max(changes)
max(amount)

cat(changes)
cat(amount)
cat(price)
