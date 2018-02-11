---
title: "Live Session Unit 5 Assignment"
author: "Luke Pierce"
date: "February 13, 2018"
output:
   html_document:
     keep_md: true
---


####GitHub Repository: https://github.com/lp5510/Homework/tree/master/LiveSession04

# Questions

####Backstory: Your client is expecting a baby soon. However, he is not sure what to name the child.Being out of the loop, he hires you to help him figure out popular names. He provides for you raw data in order to help you make a decision.

###1.Data Munging: 

####Utilize yob2016.txt for this question. This file is a series of popular children's names born in the year 2016 in the United States.It consists of three columns with a first name, a gender, and the amount of children given that name.  However, the data is raw and will need cleaning to make it tidy and usable.

####a. First, import the .txt file into R so you can process it.  Keep in mind this is not a CSV file.  You might have to open the file to see what you're dealing with.  Assign the resulting data frame to an object, df, that consists of three columns with human-readable column names for each.


```r
# txt to csv
# Use read.table to read in txt file which is semicolon delimited 
df <- read.table("yob2016.txt", header = FALSE, sep=";", row.names = NULL)

# add column names
names(df) <- c("Name", "Gender", "Occurrence")

# change variable type for Name to character
df$Name <- as.character(as.factor(df$Name))
```

####b. Display the summary and structure of df


```r
# summary and structure

summary(df)
```

```
##      Name           Gender      Occurrence     
##  Length:32869       F:18758   Min.   :    5.0  
##  Class :character   M:14111   1st Qu.:    7.0  
##  Mode  :character             Median :   12.0  
##                               Mean   :  110.7  
##                               3rd Qu.:   30.0  
##                               Max.   :19414.0
```

```r
str(df)
```

```
## 'data.frame':	32869 obs. of  3 variables:
##  $ Name      : chr  "Emma" "Olivia" "Ava" "Sophia" ...
##  $ Gender    : Factor w/ 2 levels "F","M": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Occurrence: int  19414 19246 16237 16070 14722 14366 13030 11699 10926 10733 ...
```

####c.	Your client tells you that there is a problem with the raw file. One name was entered twice and misspelled.The client cannot remember which name it is; there are thousands he saw! But he did mention he accidentally put three y's at the end of the name. Write an R command to figure out which name it is and display it.


```r
# Find name with accidental "yyy" typed in
df[grep("yyy", df$Name), ]
```

```
##         Name Gender Occurrence
## 212 Fionayyy      F       1547
```

####d.	Upon finding the misspelled name, please remove this particular observation, as the client says it's redundant.Save the remaining dataset as an object: y2016 


```r
# Remove this row from data frame
y2016 <- df[-212, ]
```

###1.Data Merging:

####Utilize yob2015.txt for this question. This file is similar to yob2016, but contains names, gender, and total children given that name for the year 2015.

####a.	Like 1a, please import the .txt file into R.  Look at the file before you do. You might have to change some options to import it properly.Again, please give the dataframe human-readable column names. Assign the dataframe to y2015.


```r
# txt to csv
# Use read.table to read in txt file which is comma delimited 
y2015 <- read.table("yob2015.txt", header = FALSE, sep=",")

# add column names
names(y2015) <- c("Name", "Gender", "Occurrence")

# change variable type for Name to character
y2015$Name <- as.character(as.factor(y2015$Name))

# summary
summary(y2015)
```

```
##      Name           Gender      Occurrence     
##  Length:33063       F:19054   Min.   :    5.0  
##  Class :character   M:14009   1st Qu.:    7.0  
##  Mode  :character             Median :   11.0  
##                               Mean   :  111.4  
##                               3rd Qu.:   30.0  
##                               Max.   :20415.0
```

```r
# structure
str(y2015)
```

```
## 'data.frame':	33063 obs. of  3 variables:
##  $ Name      : chr  "Emma" "Olivia" "Sophia" "Ava" ...
##  $ Gender    : Factor w/ 2 levels "F","M": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Occurrence: int  20415 19638 17381 16340 15574 14871 12371 11766 11381 10283 ...
```
 
####b.	Display the last ten rows in the dataframe.  Describe something you find interesting about these 10 rows.


```r
# Examine last 10 values

tail(y2015, 10)
```

```
##         Name Gender Occurrence
## 33054   Ziyu      M          5
## 33055   Zoel      M          5
## 33056  Zohar      M          5
## 33057 Zolton      M          5
## 33058   Zyah      M          5
## 33059 Zykell      M          5
## 33060 Zyking      M          5
## 33061  Zykir      M          5
## 33062  Zyrus      M          5
## 33063   Zyus      M          5
```

```r
summary(tail(y2015, 10))
```

```
##      Name           Gender   Occurrence
##  Length:10          F: 0   Min.   :5   
##  Class :character   M:10   1st Qu.:5   
##  Mode  :character          Median :5   
##                            Mean   :5   
##                            3rd Qu.:5   
##                            Max.   :5
```

Since there are the same number of occurrences of each name, all "Occurrence" stats are equal to five, as well as
Min, Q1, Median, Mean, Q3 and Max. There is no statistical variance in these values.


####c.	Merge y2016 and y2015 by your Name column; assign it to final.  The client only cares about names that have data for both 2016 and 2015; there should be no NA values in either of your amount of children rows after merging.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
# Merge Female/male data frames using inner_join
# return all rows from x where there are matching values in y, and all columns from x and y.
# If there are multiple matches between x and y, all combination of the matches are returned.
final <- dplyr::inner_join(y2016, y2015, by = "Name")

# Select columns
final <- select(final, "Name", "Gender.y", "Occurrence.x", "Occurrence.y")

# Rename columns
final <- rename(final, Gender = Gender.y, Occurrence2016 = Occurrence.x, Occurrence2015 = Occurrence.y)

# Arrange rows by Gender
final <- arrange(final, (Gender))
```
 
###3. Data Summary
####Utilize your data frame object final for this part.

####a.	Create a new column called "Total" in final that adds the amount of children in 2015 and 2016 together.  In those two years combined, how many people were given popular names?


```r
# Sum occurrences for 2016 and 2015, append column, name "Total"
final <- dplyr::mutate(final, Total = Occurrence2016 + Occurrence2015)

# Sum Total Occurrences for names which appear both in 2015 and 2016
sum(final$Total)
```

```
## [1] 11404228
```

####b.	Sort the data by Total.  What are the top 10 most popular names?


```r
# Sort Total by most popular names (Occurrence)
MostPopularAll <- dplyr::arrange(final, desc(Total))

# List top 10 only:
TopTenAll <- dplyr::top_n(final, 10, Total)
TopTenAll
```

```
##        Name Gender Occurrence2016 Occurrence2015 Total
## 1      Emma      F          19414          20415 39829
## 2    Olivia      F          19246          19638 38884
## 3       Ava      F          16237          16340 32577
## 4    Sophia      F          16070          17381 33451
## 5  Isabella      F          14722          15574 30296
## 6      Noah      M          19015          19594 38609
## 7      Liam      M          18138          18330 36468
## 8   William      M          15668          15863 31531
## 9     Mason      M          15192          16591 31783
## 10    Jacob      M          14416          15914 30330
```

####c.	The client is expecting a girl!  Omit boys and give the top 10 most popular girl's names.


```r
# 10 most popular girl names only
FemaleMostPopularAll <- dplyr::filter(MostPopularAll, Gender=="F")
dplyr::top_n(FemaleMostPopularAll, 10, Total)
```

```
##         Name Gender Occurrence2016 Occurrence2015 Total
## 1       Emma      F          19414          20415 39829
## 2     Olivia      F          19246          19638 38884
## 3     Sophia      F          16070          17381 33451
## 4        Ava      F          16237          16340 32577
## 5   Isabella      F          14722          15574 30296
## 6        Mia      F          14366          14871 29237
## 7  Charlotte      F          13030          11381 24411
## 8    Abigail      F          11699          12371 24070
## 9      Emily      F          10926          11766 22692
## 10    Harper      F          10733          10283 21016
```

####d.	Write these top 10 girl names and their Totals to a CSV file.  Leave out the other columns entirely.


```r
# trim list and remove extra columns
FemaleTopTen <- dplyr::top_n(FemaleMostPopularAll, 10, Total)
FemaleTopTen <- select(FemaleTopTen, "Name", "Total")
FemaleTopTen
```

```
##         Name Total
## 1       Emma 39829
## 2     Olivia 38884
## 3     Sophia 33451
## 4        Ava 32577
## 5   Isabella 30296
## 6        Mia 29237
## 7  Charlotte 24411
## 8    Abigail 24070
## 9      Emily 22692
## 10    Harper 21016
```

```r
# Write out to csv file
write.csv(FemaleTopTen, file = "FemaleTopTen.csv", row.names = FALSE)
```
