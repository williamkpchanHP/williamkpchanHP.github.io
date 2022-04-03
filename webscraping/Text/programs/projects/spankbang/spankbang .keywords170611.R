# https://spankbang.com/s/jaylene+rio/
# https://spankbang.com/s/jaylene+rio/15/
# first to collect TOC second collect mp4
# ask for keyword
# ask for total pages

# https://spankbang.com/s/eva+notty/
# https://spankbang.com/s/eva+notty/38/
# class="thumb">
# linnum, linnum + 1

#          poster="//cdnthumb2.spankbang.com/0/9/3/932653-t4.jpg">
#             <source src="/_jzn1/IjE0OTY4NDMwNDcuMDgi.rBvguq-1xRjcEDbBxQco4Fm79ZQ/bruntee+sluts+eva+notty+and+gia+paige+in+an+intense+threesome/480p__mp4" type='video/mp4'>

#  <source src
# linnum, linnum - 1
dirStr = "C:/Users/user/mpg/Text/programs/projects/spankbang"
setwd(dirStr)

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter key words: ")
	if(Selection != "")   {
	  	Selection = tolower(gsub(" ", "+", Selection))
  	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

MakeKey <- function(Selection){
	# https://spankbang.com/s/jaylene+rio/15/
	searchHead = 'https://spankbang.com/s/'
	return(paste0(searchHead, thekeyword, "/"))
}

boilPages <- function(searchKey){
	theWholepage = character(0)
	theWholelist = character(0)
    cat("Reading Pages: \n")

	for(i in 1:thenum){
	    cat(i," ")
		thepage = readLines(paste0(pageHeader,i))
		linenum = grep(lineSig, thepage)
		linenum = sort(c(linenum, linenum +1))
		thepage = thepage[linenum]
		thepage = gsub('class="cover" />', "></a>", thepage)
		thepage = gsub(' class="thumb"', "", thepage)

		# <a href="/14ong/video/daylene+rio">
		ahreflin = grep("<a href", thepage)
		theVidList = thepage[ahreflin]
		theVidList = gsub('.*<a href="', "https://spankbang.com", theVidList)
		theVidList = gsub('">', "", theVidList)

		theWholelist = c(theWholelist, theVidList)
		theWholepage = c(theWholepage, thepage)
	}

	sink(projTitleHtml)
	cat('<base href="https://spankbang.com">')
	cat(template, sep="\n")
	cat(theWholepage, sep="\n")
	sink()

	return(theWholelist)
}


# =========
# entry point

lineSig = 'class="thumb">'
template = readLines("Template.html")

thekeyword = askforKey()
if(thekeyword == ""){
	break
}

thenum = 30
asknum = askforNum()
if(asknum != "")   {
	thenum = as.numeric(asknum)
}

pageHeader = MakeKey(thekeyword)

projTitle = paste0("SPB_", thekeyword)
projTitleHtml = paste0(projTitle,"_TOC.html") 
projTitleVList = paste0(projTitle,"_VList.txt") 
vidTitle = paste0(projTitle,"_Vid") 

theVList = boilPages()

cat("\ntotal vid: ", length(theVList),"\nCollecting Videos.\n")

allVidPage = ""
for(vid in 1:length(theVList)){
	if(vid %% 10 ==0 ){
		cat(vid, "")
	}
	thepage = readLines(theVList[vid])
	linenum = grep("poster", thepage)
	linenum = sort(c(linenum, linenum +1))
	thepage = thepage[linenum]
# poster="//cdnthumb2.spankbang.com/0/9/3/932653-t4.jpg">
# <source src="/_jzn1/IjE0OTY4NDMwNDcuMDgi.rBvguq-1xRjcEDbBxQco4Fm79ZQ/bruntee+sluts+eva+notty+and+gia+paige+in+an+intense+threesome/480p__mp4" type='video/mp4'>
	thepage = gsub('.*poster', "<img src", thepage)
	thepage = gsub('.*<source src', "<a href", thepage)
	thepage = gsub(" type='video/mp4'", "", thepage)
	newLine = paste0(thepage[2], thepage[1], "</a>\n")
	allVidPage = c(allVidPage, newLine)
}


htmlHead = '<base href="https://spankbang.com">'
htmlHead = c(htmlHead, template)
htmlHead = c(htmlHead, "<center>")

page = 1
groupNum = 200

while(length(allVidPage)%/%groupNum > 0){
    cat(page," ")
    outputpage= allVidPage[1:groupNum]
    allVidPage= allVidPage[-(1:groupNum)]

    cat("\nRemaining videos: ", length(allVidPage), "\n")

    sink(paste0(vidTitle,"_P_", page, ".html"))
    cat(htmlHead, sep="\n")
    cat(outputpage, sep="\n")
    sink()
    page = page + 1
}
sink(paste0(vidTitle,"_P_", page, ".html"))
cat(htmlHead)
cat(allVidPage, sep="\n")
sink()

firstpage = paste0(vidTitle,"_P_", 1, ".html")

startstr="start chrome.exe --start-fullscreen "
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", firstpage))
