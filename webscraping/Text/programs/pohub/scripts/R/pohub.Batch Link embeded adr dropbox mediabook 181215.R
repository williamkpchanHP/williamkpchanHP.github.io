
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

askforURL <-function(){
	Selection = readline(prompt="Note! no input file! addr embbed! enter output name without extension: ")
	return(Selection)		# if empty, calling program handle
}

seekkey = '<div class="preloadLine"></div>'

boilPages <- function(theURL){

	thepage = readLines(theURL, warn = F)
	thepage = gsub('\t' , '', thepage) 

	thepage = seekforkey(thepage)

	linenuma = grep('<a', thepage)
	aPage = thepage[linenuma]

	linenumBook = grep('data-mediabook', thepage)
	bookPage = thepage[linenumBook]

	linenumImg = grep('data-thumb_url', thepage)
	imgPage = thepage[linenumImg]

	aPage = gsub('.*wkey=', '\'<a href ="https://www.pornhub.com/embed/', aPage)
	aPage = gsub(' title=".*>', '></a>', aPage)  

	imgPage = gsub('.*data-thumb_url', '<img src', imgPage)  
	imgPage = gsub('jpg.*' , 'jpg">\',', imgPage)  
#	imgPage = gsub('" .*title.*' , 'jpg">\',', imgPage)  

	bookPage = gsub('.*data-mediabook' , '<video controls width="800"><source src', bookPage)  
	bookPage = gsub('$' , '></video><br>', bookPage)  

	newpage = paste0(aPage, bookPage, imgPage)

	return(newpage)
}


seekforkey <- function(thepage){
	linenum = grep(seekkey, thepage)
	thepage = thepage[-(1:(linenum[1]-1))]

	linenum = grep(seekkey, thepage)
	linenumA = linenum +3
	linenumImg = linenum +7
	linenumbook = grep('data-mediabook', thepage)
	linenum = sort(c(linenumA, linenumbook, linenumImg))
	thepage = thepage[linenum]
}


# =========
# entry point
thefileName = askforURL()
if(thefileName == ""){
	break
}

urlHead = "https://www.pornhub.com/view_video.php?viewkey="

# theList = c('ph581871b15b188','ph576d7a46ab091','ph582b460378a4e','ph57dd5c2624387','ph58e5bc9d6f6e5','ph58daceabceb6f','ph59cd1b62cd8a4','ph59c543a885beb','ph59ccf5703bba5','698993382','2042406730','1440044711','1066744108','13644832','168123078','397912715','54192560','169898234','383253353','918152325','394536153','526001736','702807851','394593313','ph5734bd0fb546f','ph59ccf607ea658','ph59c5087dd877c','ph5a32da2e1e3fd','ph55e7702f5806d','13503766','1970966488','1338364482','ph5ad47addb332a','ph57da891d2b8cb','ph56e2ccf872185','ph57571391a0c2e','ph57024bbbed4fd','493341637','ph55d2896bd40ff','419076781','ph55ab6b287070f','223924232','18973287','734711869','ph58782849729ba','ph5bb535cdac534','ph5bcc49653d9d3','ph5be4584a70ec2','ph5a72d24c9fa3e','ph5ade18045d89f','ph573f465399670','ph58e7f913edaff','ph58f3f75085c64','ph5bf075f01bda0','ph5bce291fd65c8','ph5a1ea2dea697b','ph5829a71e75a54','ph56d5c98823547','ph56d05bb282229','ph5617dde0b1e1b','ph55b6e60f09271','ph55eedd72b41e3','ph560443d208bde','ph567984c47c83d','165549693','ph5a8bf11ee9bb3','ph58ab6d4692200','ph57641cfb0cc23','ph58d5315d4cef1','ph577e119c4a872','ph56eacd73dc2fc','ph570e56d964f10','570681370','1330758703','ph564cac90f0f8e','ph55c82926cd922','ph55a330071846b','ph55b6f0af4e6a4','671489641','ph55ae5199857b8','ph56f9539c05bc9','1976506444','ph56fc9e0b2b1fb','1712724656','380540376','1246727255','1747821889','1126726619','1844919517','1274078518','ph5612cb27c1518','ph5728f160b04e0','1263066475','ph578932a38a6bc','ph583f432681ab4','ph5863486966053','ph57964718c6819','614593181','171964774','1431397381','ph5812a5e7aa954','448927773','ph5653410740457','ph582b3e5dc97d6','ph561bd6144bcec','1258683542','ph56d5a77c45f5c')
# theList = c('1654949004','ph5672d2f5ed8c6','305271698','1338672447','77286005','287780272','13503766','ph587b8c7f69850','ph59e292d27b842','ph59e5070fae9d9','ph57ae0467a52e4')
# theList = c('993822993','ph592f29de36192','ph590475a503f8a','ph58d364e5dfc93','ph55e5a6e9e5f45','426312995','1389419618','ph55e4892100e7b','ph56b47ff09ea80','ph56faf8f8090f2','ph57154957d5684','ph579a7afb9ed42','ph5ab853831adcf','ph5b7606a3f1efa','ph5ae39780a4254')
# theList = c('ph5804c23be24a7','1837402921','ph56e71b133fa1c','ph55fc8c61c3b9f','ph58385bcebed56','ph573ece814d18d','ph56c42e0309bda','ph576c0d532362f','1124944176','64033829')
# theList = c('ph599ac39a51f07','ph5922bd323b07f','ph59f8583beb2f0','ph585add7741343','311216794','ph56fc0401cff20','ph577e7ea68f423','ph57ef52eda714c','1486363494','ph5582511fdc79b','ph573ece814d18d','ph589935ea00acc','ph5747f2be7de71','ph5798ff026f5eb','ph58951730c5995','ph59382673b1e93','ph5aedd3931d6b6','ph5a66638c837ed','ph5a9b69a7d25e3')
# theList = c('ph570068dbe3399','686065938','1316218882','ph58d9bd0cb180d','ph5722f061c1239','ph59ecc687a4b7d','ph5a2101a5efc5b','ph58e9ca4887816','ph5895de5329c4d')
# theList = c('ph5b50d5b96ba7b','ph5acc5e6e8a0e8','ph5acdf3c45dbf5','ph5af19dd981834','ph5b02069d86dbd','ph5b50d5b96ba7b','ph5582511fdc79b','ph573ece814d18d','ph56c42e0309bda','ph596dbd0ccee66','ph56772a20cb34b','ph5856ad45c3c25','ph58569d655ab46','ph566b58cc1b316')
#theList = c('ph5af143ff451a0','ph5af289e19a18d','ph5a1aedd57d4f7','ph5aae592c8a8ba','ph5b1623406f5ff','ph58313c6983b5f','1795907965','ph55ab6b287070f','ph59cdd305207ba','ph5a7300d5a11a3','ph59c987a9f1bf6','ph597a3fed55147','ph59c987aa8196f','ph5830f519a769a','ph582218a679774','ph58bf827aa6b5a','ph58e8fbe9e7f50','ph58c33c9db5b83')
theList = c('e754f8148941800d63ff','b936fd36fc9a9542d459','2123098569','84165e1739b6f3f38b08','5fada1a5d2b35f295c68','ph56d7aa532a6a2','ph56cfb347752e2')
# web scrawller from one addr

lentheList = length(theList)

wholeData = ""
for(i in 1:lentheList){
	cat(i, " ")
	theURL = paste0(urlHead, theList[i])

	wholeData = c(wholeData, boilPages(theURL))
}

	wholeData = unique(wholeData)
	pageheader <- readLines("pageHead.txt")
	pagetail <- readLines("pageTail.txt")

	sink(paste0(thefileName,".html"))
	cat(pageheader, sep="\n")

#	cat("<base target=_blank>\n")
#	cat("<style>\nhtml {height: 100%; overflow: scroll;}\n::-webkit-scrollbar { width: 0px; background: transparent;}\nbody { font-size: 24px; background-color: #000000; color: #109030;}\na { text-decoration: none;    color: #28B8B8;}\na:visited { color: #389898;}\nA:hover {   color: yellow;}\nA:focus {   color: red;}\nimg {width:32%;}\n</style>\n")

	cat(wholeData, sep="\n")
	cat(pagetail, sep="\n")
	sink()

	startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	# shell(paste0(startstr, "'",dirStr,"/", paste0(thefileName,".html\'")))
