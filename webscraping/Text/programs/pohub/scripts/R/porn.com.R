# https://www.porn.com/videos/search?q=hookup+hotshot&p=15
# https://www.porn.com/videos/pussy-spreading?p=1085
# startNum = 532
# endNum = 600 completed

# thumb-list videos
# icon-chevron-left

# <div class="thumb">

# a href
# alt="
# https://www.porn.com/

# open dest URL and got download address
# https://www.porn.com/videos/mia-khalifa-first-porn-audition-for-bangbros-mk13786-3691099
# href="/download/240/3691099.mp4">MP4 240p
# 720p

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"

setwd(dirStr)

cutter1 = 'thumb-list videos'
cutter2 = 'icon-chevron-left'

pageHead = 'https://www.porn.com/videos/search?q=hookup+hotshot&p='
seekkey1 = 'div class="item rollable'
seekkey2 = '<div class="thumb">'

startNum = 1
endNum = 15
filename = paste0("pornComHookup", ".html")
theWholePage = character(0)

	for(i in startNum:endNum){
		cat(i,". ")
		thepage = readLines(paste0(pageHead, i))
		thepage = thepage[1]	# use line 1 only
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


# https://www.porn.com/videos/big-tits?p=2813
# 115333/2813 = 41
# 130648/41 = 3187
# https://www.porn.com/videos/mature?p=494
# 20220/41 = 494
