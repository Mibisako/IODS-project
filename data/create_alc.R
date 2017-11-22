#Volkova Anastasiia
#15.11.2017
#This is the script for creating a dataset downloaded from https://archive.ics.uci.edu/ml/datasets/Student+Performance to work with logistic regression during the MOOC "Introduction to Open Data Science".
math <- read.table("student-mat.csv", header = TRUE, sep = ";")
por <- read.table("student-por.csv", header = TRUE, sep = ";")
dim(math) #It has 395 observations of 33 variables. 
dim(por) #It has 649 observations of 33 variables.
str(math) 
str(por)
#Both files have categorical and metric variables.

library(dplyr)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por")) #only the students present in both data sets
colnames(math_por)
dim(math_por) #It has 382 observations of 53 variables.
str(math_por) #Now variables have an indicator after their name ".math/por" to indicate from which these variables came

# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2) #the average of the answers related to weekday and weekend alcohol consumption
alc <- mutate(alc, high_use = alc_use > 2) #TRUE for students for which 'alc_use' is greater than 2

glimpse(alc) #Observations: 382; Variables: 35; everything is OK
write.table(alc, file = "alc.csv", sep = ";", col.names = TRUE)

