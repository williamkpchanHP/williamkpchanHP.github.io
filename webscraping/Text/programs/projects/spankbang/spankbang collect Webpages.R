# https://spankbang.com/s/jaylene+rio/
# https://spankbang.com/s/jaylene+rio/15/
# first to collect TOC second collect mp4
# ask for keyword
# ask for total pages

# https://spankbang.com/s/eva+notty/
# https://spankbang.com/s/eva+notty/38/
# class="thumb">
# linnum, linnum + 1

# <video 
#          poster="//cdnthumb2.spankbang.com/0/9/3/932653-t4.jpg">
#             <source src="/_jzn1/IjE0OTY4NDMwNDcuMDgi.rBvguq-1xRjcEDbBxQco4Fm79ZQ/bruntee+sluts+eva+notty+and+gia+paige+in+an+intense+threesome/480p__mp4" type='video/mp4'>
#           </video>

#  <source src
# linnum, linnum - 1

setwd("C:/Users/user/mpg/Text/programs/projects/spankbang")
totalpages = 38
beginpages = 1
endpage = beginpages + totalpages - 1
pageHeader="https://spankbang.com/s/eva+notty/"
lineSig = 'class="thumb">'
template = readLines("Template.html")

projTitle = "spankbang"

theWholepage = ""

for (page in beginpages:endpage){
	cat("\n", page)

	thepage = readLines(paste0(pageHeader,page))
	linenum = grep(lineSig, thepage)
	linenum = sort(c(linenum, linenum +1))
	thepage = thepage[linenum]
	thepage = gsub('class="cover" />', "></a>", thepage)
	theWholepage = c(theWholepage, thepage)
}
	sink(paste0(projTitle, "TOC.html"))
	cat(template, sep="\n")
	cat(theWholepage, sep="\n")
	sink()

#======
