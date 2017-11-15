#Volkova Anastasiia
#15.11.2017
#This is the script for creating a dataset to work with during the MOOC "Introduction to Open Data Science".

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header=TRUE, sep="\t") #The file was successfully read into R.
str(lrn14) #Almost all variables are metric, except for the "gender", which is a two-level factor.
dim(lrn14) #It has 183 observations of 60 variables.

library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# create column 'attitude' by scaling the column "Attitude"
lrn14$attitude <- lrn14$Attitude / 10

#Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points by combining questions
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# see the stucture of the new dataset
str(learning2014)

learning2014$deep_adjusted <-   learning2014$deep/12  # previous Deep score divided by the number of the items of the scale
learning2014$surface_adjusted  <-  learning2014$surf/12 # previous Surface score divided by the number of the items of the scale
learning2014$strategic_adjusted <- learning2014$stra/8 # previous Strategic score divided by the number of the items of the scale

#Exclude observations where the exam points variable is zero
learning2014 <- filter(learning2014, Points>0) #The data now have 166 observations and 10 variables - 7 + 3 adjusted

#Set the working directory of R session the IODS project folder 
getwd()
setwd("C:/Users/Missao/Documents/GitHub/IODS-project")

#Save the analysis dataset to the ‘data’ folder
write.table(learning2014, file="C:/Users/Missao/Documents/GitHub/IODS-project/data/learning2014.txt", sep="\t")

#Demonstrate that you can also read the data again
demonstration<-read.table("C:/Users/Missao/Documents/GitHub/IODS-project/data/learning2014.txt", header=TRUE, sep="\t")

str(demonstration) #Same variables and numbers of observation
head(demonstration) #Same data