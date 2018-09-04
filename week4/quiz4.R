###----------------------------------------------------------------------------------------------------------------------
###Question 1------Question 1-----------Question 1-------------Question 1-------Question 1

# The American Community Survey distributes downloadable data about United States 
# communities. Download the 2006 microdata survey about housing for the state of 
# Idaho using download.file() from here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?

url_Q1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
# download.file(url_Q1,"Q1.csv" ,"curl")
SurveyData <- read.csv("Q1.csv", stringsAsFactors = FALSE)

dataNames <- names(SurveyData)
result_Q1 <- strsplit(dataNames[[123]],"wgtp")
print(result_Q1)

# [1] ""   "15"

###----------------------------------------------------------------------------------------------------------------------
###Question 2------Question 2-----------Question 2-------------Question 2-------Question 2

# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Remove the commas from the GDP numbers in millions of dollars and average them. 
# What is the average?
#     
#     Original data sources:
#     
#     http://data.worldbank.org/data-catalog/GDP-ranking-table

url_Q2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
# download.file(url_Q2,"Q2.csv" ,"curl")
GDP <- read.csv("Q2.csv",skip = 5,nrows = 190, header = FALSE, stringsAsFactors = FALSE)

# clean the data
GDP <- GDP[,c(1,2,4,5)]
names(GDP) <- c("CountryCode", "Rank", "Country.Name", "GDP.Value")
GDP$GDP.Value <- as.numeric(gsub(",", "",GDP$GDP.Value))

result_Q2 <- mean(GDP$GDP.Value, na.rm = TRUE)
print(result_Q2)

# [1] 377652.4

###----------------------------------------------------------------------------------------------------------------------
###Question 3------Question 3-----------Question 3-------------Question 3-------Question 3

# In the data set from Question 2 what is a regular expression that would allow you to count 
# the number of countries whose name begins with "United"? Assume that the variable with the 
# country names in it is named countryNames. How many countries begin with United?

countryNames <- GDP$Country.Name

# include "United"
grep("*United",countryNames)

# end with "United"
grep("United$",countryNames)

# begins with "United"
begins <- grep("^United",countryNames)
result_Q3 <- c("grep('^United',countryNames)", length(begins))
print(result_Q3)

# [1] "grep('^United',countryNames)" "3" 

###----------------------------------------------------------------------------------------------------------------------
###Question 4------Question 4-----------Question 4-------------Question 4-------Question 4

# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. Of the countries for which the end 
# of the fiscal year is available, how many end in June?
#     
# Original data sources:
#     
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats

url_Q4 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
# download.file(url_Q4,"Q4.csv" ,"curl")
educational <- read.csv("Q4.csv", stringsAsFactors = FALSE)

# only need part of data
eduNotes <- educational[,c("CountryCode","Special.Notes")]

GDP_EDU <- merge(eduNotes,GDP,  by = "CountryCode")
# convert to lower
result_Q4 <- length( grep("fiscal year end.*june", tolower(GDP_EDU$Special.Notes)) )
print(result_Q4)

# [1] 13

###----------------------------------------------------------------------------------------------------------------------
###Question 5------Question 5-----------Question 5-------------Question 5-------Question 5

# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices 
# for publicly traded companies on the NASDAQ and NYSE. Use the following code to download 
# # data on Amazon's stock price and get the times the data was sampled.
# 
# library(quantmod)
# amzn = getSymbols("AMZN",auto.assign=FALSE)
# sampleTimes = index(amzn)
# 
# How many values were collected in 2012? How many values were collected on Mondays in 2012?

# install.packages("quantmod")
library("quantmod")
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

result_Q51 <- sum(year(sampleTimes) == 2012)

#my computer language is Chinese
# Sys.setlocale("LC_TIME", "English")
result_Q52 <- sum(year(sampleTimes) == 2012 & weekdays(sampleTimes) == "Monday")

print(c(result_Q51,result_Q52))

# [1] 250  47
