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
       cat("\ncollect image page", linkIndex, "of", length(links),".. pageURL: ", page, "\n")
       pagesource <- tryCatch(readLines(page, warn=F), 
                        warning = function(w){return("")}, 
                        error = function(e) {return("")}
                     )

       #className = ".thumb-list__item a.video-thumb__image-container"
    
       photoLine <- grep("<script id='initials-script", pagesource)
       if(length(photoLine)>0){
         photoList = pagesource[photoLine]

         photoList = unlist(strsplit(photoList, '","'))
         allPhotoIndex = grep("1000.jpg", photoList)
         if(length(allPhotoIndex)>0){
           photoList = photoList[allPhotoIndex]

           photoList = unlist(strsplit(photoList, '":"'))
           allPhotoIndex = grep("1000.jpg", photoList)
           if(length(allPhotoIndex)>0){
             photoList = photoList[allPhotoIndex]

             photoList = gsub('http','<img class="lazy" data-src="http', photoList)
             photoList = gsub('\.jpg','\.jpg">', photoList)
             photoList = gsub('\\\\/','/', photoList)

             cat(blue("number of collected imgs: ", length(photoList), "\n"))
             allPhotoList <<- c(allPhotoList, photoList)
             cat(yellow("number of all collected imgs: ", length(allPhotoList), "\n"))
             allPhotoList <<- unique(allPhotoList)
             cat(green("unique number of all collected imgs: ", length(allPhotoList), "\n"))
           }else{
             cat(yellow("no imgs\n"))
           }
         }else{
           cat(yellow("no imgs\n"))
         }
       }else{
         cat(yellow("no imgs\n"))
       }
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
      className = ".xh-paginator-button "
      keywordList <- html_nodes(pagesource, className)
      links = html_attr(keywordList, "href")
      linksline = grep("https", links)
      links = links[linksline]

      if(length(links) != 0){
        lastLine = links[length(links)]
        lastLineNum = as.numeric(gsub("http.*/", "", lastLine))

        links = urlAddr
        for(num in 2:lastLineNum){
          newlinks = paste0(urlAddr, "/", num)
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
       pagesource <- readLines(page)

       albumLine <- grep("<script id='initials-script", pagesource)
       albumList = pagesource[albumLine]

       albumList = unlist(strsplit(albumList, 'pageURL":"'))
       albumList = unlist(strsplit(albumList, '","'))
       albumList = gsub('\\\\/','/', albumList)
       allPhotoIndex = grep("photos/gallery", albumList)
       albumList = albumList[allPhotoIndex]
       cat(blue("found albumList: ", length(albumList), "  "))
       allAlbumList <<- c(allAlbumList, albumList)
    }
    cat(red("total allAlbumList: ", length(allAlbumList),"\n"))
}
