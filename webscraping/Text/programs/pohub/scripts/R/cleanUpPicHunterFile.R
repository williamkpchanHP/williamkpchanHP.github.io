# to find out the duplicated entries in js object
library(crayon)
options("encoding" = "native.enc")
#Sys.setlocale(category = 'LC_ALL', 'Chinese')
fileName = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/pichunterList.html"
AllItems = readLines(fileName)
#AllItems = gsub(' n=".*href',' href',AllItems)
#AllItems = gsub('#\\d{1,}','',AllItems)
AllItems = gsub('<a.*src=','',AllItems)
AllItems = gsub('></a>',',',AllItems)

sink(fileName)
 cat(AllItems, sep="\n")
sink()
cat(red("\nCompleted"))


