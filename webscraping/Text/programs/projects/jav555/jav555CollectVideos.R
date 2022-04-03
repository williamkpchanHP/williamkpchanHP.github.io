# ask for the PinkFineArt Photo Galleries name
# also the number of pages of the Gallery
# then collect all pages
# then collect every images inside each link in the Gallery
# then clean up the list and save as the .txt with Photo Galleries name

Sys.setlocale(category = "LC_ALL", locale = "chs")

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects/jav555"
setwd(dirStr)

theWholePage = character(0)
theWholeAddrList = character(0)
theWholeImgList = character(0)
classNamea = "div.ml-item a href"
classNamei = "div.ml-item img"

library(rvest)

cat("https://jav555.me/studio/1pondo/page-1\n")
urlHeader = "https://jav555.me/studio/1pondo/page-"

for(page in 1:19){ # page 1 - 19
  urlAddr = paste0(urlHeader, page)
  thepage <- read_html(urlAddr)
  keywordLista <- html_nodes(thepage, classNamea)
  keywordListi <- html_nodes(thepage, classNamei)
not complete!
}

  sink("temp.html")
  cat('<base href="http://www.pinksmilfs.com"><link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css"><style>img { width: 90%; border-radius:5px; display: block; margin-left: auto; margin-right: auto;}</style>')

  cat(gsub("pthumbs", "full", paste0('<img src="',html_attr(keywordList, "src"),'">')), sep="<br>\n")
  cat("<br><a href='http://www.pinksmilfs.com/'>pinksmilfs</a>\n") # add a link to visit

  sink()
  startstr="start launcher.exe --start-maximized %U \""
  shell(paste0(startstr, dirStr,"/temp.html\""))

