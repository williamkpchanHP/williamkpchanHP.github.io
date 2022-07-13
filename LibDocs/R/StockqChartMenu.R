rm(list = ls())
Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
options("encoding" = "UTF-8")

AChoice = "C:/R programs/mainMenu"
setwd(AChoice)
mainMenuDir= "C:/R programs/mainMenu"
Select = "a"
source("C:/R programs/mainMenu/showcolor.R")
source("C:/R programs/mainMenu/stockQ.R")
source("C:/R programs/!!! STKMon !!!/stockQUrl.R")
worldStkChartHeader = readLines("C:/R programs/!!! STKMon !!!/worldStkChartHeader.html")
mainMenu <- c("stock", "commodity", "forex", "other Index", "batch job")

readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		key = readline(prompt="Enter your choice: ")
		if(key == "0" | key == "as.raw(27)") {break}
	}

	return(strtoi(key))
}

runBatch = function(){
  for(i in 1:nrow(batchIdx)){  # batchIdx is array of arrays
    theSeleted = batchIdx[i,1]
    itemName = batchIdx[i,2]
    groupNo = batchIdx[i,3]  # since header is diff for diff group
    dataArr = readStockqUrl(theSeleted, groupNo)
    outputName = paste0("StkChart", theSeleted, ".html")
    sink(outputName)
    cat(worldStkChartHeader, sep="\n")
    cat("stkpriceDataArr = [")
    cat(dataArr, sep=",")
    cat("]\n")
    cat('theStartCode = "', theSeleted,'"\n')
    cat('stkName = "', itemName,'"\n')
    cat('redraw()\n</script>\n</body>\n</html>\n')
    sink()
    shell(outputName)  # note not to include pathname
  }
}

exitCode = " "
while(exitCode != ""){
    # show first menu
    cat(green("==========================\n"))
    disp1ColMenu()
    keyin <- length(mainMenu) +1
    
    while(keyin >length(mainMenu) | keyin<1){
        cat("\nSelect the item you want: \n")
        keyin <- readkey()
    }
    
    cat("\n\nSelected: ", mainMenu[keyin],"\n\n")
    groupNo = keyin
    theSeleted = mainMenu[keyin]
    if( keyin == 1){
      themenu = stockIdxMenu
    }else if( keyin == 2){
      themenu = commodityIdxMenu
    }else if( keyin == 3){
      themenu = forexIdxMenu
    }else if( keyin == 4){
      themenu = otherIdxMenu
    }else if( keyin == 5){
      runBatch()
      cat(red("\nJob completed!\n"))
      break
    }else if( keyin == 6){
      break
    }
    
    
    # show second menu
    cat(theSeleted)
    dispMColMenu(themenu)
    
    keyin <- nrow(themenu) +1
    
    while(keyin >nrow(themenu) | keyin<1){
        cat("\nSelect the item you want: \n")
        keyin <- readkey()
    }
    cat("\n\nSelected: ", themenu[keyin, ],"\n\n")
    theSeleted = themenu[keyin,1]
    dataArr = readStockqUrl(theSeleted, groupNo)
    
    outputName = "StkChart.html"
    sink(outputName)
    cat(worldStkChartHeader, sep="\n")
    cat("stkpriceDataArr = [")
    cat(dataArr, sep=",")
    cat("]\n")
    cat('theStartCode = "', themenu[keyin, ],'"\n')
    cat('stkName = "', theSeleted,'"\n')
    cat('redraw()\n</script>\n</body>\n</html>\n')
    sink()
    shell(outputName)  # note not to include pathname
    cat(red("hit esc to exit!\n"))
}
