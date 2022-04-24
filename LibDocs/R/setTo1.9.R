# init environment
 curDir = getwd()

# check current theQuestionTable is "EnglishWordList.txt"
 if(theQuestionTable != "EnglishWordList.txt"){
  cat(red("\theQuestionTable incorrect, not EnglishWordList.txt\n"))
  break
 }

 tempStr = "C:/R programs/Learning Exercise/QuizData/"
 setwd(tempStr)
 statusList = 'EnglishWordListScore.txt'
 thetable = readLines(statusList)
 thetableLength = length(thetable)

 linenumFile = 'linenum.txt'
 thelinenum = as.numeric(readLines(linenumFile))
 if(any(is.na(thelinenum))){
   cat(red("invalid line numbers in linenum.txt!\n"))
   break
 }

 thelinenum =  thelinenum[!is.na(thelinenum)]  # remove invalid numbers, this line will not run

 if(length(thelinenum)<=0){
   cat("empty list!");
   break
 }

 if( max(thelinenum, na.rm=TRUE) > thetableLength){
   cat("line number exceeds score list max length: ", max(thelinenum), "\n");
   break
 }

# if(length(thelinenum)>11){
#   theFirstTen = thelinenum[1:10]
#   thelinenum = thelinenum[-(1:10)]
# }else{
#   theFirstTen = thelinenum
#   thelinenum = ""
# }

# theFirstTen = theFirstTen[theFirstTen != ""] # remove empty lines


# looping
cat("resets line numbers: ")
 for(lineNo in 1: length(thelinenum)){
     cat(lineNo,".")
     if(suppressWarnings(!is.na(as.numeric(thelinenum[lineNo])))){  # ensure no alphabets
       thePtr = as.integer(thelinenum[lineNo])
       thetable[thePtr] = '1.9'
     }
 }
# backup original file
 file.rename(statusList, paste0(format(Sys.Date(), format="%m%d")," ",format(Sys.time(), "%H%M")," ",statusList))
 file.rename(linenumFile, paste0(format(Sys.Date(), format="%m%d")," ",format(Sys.time(), "%H%M")," ",linenumFile))

# write to file
 sink(statusList)
 cat(thetable, sep = "\n")
 sink()

 cat("\nbackup EnglishWordListScore.txt complete.\n")

# cleanup linenum file
  sink(linenumFile)
   #cat(thelinenum, sep = "\n")
   cat("")
  sink()
  cat("\ncleanup linenum.txt complete.\n")

setwd(curDir)
