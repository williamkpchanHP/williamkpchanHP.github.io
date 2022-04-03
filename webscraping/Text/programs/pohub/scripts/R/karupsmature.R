# prefetch addr
# grep all img addrs
# store in text array in array
# 
# to recover
# run show array function
# 
# action: collect imgs
# collect addr database
# 
# http://www.milfpornpics.xxx/cat/spreading/?pg=8

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

pageHeader="http://www.karupsmature.com/gals/"
pageTail=""
theFilename = "karupsmature.html"
addr = c(
"action/srt-by-tags/busty-hardcore/",
"action/srt-by-tags/free-mature-hardcore/",
"action/srt-by-tags/free-mature-pics/",
"action/srt-by-tags/hardcore-images/",
"action/srt-by-tags/hardcore-pics/",
"action/srt-by-tags/hot-mature/",
"action/srt-by-tags/mature-amateur/",
"action/srt-by-tags/mature-and-boy/",
"action/srt-by-tags/mature-and-young/",
"action/srt-by-tags/mature-babes/",
"action/srt-by-tags/mature-blow-job/",
"action/srt-by-tags/mature-boobs/",
"action/srt-by-tags/mature-boy/",
"action/srt-by-tags/mature-chicks/",
"action/srt-by-tags/mature-facial/",
"action/srt-by-tags/mature-galleries/",
"action/srt-by-tags/mature-hard-sex/",
"action/srt-by-tags/mature-hardcore/",
"action/srt-by-tags/mature-housewives/",
"action/srt-by-tags/mature-lesbian/",
"action/srt-by-tags/mature-mom/",
"action/srt-by-tags/mature-photo/",
"action/srt-by-tags/mature-pics/",
"action/srt-by-tags/mature-pictures/",
"action/srt-by-tags/mature-sex/",
"action/srt-by-tags/mature-tgp/",
"action/srt-by-tags/mature-women-pics/",
"action/srt-by-tags/mature-women/",
"action/srt-by-tags/mature-xxx-pictures/",
"action/srt-by-tags/mature-xxx/",
"action/srt-by-tags/mom-fuck/",
"action/srt-by-tags/mom-in-action/",
"action/srt-by-tags/old-mature/",
"mature/srt-by-tags/beautiful-mature-pics/",
"mature/srt-by-tags/elegant-matures/",
"mature/srt-by-tags/free-karupsow/",
"mature/srt-by-tags/free-mature-pics/",
"mature/srt-by-tags/hq-mature/",
"mature/srt-by-tags/ideal-mature/",
"mature/srt-by-tags/karups-amateurs/",
"mature/srt-by-tags/karups-galleries/",
"mature/srt-by-tags/karups-hq-mature/",
"mature/srt-by-tags/karups-models/",
"mature/srt-by-tags/karups-older-woman/",
"mature/srt-by-tags/karups-older/",
"mature/srt-by-tags/mature-amature/",
"mature/srt-by-tags/mature-babes/",
"mature/srt-by-tags/mature-cutie/",
"mature/srt-by-tags/mature-heels/",
"mature/srt-by-tags/mature-hot/",
"mature/srt-by-tags/mature-ladies-pics/",
"mature/srt-by-tags/mature-mom-gallery/",
"mature/srt-by-tags/mature-mom-pictures/",
"mature/srt-by-tags/mature-mom/",
"mature/srt-by-tags/mature-photo/",
"mature/srt-by-tags/mature-posing/",
"mature/srt-by-tags/mature-solo/",
"mature/srt-by-tags/mature-wife/",
"mature/srt-by-tags/mature-women-galleries/",
"mature/srt-by-tags/mature-women-pics/",
"mature/srt-by-tags/mature-women/",
"mature/srt-by-tags/new-matures/",
"mature/srt-by-tags/old-mature/",
"mature/srt-by-tags/older-women-galleries/",
"mature/srt-by-tags/retro-mature/",
"mature/srt-by-tags/want-matures/",
"srt-by-name/name-b.php",
"srt-by-name/name-c.php",
"srt-by-name/name-d.php",
"srt-by-name/name-e.php",
"srt-by-name/name-f.php",
"srt-by-name/name-g.php",
"srt-by-name/name-h.php",
"srt-by-name/name-i.php",
"srt-by-name/name-j.php",
"srt-by-name/name-k.php",
"srt-by-name/name-l.php",
"srt-by-name/name-m.php",
"srt-by-name/name-n.php",
"srt-by-name/name-o.php",
"srt-by-name/name-p.php",
"srt-by-name/name-q.php",
"srt-by-name/name-r.php",
"srt-by-name/name-s.php",
"srt-by-name/name-t.php",
"srt-by-name/name-u.php",
"srt-by-name/name-v.php",
"srt-by-name/name-w.php",
"srt-by-name/name-x.php",
"srt-by-name/name-y.php",
"srt-by-name/name-z.php",
"uniforms/srt-by-tags/free-mature/",
"uniforms/srt-by-tags/granny-mature/",
"uniforms/srt-by-tags/hot-mature/",
"uniforms/srt-by-tags/hot-uniform/",
"uniforms/srt-by-tags/mature-amature/",
"uniforms/srt-by-tags/mature-babes/",
"uniforms/srt-by-tags/mature-boobs/",
"uniforms/srt-by-tags/mature-girls/",
"uniforms/srt-by-tags/mature-granny/",
"uniforms/srt-by-tags/mature-hot/",
"uniforms/srt-by-tags/mature-lingerie/",
"uniforms/srt-by-tags/mature-mom/",
"uniforms/srt-by-tags/mature-older-women/",
"uniforms/srt-by-tags/mature-panties/",
"uniforms/srt-by-tags/mature-pantyhose/",
"uniforms/srt-by-tags/mature-pics/",
"uniforms/srt-by-tags/mature-picture/",
"uniforms/srt-by-tags/mature-stockings/",
"uniforms/srt-by-tags/mature-tgp/",
"uniforms/srt-by-tags/mature-wife/",
"uniforms/srt-by-tags/mature-women/",
"uniforms/srt-by-tags/mature-xxx/",
"uniforms/srt-by-tags/milfs-uniform/",
"uniforms/srt-by-tags/mom-uniform/",
"uniforms/srt-by-tags/old-mature/",
"uniforms/srt-by-tags/sexy-clothes/",
"uniforms/srt-by-tags/sexy-dresses/",
"uniforms/srt-by-tags/sexy-secretary/",
"uniforms/srt-by-tags/sexy-stockings/",
"uniforms/srt-by-tags/uniform-babes/",
"uniforms/srt-by-tags/uniform-mature/",
"uniforms/srt-by-tags/xxx-mature/"
)
lentocpage = length(addr)

theWholepage = ""
cat("\nlentocpage: ",lentocpage,"\n")
pageHead = '<div class="row thumbs">'

pageEnd = '<div class="container">'

theWholepage = ""

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum[1])
	return(thepage[-(1:(headlinenum[1]))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageEnd, thepage)  # chop tail
	cat( " ", taillinenum[1], "\n")
	if(length(taillinenum) != 0){
		return(thepage[-((taillinenum[1]):length(thepage))])
	} else {
		return("")
	}
}

for (page in 1:lentocpage){
	cat(" ", page)
	thepage=readLines(paste0(pageHeader, addr[page], pageTail))

#	thepage=breakArticle(thepage, pageHead, pageEnd)
	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)
	theWholepage = c(theWholepage , "<div class='topic'>\n",thepage, "\n</div>\n")
}


sink(theFilename)
cat(theWholepage, sep = "\n")
sink()

