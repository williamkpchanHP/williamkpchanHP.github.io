# will not detect next page, just ext every url included
# to extract gallery pages use 'window.initials>'
# 'pageURL', "editURL

# to extract gallery images, grep the only line 'window.initials'
# break at 'imageURL'
# grep the only useful
# cut height afterwards
# add '
# same in output file

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)
thefileName = "temp" # no extension


seekkey = 'window.initials'
chopkey = 'pageURL'
boilPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	linenum = grep(seekkey, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, chopkey))
	thepage = thepage[-1]

	linenum = grep("imageURL", thepage)
	thepage = thepage[linenum]

	thepage = gsub('.*imageURL":' , '\'<img src=', thepage) 
	thepage = gsub(',"height.*' , '>\',', thepage) 
	thepage = gsub('\\\\/' , '/', thepage) 
	return(thepage)
}


# =========
# entry point

urlHead = "https://xhamster.com/photos/gallery/"
theList = c(
"bbw-milf-flashing-in-park-13827697",
"pussy-show-9462252",
"pussy-show-9462252/2",
"pussy-show-9462252/3",
"pussy-show-9462252/4",
"pussy-show-9462252/5",
"pussy-show-9462252/6",
"pussy-show-6826073",
"showed-pussy-13355231",
"showing-pussy-12833862",
"pussy-show-12146108",
"showing-pussy-3265082",
"girls-shows-pussy-13911033",
"girls-showing-pussy-13054638",
"girls-showing-pussy-13054638/2",
"girls-showing-pussy-13054638/3",
"sexy-hot-moms-and-wives-spread-show-pussy-in-cars-bus-14-13953363",
"sexy-hot-moms-and-wives-spread-show-pussy-in-cars-bus-5-13316475",
"sexy-hot-moms-and-wives-spread-show-pussy-in-cars-bus-7-13532749",
"sexy-hot-moms-and-wives-spread-show-pussy-in-cars-bus-6-13441251",
"brunette-with-big-boobs-shows-pussy-in-the-woods-13837006",
"png-pussy-show-13790374",
"before-and-after-pussy-show-13974279",
"slut-wife-pussy-show-2-13773558",
"slut-wife-pussy-show-13748538",
"big-tits-big-ass-slut-wife-mature-shows-freshly-shaved-pussy-11421439",
"teen-milf-mature-big-tits-big-as-feet-footjob-legs-wife-slut-11115065",
"slut-wife-claire-show-set-hairy-pussy-5220060",
"slut-wife-claire-shows-shaved-pussy-in-the-bedroom-5325220",
"slut-wife-claire-shows-hairy-pussy-and-ass-5220049"
)

lentheList = length(theList)

wholeData = ""
for(i in 1:lentheList){
	cat(i, " ")
	theURL = paste0(urlHead, theList[i])
	wholeData = c(wholeData, boilPages(theURL))
}
	writeClipboard(wholeData)
	cat("data copied to clipboard!\n")

	thepageHear = readLines('picViewerHead.txt', warn = F)
	thepageTail = readLines('picViewerTail.txt', warn = F)
	sink(paste0(thefileName,".html"))
	cat(thepageHear, sep="\n")
	cat(wholeData, sep="\n")
	cat(thepageTail, sep="\n")
	sink()

	startstr="start launcher.exe --start-fullscreen \""
	shell(paste0(startstr, dirStr,"/", paste0(thefileName,".html")))

