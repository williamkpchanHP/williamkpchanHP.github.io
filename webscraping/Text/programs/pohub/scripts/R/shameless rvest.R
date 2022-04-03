# try using rvest to scrape shameless
dirStr = "C:/Users/user/mpg/Text/programs/"
setwd(dirStr)
library(rvest)

thesiteword = "shameless"
urlHead = "https://www.shameless.com/categories/"
thekeyword = "pussy"
thenum = 21
theWholePage = character(0)

	for(i in 1:thenum){
		cat(i,". ")
		pageHeader = paste0(urlHead,thekeyword,"/", i, "/")
		pagesource <- retrieveFile(pageHeader)
		className = "#icnt"
		keywordList <- html_nodes(pagesource, className)
		content = as.character(keywordList)
		theWholePage = c(theWholePage, content)
	}
	sink(paste0(thesiteword," ",thekeyword,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()

startstr="start launcher.exe --start-fullscreen \""
# note to quote the long filename
# note not to use single quote '
shell(paste0(startstr, dirStr, paste0(thesiteword," ",thekeyword,".html\"")))


