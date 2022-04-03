#http://www.postyourflasher.com/naked-nude-public/albums/userpics/thumb_IMGS_132.jpg
#http://www.postyourflasher.com/naked-nude-public/albums/userpics/IMGS_132.jpg
#albums/userpics/thumb
#<img src="albums/userpics/thumb_23899.jpg" class="image thumbnail" 

dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts"
setwd(dirStr)

urlHead = 'http://www.postyourflasher.com/naked-nude-public/thumbnails-37-page-'
urlTail = '.html'
firstPage = 1
lastPage = 77
	pattern = 'albums/userpics/thumb'

thekeyword = 'postyourflasher'
makeaddr <- function(pageNum){
	theURL = paste0(urlHead, pageNum, urlTail)
}

theWholePage = character(0)

for(i in 1:lastPage){
	cat(i,". ")
	thepage = readLines(makeaddr(i))
	thelines = grep(pattern, thepage)
	thepage = thepage[thelines]
	thepage = gsub('.*<img src=' , '<img src=', thepage) 
	thepage = gsub(' class="image.*' , '>', thepage) 
	thepage = gsub('thumb_' , '', thepage) 

	theWholePage = c(theWholePage, thepage)
}

sink(paste0(thekeyword,".html"))
	cat("<base target=_blank>\n<base href='http://www.postyourflasher.com/naked-nude-public/'\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none; color: #28B8B8;}a:visited { color: #389898;}A:hover { color: yellow;}A:focus { color: red;}</style>\n")
	cat(theWholePage, sep="\n")
sink()

startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0(thekeyword,".html\"")))
