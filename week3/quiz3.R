###Question 1------Question 1-----------Question 1-------------Question 1-------Question 1
#
# The American Community Survey distributes downloadable data about United States
# communities. Download the 2006 microdata survey about housing for the state of Idaho
# using download.file() from here:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#
# and load the data into R. The code book, describing the variable names is here:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#
# Create a logical vector that identifies the households on greater than 10 acres who sold
# more than $10,000 worth of agriculture products. Assign that logical vector to the
# variable agricultureLogical. Apply the which() function like this to identify the rows of the
# data frame where the logical vector is TRUE.
#
# which(agricultureLogical)
#
# What are the first 3 values that result?

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv" ,"Q1.csv" ,"curl")
communities <- read.csv("Q1.csv",stringsAsFactors = FALSE)

# Lot size:House on ten or more acres  AND
# Sales of Agriculture Products .$10000+
agricultureLogical <- communities$ACR == 3 & communities$AGS == 6
print(head(which(agricultureLogical),3))

## [1] 125 238 262

###--------------------------------------------------------------------------------------
###Question 2------Question 2-----------Question 2-------------Question 2-------Question 2
#
# Using the jpeg package read in the following picture of your instructor into R
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting
# data? (some Linux systems may produce an answer 638 different for the 30th quantile)
#
#
# #If you are using it for the first time, please install it
# #install.packages("jpeg")
# library("jpeg")
#
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg","Q2.jpg" ,"curl")
# picture <- readJPEG("Q2.jpg",native=TRUE)
# print(quantile(picture, probs = c(0.3, 0.8)))
#
# #      30%       80%
# # -15259150 -10575416

##--------------------------------------------------------------------------------------
##Question 3------Question 3-----------Question 3-------------Question 3-------Question 3

# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#
# Load the educational data from this data set:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
#
# Match the data based on the country shortcode. How many of the IDs match? Sort the
# data frame in descending order by GDP rank (so United States is last). What is the 13th
# country in the resulting data frame?
#
# Original data sources:
#
# http://data.worldbank.org/data-catalog/GDP-ranking-table
#
# http://data.worldbank.org/data-catalog/ed-stats

#If you are using it for the first time, please install it
#install.packages("dplyr")
library("dplyr")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv" ,"Q3a.csv" ,"curl")
GDP <- read.csv("Q3a.csv", skip = 4,stringsAsFactors = FALSE)
#Remove invalid data
GDP <- select(GDP,CountryCode=X,Ranking=X.1, Economy = X.3, US.dollars = X.4)
GDP <- GDP[GDP$CountryCode != "" & GDP$Ranking != "" ,]
GDP$Ranking <- as.numeric(GDP$Ranking)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv" ,"Q3b.csv" ,"curl")
educational <- read.csv("Q3b.csv",stringsAsFactors = FALSE)

edu_GDP <- merge(GDP,educational, all = TRUE, by = c("CountryCode"))

print(sum(!is.na(unique(edu_GDP$Ranking))))

odr_GDP <- arrange(edu_GDP,desc(edu_GDP$Ranking))
print(odr_GDP[13,]$Long.Name)

#189 matches, 13th country is St. Kitts and Nevis

###--------------------------------------------------------------------------------------
###Question 4------Question 4-----------Question 4-------------Question 4-------Question 4

# What is the average GDP ranking for the "High income: OECD" and 
# "High income: nonOECD" group?

print(mean(odr_GDP[odr_GDP$Income.Group == "High income: OECD",]$Ranking,na.rm = TRUE))

print(mean(odr_GDP[odr_GDP$Income.Group == "High income: nonOECD",]$Ranking,na.rm = TRUE))

# 32.96667, 91.91304


###--------------------------------------------------------------------------------------
###Question 5------Question 5-----------Question 5-------------Question 5-------Question 5

# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?

table(odr_GDP$Income.Group, cut(odr_GDP$Ranking,5))

# 5







