#Kisun Pokharel
#15th November 2017
#This is an R script that does some data wrangling 

lrn14<-read.csv("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = T)
str(lrn14)
#the dataframe consist values for 60 different variables. For more information on variable names 
#and their description: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-meta.txt 
#moreover, str gives information about what kind of values each variables store - in our case, all variables except gender
#are integers (int). Gender is a factor variable as it stores whether the observation is male "M" or female "F"
head(lrn14) #the command will show first six observations of 60 variables
dim(lrn14) # the dim command shows the dimension of the table i.e 183 x 60 i.e 183 observations (rows) for 60 variables (columns)

#install.packages("dplyr") #just to show that dplyr package should be installed before calling it. Only for the first time so I marked it as a comment.
library(dplyr) #access the dplyr library. 

#Now create new variables out of existing variables
colnames(lrn14) 

#this showed that Age, Attitude, Points and gender are already existing. Now, we need to add three new variables (deep, stra and surf) to the lrn14
lrn14_deep<-c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
lrn14_deep_select<-select(lrn14, one_of(lrn14_deep))
lrn14$deep<-rowMeans(lrn14_deep_select)


lrn14_surf<-c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14_surf_select<-select(lrn14, one_of(lrn14_surf))
lrn14$surf<-rowMeans(lrn14_surf_select)

lrn14_stra<-c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14_stra_select<-select(lrn14, one_of(lrn14_stra))
lrn14$stra<-rowMeans(lrn14_stra_select)

colnames(lrn14)
head(lrn14)
#using the head command (above) we noticed that Attitude variable needs to be scaled, i.e currently, it's sum of 10 variables. Thus, in order
#to get an average, we divide attitude by 10.
div_att<-lrn14$Attitude / 10
#and add new variable attitude
lrn14$attitude <- div_att
#exclude ovservations where exam points is zero
lrn14<-filter(lrn14, Points > 0)
#check new table
head(lrn14)

#keep only selected columns i.e Age, Points, gender, deep, surf, stra and attitude
keep_cols<-c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")
lrn14_select<-select(lrn14, one_of(keep_cols))
head(lrn14_select)
#lets convert Age and Points to age and points
colnames(lrn14_select)[2]<-"age"
colnames(lrn14_select)[7]<-"points"
head(lrn14_select)

#check the dimensions
dim(lrn14_select) #166 x 7
#save the file under IODS-project/data. 
write.table(lrn14_select, "data/learning2014.csv", sep = "\t")
#Validation
#1. read the file
learning2014<-read.csv("data/learning2014.csv", sep = "\t")
#2. get the structure and head of file
str(learning2014) #166 obs. of 7 variables
dim(learning2014) #166 7

