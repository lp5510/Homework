# Clean the workspace, remove all existing Objects
rm(list=ls())

setwd("P:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 10 Assignment")
setwd("J:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 10 Assignment")

# Load the needed libraries

library(plyr)
library(ggplot2)
library(dplyr)
library(stringr)
library(RColorBrewer)
library(colorRamps)
library(knitr)
library(kableExtra)

# Load mh2015_puf environment from data directory
load("N-MHSS-2015-DS0001-data-r.rda")

# Pull out STATE abbreviations without count
state <- dplyr::select(mh2015_puf, LST)

# remove counts from df 
state <- state[-1, ] 

head(state)

# Filter for "FACILITYTYPE" for VAMC facilities by LST
data.frame <- dplyr::filter(mh2015_puf, FACILITYTYPE == "Veterans Administration medical center (VAMC) or other VA health care facility")
data.frame <- dplyr::select(data.frame, LST, FACILITYTYPE)
data.frame <- dplyr::arrange(data.frame, LST)

# Remove AK, HI and PR entries from LST
data.frame <- data.frame[-grep("AK", data.frame$LST),] 
data.frame <- data.frame[-grep("HI", data.frame$LST),]
data.frame <- data.frame[-grep("PR", data.frame$LST),]

# Output final state listing with frequency count
data.frame <- data.frame %>% group_by(FACILITYTYPE, LST) %>% tally()
data.frame$FACILITYTYPE = NULL

# Order barplot by decreasing frequency
data.frame$LST <- factor(data.frame$LST, levels = data.frame$LST[order(data.frame$n)])

# Define and expand color pallette to 48 colors
colourCount <- length(unique(data.frame$LST))  
getPalette <- colorRampPalette(brewer.pal(9, "Set1"))

# Plot VAMC facilities vs State with color 
p <- ggplot(data.frame, aes(x=as.factor(LST), y=n, fill=as.factor(LST), width=0.75)) + geom_bar(stat = "identity") 
p <- p + coord_flip() + guides(fill=FALSE) + xlab("State") + ylab("Veterans Administration Medical Center Facilities")
p <- p + ggtitle("Veterans Administration Medical Center Facilities by State") + theme(plot.title = element_text(hjust=0.5))
p <- p + scale_fill_manual(values = colorRampPalette(brewer.pal(9,"Set1"))(colourCount))
p

# Read stateside.csv into R environment
statesize <- read.csv(file="statesize.csv", header=TRUE, sep=",")

# Rename Abbrev col to LST in statesize df
statesize <- dplyr::rename(statesize, LST = Abbrev)

# Remove AK and HI entries from LST 
statesize <- statesize[-grep("AK", statesize$LST),] 
statesize <- statesize[-grep("HI", statesize$LST),]

# Attempt merge
test <- dplyr::inner_join(statesize, data.frame, by = "LST")
summary(test)

# Use paste()command to diagnose issue
paste(data.frame$LST)

# data.frame$LST has 3 extra spaces in character string, preventing a merge on the LST variable 

# Correct this problem using stringr "str_trim" option
data.frame$LST <- str_trim(data.frame$LST)
paste(data.frame$LST)

# Merge statesize and data.frame
data.frame <- dplyr::inner_join(statesize, data.frame, by = "LST")
summary(data.frame)

# Add new variable "VAHPerSqMi" for VA facilities per 1000 sq mile
data.frame$KSqMiles <- data.frame$SqMiles/1000
data.frame <- dplyr::mutate(data.frame, VAHPerKSqMi = n/KSqMiles)

# Clean up data frame
data.frame <- dplyr::select(data.frame, StateName, LST, n, Region, KSqMiles, VAHPerKSqMi)
data.frame <- dplyr::arrange(data.frame, desc(VAHPerKSqMi))

# Order barplot by decreasing frequency
data.frame$LST <- factor(data.frame$LST, levels = data.frame$LST[order(data.frame$VAHPerKSqMi)])

# Plot VAMC facilities vs State with color 
p <- ggplot(data.frame, aes(x=as.factor(LST), y=VAHPerKSqMi, fill=as.factor(Region), width=0.75)) + geom_bar(stat = "identity") 
p <- p + coord_flip() + xlab("State") + ylab("Facilities Per 1000 Square Miles")
p <- p + ggtitle("Veterans Administration Medical Center Facilities Per 1000 Square Miles") + theme(plot.title = element_text(hjust=0.5))
p <- p + scale_fill_brewer(palette = "Set2")
p <- p + guides(fill=guide_legend(title="Region"))
p




