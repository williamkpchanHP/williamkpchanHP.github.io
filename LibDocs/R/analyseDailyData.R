# Object: to understand some features and critical point of unexpected actions
#  by sorting and analyse daily scenarios from datasets:
#  the stat mylist, TDX rpt + prev TDX rpt
# 
# Flow Chart: 
#  clean up stat mylist, remove leading spaces, remove lines with (:)
#  sort the activity list by unique codes
# 
#  read database file, 
#  clean up to keep code, name, amt and diff and create new database
# 
#  loop to check diff > +/- 2%
#  list out results with sorting
# 
#  read prev database to extract prev amt
# 
#  generate html report
#  +/- to flip pages, from max diff to less diff
#  showing 
#  code, name, prev amt, today max/min, the max/min minute amt, ave amt
#  activities list
# 

# set language
  options("encoding" = "native.enc")
   # options("encoding" = "UTF-8")

  Sys.setlocale(category = 'LC_ALL', 'Chinese')

# set up
  dirStr = "D:/yhzq/T0002/export"
  setwd(dirStr)
  library(stringr)

# support functions
  filterQuote <- function(stkList){	# this is to remove quote characters in stk names
	return(gsub("'", "_", stkList))
  }

# process activity list
  # just list out the codes with records
   cat("\nSelect today's activity list (amtAlm)...\n")
   actListName <- file.choose()

  # show start time
   cat(format(Sys.time(), "%H:%M:%OS"),"\n")

  # actListName = strsplit(basename(actListName), "\\.")[[1]][1]
   cat("\nactivity list is: ",actListName,"\n")
   activityList = filterQuote(readLines(actListName)) # remove quote characters
   rawActivityList = activityList

   activityList = rawActivityList
   activityList = gsub("^ +", "", activityList)	# remove blank spaces

   removeLines = grep("^$",activityList)	# remove blank lines
   activityList = activityList[-removeLines]

   activityListCode = gsub("^.*C%  ", "", activityList)	# extract codes only
   activityListCode = str_replace(activityListCode, ".*\\b(\\d{5})\\b.*", "\\1")
   activityListCode = unique(activityListCode)	# remove duplicates

# process dataTableName
  cat("\nSelect today's dataTable ...\n")
  dataTableName <- file.choose()
  dataTableName = strsplit(basename(dataTableName), "\\.")[[1]][1]
  cat(dataTableName,"\n")
  dataTable = filterQuote(readLines(paste0(dataTableName,".txt")))

  allData = dataTable[-1]	# remove header
  allData = allData[-length(allData)]	# remove last line

  # usedata is today's data list with 5 columns
   usedata <- matrix(, nrow = length(allData), ncol = 5)

  # extract leading 5 columns
   for(i in 1:length(allData)){
	temp<- unlist(strsplit(allData[i],"\t"))
	usedata[i,]<- temp[c(1:5)]
   }

  # select the rangeData, less than -2 or above +2
   rangeData = suppressWarnings(usedata[which( (as.numeric(usedata[,3])>2)|(as.numeric(usedata[,3])<(-2)) ),])

  # singleOutCode is intersect of the activityList and rangeData
   singleOutCode = intersect(activityListCode, rangeData[,1])	# intersection

  # resultDataList is the final list extracted from pointed by singleOutCode
   resultDataList = rangeData[which(rangeData[,1] %in% singleOutCode),]
   resultDataList = resultDataList[order(-as.numeric(resultDataList[,3])),]	# this is ordered result

# read prev database to extract prev amt
  cat("\nSelect prev database ...\n")
  prevDBName <- file.choose()
  cat("\nactivity list is: ",prevDBName,"\n")
  prevDBNameList = filterQuote(readLines(prevDBName))
  prevData = prevDBNameList[-1]	# remove header
  prevData = prevData[-length(prevData)]	# remove last line

  useprevdata <- matrix(, nrow = length(prevData), ncol = 7)
  # extract leading 7 columns
   for(i in 1:length(prevData)){
	temp<- unlist(strsplit(prevData[i],"\t"))
	useprevdata[i,]<- temp[c(1:7)]
   }

# html report
# body content
# toc
# toc content: code, name, diff, amt, prev amt
# summary content: total above 2 pct, below 2 pct
  htmlHead = readLines("reportHeader.txt")
  htmlTail = readLines("reportTail.txt")
# create content
  htmlContent = ""
  for(i in 1:nrow(resultDataList)){
	thecode = resultDataList[i,1]
	thename = resultDataList[i,2]
	thediff = resultDataList[i,3]
	todayClose = resultDataList[i,5]
	storyHead = paste0("<h2>", thecode, " ", thename, " ", thediff, "</h2>")
	theAmt = round(as.numeric(resultDataList[i,4])/10000, digits=0)

	PrevLine = useprevdata[match(thecode, useprevdata[,1]),]
	prevAmt = round(as.numeric(PrevLine[4])/10000, digits=0)
	prevClose = PrevLine[5]	# prev table, use day close
	story = paste0(storyHead, "<b onclick=sCtmin(\"", thecode, "\")>","Today</b> Amt: ", theAmt, " Prev Amt: ", prevAmt, " Prev Close: ", prevClose, " Today Close: ", todayClose,' <a href="http://www.aastocks.com/tc/stocks/analysis/transaction.aspx?symbol=',thecode,'">xact</a><br><br><img src="http://charts.aastocks.com/servlet/Charts?fontsize=12&15MinDelay=T&lang=1&titlestyle=1&vol=1&Indicator=3&indpara1=5&indpara2=10&indpara3=15&indpara4=20&indpara5=25&subChart1=3&ref1para1=12&ref1para2=26&ref1para3=9&subChart2=2&ref2para1=14&ref2para2=0&ref2para3=0&scheme=3&com=100&chartwidth=1200&chartheight=600&stockid=', thecode, '&period=5012&type=1&logoStyle=1"><br>')

	linenums = grep(thecode, rawActivityList)	# the location of the note

	# compare search result with topic ranges to check within topic ranges

	storyLines = vector()
	for(counter in 1:length(linenums)){
		storyLine = paste0(rawActivityList[linenums[counter]],"<br>")
		storyLines =  c(storyLines, storyLine)
	}

	storyLines = paste(storyLines, collapse = '')
	story = paste0("'",story, storyLines,"',\n")
	htmlContent = c(htmlContent, story)
  }

# create output
  outputFilename = paste0(dataTableName," activity.html")
  options("encoding" = "UTF-8")

  sink(outputFilename)
  cat(htmlHead, htmlContent, htmlTail, sep="\n")
  sink()

# show finish time
  cat(format(Sys.time(), "%H:%M:%OS"),"\n")

# show the report
  startstr="start chrome.exe --start-fullscreen \""
  shell(paste0(startstr, dirStr,"/", outputFilename))

# add prev close, add link to open chart
# 