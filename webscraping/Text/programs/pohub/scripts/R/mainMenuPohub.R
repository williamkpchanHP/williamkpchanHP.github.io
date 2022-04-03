# this is main menu for pohub

# support function
 readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		cat("Enter your choice: ")
		key = readLines("stdin",n=1);
		if(key == "as.raw(27)") {break}
	}

	return(strtoi(key))
 }

# entry point
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(AChoice)

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
mainMenuName = "mainMenuPohubList.txt"
themainMenu <- readLines(mainMenuName)
mainMenu <- matrix(unlist(strsplit(themainMenu, split = "\\t")), ncol=2, byrow=TRUE)

cat("\nFollowings are available R scripts.\n")
cat("=====================================\n\n")

for(scriptNo in 1:nrow(mainMenu)){
	cat(scriptNo, mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\n")
}

keyin <- nrow(mainMenu) +1

while(keyin >nrow(mainMenu) | keyin<1){
	cat("\nSelect the script you want to try: \n")
	keyin <- readkey()
}

cat("\n\nSelected: ", mainMenu[keyin,],"\n\n")
theSeleted = paste0(mainMenu[keyin,1], mainMenu[keyin,2])
theSeleted = gsub("\\\\", "/", theSeleted)
cat("\n",theSeleted, "\n")
source(theSeleted, encoding = "UTF-8")
