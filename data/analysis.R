#Kisun Pokharel
#15th November 2017
#This is an R script that does the regression analysis and modeling. 
#The results along with the explanations are available in chapter 2. see https://kisun.github.io/IODS-project/

#read the table
lrn2014<-read.table("data/learning2014.csv")
#look at the structure and dimension
str(lrn2014)
dim(lrn2014)
#load GGally and ggplot2 libraries. GGally package was installed (first time only)
library(GGally)
library(ggplot2)
plot_lrn2014<-ggpairs(lrn2014, mapping = aes(col=gender, alpha = 0.3), lower=list(combo = wrap ("facethist", bins = 20)))
plot_lrn2014 
model<-lm(points ~ attitude + stra + surf, data = lrn2014)
summary(model)
model_sig<-lm(points ~ attitude, data = lrn2014)
summary(model_sig)
par(mfrow = c(2,2))
plot(model_sig, which = c(1,2,5))
