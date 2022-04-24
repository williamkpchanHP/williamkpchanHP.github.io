# filter stock data using datatable
library(crayon)
library(data.table)
options(stringsAsFactors = FALSE)
options("encoding" = "UTF-8")
options(scipen=999)
options(max.print = .Machine$integer.max)

dirStr = "D:/yhzq/T0002/export"
setwd(dirStr)

# define functions
 # rmItems(fmList, itemList) remove itemList from fmList
  rmItems <- function(fmList, itemList){
		commons = fmList[fmList %in% itemList]
		for(item in commons){fmList = fmList[-(which(fmList == item))]}
		return(fmList)
 }

 # sortItems
  sortItems <- function(){
      cat("\n\n")

      inputCodeList = unlist(strsplit((readline(prompt="enter CodeList sep by space: ")), " "))
      subsetdata = dataCol[which(stkCode %in% inputCodeList)]

      outputName = "sortDtkDataResult.txt" 

      sink(outputName)
      setorder(subsetdata, -"amt", "U/D", "price")
      cat(red("\norder by amt\n"))
      print(subsetdata, n=nrow(subsetdata))

      setorder(subsetdata, -"U/D", -"amt", "price")
      cat(red("\norder by U/D\n"))
      print(subsetdata, n=nrow(subsetdata))

      setorder(subsetdata, "price", "U/D", -"amt")
      cat(red("\norder by price\n"))
      print(subsetdata, n=nrow(subsetdata))
      sink()
      shell(outputName)
      cat(yellow("Please read report: ", outputName))
  }

 # removeItems
  removeItems <- function(){
      cat("\n\n")
      originalList = unlist(strsplit(readline(prompt="enter SourceList, sep by space, :"), " "))
      cat("\n\n")
      removelist = unlist(strsplit(readline(prompt="enter RemoveList, sep by space, :"), " "))
      outputList = rmItems(originalList, removelist)

      outputName = "removeDataResult.txt" 

      sink(outputName)
      cat(outputList)
      sink()
      shell(outputName)
      cat(yellow("Please read removeDataResult report: ", outputName))
  }
# program entery

cat(pink(bold("\n\nThis is to filter the stock datafile to find data ranges.\nthe data file name begins with a21 and end with .txt\nto input the file name, just enter the date, eg. 0316\nit is possible apply for A stks, since the first 8 item types are same\nbut the amt unit is 1 w bigger in A stk\n\n")))
filddate = readline(prompt="enter datafile date, e.g. 0316 ")
datafildname = paste0("a21", filddate, ".txt")



isHKstk = readline(prompt="Is it HK stk? 0/1 ")
if (isHKstk=="1"){
  fileClasses = c(rep("character", 2),rep("numeric", 5), rep("character", 6))
}else{
  fileClasses = c(rep("character", 2),rep("numeric", 5), rep("character", 7))
}

datafile <- fread(datafildname, encoding="UTF-8", colClasses = fileClasses, stringsAsFactors = FALSE)

dataCol = datafile[,c(1,2,3,4,5)]

setnames(dataCol, c("V1","V2","V3","V4","V5"), c("stkCode", "chiName", "U/D","amt","price"))

looping = TRUE
while(looping){
    #chosenFile = unlist(strsplit((readline(prompt="enter stks chosen, sep by space, :")), " "))
    #subsetdata = subset(dataCol, dataCol[,1] %in% chosenFile)

   # findDataDetails    
    findDataDetails = "1"
    while(findDataDetails == "1"){
      cat("\n\n")
      findDataDetails = readline(prompt="To find code details? 0/1: ")
      if(findDataDetails == "1"){sortItems()}
    }

   # removeItem
    removeItemFlag = "1"
    while(removeItemFlag == "1"){
      cat("\n\n")
      removeItemFlag = readline(prompt="To remove items from list? 0/1: ")
      if(removeItemFlag == "1"){ removeItems()}
    }

    cat("\n\n")

    min_Amt = as.numeric(readline(prompt="enter minimum amt in w, e.g. 5000 :"))
    if(is.na(min_Amt)){min_Amt = 5000}

    max_Amt = as.numeric(readline(prompt="enter maximum amt in w, e.g. 10000000:"))
    if(is.na(max_Amt)){max_Amt = 10000000}

    cat(paste("\namt >", min_Amt, "w and < ", max_Amt,"w\n"))
    subsetdata = dataCol[which((amt>min_Amt)&(amt<max_Amt))]
    cat("\nTotal numbers: ", nrow(subsetdata))
    cat("\n")
    print(subsetdata)

    min_Price = as.numeric(readline(prompt="enter min price in, e.g. 0.5 :"))
    if(is.na(min_Price)){min_Price = 0.5}
    max_Price = as.numeric(readline(prompt="enter max price in, e.g. 2.8 :"))
    if(is.na(max_Price)){max_Price = 2.8}
    cat("\nmin price : ", min_Price, " max price : ", max_Price, "\n")

    max_Pricedata = subsetdata[which((price>min_Price)& (price<max_Price))]
    cat(red("\nTotal numbers: ", nrow(max_Pricedata), "\n"))
    print(max_Pricedata)
    # cat(red("\nList the top 30s\n"))
    # print(head(max_Pricedata,30))
    # cat(red("\nThe codes are: \n"))

    for(i in 1:nrow(max_Pricedata)){cat(as.character(max_Pricedata[i,1]), "")}
    cat(red("\nTotal numbers: ", nrow(max_Pricedata), "\n"))

    theNames = max_Pricedata[[2]]
    index = grep("ST", theNames)
    if(length(index)!=0){
      removeST = max_Pricedata[-index]
    } else {
      removeST = max_Pricedata
    }

    cat(blue("Removes the STs:\n"))
    for(i in 1:nrow(removeST)){cat(as.character(removeST[i,1]), "")}
    cat(red("\nTotal numbers: ", nrow(removeST), "\n"))

    cat(blue("Select Ups:\n"))
    removeST = removeST[which(removeST[,3]>0)]
    for(i in 1:nrow(removeST)){cat(as.character(removeST[i,1]), "")}
    cat(red("\nTotal numbers: ", nrow(removeST), "\n"))
    print(removeST)
}
