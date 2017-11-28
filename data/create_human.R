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
