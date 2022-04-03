setwd("C:/Users/user/mpg/Text/programs/projects/xvideos bikinidare")
theFilename = "xvideos bikinidareAllVideo.html"
theList = readLines(theFilename)

htmlHead = '<head>\n<style type="text/css">body {margin:2%; background-color: #000000;}div {display: inline-block; width: 25%; padding: 3px; border-radius: 4px; border: 1px solid gray; margin: 3px; vertical-align:middle;}</STYLE>\n</head><body><center>\n'

page = 1
groupPageNum = 50
while(page <= 40){
	cat(page)
	thepage= theList[1:50]
	theList= theList[-(1:50)]

	sink(paste0("xvideos bikinidare P ", page, ".html"))
	cat(htmlHead)
	cat(thepage, sep="\n")
	sink()
	page = page + 1
}

#======


#======
