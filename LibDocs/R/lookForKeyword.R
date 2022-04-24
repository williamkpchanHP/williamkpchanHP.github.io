# 210702 modify to print higlighted keyword
# program to seek key words in a list
# ask for key word
# read the file
# grep the list
# show result
# 200718 add function to include file in any locations !!

setwd("C:/R programs/Learning Exercise/QuizData")
options("encoding" = "native.enc")
#options("encoding" = "UTF-8")
Sys.setlocale(category = 'LC_ALL', 'Chinese') # this must be added to script to show chinese
library(crayon)
  ligSilver <- make_style("#889988")
  lime <- make_style("#10ff10")
  purple <- make_style("#9400D3")
  deeppink <- make_style("#FF1493")
  darkgreen <- make_style("#004000")
  magenta  <- make_style("#800080")
  orange  <- make_style("#D93B6A")
  pink  <- make_style("#E98B8A") # note dont change this code
  brown  <- make_style("#B8937C")
  gray  <- make_style("#302E4D")
  blue  <- make_style("#12BBEC")

# askForkeyword
  askForkeyword <- function(){
     options("encoding" = "native.enc")
     Selection = ""
     while(Selection == ""){
       cat("\n")
       Selection <- readline(prompt="enter the keyword: ")
       if((Selection!="") & (Selection!=" ")){
         if(Selection==":ct:"){
           ChooseTable()
           return(":changetable:")
         }else{
           return(Selection)
         }
       }
     }
  }
# showResults
  showResults <- function(){
    listPtr = 1
    while(listPtr <= length(resultLines)){
      cat(cyan(resultLines[listPtr],"\t"))
      #theLine = gsub("`", " ", dictList[resultLines[listPtr]])
      #theLine = unlist(strsplit(theLine, keyword))
      #cat(ligSilver(theLine[1]), yellow(keyword), ligSilver(theLine[2]), sep="")
      cat(ligSilver(gsub("`", " ", dictList[resultLines[listPtr]])))
      cat("\n") # to avoid extra space in the preceeding line

      if((listPtr %% 5 == 0)&(listPtr>0)){
        Selection <- readline("Type 'n' to skip, others to continue: ")
        if(Selection==("n")){
          listPtr = length(resultLines)+1
        }
      }
      listPtr = listPtr + 1
    }
  }

# printHtml
  printHtml <- function(){
        dictList = gsub(keyword, paste0("<span class='yellow'>",keyword,"</span>"), dictList, ignore.case = TRUE)

        thisFilename = "searchResult.html"

        options("encoding" = "UTF-8")
        sink(thisFilename)
          cat(
            '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n',
            '<link rel="stylesheet" href="https://williamkpchan.github.io/maincss.css">\n', 
            '<style>body{width:90%;margin-left: 5%; font-size:18px;}</style>\n',
            '<script src="https://williamkpchan.github.io/mainscript.js"></script>\n',
            '<body onkeypress="chkKey()">\n',
            '<pre><br>')
          for(i in 1:length(resultLines)){
            cat("<br><br><span class='blue'>",resultLines[i],"</span>\t", sep="")
            cat(dictList[resultLines[i]], sep = "<br><br>")
          }
        sink()
        shell(thisFilename)
        options("encoding" = "native.enc")
  }
 # c Choose Table
  ChooseTable <- function(){
cat("\n\n\nAvailable Tables.\n")
cat("=====================================\n\n")
for(QNo in 1:length(QuizTab)){
cat(QNo, QuizTab[QNo], "\t\t")
if(QNo%%3 == 0){cat("\n")} # 3 items per line
}
quizN <- length(QuizTab) +1
while((quizN >length(QuizTab) | quizN<1)&&(quizN != 999)){
key = ""
while(is.na(suppressWarnings(as.numeric(key)))){
key = readline(prompt="999 Input Table Number: ")
   if(key == "as.raw(27)") {break}
}
quizN <- as.numeric(key)
}
     if(quizN == 999) {
extFilename <<- file.choose()  # load external file
dictList <<- readLines(extFilename, encoding="UTF-8", warn = FALSE)
          cat("\n\nTable Selected: ", extFilename,"\n\n")
}else{
 quizNo <<- quizN
 cat("\n\nTable Selected: ", QuizTab[quizNo],"\n\n")
 dictList <<- readLines(QuizTabFile[quizNo], encoding="UTF-8", warn = FALSE)
}
  }

# Program Init
 QuizTabName = "QuizTableList.txt"
 extFilename = QuizTabName

 QuizTab <- readLines(QuizTabName, encoding="UTF-8", warn = FALSE)
 QuizTabFile <- paste0(QuizTab, ".txt")
 quizNo = 1
 dictList = readLines(QuizTabFile[quizNo], encoding="UTF-8", warn = FALSE)

# main body
looping = TRUE
while(looping){
  cat("\n")
  keyword = askForkeyword()
  options("encoding" = "native.enc")
  dictList <<- readLines(QuizTabFile[quizNo], encoding="UTF-8", warn = FALSE) # refresh table every time
  resultLines = grep(keyword, dictList, ignore.case=TRUE)
  if(length(resultLines)==0){
    cat("No Records Matched!\n")
  }
 
 if(length(resultLines)>0){
      cat(gray("Table name: ", extFilename), red(" total matched: ",length(resultLines)))
      confirmY = readline("Type 'y','0' to continue, 'p','1' to print file, others to skip: ")
      if((confirmY=="y")|(confirmY=="0")){
        showResults()
        printHtml()
      }else if((confirmY=="p")|(confirmY=="1")){
        thisFilename = "searchResult.txt"
        sink(thisFilename)
          for(i in 1:length(resultLines)){
            cat(resultLines[i],"\t")
            cat(dictList[resultLines[i]], sep = "\n")
          }
        sink()
        shell(thisFilename)
        printHtml()
      }else{
        cat("Result table is skipped!\n")
      }
  }else{
   showResults()
  }
  cat(blue(":ct:"),brown("total counts: "),deeppink(length(resultLines)))
}
