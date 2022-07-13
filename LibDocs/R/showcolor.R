library(crayon)
  ligSilver <- make_style("#889988")
  lime <- make_style("#10ff10")
  purple <- make_style("#9400D3")
  deeppink <- make_style("#FF1493")
  darkgreen <- make_style("#004000")
  magenta  <- make_style("#800080")
  orange  <- make_style("#E6971E")
  pink  <- make_style("#FFB6C1")
  brown  <- make_style("#DF7E43")
  gray  <- make_style("#8F8F8F")
  cyan  <- make_style("#42A783")
  puzzle  <- make_style("#CFCE90")
  paleYel  <- make_style("#E7D9A5")

  dispMenu = function(mainMenu){
    cat("\nselect yout option..\n")
    cat("=====================================\n\n")
    for(scriptNo in 1:nrow(mainMenu)){
        remainder = scriptNo %% 4
        if(remainder==0){
          cat(scriptNo, puzzle(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\n"))
        }else if(remainder==1){
          cat(scriptNo, paleYel(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\n"))
        }else if(remainder==2){
          cat(scriptNo, cyan(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\n"))
        }else{
          cat(scriptNo, brown(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\n"))
        }
    }
  }

  dispMColMenu = function(mainMenu){
    cat("\nselect yout option..\n")
    cat("=====================================\n\n")
    for(scriptNo in 1:nrow(mainMenu)){
        lineremainder = scriptNo %% 3
        if(lineremainder==0){ cat("\n") }

        remainder = scriptNo %% 4
        if(remainder==0){
          cat(scriptNo, puzzle(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\t"))
        }else if(remainder==1){
          cat(scriptNo, paleYel(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\t"))
        }else if(remainder==2){
          cat(scriptNo, cyan(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\t"))
        }else{
          cat(scriptNo, brown(mainMenu[scriptNo,2], "\t", mainMenu[scriptNo,1], "\t"))
        }
    }
  }


  disp1ColMenu = function(){
    for(optNo in 1:length(mainMenu)){
        remainder = optNo %% 4
        if(remainder==0){
          cat(optNo, puzzle(mainMenu[optNo], "\n"))
        }else if(remainder==1){
          cat(optNo, paleYel(mainMenu[optNo], "\n"))
        }else if(remainder==2){
          cat(optNo, cyan(mainMenu[optNo], "\n"))
        }else{
          cat(optNo, brown(mainMenu[optNo], "\n"))
        }
    }
  }
