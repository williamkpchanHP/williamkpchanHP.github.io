# ask for the PinkFineArt Photo Galleries name
# also the number of pages of the Gallery
# then collect all pages
# then collect every images inside each link in the Gallery
# then clean up the list and save as the .txt with Photo Galleries name

Sys.setlocale(category = "LC_ALL", locale = "chs")

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects/pinkfineart"
setwd(dirStr)

linkAdrkey = '<a class="card-link'

theWholePage = character(0)
theWholeAddrList = character(0)
theWholeImgList = character(0)

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="\nenter key words: ")
	if(Selection != "")   {
	  	Selection = gsub(" ", "+", Selection)
  	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

boilPages <- function(searchKey){
  cat("\nReading pages to collect links... ")
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
  cat("\nReading links to collect images ... ")
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
    removestr = paste0("/galleries/" , thekeyword, "/")
    theAddrList = gsub(removestr, "", theAddrList)  
    theWholeImgList <<- c(theWholeImgList, theAddrList)
  }

  sink(paste0(thekeyword,".txt"))
  cat(theWholeImgList, append=TRUE, sep="\n")
  sink()
}

# =========
# entry point
thekeyword = askforKey()
endPageNum = as.numeric(askforNum())
urlHead = paste0("https://www.pinkfineart.com/",thekeyword, "/page/")
cat("\napproximate ", endPageNum*50, " pages, expected ", endPageNum*50*16, " images!\n")
boilPages()

