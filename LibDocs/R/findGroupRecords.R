# prepare to detect multiple groups in kline check: upXWA cXWA 3X6
# this is for inspection of single stk

rm(list = ls())
options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')    # this must be added to script to show chinese
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
  gray  <- make_style("#385E6D")
  blue  <- make_style("#12BBEC")
  gold <- make_style("#eeae00")

  folderName = "C:/Users/User/Desktop/Imp Mon Data/"
  setwd(folderName)
  groupRecord <<- readLines("filterResulitLib.txt",  encoding="UTF-8", warn = FALSE)

 # askForCode
   askForCode <- function(){
     Selection = ""
     while(Selection == ""){
       cat("\n")
       Selection <- readline(prompt="Find group records, enter code: ")
       Selection <- gsub(" ","",Selection)

       if((Selection!="") & (Selection!=" ")){
           if(is.na(suppressWarnings(as.numeric(Selection)))){ # avoid mis typing or by special names
             if(Selection %in% signalList){ return(Selection) } # signalList is names of signals
             else{Selection == ""}
           } else{
             if(nchar(Selection)<5){
               Selection = paste0("00000",Selection)
               Selection = substr(Selection, nchar(Selection)-4, nchar(Selection))
             }
           }
           return(Selection)
       }
     }
  }

 # showResults
   showResults <- function(theCode){
     pointer = grep(theCode, groupRecord)
     theResults = groupRecord[pointer]
     theResults = gsub("^.*?>2", "2", theResults)
     theResults = gsub("</.*", "", theResults)
     cat(theResults, sep="\n")
   }

# loop for service
    cat(gold("\nFind group records"))
    looping = TRUE
    while(looping){
      cat("\n")
      keyword = askForCode()
      showResults(keyword)
    }
    cat("Exited program!\n")