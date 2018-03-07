# R Script to run Lecture Assignment 0 solution
# Clean the workspace, remove all existing Objects

rm(list=ls())

# setwd
setwd("Q:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 9 Assignment")
setwd("J:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 9 Assignment")

# Load the needed libraries
library(dplyr)
library(ggplot2)
library(rvest)
library(stringr)
library(tidyr)
library(data.table)
library(reshape2)

# Run the code for each question
# Read data from website
harry_potter <- read_html("http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1")

# Actor Data =====================================================================================

# Use SelectorGadget to find CSS keywords
  
# CSS selector for actors
# .itemprop span

# Using CSS selectors to scrap the actor list section
actor_data_html <- html_nodes(harry_potter,'.itemprop span')

# Converting the actor data to text
actor_data <- html_text(actor_data_html)

# Character Data =====================================================================================

# Use SelectorGadget to find CSS keywords
  
# CSS selector for characters
#  .character

# Using CSS selectors to scrap the character list section
character_data_html <- html_nodes(harry_potter,'.character')

#Converting the character data to text
character_data <- html_text(character_data_html)

head(character_data)

# Data cleaning ==============================================================================

# Remove \n characters in character_data
character_data <- gsub("\n","",character_data)

# Remove white space from string
character_data <- str_squish(character_data)

# save as data frame
actor_data = data.frame(actor_data)
character_data = data.frame(character_data)

# change class to character
actor_data[] <- lapply(actor_data, as.character)
character_data[] <- lapply(character_data, as.character)

# add column names
names(actor_data) = c("ActorName")
names(character_data) = c("Character")

# Separate First name(s) and singular last name using tidyr
actor_names <- actor_data %>% separate(ActorName, into = c('FirstName', 'Surname'), sep = '\\s(?=\\S*?$)')

#utils::View(actor_names)
#utils::View(character_data)

# Merge Actor and Character data frames
HarryPotterCast <- cbind(actor_names,character_data)


# ================================================================================================
  
#pattern <- "(uncredited)"
#replacement <- ""
#test <- str_replace_all(character_data, pattern, replacement)
#test <- gsub("\\(uncredited)","",character_data)
#????
  
# ====================================================================================================
  
# Merge
  
#utils::View(actor_names)
#utils::View(character_data)

HarryPotterCast <- cbind(actor_names,character_data)

utils::View(HarryPotterCast)

# ======================================================================================


# SportsBall

# a and b

# Read in web page
url <- 'http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs'
webpage <- read_html(url)

# Use html.nodes to extract web table
spurs_tables <- html_nodes(webpage, 'table')

# Extract second table (shooting statistics) and output to data frame
shootstats <- html_table(spurs_tables)[[2]]

# c

# Save header information
statheader <- dplyr::slice(shootstats,2)

# Remove first 2 header rows and totals row
shootstats <- shootstats[-c(1, 2, 20), ]

# change row.names column to first, rename to rn 
shootstats <- setDT(shootstats, keep.rownames = TRUE)[]

# Remove rn column
shootstats$rn = NULL

# Add header names to data frame
names(shootstats) = as.character(statheader)

# utils::View(shootstats)

# Split PLAYER column into Name and Positiom
PlayerPos <- colsplit(shootstats$PLAYER, ",", c("Name", "Position"))

# Remove PLAYER coumn from shootstats data frame
shootstats$PLAYER = NULL

# Bind PlayerPos and shootstats data frame
shootstats <- cbind(PlayerPos,shootstats)

# Convert character stat data to numeric
shootstats[,3:16] <- lapply(shootstats[,3:16], as.numeric)

shootstats

#PG - Point guard.
#SG - Shooting guard.
#SF - Small forward.
#PF - Power forward.
#C -  Center.

# Resample data frame for FG% stas per player and position
fgpct <- select(shootstats, contains("Name"),("Position"),("FG%"))

# Convert FG% variable to factor
fgpct$`FG%` <- as.factor(fgpct$`FG%`)


# ===========================================================
##   supp dose  len
## 1   VC D0.5  6.8
## 2   VC   D1 15.0
## 3   VC   D2 33.0
## 4   OJ D0.5  4.2
## 5   OJ   D1 10.0
## 6   OJ   D2 29.5


# try sorting frame by Position factor
fgpct <- dplyr::arrange(fgpct, desc(Position))

#Best yet
#p <- ggplot(fgpctbypos, aes(x=Name, y=`FG%`, fill=Position)) +  geom_bar(stat="identity") + theme_classic() + coord_flip() + labs(title ="Field Goals by Player and Position", x = "Name of Player", y = "Field Goal Percentage")

fgpct$Name2 <- factor(fgpct$Name, as.character(fgpct$Name))

p <- ggplot(fgpct, aes(x=Name2, y=`FG%`, fill=Position)) +  geom_bar(stat="identity") + theme_classic() + coord_flip() +
  labs(title ="Field Goals by Player and Position", x = "Name of Player", y = "Field Goal Percentage")
