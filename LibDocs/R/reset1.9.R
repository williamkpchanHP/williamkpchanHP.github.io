# to reset all 1.9 items and then set new leading waiting 1.9 items
# init environment
 curDir = getwd()

 tempStr = "C:/R programs/Learning Exercise/QuizData/"
 setwd(tempStr)

 # theScoreTable is the result score table in learning English.R
 thetable = readLines(theScoreTable)
 thetableLength = length(thetable)

 # locate the 1.9s and set to 1
 toReset = grep("1.9", thetable)
 cat(yellow("\nTotal number of 1.9s: "), length(toReset))
 cat(cyan("\nThe positions of 1.9s are: "), toReset)
 thetable[toReset] = 1

 # locate all 1s and set leading portion 1.9
 toSet = grep("^1$", thetable)
 setNum = 1
 setNum = as.numeric(readline(prompt="Enter the base buffer size: "))
 if(is.na(setNum)){setNum = length(toReset)}
 cat("\nlength of all 1: ", length(toSet), "\n")
 cat(red("length of 1.9 to be resetted to 1: "), length(toReset))

 if(length(toSet) < setNum){setNum = toSet}

 toSet = toSet[1:setNum]
 thetable[toSet] = 1.9

# show the final result
 cat("\nnew length 1.9: ", length(toSet))
 cat("\nNow positions of 1.9s are:\n", toSet)

 toSet = grep("^1$", thetable)
 cat("\nlength of all 1: ", length(toSet), "\n")

# backup original file
 file.rename(theScoreTable, paste0(format(Sys.Date(), format="%m%d")," ",format(Sys.time(), "%H%M")," ",theScoreTable))

# write to file
 sink(theScoreTable)
 cat(thetable, sep = "\n")
 sink()

 cat("\nbackup EnglishWordListScore.txt complete.\n")

setwd(curDir)
