# https://www.pornhub.com/pornstars?gender=female&page=213

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

pageHeader="https://www.pornhub.com/pornstars?gender=female&page="
pageTail=""

theWholepage = ""
theFilename = "pornhubPornstar.html"
# addr = c('4953','4954','4955','4956','4957','4958','4959','4960','4961','4962','4963','4964','4965','4966','4967','4968','4969','4970','4971','4972','4973','4974','4975','4976','4977','4978','4979','4980','4981','4982','4983','4984','4985','4986','4987','4988','4989','4990','4992','4993','4994','4995','4996','4997','4998','4999','5000','5001','5002','5003','5004','5005','5006','5007','5008','5009','5010','5011','5012','5013','5014','5015','5019','5020','5021','5022','5023','5024','5025','5026','5027','5028','5029','5030','5031','5032','5033','5034','5035','5036','5037','5038','5039','5040','5041','5042','5043','5044','5045','5046','5047','5048','5049','5050','5051','5052','5053','5054','5055','5057','5058','5059','5060','5061','5062','5063','5064','5065','5066','5067','5068','5069','5070','5071','5072','5073','5074','5075','5076','5077','5078','5079','5080','5081','5082','5083','5084','5085','5086','5087','5088','5089','5090','5091','5092','5093','5094','5095','5096','5097','5098','5099','5100','5101','5102','5103','5104','5105','5106','5107','5108','5109','5110','5111','5112','5113','5114','5115','5116','5117','5118','5119','5120','5121','5122','5123','5124','5125','5126','5127','5128','5129')

lentocpage = 213
cat("\nlentocpage: ",lentocpage,"\n")
pageHead = '<ul id="popularPornstars"'
pageEnd = '<div class="pagination'
theWholepage = ""

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum)
	return(thepage[-(1:(headlinenum-1))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageTail, thepage)  # chop tail
	cat( " ", taillinenum, "\n")
	if(length(taillinenum) != 0){
		return(thepage[-(taillinenum:length(thepage))])
	} else {
		return("")
	}
}

for (page in 1:lentocpage){
	cat(" ", page)
	thepage=readLines(paste0(pageHeader, page))
	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)

	theWholepage = c(theWholepage , thepage)
}


sink(theFilename)
cat(theWholepage, sep = "\n")
sink()

