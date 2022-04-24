options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')    # this must be added to script to show chinese
 AChoice = "C:/R programs/Learning Exercise/QuizData/"
 setwd(AChoice)
 theWholeFile = readLines("EnglishWordList.txt", encoding="UTF-8", warn = FALSE)

 toBreakList = as.numeric()
 for(i in 1:length(theWholeFile)){
   temp = unlist(strsplit(theWholeFile[i], "\t"))
   if(nchar(temp[1]) > 203){
    toBreakList = c(toBreakList, i)
   }
}

 sink("toBreakList.txt")
 cat(toBreakList, sep = "\n")
 sink()
 cat("Job accomplish! out file is toBreakList.txt\n")
