
# extract meaty

dirStr = "C:/Users/user/Desktop"
# dirStr = "D:/Users/REXTONG/Desktop"
setwd(dirStr)

theFilename = "meaty.html"

URLHead = "http://www.sex.com/user/spiny/meaty-pussy/?page="
tocpage = character(0)

for (i in 1:58){
	tocpage[i] = paste0(URLHead, i)
}

lentocpage = length(tocpage)

newpage = ""

for(i in 1:lentocpage){
	cat(i, " ")
	theURL = tocpage[i]
	thepage = readLines(theURL, warn = F)
    imgline = grep("<img", thepage)
	thepage = 	thepage[imgline]
   	newpage = c(newpage, thepage)

}
sink(theFilename)
cat('<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><base target=_blank><style>body { margin: 10%; font-size: 20px; background-color: #000000; color: #109030;}a { text-decoration: none; color: #28B8B8;}a:visited { color: #389898;}A:hover { color: yellow;}A:focus { color: red;}code { color: pink; background-color: #001500}pre { color: gray; background-color: #001010}div {display: inline-block; width: 48%; padding: 3px; border-radius: 4px; border: 1px solid gray; margin: 3px; vertical-align:middle;}</style>\n</head><body>\n')
cat(newpage, sep = "\n")
sink()


startstr="start chrome.exe --start-fullscreen "
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"",theFilename,"\"")))
