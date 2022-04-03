# htis is the workhorse for collectXhamPhotos.R
# retrieveFile
  retrieveFile <- function(urlAddr){
    retryCounter = 1
    cat("retrieving urlAddr: ", urlAddr, "\n") 
    while(retryCounter < 5) {
      cat("...try ",retryCounter) 
      retriveFile <- tryCatch(read_html(urlAddr, warn=F, encoding = "UTF-8"), 
                        warning = function(w){
                         cat("code param error ");
                         return("code param error")
                        }, 
                        error = function(e) {
                          if(grepl("Error in open.connection", e)){
                            cat("Error in open.connection ")
                            return("Error in open.connection")
                          }else if(grepl("Error in doc_parse_raw", e)){
                            cat("Error in open.connection ")
                            return(read_html(urlAddr, warn=F))
                          }else{
                            cat("code param error ")
                            return("code param error")
                          }
                        }
                     )
      if (grepl("code param error", retriveFile)) {
        cat("Error in connection, try 5 secs later!\n")
        retryCounter <- retryCounter + 1
        retriveFile = ""  # if end of loop this will be returned
      }else if(grepl("Error in open.connection", retriveFile)){
        cat("unable to connect!\n")
        urlAddr = "http://news.rthk.hk/rthk/ch/latest-news.htm" # unable to connect, so use phantom url to bypass
        # return("")
      }else{
        retryCounter = 200  # to jump out of loop
      }
    }
    return(retriveFile)
  }

# collect imgs, all results stay in allPhotoList
collectImgs <- function(links){
    linkIndex = 0
    for (page in links){
      linkIndex = linkIndex + 1

      now_time <- unclass(as.POSIXlt(Sys.time()))
      collectStartTime <- now_time[3]$hour*3600 + now_time[2]$min*60 + now_time[1]$sec 

      cat(red("\ncollect image cabinet", linkIndex), "of", length(links))
      cat(".. pageURL: ", page, "\n")

      pagesource <- retrieveFile(page)
      className = "div.card a"
      keywordList <- html_nodes(pagesource, className)
      photoList <- as.character(html_attr(keywordList, "href"))
      cat(yellow("\nfound num of imgs:", length(photoList), "\n"))
       if(length(photoList)>0){
             allPhotoList <<- c(allPhotoList, photoList)
             cat(blue("number of all collected imgs: ", length(allPhotoList), " "))
             if(uniqueFlag == TRUE){
               allPhotoList <<- unique(allPhotoList)
               cat(green("unique number of all collected imgs: ", length(allPhotoList), " "))
             }
       }else{ cat(yellow("no imgs ")) }

       now_time <- unclass(as.POSIXlt(Sys.time()))
       collectEndTime <- now_time[3]$hour*3600 + now_time[2]$min*60 + now_time[1]$sec 
       timdDiff = collectEndTime - collectStartTime
       cat(green(" time lapse:", format2digit(timdDiff), "secs\n"))
    }

}

# collect links inside page and call collectImgs
collectLinks <- function(allPageHeader){
    linkIndex = 0
    allLinkLen = length(allPageHeader)
    for (urlAddr in allPageHeader){
      linkIndex = linkIndex + 1
      cat(yellow("\ncollect link info...", linkIndex, "of", allLinkLen, "\nurlAddr: ", urlAddr, "\n"))
      pagesource <- retrieveFile(urlAddr)
      className = ".below-pageform small"
      keywordList <- html_nodes(pagesource, className)
      links <- as.character(keywordList[1])

      if(length(links) != 0){
        lastLineNum = gsub("<small>of ", "", links)
        lastLineNum = gsub("</small>", "", lastLineNum)
        lastLineNum = as.numeric(lastLineNum)

        links = urlAddr
        for(num in 2:lastLineNum){
          newlinks = paste0(urlAddr, "page/",num)
          links = c(links, newlinks)
        }
      }else{
        links = urlAddr
      }

      cat("\n\nfound links: ",links, sep="\n")
      allLinkList <<- c(allLinkList, links)
      cat(red("total links: ", length(allLinkList), "\n"))
    }
}

# collect albums, all results stay in allAlbumList
collectAlbums <- function(links){
    for (page in links){
      cat(yellow("\nalbumURL: ", page, "\n"))
      pagesource <- retrieveFile(page)
      className = "a.card-link[href]"
      keywordList <- html_nodes(pagesource, className)
      albumList <- as.character(html_attr(keywordList, "href"))
      cat(blue("found albumList: ", length(albumList), "  "))
      allAlbumList <<- c(allAlbumList, albumList)
    }
    cat(red("total allAlbumList: ", length(allAlbumList),"\n"))
}

# format2digit
format2digit  = function(value){ sprintf(value, fmt = '%#.2f')}

