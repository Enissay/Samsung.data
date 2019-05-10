
# Download Files ----------------------------------------------------------

library(data.table)
setwd("C:/Users/U6065449/Downloads/nuevo")

fileurl<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('./UCI HAR Dataset.zip')){
  download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip", exdir = getwd())
}

# Convert into one data frame ---------------------------------------------

features <- read.csv('./UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features<-as.character(features[,2])
head(features)

data_x_train <- read.csv('./UCI HAR Dataset/train/X_train.txt')
data_y_train <- read.csv('./UCI HAR Dataset/train/Y_train.txt', sep = ' ')
data_subject_train <- read.csv('./UCI HAR Dataset/train/subject_train.txt', sep = ' ')

head(data_x_train)
head(data_y_train)
head(data_subject_train)

data.train<-data.frame(data_subject_train,data_y_train,data_x_train) 
names(data.train)<-c(c('subject','activity'))
head(data.train)

# With tables -------------------------------------------------------------

data_x_test <- read.table('./UCI HAR Dataset/train/X_train.txt')
data_y_test <- read.table('./UCI HAR Dataset/train/Y_train.txt', header = FALSE, sep = ' ')
data_subject_test <- read.table('./UCI HAR Dataset/train/subject_train.txt', sep = ' ')

data.test<-data.frame(data_subject_train,data_y_train,data_x_train) 
names(data.test)<-c(c('subject','activity'))
head(data.test)


# Merge data --------------------------------------------------------------

new_data<-rbind(data.train,data.test)

# activities --------------------------------------------------------------

mean_std.select<-grep('mean|std',features)
head(mean_std.select)
data.sub<-new_data[,c(1,2,mean_std.select+2)]
names(data.sub)

# replace names -----------------------------------------------------------

name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new

# new tidy data set -------------------------------------------------------

data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
