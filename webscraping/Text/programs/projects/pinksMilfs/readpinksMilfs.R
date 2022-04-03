# ask for the PinkFineArt Photo Galleries name
# also the number of pages of the Gallery
# then collect all pages
# then collect every images inside each link in the Gallery
# then clean up the list and save as the .txt with Photo Galleries name

Sys.setlocale(category = "LC_ALL", locale = "chs")

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects/pinksMilfs"
setwd(dirStr)

theWholePage = character(0)
theWholeAddrList = character(0)
theWholeImgList = character(0)
className = "div.thumbBlock img"

library(rvest)

cat("http://www.pinksmilfs.com/karups-ow/\n")

urlAddr = readline(prompt="enter URL address: ")
  cat("\nReading links to collect images ... ")
  thepage <- read_html(urlAddr)
  keywordList <- html_nodes(thepage, className)

  sink("temp.html")
  cat('<base href="http://www.pinksmilfs.com"><link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css"><style>img { width: 90%; border-radius:5px; display: block; margin-left: auto; margin-right: auto;}</style>')

  cat(gsub("pthumbs", "full", paste0('<img src="',html_attr(keywordList, "src"),'">')), sep="<br>\n")
  cat("<br><a href='http://www.pinksmilfs.com/'>pinksmilfs</a>\n") # add a link to visit

  sink()
  startstr="start launcher.exe --start-maximized %U \""
  shell(paste0(startstr, dirStr,"/temp.html\""))

