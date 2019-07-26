#-------------------------------------------------------------------------------------
# function to plot side by side the spectra and the corresponding image along with the 
# cut-off value from the LDVao App written in LabView and running on the acquisition 
# system of the LDVao device.# Martial, 29 juin 2016
# strongly modifed in July 2019
#-------------------------------------------------------------------------------------
appName= "Plot.Image.spectra"
appVersion= 3
appDate= "July 2019"

#-------------------------------------------------------------------------------------
# LIBRARIES
	library(png)

# for testing purpose
	# raw.recordings<- "~/repositories/R/LDVao/ForTest/raw/10_sain/T0/2017_10_05_14_37_50_SNSA_OS"
	# res.recordings<- "~/Desktop"
	# plot.image.spectra(raw.recordings,res.recordings,T)


plot.image.spectra<- function(raw.recordings,res.recordings,print2pdf=F){
#	This will look at all the spectra  and imags within one recording (max 40)
#	rm(list = ls()) #clear all data and all parameters 
#	graphics.off() #close all plots 
# 	print2pdf=F 
#	if print2pdf is TRUe then a file strating with pis_ will be generated in the session folder
	# folder where the measurement data are stored
	setwd(raw.recordings)
	exp<- unlist(strsplit(raw.recordings, "\\/"))
	recording<- exp[length(exp)]
	session<- exp[length(exp)-1]
	subject<- exp[length(exp)-2]
	print(paste("===",recording,"started"))
	# save a pdf file if expected
	#if (print2pdf){pdf(paste("~/Desktop/",WDtext,".pdf",sep=""))}	
	if (print2pdf){pdf(file.path(res.recordings, paste("pis_",recording,".pdf",sep="")))}	
	par(mfrow=c(5,4),oma=c(0,0,1,0),omi=c(0,0,0,0),mai=c(0,0,0,0))
	plot(c(0,1),c(0,1),frame=F,type="n",xaxt="n",yaxt="n",xlab="",ylab="")
	text(0,0.9,paste(subject," (",session,")"),cex=1,pos=4)
	text(0,0.8,recording,cex=0.8,pos=4)
	plot(c(0,1),c(0,1),frame=F,type="n",xaxt="n",yaxt="n",xlab="",ylab="")
	text(0,0.2,paste("App: ",appName,".R (v",appVersion,")",sep=""),cex=0.8,pos=4)
	text(0,0.1,paste("Date:",date(),sep=""),cex=0.8,pos=4)
	# read the results.xls file
	results <- read.table(paste(raw.recordings,"/Results.xls", sep=""),skip=20,sep="\t")
	results <- results[,-1]	# remove the first column
	colnames(results) <- c("t","FC1","FC2","Vmax","pulse","Q1","Q2","valid")
	sequence<- 1:length(results$Q1)
	results$t<- sequence	# to have number from 1 to the maximum

	# filename of each spectra	
	folder.spectra <- paste(raw.recordings,"/Spectra",sep="")
	setwd(folder.spectra)
	mylist <- list.files()
	# the following happen sometimes with Google Drive ! and should be removed
	if (mylist[1]=="Icon\r"){ mylist<- mylist[-1]}
	if (mylist[length(mylist)]=="Icon\r"){ mylist<- mylist[-length(mylist)]}
	filename.spectra<- paste(folder.spectra,"/",mylist,sep="")
	
	# filename of each images
	folder.images <- paste(raw.recordings,"/Images",sep="")
	setwd(folder.images)
	mylist <- list.files()
	# the following happen sometimes with Google Drive ! and should be removed
	if (mylist[1]=="Icon\r"){ mylist<- mylist[-1]}
	if (mylist[length(mylist)]=="Icon\r"){ mylist<- mylist[-length(mylist)]}
	filename.images<- paste(folder.images,"/",mylist,sep="")
	for (l in 1:40){	
		s<- read.table(filename.spectra[l], skip=10, sep="\t")
		# plot(c(0,f.max),c(0,p.max),type="n",xlab="Power",ylab="Frequency [Hz]",main=mylist[i])
		plot(c(0,Df.max),c(0,1),type="n",xaxt="n",yaxt="n",frame=F)
		segments((0:10)*1000,rep(0,11),(0:10)*1000,rep(1,11),col="gray",lwd=0.5)
		text(Df.max,0.95,l-1,pos=2,cex=1.1)
		for (fc in 1:2){	# for each channel
			fcs<-fc+1	# to select the right column in the array s
			norm.factor<-max(c((round(5*mean(s[3:50,fcs])*1e6))/1e6,3*max(s[3:50,fcs])))
			FC<- results[l,fc+1]
			FC.i<- min(which(s[,1] > FC))
			A<- mean(s[m1:FC.i,fc+1])/norm.factor
			rect(0,bottom[fc],FC,A+bottom[fc],col=gray(0.9),border=NA)
			points(s[,1],s[,fcs]/norm.factor + bottom[fc],type="l",col=mycol[fc],lwd=0.5)
			#segments(results[l,fc+1],bottom[fc],results[l,fc+1],bottom[fc+1],col="gray",lwd=2)
			text(Df.max,bottom[fc]+0.1,paste("fc=",round(results[l,fcs],0)),pos=2,col="black",cex=0.7)
			text(Df.max,bottom[fc]+0.2,paste("Q=",round(results[l,fc+5],4)),pos=2,col="black",cex=0.7)
		}	# end of for fc
		img<- readPNG(filename.images[l])
		img.c<- img-min(img)
		img.c<- img.c/max(img.c)
		max.pos<- which( img==max(img), arr.ind = T ) # find the position fo the maximum
		xm<- max.pos[1]-side/2
		ym<- max.pos[2]-side/2
		if ((ym+side)>sideY){ym<- sideY-side}
		if ((xm+side)>sideX){xm<- sideX-side}
		if ((ym-side)<0){ym<- 0}
		if ((xm-side)<0){xm<- 0}
		img.s<- img.c[xm:(xm+side),ym:(ym+side)]
		plot(c(0,side),c(0,side),type="n",xaxt="n",yaxt="n",xlab="",ylab="",axes=F,frame.plot=F,mar=c(0,0,0,0))
		rasterImage(img.s,0,0,side,side,interpolate=FALSE) # to be changed !!!!!!
	}	# end of for l
	if (print2pdf){dev.off()}		
}	# end of function

