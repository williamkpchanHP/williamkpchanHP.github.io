Sys.setlocale(category = "LC_ALL", locale = "chs")
thekeyword = "istripper"

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects/pinkfineart"
setwd(dirStr)

linkAdrkey = '<a class="card-link'
urlHead="https://www.pinkfineart.com/istripper/page/"
endPageNum = 41

theWholePage = character(0)
theWholeAddrList = character(0)
theWholeImgList = character(0)
boilPages <- function(searchKey){
  for(i in 1:endPageNum){
      cat(i," ")
#      if(i%%100 == 0){cat("\n")}
    theAddr = paste0(urlHead,i)
    thepage = readLines(theAddr)
    linenum = grep(linkAdrkey, thepage)
    theAddrList = thepage[linenum]

    theAddrList = gsub('" title=".*>' , '', theAddrList) # chop tail first
    theAddrList = gsub('.*href="' , '', theAddrList)  

    theWholeAddrList <<- c(theWholeAddrList, theAddrList)
  }
  for(i in 1:length(theWholeAddrList)){
    cat(i," ")
    theAddr = paste0("https://www.pinkfineart.com",theWholeAddrList[i])
    thepage = readLines(theAddr)
    linenum = grep('<img class="card-img-top', thepage)
    theAddrList = thepage[linenum]

    theAddrList = gsub(' alt.*>' , '', theAddrList) # chop tail first
    theAddrList = gsub('class="card-img-top" ' , '', theAddrList)  
    theAddrList = gsub('pthumbs' , 'full', theAddrList)  
    theAddrList = gsub('<img', '\'<img', theAddrList)  
    theAddrList = gsub('jpg"', 'jpg">\',', theAddrList)  
    theWholeImgList <<- c(theWholeImgList, theAddrList)
  }

  sink(paste0(thekeyword,".txt"))
  cat(theWholeImgList, append=TRUE, sep="\n")
  sink()
}


# =========
# entry point
boilPages()



