# ==========
# functions

readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		key = readline(prompt="Enter your choice: ")
		if(key == "as.raw(27)") {break}
	}

	return(strtoi(key))
}

# ==========
# init data

mainMenu = c("boobimglist", "titsImgList", "pusImgList")

# ==========
# init

cat("\nAvailable Lists.\n")
cat("==========================\n\n")

for(listNo in 1:length(mainMenu)){
	cat(listNo, mainMenu[listNo], "\n")
}

keyin <- length(mainMenu) +1

while(keyin >length(mainMenu) | keyin<1){
	cat("\nSelect the list you want to run: \n")
	keyin <- readkey()
}

cat("\n\nSelected: ", mainMenu[keyin],"\n\n")

theSeleted = paste0(mainMenu[keyin], ".txt")
