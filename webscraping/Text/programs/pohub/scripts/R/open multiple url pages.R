# http://pierceduniverse.tumblr.com/page/2

urlHead= 'http://sindymet.tumblr.com/page/'
lentheList = 6513
startstr="start chrome.exe --start-fullscreen \""

readkey = function(){
	key = readline(prompt="Please hit a key. ")
	    if(key == "as.raw(27)") {break}
}

for(i in 1:lentheList){
	if(i %% 5 == 0) {readkey()}
	cat(i, " ")
	Sys.sleep(10)
	theURL = paste0(urlHead, i)
	shell(paste0(startstr, theURL))
}


