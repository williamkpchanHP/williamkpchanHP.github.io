# http://pinkfineart.com/anilos/page/2/ ~22

# FIrstly collect all the addr DB
# run a play file to read the DB and ask for input
# then read the addr and collect the page for analysis
# grep all the imgs and assemble the img html

askforsitename <-function(){
	Selection = readline(prompt = "Enter exact sitename: ")
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt = "enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

# = = = = = = = = = 
# entry point
thefileName = askforsitename()
if(thefileName = = ""){
	break
}

asknum = askforNum()
if(asknum ! = "")  {
	thenum = as.numeric(asknum)
}

# need to choose path later
setwd("C:/Users/user/mpg/Text/programs/ahref/")

pageHeader = paste0("http://pinkfineart.com/", sitename, "/page/")
pageHead = "thumbsContainer"
pageTail = "firstBtn"

AhrefHeader = paste0('<a href = "/anilos/')
imgTail = "/pthumbs/"
imgReplace = "/full/"

theWholeApage = matrix()
cat("\n", sitename, " totalpages: ", totalpages, "\n")

for (page in 1:totalpages){
  cat(" ", page)

  thepage = readLines(paste0(pageHeader,page))
  headlinenum = grep(pageHead, thepage) # chop head
  thepage = thepage[-(1:headlinenum)]

  taillinenum = grep(pageTail, thepage) # chop tail
  thepage = thepage[-(taillinenum:length(thepage))]

  Ahreflinenum = grep(AhrefHeader, thepage) # extract img
  thepage = thepage[Ahreflinenum]

  thepage = gsub(paste0(".*", sitename, "/|\" title.*"), "", thepage) #purify
  theWholeApage = rbind(theWholeApage, matrix(thepage, ncol = 1, byrow = T))
}
theWholeApage = theWholeApage[-1]
sink(paste0("Ahref-",sitename,".txt"))
cat(theWholeApage, sep = "\n")
sink()
cat("\nJob complete!\n")
# = = = = = = 
