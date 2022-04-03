# this is ok in user, but not in search in pages
# process lists of lists
# given many gallery list urls, extract gallery pageURLs and photo numbers 
# in every url addr
 # 'pageURL', "editURL

 # to extract gallery images, grep the only line 'window.initials'
 # break at 'imageURL'
 # grep the only useful
 # cut height afterwards
 # add '
 # same in output file
 #163 sets, 30 set per page = 6 pages
# init
 dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
 setwd(dirStr)

 seekkey = 'window.initials'
 chopkey = 'pageURL'

 thefileName = "prussss"

 urlHead = "https://xhamster.com/users/"
 theList = c('prussss/photos','prussss/photos/2','prussss/photos/3','prussss/photos/4','prussss/photos/5')
 lentheList = length(theList)

 theExtractURL = ""
 thePagePhotoNoList = ""
# collectPages()
 collectPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	linenum = grep(seekkey, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, chopkey))
	thepage = thepage[-1]
	return(thepage)
 }
# extractURL
 extractURL <- function(thepage){
	thepage = gsub('.*pageURL":' , '', thepage) 
	thepage = gsub(',"editURL.*' , '', thepage) 
	thepage = gsub('[\\]' , '', thepage) 

	return(thepage)
 }
# extractCntNo
 extractCntNo <- function(thepage){
	thepage = gsub('.*"quantity":' , '', thepage) 
	thepage = gsub(',"views".*' , '', thepage) 
	return(thepage)
 }

# loop all
 for(i in 1:lentheList){
	cat(i, " ")
	theURL = paste0(urlHead, theList[i])
	thepage = collectPages(theURL)

	# note that the first line contain the "quantity" parameter but without URL
	# the structure is "quantity" comes first and URL comes later
	linenum = grep("retired", thepage)
	theURLpage = thepage[-linenum]

	theExtractURL = c(theExtractURL, extractURL(theURLpage))
	thepage = thepage[-length(thepage)]

	thePagePhotoNoList = c(thePagePhotoNoList, extractCntNo(thepage))
 }
# send to clipboard
 writeClipboard(thePagePhotoNoList)
 cat("data sent to clipboard!\n")

# give output
 sink(paste0(thefileName,".txt"))
 cat(theExtractURL, sep="\n")
 cat(thePagePhotoNoList, sep="\n")
 sink()
