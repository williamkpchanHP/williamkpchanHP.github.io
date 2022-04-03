# can be used here too http://www.51shucheng.com/lishi/kangxidadi
# <ul class="list">
# <ul class="paging">

setwd("C:/Users/user/mpg/Text/programs/ahref/mylivec")
theList = c(
"http://www.mylivecamsite.com/female-cams/",
"http://www.mylivecamsite.com/female-cams/?page=2",
"http://www.mylivecamsite.com/female-cams/?page=3",
"http://www.mylivecamsite.com/female-cams/?page=4",
"http://www.mylivecamsite.com/female-cams/?page=5",
"http://www.mylivecamsite.com/female-cams/?page=6",
"http://www.mylivecamsite.com/female-cams/?page=7",
"http://www.mylivecamsite.com/female-cams/?page=8",
"http://www.mylivecamsite.com/female-cams/?page=9",
"http://www.mylivecamsite.com/female-cams/?page=10",
"http://www.mylivecamsite.com/female-cams/?page=11",
"http://www.mylivecamsite.com/female-cams/?page=12",
"http://www.mylivecamsite.com/female-cams/?page=13"
)

sink("output.html")
for (i in 1:length(theList)){

thepage = readLines(theList[i])
linnum=grep('<ul class="list">', thepage)
thepage = thepage[-(1:(linnum-1))]

linnuml=grep('<ul class="paging">', thepage)
thepage = thepage[-(linnuml:length(thepage))]

cat(thepage)
}
sink()

