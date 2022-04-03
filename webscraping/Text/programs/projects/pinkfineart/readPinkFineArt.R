# ask for the PinkFineArt Photo Galleries name
# also the number of pages of the Gallery
# then collect all pages
# then collect every images inside each link in the Gallery
# then clean up the list and save as the .txt with Photo Galleries name

Sys.setlocale(category = "LC_ALL", locale = "chs")

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects/pinkfineart"
setwd(dirStr)

theWholePage = character(0)
theWholeAddrList = character(0)
theWholeImgList = character(0)

urlAddr = readline(prompt="enter URL address: ")
  cat("\nReading links to collect images ... ")
    thepage = readLines(urlAddr)
    linenum = grep('<img class="card-img-top', thepage)
    theAddrList = thepage[linenum]

    theAddrList = gsub(' alt.*>' , '', theAddrList) # chop tail first
    theAddrList = gsub('class="card-img-top" ' , '', theAddrList)  
    theAddrList = gsub('pthumbs' , 'full', theAddrList)  
    theAddrList = gsub('<img', '<img', theAddrList)  
    theAddrList = gsub('jpg"', 'jpg"><br>', theAddrList)  

  sink("temp.html")
  cat('<base href="https://www.pinkfineart.com/"><link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css"><style>img { width: 90%; border-radius:5px; display: block; margin-left: auto; margin-right: auto;}</style>')
  cat(theAddrList, sep="<br>\n")
  sink()
  startstr="start launcher.exe --start-maximized %U \""
  shell(paste0(startstr, dirStr,"/temp.html\""))


#opera 


