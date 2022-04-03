
# http://yespornplease.com/?p=122
# http://yespornplease.com/search?p=5&q=Bald+Pussy

# <a style="text-decoration:none;" class="video-link" href="/view/268601866">
# <div class="thumb-overlay playthumb">
# <img src="http://yespornplease.com/images/201406/d0403d0/311x173_1.jpg?v=1" title="" alt="HAM Diamond Kitty, Asa Akira - Muffin Stuffin" id="268601866" name="d0403d0-1-201406-10-1" class="img-responsive "/>

setwd("C:/Users/user/mpg/Text/programs/projects/yespornplease/Bald+Pussy")
totalpages = 5
pageHeader="http://yespornplease.com/?p="
lineSig = 'video-link'
projTitle = "yespornplease Bald+Pussy"

theWholepage = ""

for (page in 1:totalpages){
    cat(" ", page)
    thepage = readLines(paste0(pageHeader,page, "&q=Bald+Pussy"))
    linenum = grep(lineSig, thepage)
    linenum = sort(c(linenum, linenum+2))
    thepage = thepage[linenum]
    theWholepage = c(theWholepage , thepage)
}
sink(paste0(projTitle, "Toc.html"))
cat(theWholepage, sep="\n")
sink()

#======