setwd("C:/Users/user/mpg/Text/programs/projects/pinksMilfs/old-pussy-exam/")

htmlHead = '<base href=http://www.pinksmilfs.com/content/old-pussy-exam/galleries/>\n<head>\n<style type="text/css">body {background-color: #000000;}</STYLE>\n</head><body><center>\n'

tocList = readLines("old-pussy-exam addr list.txt")
totalpages = length(tocList)

theWholepage = htmlHead
page = 1
groupPageNum = 15
while(page <= totalpages){
    cat(page)
    thepage= ""
    for(imgNum in 1:15){
        thepage= paste0(thepage,"<img src='", tocList[page], "full/", imgNum, ".jpg'><br>\n")
    }

    theWholepage = c(theWholepage , thepage)
    if(page%%groupPageNum == 0){
		sink(paste0("old-pussy-exam P ", page%/%groupPageNum, ".html"))
		cat(theWholepage, sep="\n")
		sink()
		theWholepage = htmlHead
	}
	page = page + 1
}
sink(paste0("old-pussy-exam P ", (page%/%groupPageNum + 1), ".html"))
cat(theWholepage, sep="\n")
sink()

#======