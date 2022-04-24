options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')    # this must be added to script to show chinese

library(crayon)
longLine = " "
while(longLine != "."){
  cat(blue("\n\nEnter sample line: "))
  longLine = readline()
  if((longLine == "as.raw(27)") | (longLine  ==  ".")) {
    cat(yellow("\n\nScript Ended!\n\n"))
    break
  }

  WordTable = unlist(strsplit(longLine, "\t"))

  cat("\n\n\n",cyan(99999), " Question:  ", "\tWhat is:\t")
  cat(yellow(unlist(strsplit(WordTable[1], "`"))), sep = "\n    ")

  cat("\n\n\n",blue(1), ": ")
  cat(cyan(unlist(strsplit(WordTable[2], "`"))), sep = "\n    ")
}
