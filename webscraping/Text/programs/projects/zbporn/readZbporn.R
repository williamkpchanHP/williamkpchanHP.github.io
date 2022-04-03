# ask for the PinkFineArt Photo Galleries name
# also the number of pages of the Gallery
# then collect all pages
# then collect every images inside each link in the Gallery
# then clean up the list and save as the .txt with Photo Galleries name

Sys.setlocale(category = "LC_ALL", locale = "chs")

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects/zbporn"
setwd(dirStr)

theWholePage = character(0)
theWholeAddrList = character(0)
theWholeImgList = character(0)
className = ".fotorama a"

library(rvest)

cat("https://zbporn.com/albums/categories/tits/\n")

urlAddr = readline(prompt="enter URL address: ")
  cat("\nReading links to collect images ... ")
  thepage <- read_html(urlAddr)
  keywordList <- html_nodes(thepage, className)

  sink("temp.html")
  cat('<base href="https://www.pinkfineart.com/"><link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css"><style>img { width: 90%; border-radius:5px; display: block; margin-left: auto; margin-right: auto;}</style>')
  cat(paste0('<img src="',html_attr(keywordList, "href"),'">'), sep="<br>\n")
  cat("<br><a href='https://zbporn.com/albums/'>albums</a>\n")

  sink()
  startstr="start launcher.exe --start-maximized %U \""
  shell(paste0(startstr, dirStr,"/temp.html\""))

