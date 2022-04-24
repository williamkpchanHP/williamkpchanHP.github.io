# QuizTableList.txt must have at least 100 items

# support services list
 # ReadCmd read key inputs
 # readkey
 # speakIt
 # maintenance
 # Choosequiz Choose quiz set
 # normSel Selection Begin

# startRolling
 # control board
 # Init here
 # Check file exists here
 # ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==
 # frontend
 # while(Selection != "")

 # ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==
 # backend processor
 # ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==  ==
 # CMD List:
 # c Choose quiz set
 # s Swap questions and answers
 # o turn On/Off TTS
 # t Type answers
 # g choose Grades
 #   choose no of questions
 # b Begin quiz
 # n New quiz set
 # x Exit
 #    SelectRatio, to change the selection ratio
 #    quizSet is the default selection mode
# ParseIt function
 ParseIt <- function(Selection){
  # set to 1.9, 9
    if(Selection  ==  "9") {
       source("C:/R programs/Learning Exercise/setTo1.9.R")
       theScore <<- readLines(theScoreTable, warn = FALSE)
     }

  # reset 1.9 and set some 1s, 1
    if(Selection  ==  "1") {
       source("C:/R programs/Learning Exercise/reset1.9.R")
       theScore <<- readLines(theScoreTable, warn = FALSE)
     }

  # select Quiz, c
    if(Selection  ==  "c") {Choosequiz()}

  # swap Ques and ans, s
    if(Selection  ==  "s") {
        quizSet <<- 1
        oldSelectSwap = SelectSwap
        if(oldSelectSwap  == "y"){ # had already swap
            SelectSwap <<- "n"
        } else if(oldSelectSwap  == "n"){    # had not yet swap
            SelectSwap <<- "y"
        }
    }

  # turn on TTs
    if(Selection  ==  "o") {# turn on TTs
        oldSelectSpeech = SelectSpeech
        if(oldSelectSpeech  == "y"){ # had already swap
            SelectSpeech <<- "n"
        } else {                # had not yet swap
            SelectSpeech <<- "y"
        }
    }
  # type answer, t
    if(Selection  ==  "t") {# type answer
        oldSelectTans = SelectTans
        if(oldSelectTans  == "y"){ # had already swap
            SelectTans <<- "n"
        } else if(oldSelectTans  == "n"){    # had not yet swap
            SelectTans <<- "y"
        }
    }
  # change praxis, p
    if(Selection  ==  "p") {
        oldselPraxis = selPraxis
        if(oldselPraxis  == "y"){ # had already swap
            selPraxis <<- "n"
        } else {                # had not yet swap
            selPraxis <<- "y"
        }
    }
  # choose grades, g
    if(Selection  ==  "g") {# choose grades
        cat("\n\n Choose your Quiz Pool:\n",
            "1 star :", length(which(theScore  ==  "1")),
            "\n 2 stars:", length(which(theScore  ==  "2")),
            "\n 3 stars:", length(which(theScore  ==  "3")),
            "\n 4 stars:", length(which(theScore  ==  "4")),
            "\n 5 stars:", length(which(theScore  ==  "5")),
            "\n 6 stars:", length(which(theScore  ==  "6")),
            "\n 7 stars:", length(which(theScore  ==  "7")),
            "\n 8 revision mode"
        )
        quizSet <<- readkey()
    }
  # maintenance, m
    if(Selection  ==  "m") {
        maintenance()
    }

  # select seek dictionary, d
    if(Selection  ==  "d") {lookForKeys()}

  # change selection ratio, r
    if(Selection  ==  "r") {
         key = ""
         while(is.na(suppressWarnings(as.numeric(key)))){
            key = readline("Enter selection ratio: ")
            if(key  ==  "as.raw(27)") {break}
         }
         key = as.numeric(key)
         SelectRatio <<- key
         if(key < 5){SelectRatio <<- 5}
         cat("selection ratio: ", SelectRatio, "\n")
    }

  # this is the create list action
    if(Selection  ==  "a") {
        cat("\n")
        cat("addRev2: ",addRev2, " addRev3: ",addRev3, " addRev4: ",addRev4, " addRev5: ",addRev5, " addRev6: ",addRev6,"\n")
         cat("new value for addRev2: ")
         addRev2 <<- readkey()
         cat("new value for addRev3: ")
         addRev3 <<- readkey()
         cat("new value for addRev4: ")
         addRev4 <<- readkey()
         cat("new value for addRev5: ")
         addRev5 <<- readkey()
         cat("new value for addRev6: ")
         addRev6 <<- readkey()
         cat("new values are:\n")
         cat("addRev2: ",addRev2, " addRev3: ",addRev3, " addRev4: ",addRev4, " addRev5: ",addRev5, " addRev6: ",addRev6)
         readline(prompt="mission complete! press enter to continue.. ")
     }


  # Begin quiz, b
    if(Selection  ==  "b") {
        startRolling()
    }

 }


# support services
 # resetSwitches() reset all Switches
  resetSwitches <- function(){
    SelectSwap <<-"n"
    oldSelectSwap <<- "n"
    SelectTans <<-"n"
    SelectSpeech <<-"n"
    swapSelected <<- "n"
    TansSelected <<- "n"
    selPraxis <<- "n"
  }
 # ReadCmd wait for a key
  ReadCmd <- function(){
     cat(red(format(Sys.time(), "%H:%M"), "  round number: ",roundNo,"\n"))
    Selection <- readline(prompt="section complete! press enter to continue.. ")
    return(Selection)
  }
 # readkey read key inputs
  readkey = function(){
    key = ""
    while(is.na(suppressWarnings(as.numeric(key)))){
        key = readline(prompt="Please choose: ")
        if(key  ==  "") {key = "0"}
        if(key  ==  "as.raw(27)") {break}
    }
    # return(strtoi(key))  strtoi cannot convert decimal numbers
    return(as.numeric(strsplit(key, "")[[1]][1]))
  }
 # speakIt
  speakIt = function(Msg){
    if(SelectSpeech  == "y"){
        AlertMsg = paste0(AlertMsgHead, Msg, AlertMsgTail)
        if(audioSwith){ system(AlertMsg, invisible=TRUE, wait=FALSE) }
    }
  }


 # askForkeyword
  askForkeyword <- function(){
     Selection = ""
     while(Selection  ==  ""){
       Selection <- readline(prompt="enter the keyword: ")
       if(Selection!=" "){
         return(Selection)
       }
     }
  }
 # showResults
  showResults <- function(resultLines){
    for(i in 1:length(resultLines)){
      cat(resultLines[i], "\t")
      cat(unlist(strsplit(WordTableFIle[resultLines[i]], "`")), sep = "\n        ")
    }
  }

 # lookForKeys
  lookForKeys = function(){
    looping = TRUE
    while(looping){
      keyword = askForkeyword()
      if(keyword  ==  ""){
        looping = FALSE
      }else{
        resultLines = grep(keyword, WordTableFIle, ignore.case=TRUE)
        if(length(resultLines) == 0){
          cat("No Records!\n")
        }
        if((length(resultLines)<=50)&(length(resultLines)>0)){
          showResults(resultLines)
        }
        if(length(resultLines)>50){
          cat("Result too long!",length(resultLines))
          confirmY = readline("Type 'y' to continue, others to skip: ")
          if(confirmY == ("y")){
            showResults(resultLines)
          }else{
            cat("Result table is skipped!")
          }
        }
        cat("total counts: ",length(resultLines))
      }
    }
  }
 # maintenance
  maintenance = function(){
    mSelect = "as.raw(27)"
    while(Selection != "") {
        cat("\n\n\n",
        blue("\n", "Maintenance menu"),
        green("\n", " ==  ==  ==  ==  ==  ==  ==  == "),
        "\n", "c Check duplicate",    # completed
        "\n", "d DeLete list",    # completed
        "\n", "e find list Elements # Not complete!",
        "\n", "h cHop list # Not complete!",
        "\n", "n create New list",    # completed
        "\n", "b backup wordlist and score",
        #"\n", "m modify qty add to revision",    # completed
        "\n", "p Pick pool size",    # completed
        "\n", "A toggle audio",    # completed
        #"\n", "a Alter grade",    # completed
        "\n", "r Rename list # Not complete!",
        "\n", "x Exit","\n")    # completed

        mSelect <- readline(prompt="Select function: ")

        if((mSelect  ==  "as.raw(27)") | (mSelect  ==  "x"))     {
            cat(red("\n", "!!! maintenance process ended !!!\n"))
            break
        }

        # this is the create list action
         if(mSelect  ==  "n") {
            cat("\n")
            newListName <- readline(prompt="New List Name: ")
            if((newListName  ==  "as.raw(27)") | (newListName  ==  "")){
                cat("\nNo action!\n")
                return  
            } else{
                file.create(paste0(newListName, ".txt"), showWarnings = TRUE)
                QuizTab <- c(QuizTab, newListName)
                QuizTabFile <- c(QuizTabFile, paste0(newListName, ".txt"))
                sink(QuizTabName)
                cat(QuizTab, sep = "\n")
                sink()
                cat("\n", paste0(newListName, ".txt"), " created!\n")
                return
            }
         }

        # this backup word list and score
         if(mSelect  ==  "b") {
           file.copy("C:/R programs/Learning Exercise/QuizData/EnglishWordList.txt",
             "C:/R programs/!!! STKMon !!!/resultTable/LibDocs/EnglishWordList.txt",
             overwrite = TRUE)
           file.copy("C:/R programs/Learning Exercise/QuizData/EnglishWordListScore.txt",
             "C:/R programs/!!! STKMon !!!/resultTable/LibDocs/EnglishWordListScore.txt",
             overwrite = TRUE)
           cat(red("\n\nEnglishWordList.txt and EnglishWordListScore.txt backed up to resultTable/LibDocs\n\nCompleted!!\n\n"))
         }

        # this toggle audio
         if(mSelect  ==  "A") {
            cat("\n")
            audioSwith = !audioSwith
            cat(yellow("audio status has been set to:" , audioSwith, "\n"))
            return
         }

        # this change the trialNum
         if(mSelect  ==  "p") {
            cat("\n")
            cat(paste0("Current Pick Pool Size is :" , trialNum, "\n"))
            newtrialNum <- readline(prompt="New trialNum = ")
            if((newtrialNum  ==  "as.raw(27)") | (newtrialNum  ==  "") | (as.numeric(as.character(newtrialNum))< 5) ){
                cat("\nNo action!\n")
                return  
            } else{
                trialNum = as.numeric(as.character(newtrialNum))
                return  
            }
         }

        # this is the delete action
         if(mSelect  ==  "d") {
            cat("\n")
            cat("=====================================\n\n")
            for(QNo in 1:length(QuizTab)){
                cat(QNo, QuizTab[QNo], "\n")
            }

            quizN <- length(QuizTab)  +  1

            while(quizN > length(QuizTab) | quizN < 1){
                cat("\nSelect the List to delete: \n")
                quizN <- readkey()
            }
            # QuizTab
          # QuizTabFile
            quizNo <<- quizN
            selectedList <<- QuizTab[quizNo]
            cat("\nAre you sure to delete ", selectedList)
            confirm = readline(prompt="y / n : ")
            if(confirm  ==  "y") {
                QuizTab = QuizTab[-quizNo]
                sink(QuizTabName)
                cat(QuizTab, sep = "\n")
                sink()
                cat("\n", paste0(selectedList), "\n")
            } else{
                cat("\nNo Action Taken!\n")
            }
            return
         }

        # this alter grade
         if(mSelect  ==  "a") {
            cat("\n")
            searchWord = readline(prompt="Which word to alter? ")
            theLine = which(searchWord  ==  WordTable)
            cat(paste0("line number is ",theLine,", ", "the grade is ", theScore[theLine], "\n"))
            lineNo = readline(prompt="Enter the line number? ")
            if(lineNo  ==  theLine){
                toConfirm <- readline(prompt="type YES to confirm: ")
                if(toConfirm  ==  "YES"){
                    theScore[lineNo] = "1.1"
                    theScoretmp <- theScore
                    theScore <<- theScoretmp

                    cat(paste0("\nAction completed! the grade of ",searchWord, " is ",theScore[lineNo],"\n"))
                    sink(theScoreTable)
                    cat(theScore, sep = "\n")
                    sink()
                    return
                } else{
                    cat("No action taken!\n")
                    return  
                }
            } else{
                cat("incorrect line number!\n")
                return
            }
         }

        # this check the duplicates
         if(mSelect  ==  "c") {
            print(WordTable[duplicated(WordTable[,1]),])
            cat("\n")
            print(WordTable[duplicated(WordTable[,2]),])
            cat("\n")
         }
        #if(mSelect  ==  "e") {findEle(mSelect)}
    }
  }

 # Choose quiz set
  Choosequiz <- function(){
    cat("\n\n\nFollowings are available Quiz Tables.\n")
    cat("=====================================\n\n")

    for(QNo in 1:length(QuizTab)){
        cat(QNo, QuizTab[QNo], "\t\t")
        if(QNo%%3  ==  0){cat("\n")}
    }

    quizN <- length(QuizTab)  +  1

    while(quizN > length(QuizTab) | quizN < 1){
        key = ""
        while(is.na(suppressWarnings(as.numeric(key)))){
            key = readline(prompt="Select the quiz you want to try: ")
            if(key  ==  "as.raw(27)") {break}
        }
        quizN <- as.numeric(key)
    }

    quizNo <<- quizN

    theQuestionTable <<- QuizTabFile[quizNo]
    cat(getwd())
    cat("\n\ntheQuestionTable: ", theQuestionTable,"\n\n")
    WordTableFIle <<- readLines(theQuestionTable, encoding="UTF-8", warn = FALSE)

    WordTable <<- matrix(unlist(strsplit(WordTableFIle, split = "\\t")), ncol=2, byrow=TRUE)
    quizSet <<- 1
    resetSwitches()

    cat("\n\nSelected: ", QuizTab[quizNo],"\n\n")

  }
 # Selection Begin
  normSel <- function(){
    theQuesLst1 = which(theScore  ==  "1.1")    # select only grade 1
    theQuesLst2 = which(theScore  ==  "2.1")
    theQuesLst3 = which(theScore  ==  "3.1")
    theQuesLst4 = which(theScore  ==  "4.1")
    theQuesLst5 = which(theScore  ==  "5.1")
    theQuesLst6 = which(theScore  ==  "6.1")
    theQuesLst7 = which(theScore  ==  "7.1")

    if(length(theQuesLst1) != 0){
        theQuesIdx2 = sample(1:length(theQuesLst2), length(theQuesLst2)%/%SelectRatio, replace = FALSE)    # no repeating choices
        theQuesLst2 = theQuesLst2[theQuesIdx2]
    } else {
        theQuesLst2 = which(theScore  ==  "2.1")
    }

    if((length(theQuesLst1)  ==  0) & (length(theQuesLst2)  ==  0)){
        theQuesLst3 = which(theScore  ==  "3.1")
    } else {
        theQuesIdx3 = sample(1:length(theQuesLst3), length(theQuesLst3)%/%(SelectRatio*2), replace = FALSE)
        theQuesLst3 = theQuesLst3[theQuesIdx3]
    }

    if((length(theQuesLst1)  ==  0) & (length(theQuesLst2)  ==  0)  & (length(theQuesLst3)  ==  0)){
        theQuesLst4 = which(theScore  ==  "4.1")
    } else {
        theQuesIdx4 = sample(1:length(theQuesLst4), length(theQuesLst4)%/%(SelectRatio*4), replace = FALSE)
        theQuesLst4 = theQuesLst4[theQuesIdx4]
    }

    if((length(theQuesLst1)  ==  0) & (length(theQuesLst2)  ==  0)  & (length(theQuesLst3)  ==  0) & (length(theQuesLst4)  ==  0)){
        theQuesLst5 = which(theScore  ==  "5.1")
    } else {
        theQuesIdx5 = sample(1:length(theQuesLst5), length(theQuesLst5)%/%(SelectRatio*8), replace = FALSE)
        theQuesLst5 = theQuesLst5[theQuesIdx5]
    }

    if((length(theQuesLst1)  ==  0) & (length(theQuesLst2)  ==  0)  & (length(theQuesLst3)  ==  0) & (length(theQuesLst4)  ==  0) & (length(theQuesLst5)  ==  0)){
        theQuesLst6 = which(theScore  ==  "6.1")
    } else {
        theQuesIdx6 = sample(1:length(theQuesLst6), length(theQuesLst6)%/%(SelectRatio*16), replace = FALSE)
        theQuesLst6 = theQuesLst6[theQuesIdx6]
    }
    return(c(theQuesLst1, theQuesLst2, theQuesLst3, theQuesLst4, theQuesLst5, theQuesLst6))
  }
  # Selection Complete

 # refillPool(src, dest, qty)
  refillPool <- function(src, dest, qty){
    theSrcLst = which(theScore  ==  src) # this is only the pointer
    if((src == "1") & (dest == "1.9")){ # this limits the select range to most recent item
        #find max line of 1.9
        theInlineLst = grep("^1\\.9",theScore) # find all "1"s with decimals
        requireMoreOne = qty - length(theInlineLst) # if >0, means add more require

        # require more but not enough src
        if((requireMoreOne> 0) &(length(theSrcLst) < requireMoreOne)){
            cat(red("not enough 1s to replensh, require ", requireMoreOne, " avaliable: ", length(theOneList), "\n"))
        } else if(requireMoreOne> 0) {
            # so, this is normal condition, replensh required
            theSrcLst = theSrcLst[1:requireMoreOne]
        } else{
            # requireMoreOne < 0, no need to replensh, just add one to avoid err
            theSrcLst = theSrcLst[1]
        }
    }

    theSrcLstLen = length(theSrcLst)
    theDestLst = which(theScore  ==  dest) # this is also pointer list
    theDestLstLen = length(theDestLst)
    fillQty = qty - theDestLstLen

    if( theSrcLstLen < fillQty){fillQty = theSrcLstLen}

    if(( fillQty >0)&(theSrcLstLen>0)){
        randomSel = sample(1:theSrcLstLen, fillQty, replace = FALSE)    # no repeating choices
        theScore[theSrcLst[randomSel]] <<- dest
    }
  }
 # refill each grade
  refillfmBottom <- function(star){
    refillPool(star, paste0(star,".9"), pickPoolSize)
    refillPool(paste0(star, ".9"), paste0(star, ".8"), pickPoolSize)
    refillPool(paste0(star, ".8"), paste0(star, ".7"), pickPoolSize)
    refillPool(paste0(star, ".7"), paste0(star, ".6"), pickPoolSize)
    refillPool(paste0(star, ".6"), paste0(star, ".5"), pickPoolSize)
    refillPool(paste0(star, ".5"), paste0(star, ".4"), pickPoolSize)
    refillPool(paste0(star, ".4"), paste0(star, ".3"), pickPoolSize)
    refillPool(paste0(star, ".3"), paste0(star, ".2"), pickPoolSize)
    refillPool(paste0(star, ".2"), paste0(star, ".1"), 13)
  }
  refillfmTop <- function(star){
    refillPool(paste0(star, ".2"), paste0(star, ".1"), 13)
    refillPool(paste0(star, ".3"), paste0(star, ".2"), pickPoolSize)
    refillPool(paste0(star, ".4"), paste0(star, ".3"), pickPoolSize)
    refillPool(paste0(star, ".5"), paste0(star, ".4"), pickPoolSize)
    refillPool(paste0(star, ".6"), paste0(star, ".5"), pickPoolSize)
    refillPool(paste0(star, ".7"), paste0(star, ".6"), pickPoolSize)
    refillPool(paste0(star, ".8"), paste0(star, ".7"), pickPoolSize)
    refillPool(paste0(star, ".9"), paste0(star, ".8"), pickPoolSize)
    refillPool(star, paste0(star,".9"), pickPoolSize)
  }

 # refill all grades
  refillAll <- function(){
    if(length(which(theScore  ==  "1.1")) == 0){ # if no more 1.1 fill fm bottom
        for(i in 1:9){
            refillfmBottom("1")
        }
    }else{    # else fill fm top
        for(i in 1:9){
            refillfmTop("1")
        }
    }
    for(i in 1:9){
        refillfmBottom("2")
        refillfmBottom("3")
        refillfmBottom("4")
        refillfmBottom("5")
        refillfmBottom("6")
        refillfmBottom("7")
    }
  }

    # addRevisionList takes some quizes from this grade for revision purpose
     addRevisionList <- function(gradeList,qty){
        if(length(gradeList)>9){
            #cat("original: ", length(theQuesLst), " ")
            if(length(theQuesLst)>qty){
                theQuesLst <<- c(theQuesLst, gradeList[sample(1:length(gradeList), qty)])    # added qty revision
            }else{
                theQuesLst <<- c(theQuesLst, gradeList[sample(1:length(gradeList), 1)])    # added qty revision
            }
                theQuesLst <<- unique(theQuesLst)  # to amend the duplicate problem
            #cat("inside function", length(theQuesLst), " ")
        }
     }

# start to roll
 startRolling <- function(){
    refillAll()

    # this is not used
    #    preChoiceLst <<- switch(quizSet,
    #        which(theScore  ==  "1"),
    #        which(theScore  ==  "2"),
    #        which(theScore  ==  "3"),
    #        which(theScore  ==  "4"),
    #        which(theScore  ==  "5"),
    #        which(theScore  ==  "6"),
    #        which(theScore  ==  "7"))

    # make selection pool
     theQuesLst <<- switch(quizSet,
        which(theScore  ==  "1.1"),
        which(theScore  ==  "2.1"),
        which(theScore  ==  "3.1"),
        which(theScore  ==  "4.1"),
        which(theScore  ==  "5.1"),
        which(theScore  ==  "6.1"),
        which(theScore  ==  "7.1"),
        normSel()   # this is not used at all, other grades added in addRevisionList fuction
     )
    # begin to add revisions
     theQuesLst2 = which(theScore  ==  "2.1")    # to revise star 2
     theQuesLst3 = which(theScore  ==  "3.1")    # to revise star 3
     theQuesLst4 = which(theScore  ==  "4.1")    # to revise star 4
     theQuesLst5 = which(theScore  ==  "5.1")    # to revise star 5
     theQuesLst6 = which(theScore  ==  "6.1")    # to revise star 6
     theQuesLst2.2 = which(theScore  ==  "2.2")    # to revise star 2
     theQuesLst2.3 = which(theScore  ==  "2.3")    # to revise star 2
     theQuesLst3.2 = which(theScore  ==  "3.2")    # to revise star 3
     theQuesLst4.2 = which(theScore  ==  "4.2")    # to revise star 4
     theQuesLst5.2 = which(theScore  ==  "5.2")    # to revise star 5
     theQuesLst6.2 = which(theScore  ==  "6.2")    # to revise star 6

     if(quizSet  == "1"){
          if(length(theQuesLst2.3)>9){addRevisionList(theQuesLst2,addRev2)}
          if(length(theQuesLst3.2)>9){addRevisionList(theQuesLst3,addRev3)}
          if(length(theQuesLst4.2)>9){addRevisionList(theQuesLst4,addRev4)}
          if(length(theQuesLst5.2)>9){addRevisionList(theQuesLst5,addRev5)}
          if(length(theQuesLst6.2)>9){addRevisionList(theQuesLst6,addRev6)}
          if(length(which(theScore  ==  "1.1")) < pickPoolWith){addRevisionList(theQuesLst2, 1)}
     }
     if(quizSet  == "2"){
        addRevisionList(theQuesLst3,addRev3)
        addRevisionList(theQuesLst4,addRev4)
        addRevisionList(theQuesLst5,addRev5)
        addRevisionList(theQuesLst6,addRev6)
     }
     if(quizSet  == "3"){
        addRevisionList(theQuesLst4,addRev4)
        addRevisionList(theQuesLst5,addRev5)
        addRevisionList(theQuesLst6,addRev6)
     }
     if(quizSet  == "4"){
        addRevisionList(theQuesLst5,addRev5)
        addRevisionList(theQuesLst6,addRev6)
     }
     if(quizSet  == "5"){
        addRevisionList(theQuesLst6,addRev6)
     }

     # cat("final ", length(theQuesLst), " ")

     if(length(theQuesLst) <(trialNum +  1)){
        trialNum <- length(theQuesLst)
     }

     if(length(theQuesLst)  ==  0){
     # fillFromExtList    # codes to be completed
     }
    # this is the tick mark list
     marklist = rep(0, trialNum)
   
    # random select the question
    # this choose from theQuesLst
     chooseIdx <- sample(1:length(theQuesLst), trialNum, replace = FALSE) # no repeating choices
     Choices = theQuesLst[chooseIdx]    # this is the selected Questions
    # quiz begins
     for(i in 1:trialNum){
        cat("\n")

        pointer <- Choices[i]

        cat("============","\n")
        cat(" Status: ",theScore[pointer],"  sn: ",pointer,"\n")

        if(SelectTans  == "y"){
            cat(pink(i), " Question:  ", "\tWhat is:\t")
            #writeLines(strwrap(ligyellow(unlist(strsplit(WordTable[pointer, 1], "`"))), width = 140, indent=25))
            cat(yellow(unlist(strsplit(WordTable[pointer, 1], "`"))), sep = "\n    ")
            cat("   ?\n", "\nSelect your answer", "\n")
            speakIt(WordTable[pointer,1])
        } else {
            cat(pink(i), " Question:  ", "\tWhat is:\t")
            #writeLines(strwrap(ligyellow(unlist(strsplit(WordTable[pointer, 1], "`"))), width = 140, indent=25))
            cat(yellow(unlist(strsplit(WordTable[pointer, 1], "`"))), sep = "\n    ")
            cat("   ?\n", "\nSelect your answer", "\n")
            speakIt(WordTable[pointer, 1])
        }
   
        theAnswerIs = WordTable[pointer,2]

        # To be continue to gurantee obtaining 5 choices
        #selAnswers = function(pointer){
        #    thePool = 1:WordTableLen
        #    thePool = thePool[-pointer]

        #    ansPoolIdx = sample(thePool, 4, replace = FALSE)    #random select 4 answers
        #    return(c(ansPoolIdx, pointer))    #includes the correct answer
        #}

        thePool = 1:WordTableLen
        thePool = thePool[- Choices[i]]

        theAnswerPoolIdx = sample(thePool, 4, replace = FALSE)    #random select 4 answers
        theAnswerPoolIdx = c(theAnswerPoolIdx, Choices[i])    #includes the correct answer

        theAnswerPoolIdx = sample(theAnswerPoolIdx, 5, replace = FALSE)

        theAnswerPool = WordTable[theAnswerPoolIdx,2]


        if (as.numeric(as.character(theScore[pointer]))> 2){
            readline(prompt="Press enter to show choices: ")
        }

        for(A in 1:5){
            #cat(A, ": ", theAnswerPool[A], "\n")
            cat(cyan(A), ": ")
            cat(pink(unlist(strsplit(theAnswerPool[A], "`"))), sep = "\n    ")
            #writeLines(strwrap(ligSilver(gsub("`", "\n",theAnswerPool[A])), width = 140, indent = 4))

            if (nchar(theAnswerPool[A]) > 100) { cat("\n")}
        }

        if(SelectTans  == "y"){
            key = readline(prompt="Please type the answer exactly as in the tips : ")
            if(key  ==  "as.raw(27)") {break}
            if(key  ==  theAnswerIs) {
                keyin = which(key  ==  theAnswerPool)
            } else{
                keyin = which(key != theAnswerPool)[1]
            }
        } else {
            keyin = "6"
            while((as.numeric(keyin)>5) | (as.numeric(keyin) == 0)){
                keyin <- readkey()
            }
        }

        if(theAnswerPool[keyin]  ==  theAnswerIs) {
            mark <- mark  +  1
            if(selPraxis  ==  "n") {
                if(theScore[pointer]  ==  "1.1"){
                    theScore[pointer] = "2"
                } else if(theScore[pointer]  ==  "2.1"){
                    theScore[pointer] = "3"
                } else if(theScore[pointer]  ==  "3.1"){
                    theScore[pointer] = "4"
                } else if(theScore[pointer]  ==  "4.1"){
                    theScore[pointer] = "5"
                } else if(theScore[pointer]  ==  "5.1"){
                    theScore[pointer] = "6"
                } else if(theScore[pointer]  ==  "6.1"){
                    theScore[pointer] = "7"
                }
            }
            marklist[i] = 1
            cat(lime("\t\t\t\tGood!"),"\n(")
            cat(medpink(unlist(strsplit(WordTable[pointer, 2], "`"))), sep = "\n    ")
            cat(") \b   Mark: ", mark, "\n")
            if(audioSwith){
               system(paste("WScript", '"C:/R programs/Learning Exercise/playClick.vbs"', sep = " "))
            }
        } else {
            marklist[i] = 0
            if(selPraxis  ==  "n") {
                theScore[pointer] = "1.9" # send to the lowest loop
            }
            cat(red("\t\t\t\tWrong!"),"\n(")
            cat(medpink(unlist(strsplit(WordTable[pointer,2], "`"))), sep = "\n    ")
            cat(") \b   Mark: ", mark, "\n")
            if(audioSwith){
              system(paste("WScript", '"C:/R programs/Learning Exercise/playBad.vbs"', sep = " "))
            }
        }
        speakIt(theAnswerIs)
     }

    # report result
      roundNo <<- roundNo  +  1
     cat("========================","\n\n")
     cat(brown("\n\n\t\tTotal Score: ", mark, "out of ", trialNum, ", Percentage is ", round(mark*100/trialNum, 0), "%\n"))

     system(paste("WScript", '"C:/R programs/Learning Exercise/playrandomSound.vbs"', sep = " "))
     FailIdx = which(marklist  ==  0)

     if(length(FailIdx)>0){
        cat(darkgreen("===========\n\n"))
        cat("The Failures are: \n")
        for(F in 1:length(FailIdx)){
            theFNUm = FailIdx[F]
            theFQue = Choices[theFNUm]
            cat(blue("The Topic is : "))
            cat(ligSilver(unlist(strsplit(WordTable[theFQue,1], "`"))), sep = "\n    ")
            cat(medpink("The Answer is: "))
            cat(blue(unlist(strsplit(WordTable[theFQue,2], "`"))), sep = "\n    ")
            cat("\n")
        }
     }

    # store results
     sink(theScoreTable)
     cat(theScore, sep = "\n")
     sink()

    # show results
     cat(darkgreen("===========\n"))
     cat("Achievements:",
     paste0(
      "\n 1 star: ", (length(which(theScore  ==  "1")) + length(which(theScore  ==  "1.1")) + length(which(theScore  ==  "1.2")) + length(which(theScore  ==  "1.3")) + length(which(theScore  ==  "1.4")) + length(which(theScore  ==  "1.5")) + length(which(theScore  ==  "1.6")) + length(which(theScore  ==  "1.7")) + length(which(theScore  ==  "1.8")) + length(which(theScore  ==  "1.9"))),
      ", 2 stars: ", (length(which(theScore  ==  "2")) + length(which(theScore  ==  "2.1")) + length(which(theScore  ==  "2.2")) + length(which(theScore  ==  "2.3")) + length(which(theScore  ==  "2.4")) + length(which(theScore  ==  "2.5")) + length(which(theScore  ==  "2.6")) + length(which(theScore  ==  "2.7")) + length(which(theScore  ==  "2.8")) + length(which(theScore  ==  "2.9"))),
      ", 3 stars: ", (length(which(theScore  ==  "3")) + length(which(theScore  ==  "3.1")) + length(which(theScore  ==  "3.2")) + length(which(theScore  ==  "3.3")) + length(which(theScore  ==  "3.4")) + length(which(theScore  ==  "3.5")) + length(which(theScore  ==  "3.6")) + length(which(theScore  ==  "3.7")) + length(which(theScore  ==  "3.8")) + length(which(theScore  ==  "3.9"))),
      ", 4 stars: ", (length(which(theScore  ==  "4")) + length(which(theScore  ==  "4.1")) + length(which(theScore  ==  "4.2")) + length(which(theScore  ==  "4.3")) + length(which(theScore  ==  "4.4")) + length(which(theScore  ==  "4.5")) + length(which(theScore  ==  "4.6")) + length(which(theScore  ==  "4.7")) + length(which(theScore  ==  "4.8")) + length(which(theScore  ==  "4.9"))),
      ", 5 stars: ", (length(which(theScore  ==  "5")) + length(which(theScore  ==  "5.1")) + length(which(theScore  ==  "5.2")) + length(which(theScore  ==  "5.3")) + length(which(theScore  ==  "5.4")) + length(which(theScore  ==  "5.5")) + length(which(theScore  ==  "5.6")) + length(which(theScore  ==  "5.7")) + length(which(theScore  ==  "5.8")) + length(which(theScore  ==  "5.9"))),
      ", 6 stars: ", (length(which(theScore  ==  "6")) + length(which(theScore  ==  "6.1")) + length(which(theScore  ==  "6.2")) + length(which(theScore  ==  "6.3")) + length(which(theScore  ==  "6.4")) + length(which(theScore  ==  "6.5")) + length(which(theScore  ==  "6.6")) + length(which(theScore  ==  "6.7")) + length(which(theScore  ==  "6.8")) + length(which(theScore  ==  "6.9"))),
      ", 7 stars: ", (length(which(theScore  ==  "7")) + length(which(theScore  ==  "7.1")) + length(which(theScore  ==  "7.2")) + length(which(theScore  ==  "7.3")) + length(which(theScore  ==  "7.4")) + length(which(theScore  ==  "7.5")) + length(which(theScore  ==  "7.6")) + length(which(theScore  ==  "7.7")) + length(which(theScore  ==  "7.8")) + length(which(theScore  ==  "7.9"))),
      "\n"))

    # wait for next loop
     theScoretmp <- theScore
     theScore <<- theScoretmp
     ReadCmd()
 }

# Init here
 library(crayon)
  ligSilver <- make_style("#889988")
  lime <- make_style("#10ff10")
  purple <- make_style("#9400D3")
  deeppink <- make_style("#FF1493")
  darkgreen <- make_style("#004000")
  magenta  <- make_style("#800080")
  medpink  <- make_style("#D93B6A")
  pink  <- make_style("#E98B8A") # note dont change this code
  brown  <- make_style("#B8937C")
  gray  <- make_style("#302E4D")
  blue  <- make_style("#12BBEC")
  dimlime  <- make_style("#00BF40")
  ligyellow  <- make_style("#F0E68C")

 AlertMsgHead = 'mshta vbscript:Execute("CreateObject(""SAPI.SpVoice"").Speak(""'
 AlertMsgTail = '"")(window.close)")'

 rootFolder = "C:/R programs/Learning Exercise/"

  audioSwith = FALSE
  soundlist = c("ping","coin", "shotgun", "wilhelm", "facebook", "sword")
  soundlistLength = length(soundlist)

 # run login function here
 AChoice = "C:/R programs/Learning Exercise/QuizData/"
 setwd(AChoice)

 #BChoice = "D:/KPC/Dropbox/MyDocs/R misc Jobs/Learning Exercise/QuizData/"
 #CChoice = "C:/R programs/Learning Exercise/QuizData/"

 #cat("\n\nSetup Working Folder:\n")

 #cat("A  NB\n")
 #cat("B  office\n\n")
 #cat("C  office\n\n")

 #Select = readline(prompt="enter Working Folder a or b: ")
 #if((Select  ==  "a")|(Select  ==  "")){
    #dirStr = AChoice
 #}  else if (Select  ==  "b"){
    #dirStr = BChoice
 #}  else if (Select  ==  "c"){
    #dirStr = CChoice
 #}

 #if(dir.exists(dirStr)){
    #setwd(dirStr)
 #} else {
    #cat("\n\n!!!!Working Folder not exist!!!!\n\n")
    #break
 #}
 trialNum <- 5
 mark <- 0
# add to revision queue qty
 addRev2 = 0
 addRev3 = 0
 addRev4 = 0
 addRev5 = 0
 addRev6 = 0

options("encoding" = "native.enc")
Sys.setlocale(category = 'LC_ALL', 'Chinese')    # this must be added to script to show chinese

 QuizTabName = "QuizTableList.txt"

 QuizTab <- readLines(QuizTabName, encoding="UTF-8", warn = FALSE)

 QuizTabFile <- paste0(QuizTab, ".txt")

 QuizTabScoreFile = paste0(QuizTab, "Score.txt")
 QuizTabScoreRevFile = paste0(QuizTab, "RevScore.txt")

 QuizTabScoreTAnsFile = paste0(QuizTab, "TAnsScore.txt")
 QuizTabScoreRevTAnsFile = paste0(QuizTab, "RevTAnsScore.txt")

 quizNo = 1

 resetSwitches()

 quizSet = 1
 SelectRatio = 5    #this is the basic proportion
 pickPoolWith = 6
 pickPoolSize = pickPoolWith  +  trialNum
 roundNo = 0
 theQuestionTable <<- QuizTabFile[quizNo]

 WordTableFIle <<- readLines(theQuestionTable, encoding="UTF-8", warn = FALSE)
 checkTabIdx = grep("	", WordTableFIle)
 if(length(checkTabIdx) != length(WordTableFIle)){
   cat(red("\n\nIncorrect selected Quiz structure!\n\n"))
   break
 }
 checkDoubleTabIdx = grep("	.*	", WordTableFIle)
 if(length(checkDoubleTabIdx) > 0){
   cat(red("\n\nIncorrect selected Quiz structure! Double Tab!!\n\n"))
   break
 }
 WordTable <<- matrix(unlist(strsplit(WordTableFIle, split = "\\t")), ncol=2, byrow=TRUE)



 # Check file exists here
  # file.create(..., showWarnings = TRUE)
  # file.exists(...)

  for(FNo in 1:length(QuizTab)){
    if(!file.exists(QuizTabFile[FNo])){
        cat("\n\nWarning!! ", QuizTabFile[FNo], " Not Exist!\n\n")
        break
    }
    if(!file.exists(QuizTabScoreFile[FNo])){
        file.create(QuizTabScoreFile[FNo])
    }
    if(!file.exists(QuizTabScoreRevFile[FNo])){
        file.create(QuizTabScoreRevFile[FNo])
    }
    if(!file.exists(QuizTabScoreTAnsFile[FNo])){
        file.create(QuizTabScoreTAnsFile[FNo])
    }
    if(!file.exists(QuizTabScoreRevTAnsFile[FNo])){
        file.create(QuizTabScoreRevTAnsFile[FNo])
    }
  }
  # Check file exists Completed
 # preperation completed

  # AlertMsg = 'mshta vbscript:Execute("CreateObject(""SAPI.SpVoice"").Speak(""Hello"")(window.close)")'
  # system(AlertMsg, invisible=TRUE, wait=FALSE)
  # speak the answer too, during reporting

# frontend

 Selection = "b"

 while(Selection != "")
  {
    cat("\n\n\n",
     "\n", red$bold$underline("Wonderful Quiz  Main menu"),
#     "\n", " ==  ==  ==  ==  ==  ==  ==  == ",
     "\n", blue$bold("c"), brown("Choose quiz set"),
     "\n", blue$bold("s"), ligSilver("Swap questions and answers"),
     "\n", blue$bold("o"), brown("turn On/Off TTS"),
     "\n", blue$bold("t"), ligSilver("Type answers"),
     "\n", blue$bold("g"), brown("choose Grades"),
     "\n", blue$bold("p"), ligSilver("Practise"),
     "\n", blue$bold("m"), brown("list Maintenance"),
     "\n", blue$bold("d"), ligSilver("seek dictionary"),
     "\n", blue$bold("r"), brown("change selection ratio"),
     "\n", blue$bold("a"), ligSilver("modify add revision qty"),    # completed
     "\n", blue$bold("x"), brown("Exit"),
     "\n", deeppink("Press Enter to begin"), "\n")

    #     init and check quizSet length
    theQuestionTable <<- QuizTabFile[quizNo]

    if((SelectSwap  == "n") & (SelectTans  == "n")){
        theScoreTable <<- QuizTabScoreFile[quizNo]
        if(swapSelected  ==  "y"){
            WordTable[ , c(1,2)] <- WordTable[ , c(2,1)]  
            swapSelected <<- "n"
        }
        if(TansSelected  ==  "y"){
            TansSelected <<- "n"
        }
    }
    if((SelectSwap  == "n") & (SelectTans  == "y")){
        theScoreTable <<- QuizTabScoreTAnsFile[quizNo]
        if(swapSelected  ==  "y"){
            WordTable[ , c(1,2)] <- WordTable[ , c(2,1)]  
            swapSelected <<- "n"
        }
        if(TansSelected  ==  "n"){
            TansSelected <<- "y"
        }
    }
    if((SelectSwap  == "y") & (SelectTans  == "n")){
        theScoreTable <<- QuizTabScoreRevFile[quizNo]
        # pickPoolSize = 2  +  trialNum
        if(swapSelected  ==  "n"){
            WordTable[ , c(1,2)] <- WordTable[ , c(2,1)]  
            swapSelected <<- "y"
        }
        if(TansSelected  ==  "y"){
            TansSelected <<- "n"
        }
    }
    if((SelectSwap  == "y") & (SelectTans  == "y")){
        theScoreTable <<- QuizTabScoreRevTAnsFile[quizNo]
        # pickPoolSize = 2  +  trialNum
        if(swapSelected  ==  "n"){
            WordTable[ , c(1,2)] <- WordTable[ , c(2,1)]  
            swapSelected <<- "y"
        }
        if(TansSelected  ==  "n"){
            TansSelected <<- "y"
        }
    }

    theScore <<- readLines(theScoreTable, warn = FALSE)
     if ("NA" %in% theScore){
       cat("\n\n\t !!! something wrong with the score list!!!\n\n")
       break
     }

    WordTableLen = nrow(WordTable)
    theScoreLen = length(theScore)
    if(WordTableLen < theScoreLen){    # check extra scores
        theScore = theScore[-((WordTableLen+1):theScoreLen)]    # make newcomer for the new entries
    }
    if(WordTableLen > theScoreLen){    # check empty scores
        theScore[(theScoreLen  +  1):WordTableLen] = 1    # make newcomer for the new entries
    }

    theScoreLen = length(theScore) # update the value

    # if selected star type absent, advance it
     while((length(grep(paste0(quizSet,".*"),theScore))  ==  0) & (quizSet < 8))
        {quizSet <<- quizSet  +  1}
    #     show stars and status
    # sum all stars
    singleStar = length(which(theScore  ==  "1")) + length(which(theScore  ==  "1.1")) + length(which(theScore  ==  "1.2")) + length(which(theScore  ==  "1.3")) + length(which(theScore  ==  "1.4")) + length(which(theScore  ==  "1.5")) + length(which(theScore  ==  "1.6")) + length(which(theScore  ==  "1.7")) + length(which(theScore  ==  "1.8")) + length(which(theScore  ==  "1.9"))
    cat(paste0(
     "\n\n 1 star: ", (length(which(theScore  ==  "1")) + length(which(theScore  ==  "1.1")) + length(which(theScore  ==  "1.2")) + length(which(theScore  ==  "1.3")) + length(which(theScore  ==  "1.4")) + length(which(theScore  ==  "1.5")) + length(which(theScore  ==  "1.6")) + length(which(theScore  ==  "1.7")) + length(which(theScore  ==  "1.8")) + length(which(theScore  ==  "1.9"))),
     ", 2 stars: ", (length(which(theScore  ==  "2")) + length(which(theScore  ==  "2.1")) + length(which(theScore  ==  "2.2")) + length(which(theScore  ==  "2.3")) + length(which(theScore  ==  "2.4")) + length(which(theScore  ==  "2.5")) + length(which(theScore  ==  "2.6")) + length(which(theScore  ==  "2.7")) + length(which(theScore  ==  "2.8")) + length(which(theScore  ==  "2.9"))),
     ", 3 stars: ", (length(which(theScore  ==  "3")) + length(which(theScore  ==  "3.1")) + length(which(theScore  ==  "3.2")) + length(which(theScore  ==  "3.3")) + length(which(theScore  ==  "3.4")) + length(which(theScore  ==  "3.5")) + length(which(theScore  ==  "3.6")) + length(which(theScore  ==  "3.7")) + length(which(theScore  ==  "3.8")) + length(which(theScore  ==  "3.9"))),
     ", 4 stars: ", (length(which(theScore  ==  "4")) + length(which(theScore  ==  "4.1")) + length(which(theScore  ==  "4.2")) + length(which(theScore  ==  "4.3")) + length(which(theScore  ==  "4.4")) + length(which(theScore  ==  "4.5")) + length(which(theScore  ==  "4.6")) + length(which(theScore  ==  "4.7")) + length(which(theScore  ==  "4.8")) + length(which(theScore  ==  "4.9"))),
     ", 5 stars: ", (length(which(theScore  ==  "5")) + length(which(theScore  ==  "5.1")) + length(which(theScore  ==  "5.2")) + length(which(theScore  ==  "5.3")) + length(which(theScore  ==  "5.4")) + length(which(theScore  ==  "5.5")) + length(which(theScore  ==  "5.6")) + length(which(theScore  ==  "5.7")) + length(which(theScore  ==  "5.8")) + length(which(theScore  ==  "5.9"))),
     ", 6 stars: ", (length(which(theScore  ==  "6")) + length(which(theScore  ==  "6.1")) + length(which(theScore  ==  "6.2")) + length(which(theScore  ==  "6.3")) + length(which(theScore  ==  "6.4")) + length(which(theScore  ==  "6.5")) + length(which(theScore  ==  "6.6")) + length(which(theScore  ==  "6.7")) + length(which(theScore  ==  "6.8")) + length(which(theScore  ==  "6.9"))),
     ", 7 stars: ", (length(which(theScore  ==  "7")) + length(which(theScore  ==  "7.1")) + length(which(theScore  ==  "7.2")) + length(which(theScore  ==  "7.3")) + length(which(theScore  ==  "7.4")) + length(which(theScore  ==  "7.5")) + length(which(theScore  ==  "7.6")) + length(which(theScore  ==  "7.7")) + length(which(theScore  ==  "7.8")) + length(which(theScore  ==  "7.9")))),
     "\n\nSelected Quiz:", deeppink(theQuestionTable),
     "\tScore:", deeppink(theScoreTable),
     "\tTotal:", magenta(WordTableLen),
     " L%:", red(round((WordTableLen-singleStar)*100/WordTableLen, 1)),
     "\n",red(format(Sys.time(), "%D %H:%M"),","),"swap:", swapSelected,
     "\ttype all:", TansSelected,
     "\tspeaker:", SelectSpeech,
     "\tpraxis:", selPraxis,
     "\tgrade set:", quizSet, "\n\n")

    Selection <- readline(prompt="Select function: ")

    if((Selection  ==  "as.raw(27)") | (Selection  ==  "x"))     {
        cat("\n", "Process Ended\n")
          setwd(rootFolder)
          # if logout, quit("yes")

        break
    }

    # this calls the ParseIt function
     if(Selection != "") {
        ParseIt(Selection)
     } else {
        Selection = "b"
        ParseIt(Selection)
     }
 }
 closeAllConnections()
