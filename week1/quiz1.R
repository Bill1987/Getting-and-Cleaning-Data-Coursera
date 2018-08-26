###--------------------------------------------------------------------------------------
###Question 1------Question 1-----------Question 1-------------Question 1-------Question 1
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
# from here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# How many properties are worth $1,000,000 or more?

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv","Q1.csv",method = "curl")
houseData <- read.csv("Q1.csv",stringsAsFactors = FALSE)

# 24 is Property value  .$1000000+
result_Q1 <- sum(houseData$VAL == 24,na.rm = TRUE)
print(result_Q1)

# 53

###--------------------------------------------------------------------------------------
###Question 2------Question 2-----------Question 2-------------Question 2-------Question 2

# Use the data you loaded from Question 1. Consider the variable FES in the code book. 
# Which of the "tidy data" principles does this variable violate?

result_Q2 <- unique(houseData$FES)
print(result_Q2)

# [1]  2 NA  7  1  4  8  3  5  6
# Tidy data has one variable per column.

###--------------------------------------------------------------------------------------
###Question 3------Question 3-----------Question 3-------------Question 3-------Question 3

# Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
# 
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
#     
#     dat
# 
# What is the value of:
#     
#     sum(dat$Zip*dat$Ext,na.rm=T)
#     
# (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)

# install.packages("xlsx")
library("xlsx")

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "Q3.xlsx", method = "curl")
dat <- read.xlsx("Q3.xlsx", sheetIndex = 1, header = TRUE, colIndex = 7:15, rowIndex = 18:23)
result_Q3 <- sum(dat$Zip * dat$Ext, na.rm = T)
print(result_Q3)

# 36534720

###--------------------------------------------------------------------------------------
###Question 4------Question 4-----------Question 4-------------Question 4-------Question 4

# Read the XML data on Baltimore restaurants from here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# 
# How many restaurants have zipcode 21231?

library(XML)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
# download.file(fileUrl, "Q4.xml", method = "curl")

# Must use parameter "useInternalNodes = TRUE"
# If not it will have an error 
# " unable to find an inherited method for function ¡®saveXML¡¯ for signature ¡®"character"¡¯"
# But this file is already downloaded, Why do it need to use the network???
doc <- xmlTreeParse("Q4.xml",useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)

zipcodes <- xpathSApply(rootNode,"//zipcode",xmlValue)
result_Q4 <- sum(zipcodes == 21231)
print(result_Q4)

# 127

###--------------------------------------------------------------------------------------
###Question 5------Question 5-----------Question 5-------------Question 5-------Question 5

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() 
# from here:
#     
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
# using the fread() command load the data into an R object
# 
#   DT
# 
# The following are ways to calculate the average value of the variable
# 
#   pwgtp15
# 
# broken down by sex. Using the data.table package, which will deliver the fastest user time?

library(data.table)
# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "Q5.csv", method = "curl")
DT <- fread("Q5.csv")

# loop 1000 times for clearer results
Q51 <- system.time(for (x in 1:1000) {DT[,mean(pwgtp15),by=SEX]} )
print(Q51)
# user  system elapsed 
# 0.78  0.03    0.81 
Q52 <- system.time(for (x in 1:1000) {mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)})
print(Q52)
# user  system elapsed 
# 34.38  0.02   34.61
Q53 <- system.time(for (x in 1:1000) {mean(DT$pwgtp15,by=DT$SEX)})
print(Q53)
# user  system elapsed 
# 0.05   0.00   0.05 
Q54 <- system.time(for (x in 1:1000) {sapply(split(DT$pwgtp15,DT$SEX),mean)})
print(Q54)
# user  system elapsed 
# 0.50   0.01   0.52 
Q56 <- system.time(for (x in 1:1000) {tapply(DT$pwgtp15,DT$SEX,mean)})
print(Q56)
# user  system elapsed 
# 0.53   0.01   0.54
Q55 <- system.time(for (x in 1:1000) {rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]})
# Error in rowMeans(DT) : 'x' must be numeric
# Timing stopped at: 0.92 0.02 0.94

# mean(DT$pwgtp15,by=DT$SEX)

###--------------------------------------------------------------------------------------
