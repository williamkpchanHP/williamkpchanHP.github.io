# filter and remove non exist URL links
# read file
# seek for key <img
# 
# for loop
# extract url
# test exist
# if not exist mark the indexnumber
# 
# remove marks
# write back

library(httr)
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

seekkey = '<img'

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter file name: ")
	return(Selection)		# if empty, calling program handle
}

boilPages <- function(searchKey){
	for(i in 1:thenum){
		cat(i," ")
			if(i%%100 == 0){
		cat("\n")
		}
		thepage = readLines(paste0(MakeKey(theFileName), "&page=", i))
		thepage = gsub('\t' , '', thepage)
		thepage = seekforkey(thepage, seekkey)
		thepage = gsub('.*viewkey=">' , '<a href ="https://www.pornhub.com/embed/', thepage)  
		thepage = gsub(' title=".*>' , '>', thepage)  
		thepage = gsub('.*data-mediumthumb' , '<img src', thepage)  
		thepage = gsub('jpg.*' , 'jpg"></a>', thepage)  
		theWholePage <<- c(theWholePage, boilit(thepage))
	}
	sink(paste0(theFileName, ".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;	color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()
}


boilit <- function(thepage){
	rplword = '/view_video.php\\?viewkey='
	substword = 'https://www.pornhub.com/embed/'
	thepage = gsub(rplword, substword, thepage)
	thepage = gsub(' title=.*\">' , '>', thepage)  
	return(paste0(thepage,"\n"))
}

# =========
# entry point
Sys.setlocale(category = "LC_ALL", locale = "chs")

theFileName = askforKey()
if(theFileName == ""){
	break
}

theFileName = paste0(theFileName, ".html")

thepage = readLines(theFileName)
linenum = grep(seekkey, thepage)
cat("total URL lines: ", length(linenum),"\n")

revoveList <- vector(mode="numeric", length=0)

for(i in 1:length(linenum)){
	cat(i," ")
	if(i%%100 == 0){
		cat("\n")
	}

	theline = thepage[linenum[i]]
	theUrl = gsub('.*src="' , '', theline)  
	theUrl = gsub('jpg.*' , 'jpg', theUrl)

	if(http_error(theUrl)){
		cat("\nURL not exist, line: ",linenum[i],"\n")
		revoveList = c(revoveList, i) # this is the i index, ie the linenum index
	}
}
thepage = thepage[-linenum[revoveList]]

cat("\ntotal removed lines:", length(revoveList))
sink(theFileName)
cat(thepage, sep="\n")
sink()
cat(" completed")
