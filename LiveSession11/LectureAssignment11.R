rm(list = ls())
setwd("I:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 11 Assignment")
setwd("J:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 11 Assignment")
setwd("P:/SMU/MSDS 6306 Doing Data Science/Lecture Assignments/Live Session Unit 11 Assignment")


library(fpp)
library(fpp2)
library(dplyr)
library("dygraphs")
library("forecast")
library("xts")

# Read EuStockMarkets data 1991 - 1999 
EUdata <- window(EuStockMarkets)

# Diagnostics
str(EUdata)
head(EUdata)

# Extract DAX data only
DAXdata <- EUdata[,1]

# Diagnostics
str(DAXdata)
head(DAXdata) 

# Plot time series data
plot(DAXdata, ylab="Closing Price", xlab="Year", main="DAX Index (1991-1999)", col = "blue")
abline(v=1997, col="red")

# Decompose components using multiplicative methods
DAXdataComp <- decompose(DAXdata, type = c("multiplicative"))
plot(DAXdataComp, col="blue")
abline(v=1997, col="red")

# 2.a. Temperature data ==========================================================================

?maxtemp
# Maximum annual temperatures (degrees Celsius) for Moorabbin Airport, Melbourne. 1971-2016.
# Annual time series of class ts.
# Examples
autoplot(maxtemp)

# 2.b. =========================================================================================

maxtemp_1990_2016 <- window(maxtemp,start=1990,end=2016)
#utils::View(maxtemp)

# 2.c. ============================================================================================

# SES analysis
# exponential smoothing
# simple means start with first sample, h=5 to predict out 5 years
maxtemp_ses_1990_2016_5y <- ses(maxtemp_1990_2016, alpha=0.8,beta=0.2,h=5)

# Predicted Values
plot(maxtemp_ses_1990_2016_5y, ylab="Temperature", xlab="Year", fcol="white", type="o", col="blue", main="Maximum Temperature Forecasts from Simple Exponential Smoothing")

# Fitted Values
fit_maxtemp_ses_1990_2016_5y <- fitted(maxtemp_ses_1990_2016_5y)
lines(fit_maxtemp_ses_1990_2016_5y, col="red", type="o")

# Forecasted Values
lines(maxtemp_ses_1990_2016_5y$mean, col="green", type="o")

# plot datelime from 2016
abline(v=2016, col="red")

legend("topleft", lty=1, col=c("blue", "red", "green"), c("Predicted", "Fitted", "5 Year Forecast"), pch=1)

# AICc of this ses model: 148.3759
maxtemp_ses_1990_2016_5y$model


# 2.d. ==============================================================================


# Holt analysis
# Damped linear trend 
# optimal means the initial values are optimized along with the smoothing parameters, h=5 to predict out 5 years
maxtemp_holt_1990_2016 <- holt(maxtemp_1990_2016, alpha=0.8, beta=0.2, damped=TRUE, initial='optimal',main="Maximum Temperature Forecasts from Holt's Damped Smoothing", h=5)

# Predicted Values
plot(maxtemp_holt_1990_2016, ylab="Temperature", xlab="Year", fcol="white", type="o", col="blue")

# Fitted Values
fit_holt_1990_2016 <- fitted(maxtemp_holt_1990_2016)
lines(fit_holt_1990_2016, col="red", type="o")

# The Forecasted Values
lines(maxtemp_holt_1990_2016$mean, col="green", type="o")

legend("topleft", lty=1, col=c("blue", "red", "green"), c("Predicted", "Fitted", "5 Year Forecast"), pch=1)


# AICc of this holt model: 157.9802
maxtemp_holt_1990_2016$model

# 2.e. ============================================================================================================

# AICc of this ses model: 148.3759
# AICc of this holt model: 157.9802

## Based on the Wikipedia entry on AICc, the one with the smaller value is the better fitting model so the ses model is the best of the two cases.

# 3.a ==================================================================================================

# Read in csv datasets for Ollivander and Gregorovitch
# Rename columns
Ollivander <- read.csv("./Unit11TimeSeries_Ollivander.csv", header=FALSE)
Ollivander <- dplyr::rename(Ollivander, "Year" = V1, "Wands" = V2)

Gregorovitch <- read.csv("./Unit11TimeSeries_Gregorovitch.csv", header=FALSE)
Gregorovitch <- dplyr::rename(Gregorovitch, "Year" = V1, "Wands" = V2)

# 3.b ==================================================================================================

# Convert "Year" to Date class variable for Ollivander and Gregorovitch
Ollivander$Year <- as.Date(Ollivander$Year,"%m/%d/%Y")
class(Ollivander$Year)

Gregorovitch$Year <- as.Date(Gregorovitch$Year,"%m/%d/%Y")
class(Gregorovitch$Year)

# 3.c ==================================================================================================

# Convert Ollivander and Gregorovitch data frames into xts (time series) objects 
OTS <- as.xts(Ollivander, order.by = Ollivander$Year)
OTS <- xts(Ollivander$Wands, order.by=Ollivander$Year)
utils::View(OTS)
str(OTS)
class(OTS)
OTS

GTS <- as.xts(Gregorovitch, order.by = Gregorovitch$Year)
GTS <- xts(Gregorovitch$Wands, order.by=Gregorovitch$Year)
utils::View(GTS)
str(GTS)
class(GTS)
GTS

# 3.d ==================================================================================================

# Bind both xts (time series) objects 

wandTS <-cbind(OTS, GTS)
colnames(wandTS) <- c("Ollivander", "Gregorovitch")

#wandTS <- merge(OTS, GTS, join = "right", fill = 9999)
#colnames(wandTS) <- c("Ollivander", "Gregorovitch")
#wandTS <- sapply(wandTS, as.numeric) 


utils::View(wandTS)
str(wandTS)

#dygraphs
dygraph(wandTS, main="Ollivander vs. Gregorovitch Wand Sales", ylab="Wands", xlab="Year") %>%
  dyOptions(rightGap=20) %>%
  dyLegend(width=291) %>%
  dyAxis('y', rangePad=10) %>%
  dySeries(name = "Ollivander", label = "Ollivander", color = "red") %>%
  dySeries(name = "Gregorovitch", label = "Gregorovitch", color = "darkgreen") %>%
  dyRangeSelector(height=100, fillColor = "purple") %>%
  dyShading(from = "1995-1-1", to = "1999-1-1", color = "#87f89b") %>%
  dyHighlight(highlightCircleSize = 5,
           highlightSeriesBackgroundAlpha = 0.5,
                       hideOnMouseOut = FALSE) %>%
  dyEvent("1995-1-1", "Voldemort Rises", labelLoc = "top") %>%
  dyEvent("1999-1-1", "Voldemort Defeated", labelLoc = "top")
# ================================================================================

# sapply(wandTS, as.numeric) 


