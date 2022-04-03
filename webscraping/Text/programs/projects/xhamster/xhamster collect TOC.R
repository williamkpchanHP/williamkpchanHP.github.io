# key will expire soon and so run this before show
# https://xhamster.com/new/27202.html
# very long time 27202 pages
# div class="video">

# <div class="noFlash" style="opacity: 0;"><a href="http://5.xhcdn.com/key=9IKNtTAZkHyuK-cpdGsO4g,end=1495162618,limit=3/data=123.203.73.193-dvp/speed=500k/initial_buffer=715856/1781425_hd.mp4"

setwd("C:/Users/user/mpg/Text/programs/projects/xhamster")
totalpages = 2
beginpages = 50
endpage = beginpages + totalpages
pageHeader="https://xhamster.com/new/"
lineSig = 'div class="video">'
projTitle = "xhamster"


for (page in beginpages:endpage){
	cat("\n", page)
	theWholepage = ""

	thepage = readLines(paste0(pageHeader,page, ".html"))
	linenum = grep(lineSig, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, ">"))
	linenum = grep("<img src", thepage)
	thepage = thepage[linenum]
	thepage = paste0(thepage, ">")
	thepage = gsub("class='thumb' ", "", thepage)

	theAddr = gsub(".*_|.jpg.*", "", thepage)
	theAddr = paste0("https://xhamster.com/movies/", theAddr)

	for (addr in 1:length(theAddr)){
		cat(".")
		theMpAdr = readLines(theAddr[addr])
		mpAdr = grep("file:", theMpAdr)
		theMpAdr = theMpAdr[c(mpAdr, mpAdr+1)]
		theMpAdr[1] = gsub(".*file: ", "<a href=", theMpAdr[1])
		theMpAdr[1] = gsub("',", "'>", theMpAdr[1])
		theMpAdr[2] = gsub(".*thumb: ", "<img src=", theMpAdr[2])
		theMpAdr[2] = paste0(theMpAdr[2], "></a><br>")
		theWholepage = c(theWholepage , theMpAdr)
	}
	sink(paste0(projTitle, " P ",page, ".html"))
	cat(theWholepage, sep="\n")
	sink()
}

#======
