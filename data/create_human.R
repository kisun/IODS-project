hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
#look at structure
str(hd)
str(gii)
#and dimension
dim(hd)
dim(gii)

#Summaries of the variables
summary(hd)
summary(gii)

#We need to rename variable names. So first let's look all variable names.
colnames(hd)
colnames(hd)<-c("HDIR", "Country", "HDI", "LifeExp", "EduYr", "EduYr_mean", "GNI", "GNI-HDR")
colnames(gii)
colnames(gii)<-c("GIIR", "Country", "GII", "MatMor", "Ados_BR", "Parli_pcnt", "Edu2_F", "Edu2_M", "LFP_F", "LFP_M")

#Let's check the changes have happened
head(hd)
head(gii)

#Mutate the "Gender inequality" data. Here, we will create two additional variables for "gii" data.
#1. we create ratio of Female and Male population with secondary education. Let's name new variable Edu2R, where Edu2R=Edu2_F/Edu2_M
gii_m<-mutate(gii, Edu2R = Edu2_F/Edu2_M)
#2. Similarly, we create ratio of female and male labour force participation. Let's name this new variable LFPR, where LFPR = LFP_F/LFP_M
gii_m1<-mutate(gii_m, LFPR = LFP_F/LFP_M)
#Let's see if these variables are added
head(gii_m1)

#Finally, we join two datasets using Country variables as the identifier.
human<-inner_join(gii_m1, hd, by="Country")
head(human)
str(human)
dim(human)
write.table(human, "data/human.csv")

#The following is the continuation of the above data.
#read the table that was created earlier.
#Either (1) read the table created earlier or (2) from the web!
my_human<-read.table("data/human.csv")
#reading from web is preferred for consistency with the exercise instructions
human<-read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt")
#muatate the data by transforming GNI variable to numeric
library(stringr)
str_replace(human$GNI, pattern = ",", replace = "") %>% as.numeric
#exclude all variables except country, edu2.fm, labo.fm, edu.exp, life.exp, gni, mat.mor, ado.birth and parli.f
colnames(human)
#[1] "GIIR"       "Country"    "GII"        "MatMor"     "Ados_BR"    "Parli_pcnt" "Edu2_F"    
#[8] "Edu2_M"     "LFP_F"      "LFP_M"      "Edu2R"      "LFPR"       "HDIR"       "HDI"       
#[15] "LifeExp"    "EduYr"      "EduYr_mean" "GNI"        "GNI.HDR"  

keep<-c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F" )

#let's select the above variables
human<-select(human, one_of(keep))

#remove all rows with missing values

human_clean<-filter(human, complete.cases(human) == T)
tail(human_clean, 10)
#remove the last seven rows that are not countries
human_clean<-human_clean[1:(nrow(human_clean)-7),]
tail(human_clean)
#designate country names as the row names
rownames(human_clean)<-human_clean$Country
dim(human_clean)
#remove the Country column as it has now become rowname
human_clean<-select(human_clean, -Country)
dim(human_clean)
head(human_clean)

write.table(human_clean, "data/human.csv")
