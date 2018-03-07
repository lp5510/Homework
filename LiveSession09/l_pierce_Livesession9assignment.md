---
title: "MSDS 6306 DDS Assignment 9"
author: "Luke Pierce"
date: "March 4, 2018"
output:
   html_document:
     keep_md: true
---



####GitHub Repository: https://github.com/lp5510/Homework/tree/master/LiveSession09

# Questions

###1. Harry Potter Cast: 

####a. In the IMDB, there are listings of full cast members for movies. Navigate to http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1. Feel free to View Source to get a good idea of what the page looks like in code.

####b. Scrape the page with any R package that makes things easy for you. Of particular interest is the table of the Cast in order of crediting. Please scrape this table (you might have to fish it out of several of the tables from the page) and make it a data.frame() of the Cast in your R environment.

####c. Clean up the table
#####    + It should not have blank observations or rows, a row that should be column names, or just '.'
#####    + It should have intuitive column names (ideally 2 to start - Actor and Character)
#####    + In the film, Mr. Warwick plays two characters, which makes his row look a little weird. Please replace 
#####      his character column with just "Griphook / Professor Filius Flitwick" to make it look better.
#####    + One row might result in "Rest of cast listed alphabetically" - remove this observation.


```r
# Read data from website
harry_potter <- read_html("http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1")

# Actor Data

# Use SelectorGadget to find CSS keywords
  
# CSS selector for actors
# .itemprop span

# Using CSS selectors to scrap the actor list section
actor_data_html <- html_nodes(harry_potter,'.itemprop span')

# Converting the actor data to text
actor_data <- html_text(actor_data_html)

# save as data frame
actor_data = data.frame(actor_data)

# Character Data

# Use SelectorGadget to find CSS keywords
  
# CSS selector for characters
#  .character

# Using CSS selectors to scrap the character list section
character_data_html <- html_nodes(harry_potter,'.character')

#Converting the character data to text
character_data <- html_text(character_data_html)

# Remove \n characters in character_data
character_data <- gsub("\n","",character_data)

# Remove white space from string
character_data <- str_squish(character_data)

# save as data frame
character_data = data.frame(character_data)

# change class to character
actor_data[] <- lapply(actor_data, as.character)
character_data[] <- lapply(character_data, as.character)

# add column names
names(actor_data) = c("ActorName")
names(character_data) = c("Character")
```

####d. Split the Actor's name into two columns: FirstName and Surname. Keep in mind that some actors/actresses have middle names as well. Please make sure that the middle names are in the FirstName column, in addition to the first name (example: given the Actor Frank Jeffrey Stevenson, the FirstName column would say "Frank Jeffrey.")


```r
# Separate First name(s) and singular last name using tidyr
actor_names <- actor_data %>% separate(ActorName, into = c('FirstName', 'Surname'), sep = '\\s(?=\\S*?$)')

# Merge Actor and Character data frames
HarryPotterCast <- cbind(actor_names,character_data)
```

####e. Present the first 10 rows of the data.frame() - It should have only FirstName, Surname, and Character columns.


```r
# kable(HarryPotterCast[1:10, ], "html")

kable(HarryPotterCast[1:10, ], "html") %>%
  kable_styling(bootstrap_options = c("striped", "hover"))
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> FirstName </th>
   <th style="text-align:left;"> Surname </th>
   <th style="text-align:left;"> Character </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ralph </td>
   <td style="text-align:left;"> Fiennes </td>
   <td style="text-align:left;"> Lord Voldemort </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Michael </td>
   <td style="text-align:left;"> Gambon </td>
   <td style="text-align:left;"> Professor Albus Dumbledore </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Alan </td>
   <td style="text-align:left;"> Rickman </td>
   <td style="text-align:left;"> Professor Severus Snape </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Daniel </td>
   <td style="text-align:left;"> Radcliffe </td>
   <td style="text-align:left;"> Harry Potter </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rupert </td>
   <td style="text-align:left;"> Grint </td>
   <td style="text-align:left;"> Ron Weasley </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Emma </td>
   <td style="text-align:left;"> Watson </td>
   <td style="text-align:left;"> Hermione Granger </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Evanna </td>
   <td style="text-align:left;"> Lynch </td>
   <td style="text-align:left;"> Luna Lovegood </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Domhnall </td>
   <td style="text-align:left;"> Gleeson </td>
   <td style="text-align:left;"> Bill Weasley </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Clémence </td>
   <td style="text-align:left;"> Poésy </td>
   <td style="text-align:left;"> Fleur Delacour </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Warwick </td>
   <td style="text-align:left;"> Davis </td>
   <td style="text-align:left;"> Griphook / Professor Filius Flitwick </td>
  </tr>
</tbody>
</table>
###2. SportsBall:

####a. On the ESPN website, there are statistics of each NBA player. Navigate to the San Antonio Spurs current statistics (likely http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs). You are interested in the Shooting Statistics table.

####b.Scrape the page with any R package that makes things easy for you. There are a few tables on the page, so make sure you are targeting specifically the Shooting Statistics table.


```r
# Read in web page
url <- 'http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs'
webpage <- read_html(url)

# Use html.nodes to extract web table
spurs_tables <- html_nodes(webpage, 'table')

# Extract the second table (shooting statistics) and output to data frame
shootstats <- html_table(spurs_tables)[[2]]
```

####c. Clean up the table (You might get some warnings if you're working with tibbles)
#####   + You'll want to create an R data.frame() with one observation for each player. Make sure that you do not accidentally include           blank rows, a row of column names, or the Totals row in the table as observations.
#####   + The column PLAYER has two variables of interest in it: the player's name and their position, denoted by 1-2 letters after             their name. Split the cells into two columns, one with Name and the other Position.
#####   + Check the data type of all columns. Convert relevant columns to numeric. Check the data type of all columns again to confirm           that they have changed!


```r
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

kable(shootstats, "html") %>%
  kable_styling(bootstrap_options = c("striped", "hover"))
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Name </th>
   <th style="text-align:left;"> Position </th>
   <th style="text-align:right;"> FGM </th>
   <th style="text-align:right;"> FGA </th>
   <th style="text-align:right;"> FG% </th>
   <th style="text-align:right;"> 3PM </th>
   <th style="text-align:right;"> 3PA </th>
   <th style="text-align:right;"> 3P% </th>
   <th style="text-align:right;"> FTM </th>
   <th style="text-align:right;"> FTA </th>
   <th style="text-align:right;"> FT% </th>
   <th style="text-align:right;"> 2PM </th>
   <th style="text-align:right;"> 2PA </th>
   <th style="text-align:right;"> 2P% </th>
   <th style="text-align:right;"> PPS </th>
   <th style="text-align:right;"> AFG% </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> LaMarcus Aldridge </td>
   <td style="text-align:left;"> PF </td>
   <td style="text-align:right;"> 8.7 </td>
   <td style="text-align:right;"> 17.5 </td>
   <td style="text-align:right;"> 0.500 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:right;"> 1.3 </td>
   <td style="text-align:right;"> 0.321 </td>
   <td style="text-align:right;"> 4.3 </td>
   <td style="text-align:right;"> 5.2 </td>
   <td style="text-align:right;"> 0.84 </td>
   <td style="text-align:right;"> 8.3 </td>
   <td style="text-align:right;"> 16.2 </td>
   <td style="text-align:right;"> 0.514 </td>
   <td style="text-align:right;"> 1.272 </td>
   <td style="text-align:right;"> 0.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kawhi Leonard </td>
   <td style="text-align:left;"> SF </td>
   <td style="text-align:right;"> 5.8 </td>
   <td style="text-align:right;"> 12.3 </td>
   <td style="text-align:right;"> 0.468 </td>
   <td style="text-align:right;"> 1.2 </td>
   <td style="text-align:right;"> 3.9 </td>
   <td style="text-align:right;"> 0.314 </td>
   <td style="text-align:right;"> 3.4 </td>
   <td style="text-align:right;"> 4.2 </td>
   <td style="text-align:right;"> 0.82 </td>
   <td style="text-align:right;"> 4.6 </td>
   <td style="text-align:right;"> 8.4 </td>
   <td style="text-align:right;"> 0.539 </td>
   <td style="text-align:right;"> 1.315 </td>
   <td style="text-align:right;"> 0.52 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rudy Gay </td>
   <td style="text-align:left;"> SF </td>
   <td style="text-align:right;"> 4.3 </td>
   <td style="text-align:right;"> 9.1 </td>
   <td style="text-align:right;"> 0.470 </td>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:right;"> 2.1 </td>
   <td style="text-align:right;"> 0.333 </td>
   <td style="text-align:right;"> 2.1 </td>
   <td style="text-align:right;"> 2.7 </td>
   <td style="text-align:right;"> 0.78 </td>
   <td style="text-align:right;"> 3.6 </td>
   <td style="text-align:right;"> 7.0 </td>
   <td style="text-align:right;"> 0.511 </td>
   <td style="text-align:right;"> 1.246 </td>
   <td style="text-align:right;"> 0.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Pau Gasol </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 4.0 </td>
   <td style="text-align:right;"> 8.6 </td>
   <td style="text-align:right;"> 0.460 </td>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:right;"> 1.7 </td>
   <td style="text-align:right;"> 0.382 </td>
   <td style="text-align:right;"> 2.2 </td>
   <td style="text-align:right;"> 2.8 </td>
   <td style="text-align:right;"> 0.76 </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;"> 6.9 </td>
   <td style="text-align:right;"> 0.479 </td>
   <td style="text-align:right;"> 1.247 </td>
   <td style="text-align:right;"> 0.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Patty Mills </td>
   <td style="text-align:left;"> PG </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;"> 8.0 </td>
   <td style="text-align:right;"> 0.420 </td>
   <td style="text-align:right;"> 1.8 </td>
   <td style="text-align:right;"> 4.8 </td>
   <td style="text-align:right;"> 0.379 </td>
   <td style="text-align:right;"> 1.2 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.88 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 3.2 </td>
   <td style="text-align:right;"> 0.485 </td>
   <td style="text-align:right;"> 1.222 </td>
   <td style="text-align:right;"> 0.54 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Manu Ginobili </td>
   <td style="text-align:left;"> SG </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;"> 7.6 </td>
   <td style="text-align:right;"> 0.437 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 3.2 </td>
   <td style="text-align:right;"> 0.327 </td>
   <td style="text-align:right;"> 1.6 </td>
   <td style="text-align:right;"> 1.9 </td>
   <td style="text-align:right;"> 0.86 </td>
   <td style="text-align:right;"> 2.3 </td>
   <td style="text-align:right;"> 4.4 </td>
   <td style="text-align:right;"> 0.516 </td>
   <td style="text-align:right;"> 1.223 </td>
   <td style="text-align:right;"> 0.51 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Danny Green </td>
   <td style="text-align:left;"> SG </td>
   <td style="text-align:right;"> 3.3 </td>
   <td style="text-align:right;"> 8.1 </td>
   <td style="text-align:right;"> 0.409 </td>
   <td style="text-align:right;"> 1.8 </td>
   <td style="text-align:right;"> 4.6 </td>
   <td style="text-align:right;"> 0.385 </td>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:right;"> 0.9 </td>
   <td style="text-align:right;"> 0.78 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 0.440 </td>
   <td style="text-align:right;"> 1.119 </td>
   <td style="text-align:right;"> 0.52 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tony Parker </td>
   <td style="text-align:left;"> PG </td>
   <td style="text-align:right;"> 3.8 </td>
   <td style="text-align:right;"> 7.9 </td>
   <td style="text-align:right;"> 0.483 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:right;"> 0.192 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.5 </td>
   <td style="text-align:right;"> 0.67 </td>
   <td style="text-align:right;"> 3.7 </td>
   <td style="text-align:right;"> 7.2 </td>
   <td style="text-align:right;"> 0.511 </td>
   <td style="text-align:right;"> 1.110 </td>
   <td style="text-align:right;"> 0.49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kyle Anderson </td>
   <td style="text-align:left;"> SF </td>
   <td style="text-align:right;"> 3.2 </td>
   <td style="text-align:right;"> 6.1 </td>
   <td style="text-align:right;"> 0.523 </td>
   <td style="text-align:right;"> 0.2 </td>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:right;"> 0.297 </td>
   <td style="text-align:right;"> 1.6 </td>
   <td style="text-align:right;"> 2.1 </td>
   <td style="text-align:right;"> 0.74 </td>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:right;"> 5.4 </td>
   <td style="text-align:right;"> 0.551 </td>
   <td style="text-align:right;"> 1.336 </td>
   <td style="text-align:right;"> 0.54 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dejounte Murray </td>
   <td style="text-align:left;"> PG </td>
   <td style="text-align:right;"> 3.1 </td>
   <td style="text-align:right;"> 7.1 </td>
   <td style="text-align:right;"> 0.439 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:right;"> 0.238 </td>
   <td style="text-align:right;"> 1.2 </td>
   <td style="text-align:right;"> 1.6 </td>
   <td style="text-align:right;"> 0.73 </td>
   <td style="text-align:right;"> 3.0 </td>
   <td style="text-align:right;"> 6.8 </td>
   <td style="text-align:right;"> 0.449 </td>
   <td style="text-align:right;"> 1.056 </td>
   <td style="text-align:right;"> 0.45 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bryn Forbes </td>
   <td style="text-align:left;"> SG </td>
   <td style="text-align:right;"> 2.8 </td>
   <td style="text-align:right;"> 6.7 </td>
   <td style="text-align:right;"> 0.414 </td>
   <td style="text-align:right;"> 1.2 </td>
   <td style="text-align:right;"> 3.2 </td>
   <td style="text-align:right;"> 0.376 </td>
   <td style="text-align:right;"> 0.5 </td>
   <td style="text-align:right;"> 0.9 </td>
   <td style="text-align:right;"> 0.61 </td>
   <td style="text-align:right;"> 1.6 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 0.448 </td>
   <td style="text-align:right;"> 1.087 </td>
   <td style="text-align:right;"> 0.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Davis Bertans </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 2.3 </td>
   <td style="text-align:right;"> 5.1 </td>
   <td style="text-align:right;"> 0.443 </td>
   <td style="text-align:right;"> 1.3 </td>
   <td style="text-align:right;"> 3.5 </td>
   <td style="text-align:right;"> 0.367 </td>
   <td style="text-align:right;"> 0.6 </td>
   <td style="text-align:right;"> 0.8 </td>
   <td style="text-align:right;"> 0.80 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 1.6 </td>
   <td style="text-align:right;"> 0.611 </td>
   <td style="text-align:right;"> 1.259 </td>
   <td style="text-align:right;"> 0.57 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Joffrey Lauvergne </td>
   <td style="text-align:left;"> C </td>
   <td style="text-align:right;"> 2.0 </td>
   <td style="text-align:right;"> 3.8 </td>
   <td style="text-align:right;"> 0.531 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.1 </td>
   <td style="text-align:right;"> 0.000 </td>
   <td style="text-align:right;"> 0.7 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.65 </td>
   <td style="text-align:right;"> 2.0 </td>
   <td style="text-align:right;"> 3.7 </td>
   <td style="text-align:right;"> 0.548 </td>
   <td style="text-align:right;"> 1.235 </td>
   <td style="text-align:right;"> 0.53 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Derrick White </td>
   <td style="text-align:left;"> PG </td>
   <td style="text-align:right;"> 0.8 </td>
   <td style="text-align:right;"> 1.6 </td>
   <td style="text-align:right;"> 0.480 </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:right;"> 0.5 </td>
   <td style="text-align:right;"> 0.500 </td>
   <td style="text-align:right;"> 0.8 </td>
   <td style="text-align:right;"> 1.1 </td>
   <td style="text-align:right;"> 0.67 </td>
   <td style="text-align:right;"> 0.5 </td>
   <td style="text-align:right;"> 1.1 </td>
   <td style="text-align:right;"> 0.471 </td>
   <td style="text-align:right;"> 1.600 </td>
   <td style="text-align:right;"> 0.56 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brandon Paul </td>
   <td style="text-align:left;"> SG </td>
   <td style="text-align:right;"> 0.9 </td>
   <td style="text-align:right;"> 2.1 </td>
   <td style="text-align:right;"> 0.440 </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:right;"> 0.9 </td>
   <td style="text-align:right;"> 0.286 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:right;"> 0.6 </td>
   <td style="text-align:right;"> 0.61 </td>
   <td style="text-align:right;"> 0.6 </td>
   <td style="text-align:right;"> 1.2 </td>
   <td style="text-align:right;"> 0.567 </td>
   <td style="text-align:right;"> 1.193 </td>
   <td style="text-align:right;"> 0.50 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Darrun Hilliard </td>
   <td style="text-align:left;"> SG </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:right;"> 1.4 </td>
   <td style="text-align:right;"> 0.263 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:right;"> 0.000 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:right;"> 0.5 </td>
   <td style="text-align:right;"> 0.86 </td>
   <td style="text-align:right;"> 0.4 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.385 </td>
   <td style="text-align:right;"> 0.842 </td>
   <td style="text-align:right;"> 0.26 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Matt Costello </td>
   <td style="text-align:left;"> SF </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.333 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.000 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.0 </td>
   <td style="text-align:right;"> 0.00 </td>
   <td style="text-align:right;"> 0.3 </td>
   <td style="text-align:right;"> 1.0 </td>
   <td style="text-align:right;"> 0.333 </td>
   <td style="text-align:right;"> 0.667 </td>
   <td style="text-align:right;"> 0.33 </td>
  </tr>
</tbody>
</table>

####d. Create a colorful bar chart that shows the Field Goals Percentage Per Game for each person. It will be graded on the following criteria.
#####+    Informative Title, centered
#####+    Relevant x and y axis labels (not simply variables names!)
#####+    Human-readable axes with no overlap (you might have to flip x and y to fix that). Note: You do not have to convert the decimal to a percentage.
#####+    Color the columns by the team member's position (so, all PF's should have the same color, etc.)



```r
# Resample data frame for FG% stas per player and position
fgpct <- select(shootstats, contains("Name"),("Position"),("FG%"))

# Convert FG% variable to factor
fgpct$`FG%` <- as.factor(fgpct$`FG%`)

# Sort table by Position
fgpct <- dplyr::arrange(fgpct, desc(Position))

# Create Position sorting level
fgpct$Name2 <- factor(fgpct$Name, as.character(fgpct$Name))

# Bar plot of players and FG%, color coded by position 
p <- ggplot(fgpct, aes(x=Name2, y=`FG%`, fill=Position)) +  geom_bar(stat="identity") + theme_classic() + coord_flip() +
  labs(title ="Field Goals by Player and Position", x = "Name of Player", y = "Field Goal Percentage")

p
```

![](l_pierce_Livesession9assignment_files/figure-html/barplot_Spurs_shooting-1.png)<!-- -->



