
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

theRevFile = unlist(strsplit(readClipboard(),","))
lenRevFile = length(theRevFile)

cat("\nSelect the patientFile ...\n")
thePatientFileName <- file.choose()
thePatientFile = readLines(thePatientFileName)
lenPatientFile = length(thePatientFile)

# the loop to process pages
for(i in 1:lenRevFile){
	cat(i, " ")
	linenum = grep(theRevFile[i], thePatientFile)
	if(length(linenum)!=0){
		cat(linenum, ". ")
		thePatientFile = thePatientFile[-linenum]
	}else{cat(" not found! ")}
}

file.rename(thePatientFileName, paste0(thePatientFileName," bak.html"))
cat("\nbackup completed")

sink(thePatientFileName)
cat(thePatientFile, sep="\n")
sink()

cat("\nJob completed!")
