# extract xxxonxxx.com imgs
library(crayon)
cat(yellow(format(Sys.time(), "%H:%M:%OSs"),"\n"))
library(rvest)

folderAddr = "C:/Users/User/Desktop/"
setwd(folderAddr)

wholePage = character()
cleanNmerge <- function(thepage){
  keywordList <- thepage %>% html_nodes("div.one-thumb img") %>% as.character()

  keywordList = gsub('gthumb','content',keywordList)
  keywordList = gsub('_300x_','',keywordList)
  keywordList = gsub(' alt=".*?>','>',keywordList)
  wholePage <<- c(wholePage, keywordList)
}

cleanNmergeallover30 <- function(thepage){
  keywordList <- thepage %>% html_nodes("div.thumb__img-holder img") %>% as.character()
  keywordList = gsub(' src="',paste0(' src="', urlheader1), keywordList)
  keywordList = gsub('-thumb','',keywordList)
  keywordList = gsub(' alt=".*?>','>',keywordList)
  wholePage <<- c(wholePage, keywordList)
}

# for xxxonxxx use this
#urlheader1 = "https://xxxonxxx.com/juiceyjaney/big-booty-high-heels/"

# for galleries.allover30
urlheader1 = "http://galleries.allover30.com/mature/kitten-latenight-1610578601/"
thepage <- read_html(urlheader1)

# for xxxonxxx use this
#cleanNmerge(thepage)
# for galleries.allover30
cleanNmergeallover30(thepage)

writeClipboard(wholePage)

# belows for batch processing
for(i in 2:10){
  urlheader2 = paste0("http://mom50.com/index", i, ".shtml")
  thepage <- read_html(urlheader2)
  cleanNmerge(thepage)
}


sink("temp.html")
cat(wholePage, sep="\n")
sink()

cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")
cat(red("Job completed!\n"))
