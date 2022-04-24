# divide group patterns
# amt ~ changes ~ price
# 7000w ,11
rm(list = ls())
  dirStr = "D:/yhzq/T0002/export/"
  setwd(dirStr)
 # rmItems(fmList, itemList) remove itemList from fmList
  rmItems <- function(fmList, itemList){
        commons = fmList[fmList %in% itemList]
        for(item in commons){fmList = fmList[-(which(fmList == item))]}
        return(fmList)
  }

dataList = readLines("a20201124.txt")
dataMatrix = matrix(unlist(strsplit(dataList, "\t")), ncol=12, byrow = TRUE)
dataMatrix = dataMatrix[,-(6:ncol(dataMatrix))]
changes = as.numeric(dataMatrix[,3])
amount = as.numeric(dataMatrix[,4])
price = as.numeric(dataMatrix[,5])
dataMatrix[,3] = as.numeric(dataMatrix[,3])
dataMatrix[,4] = as.numeric(dataMatrix[,4])
dataMatrix[,5] = as.numeric(dataMatrix[,5])

dataMatrixchanges = dataMatrix[order(as.numeric(dataMatrix[,3])),]
dataMatrixamount = dataMatrix[order(as.numeric(dataMatrix[,4])),]
dataMatrixprice = dataMatrix[order(as.numeric(dataMatrix[,5])),]

# filter criteria to remove amount range and price ranges
dataMatrixamountFiltered = dataMatrixamount[which(as.numeric(dataMatrixamount[,4])<7000),]
dataMatrixamountFiltered = dataMatrixamountFiltered[which(as.numeric(dataMatrixamountFiltered[,4])>200),]
cat(nrow(dataMatrixamountFiltered))
dataMatrixamountFiltered = dataMatrixamountFiltered[which(as.numeric(dataMatrixamountFiltered[,5])<11),]
dataMatrixamountFiltered = dataMatrixamountFiltered[which(as.numeric(dataMatrixamountFiltered[,5])>0.1),]
cat(nrow(dataMatrixamountFiltered))
cat(dataMatrixamountFiltered[,1]) # this is objTarget
objTarget = dataMatrixamountFiltered[,1]

# filter the nonObjTarget
nonObjTarget = dataMatrixamount[which(as.numeric(dataMatrixamount[,4])>200),]
nonObjTarget = nonObjTarget[,1]
nonObjTarget = rmItems(nonObjTarget, objTarget)
cat(nonObjTarget)
