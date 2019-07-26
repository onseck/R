# GLOBAL CONSTANTS
	Nb.measure<- 40	# we do not consider more because there is anyway no images
	bottom<- c(0,1/2,1)	# to have two spectra in the same plot
	m1<-2	# minimum frequency, if m1<-1 then we have a problem of normalisation with A1
	m2<- 1024-1	# maximum frequency length(spectra$f) corresponds to 30 kHz
	Df.max<-10000	# frequency shift larger than that are disreagarded
	mycol<-c("red","blue") # (close, far)
	# expected image size 1040 1392
	side<-500		# square image x0:(x0+side)
	sideX<-1040		#1040		# length of the image
	sideY<-1392		#1392		# length of the image