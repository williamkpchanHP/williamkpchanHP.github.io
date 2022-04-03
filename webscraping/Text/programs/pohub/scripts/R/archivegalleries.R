# prefetch addr
# grep all img addrs
# store in text array in array
# 
# to recover
# run show array function
# 
# action: collect imgs
# collect addr database
# 
# http://www.milfpornpics.xxx/cat/spreading/?pg=8

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

setwd("D:/Dropbox/MyDocs/R misc Jobs/Extracts by R")

pageHeader="http://archivegalleries.net/collection/"
pageTail="/"
theFilename = "archivegalleries.html"
addr = c(
"50/2019/05/82q6TtT",
"aj/2016/04/HknM2kl",
"aj/2016/05/lEVz8lA",
"aj/2016/06/fP5zzKJ",
"aj/2016/08/6GsDoVy",
"aj/2016/08/IL6ZCj0",
"aj/2016/08/k6ly0Qr",
"aj/2016/08/YwB47Rb",
"aj/2016/09/0nndeEx",
"aj/2016/09/CjgNH9W",
"aj/2016/10/LN9bd7a",
"aj/2016/11/Yecun0m",
"aj/2016/12/CNs5gFf",
"aj/2017/01/dV3A10o",
"aj/2017/01/kfwe1Ns",
"aj/2017/01/yqJD58L",
"aj/2017/03/dAZN0Eq",
"aj/2017/03/Dd6zTFt",
"aj/2017/04/HbwoX08",
"aj/2017/05/rh7M2z8",
"aj/2017/06/38kTmQG",
"aj/2017/06/43VTCPh",
"aj/2017/06/8HytMQD",
"aj/2017/06/cIDN682",
"aj/2017/06/DEw0MGAB",
"aj/2017/06/eSWm2Dc",
"aj/2017/06/FLGxEW9",
"aj/2017/06/oXJmXh0",
"aj/2017/08/0Hhq5mk",
"aj/2017/08/2kjyQ9V",
"aj/2017/08/FV56HbP",
"aj/2017/08/v6DqGD2",
"aj/2017/09/9bnHNQi",
"aj/2017/09/Ap5Bxfmd",
"aj/2017/09/ec8tRkS",
"aj/2017/10/AMzp9hr",
"aj/2017/10/c2i2YgY",
"aj/2017/10/juXh0yN",
"aj/2017/10/mJPWbl7",
"aj/2017/12/iHzU62M",
"aj/2018/03/bXv25ZM",
"aj/2018/03/WSnJj8B",
"aj/2018/04/8MhqJPm",
"aj/2018/04/Pv3x2KL",
"aj/2018/04/X5h5MfJ",
"aj/2018/05/HWmgEL8",
"aj/2018/07/3PEczgC",
"aj/2018/07/kqvF9SY",
"aj/2019/01/4g53WwB",
"aj/2019/02/8BK38Hz",
"aj/2019/04/63c7Y6Z",
"aj/2019/07/3y7K6bw",
"aj/2019/08/7js55FA",
"anl/2016/08/0NXNcUkK",
"anl/2016/08/42ykH8G",
"anl/2016/10/fE7JbD3",
"anl/2017/09/VW90F2t",
"anl/2018/06/4nsFUL4",
"anl/2018/06/PZpDE6n",
"anl/2019/04/P2T8vj4",
"anl/2019/07/J98X74n",
"ao30/2016/08/s5T3aeY",
"ao30/2016/08/YlfkB6L",
"ao30/2016/09/52fwCXO",
"ao30/2016/10/mwm6BGK",
"ao30/2016/12/6xYbL0d",
"ao30/2017/02/UiW0sU7",
"ao30/2017/03/w4Nsn50",
"ao30/2017/05/8FadPYK",
"ao30/2017/05/mWgAn0K",
"ao30/2017/05/Ytt1R6G",
"ao30/2017/06/R2sckE9",
"ao30/2017/08/7IM5Nor",
"ao30/2017/09/Ez6FjqA",
"ao30/2017/09/FoItG2S1",
"ao30/2018/01/9bWavHt",
"ao30/2018/04/a5EQLxV",
"ao30/2018/05/CPWJHb8",
"ao30/2018/07/R2CX6bK",
"ao30/2018/10/2F9eJj7",
"ao30/2018/11/7f6V7o4",
"ao30/2019/01/dg8U52o",
"ao30/2019/02/5g7RB2K",
"ao30/2019/04/KaCJ684",
"ao30/2019/06/B44d5uw",
"ao30/2019/06/gU32a2p",
"ao30/2019/07/B93te54",
"ao30/2019/07/pS7Sh66",
"ao30/2019/08/2h2j6J2",
"ao30/2019/08/KC8F32x",
"ao30/2019/08/oA57Ed8",
"ftv/2018/09/JQPUzz2",
"ftv/2019/08/L4NY5j8",
"ha/2018/06/7Szux5M",
"ha/2019/03/J8Q5n8q",
"ha/2019/04/5235v3N",
"ha/2019/04/8gJb6a7",
"ha/2019/05/85o2z7B",
"ha/2019/08/2n2c69Y",
"kow/2016/05/vKLa5w6",
"kow/2017/03/QcyB5Yi",
"kow/2018/01/JjUbUD8",
"kow/2018/06/T3RFyDa",
"kow/2019/02/wH4Js77",
"kow/2019/04/EW3bz87",
"kow/2019/06/M5477ss",
"kow/2019/06/TpA395c",
"mb/2019/06/p3J5s4M",
"nl/2016/09/DPkwU6t",
"nl/2016/09/qWFRf8F",
"nl/2019/07/R2W7Fa5",
"pc/2019/04/96U43nT",
"sl/2018/03/NZHyTn3",
"sl/2018/08/P7xu3FK",
"sl/2019/06/6ok7D8C",
"wh/2018/03/6vhRWm9",
"wh/2018/08/3mSNsgJ",
"wh/2018/09/BrbzA2u",
"wh/2018/10/nw9J4N2",
"wh/2018/11/oXy4C73",
"wh/2019/01/Y92moZ3",
"wh/2019/02/7dr663J",
"wh/2019/03/56Mjp54",
"wh/2019/04/T2dU82d",
"wh/2019/05/2fAeE52",
"wh/2019/05/3VcV4j2",
"wh/2019/05/49fU329",
"wh/2019/05/52n5h2P",
"wh/2019/05/58UK62t",
"wh/2019/06/qEm452i",
"wh/2019/06/SHp92C4",
"wh/2019/07/32QCAp2",
"wh/2019/07/94Rwn3s",
"wh/2019/07/9G6hJA6",
"wh/2019/07/i4P646F",
"wh/2019/07/VY5a3Q2",
"wh/2019/08/h9p3cS5"
)
lentocpage = length(addr)

theWholepage = ""
cat("\nlentocpage: ",lentocpage,"\n")
pageHead = '<table align="center" width="720">'
pageEnd = '</table></td>'

theWholepage = ""

breakArticle <- function(thepage, pageHead, pageEnd){
	thepage = gsub(pageHead , paste0('breakey',pageHead), thepage) 
	thepage = gsub(pageEnd , paste0(pageEnd,'breakey'), thepage) 
	thepage = unlist(strsplit(thepage,'breakey'))
	return(thepage)
}

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum[1])
	return(thepage[-(1:(headlinenum[1]))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageEnd, thepage)  # chop tail
	cat( " ", taillinenum[1], "\n")
	if(length(taillinenum) != 0){
		return(thepage[-((taillinenum[1]):length(thepage))])
	} else {
		return("")
	}
}

for (page in 1:lentocpage){
	cat(" ", page)
	thepage=readLines(paste0(pageHeader, addr[page], pageTail))

#	thepage=breakArticle(thepage, pageHead, pageEnd)
	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)
	theWholepage = c(theWholepage , "<div class='topic'>\n",thepage, "\n</div>\n")
}


sink(theFilename)
cat(theWholepage, sep = "\n")
sink()

