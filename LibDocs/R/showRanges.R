options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')    # this must be added to script to show chinese
library(crayon)

 AChoice = "C:/R programs/Learning Exercise/QuizData/"
 setwd(AChoice)

 filename = "EnglishWordList.txt"
 scoreFilename = "EnglishWordListScore.txt"

 words = readLines(filename, encoding="UTF-8", warn = FALSE)
 scores = readLines(scoreFilename)
 score2 = grep("^2$",scores)

 startLine = "."
 cat("\nmin line num ", score2[1], ", max line num ", score2[length(score2)], "\n\n")
 while(startLine != ""){
   startLine = readline(prompt="To show data ranges, enter range start number: ")
   if(startLine == ""){cat(red("Job Finished!\n"));break}
   startLineNum = as.numeric(startLine)
   startLineNumReal = score2[ which(score2<=startLineNum) ]
   startPointer = length(startLineNumReal)
   startLineNumReal = startLineNumReal[startPointer]
   endLineNum = startPointer + 5
   endLineNumReal = score2[endLineNum]
   cat(yellow("range start number: ", startLineNumReal, ", range end number: ", endLineNumReal, "\n\n"))

   for(i in startPointer:endLineNum){
      WordTable = unlist(strsplit(words[i], "\t"))

      cat("\n",cyan(score2[i]), " Question:  ", "\tWhat is:\t")
      cat(yellow(unlist(strsplit(WordTable[1], "`"))), sep = "\n    ")

      cat(blue(" ",score2[i]), ": ")
      cat(cyan(unlist(strsplit(WordTable[2], "`"))), sep = "\n    ")
   }
   cat("\n")
 }
