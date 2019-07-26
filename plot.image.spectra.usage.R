#-------------------------------------------------------------------------------------
# Application srcipt using the function plot.image.spectra.R
# 
# 25 July 2019
# Martial Geiser
#-------------------------------------------------------------------------------------

# location of source scripts (must be adapted depending on the location)
	source.path<- "~/Desktop/LDVao-Script-R"
# load global constant and other function
	source(file.path(source.path,"GlobalConstants.R"), chdir = TRUE)
# load the function to plot side by side the spectra and the corresponding image along with the cut-off value from the LDVao App written in LabView and running on the acquisition system of the LDVao device.
	source(file.path(source.path,"plot.image.spectra.R"), chdir = TRUE)	
	#	This will look at all the spectra  and imags within one recording (max 40)
	#	if print2pdf is TRUE then a file strating with pis_ will be generated in the session folder
	#	folder where the measurement data are stored


#-------------------------------------------------------------------------------------
# the following has to be given by the user
# gives the session of the chosen subject
	raw.session<-"/Volumes/OnTheWay/LDF-LDV/LDV-ao/LDVao-raw/sains/19_sain/T0"
	res.session<- "/Volumes/OnTheWay/LDF-LDV/LDV-ao/LDVao-resultats/sains/19_sain/T0"

#-------------------------------------------------------------------------------------
# This is simply executed and will handle all the recordings within the user's session
# find out all recordings within that session
	setwd(raw.session)
	recordings<- list.files()
	recordings <- recordings[c(grep("_OD", recordings),grep("_OS", recordings))]
# and goes through all recordings
	for (r in 6:length(recordings)){
		raw.recordings<- file.path(raw.session,recordings[r])
		res.recordings<- file.path(res.session)
		plot.image.spectra(raw.recordings,res.recordings,T)
	}


