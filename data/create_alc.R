#Kisun Pokharel
#21.11.2017
#This script is about wrangling student performance data that was downloaded from UCI Machine Learning Repository

#Read both student-mat.csv and student-por.csv into R (from the data folder) and explore the structure and dimensions of the data. (1 point)
smat<-read.csv("data/student-mat.csv", sep = ";")
spor<-read.csv("data/student-por.csv", sep = ";")
#get a peek inside the data
head(smat)
#it showed that the data contained ";" as delimiter so I modified the read.csv command accordingly.

#Now let's look at the structure of the two tables
str(smat) #contains data of types Factor (such as School, sex, address, famsize and reason) and int (age, Medu, traveltime, failures, etc)
str(spor) #similar variables as smat 

#Similarly, let's see the dimension of these tables
dim(smat) # 395 observations for 33 variables
dim(spor) #649 observations for 33 variables

#Join the two data sets using the variables "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery",
#"internet" as (student) identifiers. Keep only the students present in both data sets. Explore the structure and dimensions of the joined data. (1 point)
library(dplyr)
commonvar<-c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
smat_spor<-inner_join(smat, spor, by=commonvar, suffix = c(".m", ".p"))
str(smat_spor)
dim(smat_spor) #382 observations for 53 variables


#Either a) copy the solution from the DataCamp exercise The if-else structure to combine the 'duplicated' answers in the joined data, or b) write your own 
#solution to achieve this task. (1 point)
#create a new data frame with joined columns
joined <- select(smat_spor, one_of(commonvar))
not_joined<-colnames(smat)[!colnames(smat) %in% commonvar]
not_joined
glimpse(joined)

#use if-else structure to combine answers from not_joined in the joined data
for(col_name in not_joined) {
  two_cols <- select(smat_spor, starts_with(col_name))
  first_col<-select(two_cols, 1)[[1]]
  
  if(is.numeric(first_col)){
    joined[col_name] <- round(rowMeans(two_cols))
  } else {
    joined[col_name] <- first_col
  }
}

glimpse(joined)


#Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. Then use 'alc_use'
#to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise). (1 point)
alc<-mutate(joined, alc_use = (Dalc + Walc)/2) # I wanted to rename the dataframe as alc instead of joined. that's why I created alc from joined.
alc<-mutate(alc, high_use = alc_use > 2)



#Glimpse at the joined and modified data to make sure everything is in order. The joined data should now have 382 observations of 35 variables. Save the 
#joined and modified data set to the ‘data’ folder, using for example write.csv() or write.table() functions. (1 point)

glimpse(alc)
write.csv(alc, file = "data/alc.csv")

