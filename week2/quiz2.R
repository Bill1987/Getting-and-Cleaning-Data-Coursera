###------------------------------------------------------------------------------------------------------------------------------------------------
###Question 1------Question 1-----------Question 1-------------Question 1-------Question 1
# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories (hint: this is the url you want 
# "https://api.github.com/users/jtleek/repos"). Use this data to find the time that the 
# datasharing repo was created. What time was it created?
#     
# This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
# You may also need to run the code in the base R package and not R studio.

library(httr)
library(httpuv)
library(jsonlite)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at 
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "ca4e939476f37cfe295c",
                   secret = "8cd9f9085bf9d623980acafbf363644e8185dce4")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
json1 <- content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

result_Q1 <- gitDF[gitDF$full_name == "jtleek/datasharing","created_at"]

print(result_Q1)

# [[1]]
# [1] "2013-11-07T13:25:07Z"


###------------------------------------------------------------------------------------------------------------------------------------------------
###Question 2------Question 2-----------Question 2-------------Question 2-------Question 2

# The sqldf package allows for execution of SQL commands on R data frames. We will use the 
# sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.
# 
# Download the American Community Survey data and load it into an R object called
# 
# acs
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
# Which of the following commands will select only the data for the probability weights pwgtp1 
# with ages less than 50?

# install.packages("sqldf")
library("sqldf")

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "Q2.csv", method = "curl")
acs <- data.table::data.table(read.csv("Q2.csv", stringsAsFactors = FALSE))

result_Q21 <- sqldf("select pwgtp1 from acs where AGEP < 50")
result_Q22 <- sqldf("select * from acs")
result_Q23 <- sqldf("select pwgtp1 from acs")
result_Q24 <- sqldf("select * from acs where AGEP < 50")

print("select pwgtp1 from acs where AGEP < 50")

# [1] "select pwgtp1 from acs where AGEP < 50"


###------------------------------------------------------------------------------------------------------------------------------------------------
###Question 3------Question 3-----------Question 3-------------Question 3-------Question 3

# Using the same data frame you created in the previous problem, what is the equivalent 
# function to unique(acs$AGEP)

un_AGEP <- unique(acs$AGEP)

# result_Q31 <- sqldf("select AGEP where unique from acs")
# Error in result_create(conn@ptr, statement) : near "unique": syntax error

result_Q32 <- sqldf("select distinct pwgtp1 from acs")
if(identical(result_Q32[,], un_AGEP))
{
    print("select distinct pwgtp1 from acs")   
}

result_Q33 <- sqldf("select distinct AGEP from acs")
if(identical(result_Q33[,], un_AGEP))
{
    print("select distinct AGEP from acs")   
}

# result_Q34 <- sqldf("select unique AGEP from acs")
# Error in result_create(conn@ptr, statement) : near "unique": syntax error

# [1] "select distinct AGEP from acs"


###------------------------------------------------------------------------------------------------------------------------------------------------
###Question 4------Question 4-----------Question 4-------------Question 4-------Question 4

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
#     
# http://biostat.jhsph.edu/~jleek/contact.html
# 
# (Hint: the nchar() function in R may be helpful)

con <- url("http://biostat.jhsph.edu/~jleek/contact.html", "r") 
# only need 100 lines
HTML <- readLines(con,100) 
close(con)
print(c(nchar(HTML[10]),nchar(HTML[20]),nchar(HTML[30]),nchar(HTML[100])))

# [1] 45 31  7 25


###------------------------------------------------------------------------------------------------------------------------------------------------
###Question 5------Question 5-----------Question 5-------------Question 5-------Question 5

# Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# 
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# 
# (Hint this is a fixed width file format)

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for", "Q5.for", method = "curl")

# column is a fixed width 
# 1 space + 9 char week + (5 space + 4 SST + 4SSTA) * 4
colWidths <- c(-1, 9, rep(c(-5,4,4), 4))
colNames <- c("week", "sstNino12", "sstaNino12","sstNino3", "sstaNino3", "sstNino34","sstaNino34", "sstNino4","sstaNino4")

df <- read.fwf("Q5.for", colWidths, header = FALSE, skip = 4, col.names = colNames)
result_Q5 <- sum(df[,4])

print(result_Q5)

# [1] 32426.7
