# choices: D:\KPC\Dropbox\MyDocs\Javascript Documents\RGraph\demos\line-basic testing.html
# important!!! D:\KPC\Dropbox\MyDocs\Javascript Documents\
# important!!! testcharttest1.html
# important!!! testchart.html
# the D3 chart is not yet fully understood and the last part will be rewritten to use R ggplot to present data!!

optionA = "D:/Dropbox/Banking/Manulife/MLFChart"
optionB = "D:/KPC/Dropbox/MyDocs/Banking/Manulife/MLFChart"

cat("\n\n\nSetup Working Folder:\n")
cat("a  D:/Dropbox/Banking/Manulife/MLFChart\n")
cat("b  D:/KPC/Dropbox/MyDocs/Banking/Manulife/MLFChart\n\n")

Selection = readline(prompt="enter Working Folder a or b: ")
if(Selection == "a"){
	dirStr = optionA
} else {
	dirStr = optionB
}

setwd(dirStr)

library("XML")
library("dplyr")

cutDate<-as.Date("2016-11-23")

MLCode = c("UAF01", "UCP01", "UGW01", "UGU01", "UMG01", "UAA01", "UAG01", "UAI01", "UDD01", "ULL01", "UAS01", "UGS01", "UTR01", "UDE01", "UAE01", "UAC01", "UAU01", "UBA01", "UBE01", "UGA01", "UBG01", "UBS01", "UCV01", "UCC01", "UEF01", "UEU01", "UHY01", "UFC01", "UED01", "UMI01", "UFI01", "UFU01", "UCN01", "UDA01", "UMD01", "UIG01", "UGF01", "UGP01", "URE01", "USI01", "UGO01", "UGR01", "UHC01", "UHT01", "UHS01", "UHF01", "UIF01", "UIB01", "UAB01", "UIA01", "UGI01", "UIJ01", "UGE01", "UGG01", "UDR01", "UJF01", "UJA01", "UJO01", "UMK01", "UJM01", "UJC01", "UKF01", "ULA01", "UMA01", "UMN01", "UNF01", "UPB01", "URF01", "UAP01", "USM01", "UGM01", "USB01", "USE01", "USF01", "UTW01", "UFM01", "UTG01", "UTF01", "UTK01", "UUB01", "USU01", "UUE01", "UOE01", "UEY01", "UUC01", "UVY01", "SHK139", "SHK140", "SHK141", "SHK142", "SHK143", "SHK144", "SHK124", "SHK136", "SHK125", "SHK129", "SHK134", "SHK135", "SHK123", "SHK145", "SHK137", "SHK132", "SHK126", "SHK133", "SHK127", "SHK131", "SHK130", "SHK146", "SHK128", "SHK147", "SHK138", "SHK122")
MLCodeName = c("MIL進取基金", "MIL全天候資本穩健基金", "MIL全天候增長基金", "MIL全天候進昇增長基金", "MIL全天候穩定增長基金", "MIL安聯亞洲多元入息基金", "MIL安聯歐陸成長基金", "MIL安聯收益及增長基金", "MIL東方匯理新興市場內需基金", "MIL東方匯理優越生活基金 ", "MIL亞太基金", "MIL亞太收益及增長基金", "MIL亞洲總回報基金", "MIL亞洲威力股息股票基金", "MIL亞太股票收益基金", "MIL亞洲小型公司基金", "MIL澳洲基金", "MIL霸菱大東協基金", "MIL霸菱歐洲精選基金 ", "MIL貝萊德環球資產配置基金 ", "MIL貝萊德環球企業債券基金 ", "MIL貝萊德環球小型企業基金 ", "MIL中華基金", "MIL花旗中國精選基金", "MIL東歐基金", "MIL歐洲基金", "MIL富達亞洲高收益基金", "MIL富達中國消費動力基金", "MIL富達歐洲動力增長基金 ", "MIL富達環球多元收益基金 ", "MIL富達國際基金 ", "MIL富蘭克林美國機會基金", "MIL環球反向策略基金", "MIL環球動態資產配置基金", "MIL新興市場債券基金", "MIL環球股票基金", "MIL環球基金", "MIL環球房地產基金 ", "MIL環球資源基金", "MIL環球策略收益基金", "MIL大中華機會基金", "MIL增長基金", "MIL康健護理基金", "MIL亨德森環球科技基金 ", "MIL亨德森日本小型公司基金 ", "MIL香港基金", "MIL印度基金", "MIL國際債券基金", "MIL景順亞洲平衡基金", "MIL景順亞洲動力基金", "MIL景順環球高收益債券基金", "MIL景順日本動力基金 ", "MIL天達環球能源基金", "MIL天達環球黃金基金", "MIL天達環球天然資源基金", "MIL日本基金", "MIL摩根東協基金", "MIL摩根環球新興市場機會基金", "MIL摩根南韓基金", "MIL摩根全方位入息基金 ", "MIL木星全球可換股證券基金 ", "MIL韓國基金", "MIL拉丁美洲基金", "MIL麥格理中國IPO飛躍基金", "MIL中東及北非基金", "MIL北美基金", "MIL法巴亞洲(日本除外)債券基金", "MIL俄羅斯基金", "MIL施羅德亞太城市房地產股票基金 **", "MIL施羅德新興市場基金", "MIL施羅德環球股債收息基金", "MIL施羅德港元債券基金", "MIL施羅德香港股票基金 ", "MIL穩健基金", "MIL台灣基金", "MIL鄧普頓前緣市場基金", "MIL鄧普頓環球總收益基金 ", "MIL泰國基金", "MIL土耳其基金", "MIL美國債券基金 ", "MIL美國特別機會基金 ", "MIL瑞銀亞洲消費股票基金", "MIL瑞銀中國精選股票基金", "MIL瑞銀歐元高收益債券基金 ", "MIL美國小型公司基金", "MIL行健宏揚中國基金", "宏利MPF 2020退休基金", "宏利MPF 2025退休基金", "宏利MPF 2030退休基金", "宏利MPF 2035退休基金", "宏利MPF 2040退休基金", "宏利MPF 2045退休基金", "宏利MPF進取基金", "宏利MPF中華威力基金", "宏利MPF保守基金 ^", "宏利MPF歐洲股票基金", "宏利MPF富達增長基金", "宏利MPF富達平穩增長基金", "宏利MPF增長基金", "宏利MPF恒指基金", "宏利MPF康健護理基金", "宏利MPF香港債券基金", "宏利MPF香港股票基金", "宏利MPF國際債券基金", "宏利MPF國際股票基金", "宏利MPF日本股票基金", "宏利MPF北美股票基金", "宏利MPF亞太債券基金", "宏利MPF亞太股票基金", "宏利MPF人民幣債券基金", "宏利MPF智優裕退休基金", "宏利MPF穩健基金**")
MLCodeName = iconv(MLCodeName, to = "UTF-8")
lenMLCode = length(MLCode)

# download data file which is csv with header, select colnames Date,NAV
# http://www.manulife.com.hk/pws_portal/MILDFPPortlet/download_excel?fundCode=UAG01&historyRange=daily&historyStartDate=03-Jan-17&historyEndDate=03-Mar-17&categoryId=11&locale=zh&buId=IND

theUrlHead = "http://www.manulife.com.hk/pws_portal/MILDFPPortlet/download_excel?fundCode=";
#   MLCode[codeNo]
theUrlMid = "&historyRange=daily&historyStartDate="
theStartDate = "03-Oct-16"
theDateConnector = "&historyEndDate="

#   theEndDate
#   Sys.setlocale(category = "LC_TIME", locale = "English_United States.1252")
Sys.setlocale("LC_TIME", "C")	# to avoid chinese characters
theEndDate = format(Sys.Date(), "%d-%b-%y")	# EndDate = 03-Mar-17, Sys.Date() "2017-03-18"
theUrlTail= "&categoryId=11&locale=zh&buId=IND";

RegrPeriod = 8

# ===========================
dropNotes <- function(Msg){
    noteBk <<- c(noteBk, Msg)
}
# ===========================


# =======================
# this function dumps the whole set of data to get the result, 
# provides the start pt and the end point
# As this part was changed to function, assignment has changed to direct <<

# DynamCurv is the function name
# PDataSet is the data set to be processed, 
# RegrPeriod is the regression period, PTVSet is the result stored global

# flow chart :
# DynamCurv -> CalcTrend -> TrendValue+mysd
# preparation, chop value,  do the work

DynamCurv <- function(PDataSet, RegrPeriod){
  StartPTR = 1
  LastPTR = length(PDataSet)

# this prepares the result dataframe
  PTVSet <<- rep(NA,length(PDataSet))
  PStd <<- rep(NA,length(PDataSet))

# this calls the calculation function, result is stored in PTVSet
  CalcTrend(PDataSet, RegrPeriod, StartPTR, LastPTR)	# this is the cal function

  PTVSet[1:RegrPeriod] <<- PTVSet[RegrPeriod]	# makes header period nice
  PStd[1:RegrPeriod] <<- 0	# makes header period nice
}

# =======================



# =======================
# this will calculate the whole trend
# provided with x data
# TrendValue calculates the last point trend value
# PStd is the resulting Standare deviation

CalcTrend <- function(PDataSet, RegrPeriod, StartP, LastPTR)

for(j in StartP:(LastPTR-RegrPeriod+1)){
  DataStart = j
  DataEnd = j+RegrPeriod-1

  # this calls the function to get the point value
  PTVSet[DataEnd] <<- TrendValue(PDataSet, DataStart, DataEnd)	# this direct write to the matrix
  meadpt = mean(PDataSet[DataStart:DataEnd])
  PStd[DataEnd] <<- mysd(PDataSet[DataStart:DataEnd], meadpt)
}
# =======================

# ===================
# calculate my own sd
mysd = function(theVec, thePoint) {
    return(sqrt(mean((thePoint - theVec)^2)))
}
# ===================


# ===================
TrendValue <- function(PDataSet, DataStart, DataEnd){
  Xdata = 1:(DataEnd-DataStart+1)
  Ydata = PDataSet[DataStart:DataEnd]
  dataWidth = DataEnd-DataStart+1
  RegrFormula = lm(Ydata~Xdata)
  return(RegrFormula$coefficients[1] + dataWidth * RegrFormula$coefficients[2])
}

# =======================

# =======================
# calculate the stochastics of the dataset
Stoch <- function(stDataSet, stPeriod){
  StartPTR = 1
  LastPTR = length(stDataSet)
  stSet <<- rep(NA,length(stDataSet))
  Calcst(stDataSet, stPeriod, StartPTR, LastPTR)	# this is the cal function
  stSet[1:stPeriod] <<- stSet[stPeriod]	# makes header period nice
}

# =======================
Calcst <- function(stDataSet, stPeriod, StartP, LastPTR)
for(j in StartP:(LastPTR-stPeriod+1)){
  DataStart = j
  DataEnd = j+stPeriod-1
  stSet[DataEnd] <<- stValue(stDataSet, DataStart, DataEnd)
}
# =======================
stValue <- function(stDataSet, DataStart, DataEnd){
  Ydata = stDataSet[DataStart:DataEnd]
  stmin = min(Ydata)
  st.range = max(Ydata) - stmin
  st.now = Ydata[length(Ydata)]- stmin
  if(st.range == 0){st.range = 10000}
  return((Ydata[length(Ydata)]- stmin) * 100 / st.range)
}
# =======================


# ===========================
# for(codeNo in 1:lenMLCode){
# 	Url = paste0(theUrlHead, MLCode[codeNo], theUrlMid, theEndDate, theUrlTail)
# }


# use R to convert table to JSON and insert to html
library(ggplot2)

htmlHeader = '<html>\n<head>\n<meta http-equiv="Content-Type" content="text/html; charset="utf-8"><base target=_blank>\n<style>body { font-family: "Times New Roman", Times, serif; margin: 2%; font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none; color: #28B8B8;}a:visited { color: #389898;}A:hover { color: yellow;}A:focus { color: red;}code { color: pink; background-color: #001500}pre { font-family: "courier new", courier, monospace;
tab-size: 8; color: gray; background-color: #001010}.redrose { color: #cc0099} .redword { color: red} .yellowword { color: yellow} .greenword { color: lightgreen} .limeword { color: .00ff00} .orangeword { color: orange} .cyanword { color: cyan} .whiteword { color: white} .grayword { color: gray} .brownword { color: #ff8000} .yellowgreen { color: #bfff00} .palered { color: #ffcccc} .blueword { color: dodgerblue} .purpleword { color: darkorchid} .goldword { color: GoldenRod} .silverword { color: silver} .whitebord { color: red; border: 1px solid white; padding: 1px; font-size: 80%; border-radius: 2px;}  .yellowbord { color: green; border: 1px solid yellow; padding: 1px; font-size: 80%; border-radius: 2px;}</style>\n</head><body><br>\n<center>'

noteBk = htmlHeader
theRange = rep(0, lenMLCode)
for(codeNo in 1:lenMLCode){
	# theName is the data file to be downloaded
	cat(codeNo," ")
	theName = paste0(theUrlHead, MLCode[codeNo], theUrlMid, theStartDate, theDateConnector, theEndDate, theUrlTail)
	thetempData = read.csv(theName , encoding = "UTF-8", stringsAsFactors = F)

	if(codeNo %in% c(1,8,37,42,51,72,74,87:92,110:111)){
		theData = thetempData[c(1,4)]	# keep price columns only, all file formats not std
		theData[,1] = gsub(".*,", "", theData[,1])
	} else if(codeNo %in% c(93:109, 112)){
		theData = thetempData[c(2,5)]
	} else {
		theData = thetempData[c(2,4)]
	}

	colnames(theData) = c("Date","Price")

	theData$Date = as.Date(theData$Date)

	for(i in 1:length(theData$Price)){		# check for missing data
		if(is.na(as.numeric(theData$Price[i]))){
			if(i == 1){
				theData$Price[i] = min(theData$Price)
			} else {
				theData$Price[i] = theData$Price[i-1]		# replace with prev data
			}
		}
	}

	theData$Price = as.numeric(theData$Price)	# this is imp to avoid ggplot cracy

	saveRDS(theData, paste0(MLCode[codeNo],".Rda"))

# cal trends in main chart
	DynamCurv(theData$Price, RegrPeriod)		# 	PTVSet stores the result
	trend1Fc = PTVSet	
	DynamCurv(theData$Price, RegrPeriod * 2)		# 	PTVSet stores the result
	trend2Fc = PTVSet	
	SDV = PStd
	SDVT = trend2Fc + SDV
	SDVB = trend2Fc - SDV

	DynamCurv(theData$Price, RegrPeriod * 4)		# 	PTVSet stores the result
	trend4Fc = PTVSet	
	DynamCurv(theData$Price, RegrPeriod * 6)		# 	PTVSet stores the result
	trend6Fc = PTVSet	

	theData = cbind(theData, "T1" = trend1Fc, "T2" = trend2Fc, "T4" = trend4Fc,  "T6" = trend6Fc, "SDVT" = SDVT, "SDVB" = SDVB)

	title = paste0(MLCode[codeNo], " ", MLCodeName[codeNo])

	theplotData = filter(theData, Date > cutDate)

	g = ggplot(theplotData, aes(x=Date)) 
	g = g + geom_point(aes(y=Price), size = 0.6, color = "yellow", shape = 4, show.legend = TRUE) 
#	g = g + geom_line(aes(y=Price), colour="magenta2")
	g = g + geom_line(aes(y=T1), color="white")
	g = g + geom_line(aes(y=T2), color="yellow")
	g = g + geom_line(aes(y=T4), color="red")
	g = g + geom_line(aes(y=T6), color="yellowgreen")
	g = g + geom_line(aes(y=SDVT), color="gold", linetype = "dotted")
	g = g + geom_line(aes(y=SDVB), color="gold", linetype = "dotted")
	g = g + ggtitle(title)
 	g = g + theme(panel.background = element_rect(fill = "black"))
 	g = g + theme(panel.grid.minor = element_line(colour = "red", linetype = "dotted"))
 	g = g + theme(panel.grid.major = element_line(colour = "red", linetype = "dotted"))
 	g = g + theme(plot.background = element_rect(fill = "black"))
 	g = g + theme(plot.title = element_text(color="yellow"))

	jpgName = paste0(MLCode[codeNo],".jpg")
	jpeg(jpgName, width = 1200, height = 600)
	print(g)
	dev.off()


# calculate the energy and plot graph
	theFCL = (trend4Fc + trend6Fc) /2	# this is the avreage of short and long trends
	theDiff = theData$Price - theFCL	# this is the diff from trend
	DynamCurv(theDiff, RegrPeriod)	
	tT1 = PTVSet
	DynamCurv(theDiff, RegrPeriod * 2)	
	tT2 = PTVSet
	DynamCurv(theDiff, RegrPeriod * 4)	
	tT3 = PTVSet
	DynamCurv(theDiff, RegrPeriod * 8)	
	tT4 = PTVSet

	sdDV = PStd
	sdDVT = tT3 + sdDV
	sdDVB = tT3 - sdDV

	theFCL.df = data.frame("Date" = theData$Date, "theDiff" = theDiff, "tT1" = tT1, "tT2" = tT2, "tT3" = tT3, "tT4" = tT4, "sdDVT" = sdDVT, "sdDVB" = sdDVB)

	theplotFCL.df = filter(theFCL.df, Date > cutDate)

	fc = ggplot(theplotFCL.df, aes(x=Date)) 
	fc = fc + geom_point(aes(y=theDiff), size = 0.5, color = "yellow", shape = 4, show.legend = TRUE) 
	fc = fc + geom_line(aes(y=tT1), color="white")
	fc = fc + geom_line(aes(y=tT2), color="yellow")
	fc = fc + geom_line(aes(y=tT3), color="red")
	fc = fc + geom_line(aes(y=tT4), color="yellowgreen")
# 0 = blank, 1 = solid, 2 = dashed, 3 = dotted, 4 = dotdash, 5 = longdash, 6 = twodash
	fc = fc + geom_line(aes(y=sdDVT), color="gold", linetype = 3)
	fc = fc + geom_line(aes(y=sdDVB), color="gold", linetype = 3)
	fc = fc + geom_hline(aes(yintercept=0), color="gray")
 	fc = fc + theme(panel.background = element_rect(fill = "black"))
 	fc = fc + theme(panel.grid.minor = element_line(colour = "red", linetype = "dotted"))
 	fc = fc + theme(panel.grid.major = element_line(colour = "red", linetype = "dotted"))
 	fc = fc + theme(plot.background = element_rect(fill = "black"))

	jpgName.sd = paste0(MLCode[codeNo],"_sd.jpg")
	jpeg(jpgName.sd, width = 1200, height = 300)
	print(fc)
	dev.off()


#  create the stochastics values and make graph
	stPeriod = 8
	Stoch(theData$Price, stPeriod)		# 	PTVSet stores the result
	st1Set = stSet
	DynamCurv(st1Set, stPeriod)	
	stT1 = PTVSet
	Stoch(theData$Price, stPeriod * 2)		# 	PTVSet stores the result
	st2Set = stSet	
	DynamCurv(st2Set, stPeriod)	
	stT2 = PTVSet	
	Stoch(theData$Price, stPeriod * 4)		# 	PTVSet stores the result
	st4Set = stSet
	DynamCurv(st4Set, stPeriod)	
	stT4 = PTVSet


	thestSet.df = data.frame("Date" = theData$Date, "T1" = stT1, "T2" = stT2, "T3" = stT4)

	theplotstSet.df = filter(thestSet.df, Date > cutDate)

	sth = ggplot(theplotstSet.df, aes(x=Date)) 
	sth = sth + geom_line(aes(y=T1), color="white")
	sth = sth + geom_line(aes(y=T2), color="yellow")
	sth = sth + geom_line(aes(y=T3), color="red")
	sth = sth + geom_hline(aes(yintercept=0), color="gray")
	sth = sth + geom_hline(aes(yintercept=50), color="gray")
	sth = sth + geom_hline(aes(yintercept=100), color="gray")
 	sth = sth + theme(panel.background = element_rect(fill = "black"))
 	sth = sth + theme(panel.grid.minor = element_line(colour = "red", linetype = "dotted"))
 	sth = sth + theme(panel.grid.major = element_line(colour = "red", linetype = "dotted"))
 	sth = sth + theme(plot.background = element_rect(fill = "black"))

	jpgName.st = paste0(MLCode[codeNo],"_st.jpg")
	jpeg(jpgName.st, width = 1200, height = 300)
	print(sth)
	dev.off()


# stat about the ranges
	maxP = as.numeric(max(theData$Price))
	minP = as.numeric(min(theData$Price))
	RangePct = round((maxP - minP)*100/maxP,1)
	theRange[codeNo] = RangePct

	dropNotes(paste0("<img src='", jpgName,"' width = '800'><br>"))
	dropNotes(paste0("<img src='", jpgName.sd,"' width = '800'><br>"))
	dropNotes(paste0("<img src='", jpgName.st,"' width = '800'><br>"))
	dropNotes(paste0("<br>", title, "\n"))
	dropNotes(paste0("<br>\nMinimun: ", min(theData$Price), "\tMaximun: ", max(theData$Price), "\tRange: ", round((maxP - minP),2), "\tRange%: ", RangePct, "<br><br>\n"))
}

# give a final summary of Ranges

out <- capture.output(summary(theRange))
dropNotes("<pre>Range Distribution:\n")
dropNotes(paste0(out, sep = '\n'))
dropNotes(paste0("\n", MLCode[head(order(-theRange), 8)], "\n", MLCodeName[head(order(-theRange), 8)]))	# list the widest ranges 
dropNotes(paste0("</pre>", "\n"))

# generate the html

sink("MLFundStat.html")
cat(noteBk)
sink()

# view the result

startstr="start chrome.exe --start-fullscreen "

shell(paste0(startstr, dirStr,"/", paste0("\"MLFundStat.html\"")))


# ggplot(test_data, aes(date)) + geom_line(aes(y = var0, colour = "var0")) + geom_line(aes(y = var1, colour = "var1"))

# cannot direct print text to pdf, must use some package like sweave etc
# so it is better to use html with jpg image

# create html header, generat the jpgs and titles, the jpgs of 6fc, and jpg of xxfc
# cal the trends

# add the time stamp to calculate time required