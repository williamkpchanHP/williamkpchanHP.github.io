# to collect other pinkfinart pages, change allAlbumHeader and output
setwd("C:/Users/william/Desktop/scripts/R")
library(rvest)
library(crayon)

# note must end with /
allAlbumHeader = "https://www.pinkfineart.com/atk-archives/"
# output file name
output = "pinkAtk-archives.html"

uniqueFlag = FALSE
Selection = readline(prompt=("require to check unique photos? 1/0 "))
if(Selection == "1"){uniqueFlag = TRUE}

cat(green("\n\nStart time:",format(Sys.time(), "%H:%M:%OS"), "\n"))
now_time <- unclass(as.POSIXlt(Sys.time()))
startTime <- now_time[3]$hour*60 + now_time[2]$min
source("retrievePinkFile.R") # the workhorse here

allAlbumList = character()
allLinkList = character()
allPhotoList = character()


collectLinks(allAlbumHeader) # many page links in this user
albumIndex = 0
for(thelink in allLinkList){
   albumIndex = albumIndex + 1
   cat(blue("\ncollect album page URL: ", albumIndex, "of", length(allLinkList)))
   collectAlbums(thelink)
} # get all albums links
# the albums links are incomplete
allAlbumList = paste0("https://www.pinkfineart.com", allAlbumList)

#allPageHeader = allAlbumList
allLinkList = character() # reset allLinkList

collectImgs(allAlbumList) # collect images
allPhotoList = paste0('<img class="lazy" data-src="https://www.pinkfineart.com/', allPhotoList)
allPhotoList = paste0(allPhotoList, '">')


sink(output)
  cat('<base target="_blank"><html><head><title>pinkPhoto</title>\n')
  cat('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n')
  cat('<meta name="viewport" content="width=device-width, initial-scale=1" />\n')
  cat('<link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css">\n')
  cat('<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n')
  cat('<script src="https://williamkpchan.github.io/lazyload.min.js"></script>\n')
  cat('<script type="text/javascript" src="https://williamkpchan.github.io/mainscript.js"></script>\n')
  cat('<script src="D:/Dropbox/Public/commonfunctions.js"></script>\n')
  cat('<script src="https://d3js.org/d3.v4.min.js"></script>\n')
  cat('<script>\n')
  cat('  var showTopicNumber = true;\n')
  cat('  var bookid = "pinkPhoto"\n')
  cat('  var markerName = "img"\n')
  cat('</script>\n')
  cat('<style>\n')
  cat('body{width:100%;margin-left: 0%; font-size:22px;}\n')
  cat('h1, h2 {color: gold;}\n')
  cat('strong {color: orange;}\n')
  cat('pre{width:100%;}\n')
  cat('</style></head><body onkeypress="chkKey()"><center>\n')
  cat('<div id="toc"></div>\n')
  cat('<pre>\n')
  cat(allPhotoList, sep="\n")
  cat('<script src="https://williamkpchan.github.io/LibDocs/readbook.js"></script>\n')
  cat('<script>var lazyLoadInstance = new LazyLoad({ elements_selector: ".lazy" }); </script>\n')
  cat('</pre></body></html>\n')
sink()
cat(red("Job completed!\n"))

cat(green("end time:",format(Sys.time(), "%H:%M:%OS"), "\n"))
now_time <- unclass(as.POSIXlt(Sys.time()))
endTime <- now_time[3]$hour*60 + now_time[2]$min
timdDiff = endTime - startTime
cat(yellow("time lapse:",timdDiff, "minutes\n"))
