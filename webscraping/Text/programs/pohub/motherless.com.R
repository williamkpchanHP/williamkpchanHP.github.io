# https://motherless.com/porn/lingerie/videos
# https://motherless.com/porn/lingerie/videos?page=949
# 
# seekkey = 'div class="thumb video medium'
# 60 keys per page
# 
# link	+1
# link	+3
# 
# https://motherless.com/FF91124
# https://cdn4.videos.motherlessmedia.com/videos/FF91124.mp4

# startNum = 1
# endNum = 949

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub"

setwd(dirStr)

pageHead = 'https://motherless.com/porn/lingerie/videos?page='
seekkey = 'div class="thumb video medium'

startNum = 1
endNum = 494
filename = paste0("motherlesslingerie", startNum, ".html")
theWholePage = character(0)

for(i in startNum:endNum){
	cat(i,". ")
	thepage = readLines(paste0(pageHead, i))
	linnum = grep(seekkey, thepage)
	thepage = thepage[sort(c((linnum+1),(linnum+3)))]

	thepage = gsub('.*motherless.com' , '\'<a href=\"https://cdn4.videos.motherlessmedia.com/videos', thepage)
	thepage = gsub(" class=\"img-container.*" , ".mp4\">", thepage)  

	thepage = gsub('.*img class=\"static\"' , '<img', thepage)  
	thepage = gsub("-small.*" , ".jpg\">\\',", thepage)  

	linnum1 = grep("a href", thepage)
	linnum2 = grep("<img", thepage)
	thenewpage = paste0(thepage[linnum1],thepage[linnum2])
	theWholePage = c(theWholePage, thenewpage)
}


sink(filename)
cat(theWholePage, sep="\n")
sink()


# https://www.porn.com/videos/big-tits?p=2813
# 115333/2813 = 41
# 130648/41 = 3187
# https://www.porn.com/videos/mature?p=494
# 20220/41 = 494
