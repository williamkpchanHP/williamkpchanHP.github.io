rm(list = ls())

readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		key = readline(prompt="Enter your choice: ")
		if(key == "as.raw(27)") {break}
	}

	return(strtoi(key))
}

AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs"
setwd(AChoice)
pMainMenuDir= "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs"

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
pMainMenuName = paste0(pMainMenuDir, "/pMainMenu.txt")
thepMainMenu <- readLines(pMainMenuName)
pMainMenu <- matrix(unlist(strsplit(thepMainMenu, split = "\\t")), ncol=2, byrow=TRUE)

cat("\nFollowings are available R scripts.\n")
cat("=====================================\n\n")

for(scriptNo in 1:nrow(pMainMenu)){
     pathName = gsub("D:\\\\Dropbox\\\\MyDocs\\\\R misc Jobs\\\\webscraping\\\\Text\\\\programs\\\\","",pMainMenu[scriptNo,1])
	cat(scriptNo, pMainMenu[scriptNo,2], "\t", pathName, "\n")
}

keyin <- nrow(pMainMenu) +1

while(keyin >nrow(pMainMenu) | keyin<1){
	cat("\nSelect the script you want to try: \n")
	keyin <- readkey()
}

cat("\n\nSelected: ", pMainMenu[keyin,],"\n\n")
theSeleted = paste0(pMainMenu[keyin,1], pMainMenu[keyin,2])
theSeleted = gsub("\\\\", "/", theSeleted)
source(theSeleted, encoding = "UTF-8")
