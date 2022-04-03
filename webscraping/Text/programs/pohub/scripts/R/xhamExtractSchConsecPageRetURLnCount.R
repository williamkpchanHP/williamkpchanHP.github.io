# given search gallery TOC in consecutive nos, extract gallery pageURLs and counts
 # 'pageURL', "editURL

 # grep <a class="gallery-thumb__link thumb-image-container" href=
 # remove >
 # grep <span class="gallery-thumb-info__quantity"><i class="xh-icon photo-camera white"></i>
 # remove </span>

 # same in output file

# init
 dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
 setwd(dirStr)

 seekkey1 = '<a class="gallery-thumb__link thumb-image-container" href='
 seekkey2 = '<span class="gallery-thumb-info__quantity"><i class="xh-icon photo-camera white"></i>'

 thefileName = "ladySonia"

 urlHead = "https://xhamster.com/search/photos?q=lady+sonia&p="
 lentheList = 11

 theExtractURL = ""
 thePagePhotoNoList = ""
# collectPages()
 collectPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	linenum = grep(seekkey1, thepage)
	theURLpage = thepage[linenum]
	theURLpage = gsub(seekkey1 , '', theURLpage) 
	theURLpage = gsub('\">.*' , '', theURLpage) 
	theURLpage = gsub(".*http" , 'http', theURLpage) 

	numline = grep(seekkey2, thepage)
	theNOpage = thepage[numline]
	theNOpage = gsub('.*<span' , '<span', theNOpage) 
	theNOpage = gsub(seekkey2 , '', theNOpage) 
	theNOpage = gsub("</span.*" , '', theNOpage) 

	return(list(theURLpage,theNOpage))
 }

# loop all
 for(i in 1:lentheList){
	cat(i, " ")
	theURL = paste0(urlHead, i)
	resultList = collectPages(theURL)

	theExtractURL = c(theExtractURL, unlist(resultList[1]))
	thePagePhotoNoList = c(thePagePhotoNoList, unlist(resultList[2]))
 }
# give output
 sink(paste0(thefileName,".txt"))
 cat(theExtractURL, sep="\n")
 cat(thePagePhotoNoList, sep="\n")
 sink()
