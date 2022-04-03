# olderwomanfun channels 2919 videos, 72 pages, 41 per page
# found 47, 6 extra unrelated
# https://www.porn.com/channels/channel69pass?p=35
# <div class="thumb">
# https://www.porn.com/channels/oldnanny
# <nav class="pager

# open dest URL and got download address
# https://www.porn.com/videos/mia-khalifa-first-porn-audition-for-bangbros-mk13786-3691099
# href="/download/240/3691099.mp4">MP4 240p
# 720p

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"

setwd(dirStr)

cutter1 = 'thumb-list videos'
cutter2 = 'icon-chevron-left'

pageHead = 'https://www.porn.com/videos/big-tits?p='
seekkey1 = 'div class="item rollable'
seekkey2 = '<div class="thumb">'

startNum = 2563
endNum = 2770
filename = paste0("pornComBigTits", startNum,".html")
theWholePage = character(0)

	for(i in startNum:endNum){
		cat(i,". ")
		thepage = readLines(paste0(pageHead, i))
		thepage = thepage[1]	# note must use line 1 only, diff from ^u
		thepage = unlist(strsplit(thepage, cutter1))	#chop and unlist
		thepage = thepage[2]	# use line 2 only
		thepage = unlist(strsplit(thepage, cutter2))
		thepage = thepage[1]	# discard the tail

		thepage = unlist(strsplit(thepage, seekkey1))
		thepage = thepage[grep(seekkey2, thepage)]

		thepage = gsub('<h3>.*' , '', thepage)  
		thepage = gsub("\'" , '', thepage)  
		thepage = gsub('.*<a href="' , '\'<a href="https://www.porn.com', thepage)  
		thepage = gsub(" alt.*" , "></a>'\\,", thepage)  

		theWholePage = c(theWholePage, thepage)
	}


	sink(filename)
	cat(theWholePage, sep="\n")
	sink()


# https://www.porn.com/videos/mature?p=494
# 20220/41 = 494
