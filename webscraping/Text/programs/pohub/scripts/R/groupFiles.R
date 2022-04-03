# group files
# read list of files and sava all in one file, delete the list of files
library(crayon)

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/")
wholeList = character()
newName = "playwithpussy.html"

fileList = c(
"pohub pierced+pussy.html",
"pohub play+with+pussy P 1.html",
"pohub play+with+pussy P 10.html",
"pohub play+with+pussy P 11.html",
"pohub play+with+pussy P 12.html",
"pohub play+with+pussy P 13.html",
"pohub play+with+pussy P 14.html",
"pohub play+with+pussy P 15.html",
"pohub play+with+pussy P 16.html",
"pohub play+with+pussy P 17.html",
"pohub play+with+pussy P 18.html",
"pohub play+with+pussy P 19.html",
"pohub play+with+pussy P 2.html",
"pohub play+with+pussy P 20.html",
"pohub play+with+pussy P 21.html",
"pohub play+with+pussy P 22.html",
"pohub play+with+pussy P 23.html",
"pohub play+with+pussy P 24.html",
"pohub play+with+pussy P 25.html",
"pohub play+with+pussy P 26.html",
"pohub play+with+pussy P 27.html",
"pohub play+with+pussy P 3.html",
"pohub play+with+pussy P 4.html",
"pohub play+with+pussy P 5.html",
"pohub play+with+pussy P 6.html",
"pohub play+with+pussy P 7.html",
"pohub play+with+pussy P 8.html",
"pohub play+with+pussy P 9.html"
)

for(i in 1:length(fileList)){
  cat(fileList[i],"  ")
  tempfile = readLines(fileList[i])
  wholeList = c(wholeList, tempfile)
}
cat(red("\nwholeList name: "),newName,"\n")
sink(newName)
cat(wholeList, sep="\n")
sink()
# to confirm continue
  Selection <- readline(prompt="continue to delect old files? 1/0  ")
	if(tolower(Selection) != "1") {
		cat("\n", "Process Ended") 
		stop()
	}

  Selection <- readline(prompt="repeat again to delect old files? 1/0  ")
    if(tolower(Selection) != "1") {
      cat("\n", "Process Ended") 
      stop()
    }

for(i in 1:length(fileList)){
  unlink(fileList[i])
}
      cat("\n", red("Process Ended: "), newName) 
