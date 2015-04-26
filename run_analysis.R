# Clear workspace and Console
# rm(list = ls())
# cat("\014")

if(file.exists("./UCI HAR Dataset")){
        # Load dplyr library
        library(dplyr)
        
        # Folders used
        root <- "./UCI HAR Dataset/"
        test_folder <- paste(root, "test/", sep = "")
        train_folder <- paste(root, "train/", sep = "")
        
        # Files used
        activity_file <- "activity_labels.txt"
        features_file <- "features.txt"
        subjects_test_file <- "subject_test.txt"
        subjects_train_file <- "subject_train.txt"
        X_test_file <- "X_test.txt"
        Y_test_file <- "y_test.txt"
        X_train_file <- "X_train.txt"
        Y_train_file <- "y_train.txt"
        
        # Step 1: Reading Features (561)
        # Read features and set 2nd column as character
        features <- read.table(paste(root, features_file, sep = ""))
        features$V2 <- as.character(features$V2)
        # Filter the mean() and std() features (33 each)
        mean_features <- grep('-mean\\(', features$V2)
        std_features <- grep('-std\\(', features$V2)
        selected_features <- sort(c(mean_features,std_features))
        
        # Step 2: Reading Activities (6)
        # Read activities and set 2nd column as character
        activities <- read.table(paste(root,activity_file, sep = ""))
        activities$V2 <- as.character(activities$V2)
        
        # Step 3: Reading observations of 561 Features (2947 test and 7352 train)
        # Read all observations for all Features
        X_test <- read.table(paste(test_folder, X_test_file, sep = ""))
        X_train <- read.table(paste(train_folder, X_train_file, sep = ""))
        # Filter the selected Features (66) for all observations
        X_test <- X_test[,selected_features]
        X_train <- X_train[,selected_features]
        # Set names to each variable identifying a feature
        names(X_test) <- features[selected_features,2]
        names(X_train) <- features[selected_features,2]
        
        # Step 4: Reading the activity associated to each observation (2947 test and 7352 train)
        # Read each activity for each observation
        Y_test <- read.table(paste(test_folder, Y_test_file, sep = ""))
        Y_train <- read.table(paste(train_folder, Y_train_file, sep = ""))
        # Merge the activity name instead of a #
        Y_test <- merge(activities, Y_test)[,2]
        Y_train <- merge(activities, Y_train)[,2]
        
        # Step 5: Reading the subject associated to each observation (2947 test and 7352 train)
        # Read each subject for each observation
        subject_test <- read.table(paste(test_folder, subjects_test_file, sep = ""))
        subject_train <- read.table(paste(train_folder, subjects_train_file, sep = ""))
        # Set a name to identify this variable
        names(subject_test)[1] <- "SubjectId"
        names(subject_train)[1] <- "SubjectId"
        
        #Step 6: Creating the combined data (68 variables per observation)
        # Join the variables together for each subset 
        test_data <- data.frame(subject_test, Y_test, X_test)
        train_data <- data.frame(subject_train, Y_train, X_train)
        # Set the name to the activity so you can bind it in the next step
        names(test_data)[2] <- "Activity"
        names(train_data)[2] <- "Activity"
        
        #Step 7: Creating the combined data with the 2 data sets (10299 obervations of 68 variables)
        data <- rbind(test_data, train_data)
        
        #Step 8: Creating the tidy data result with the mean of the Features
        result <- data %>% group_by(SubjectId, Activity) %>% 
                summarise_each_(funs(mean), vars=names(data)[3:68])
        
        # Clear the workspace and leave the result data set only
        rm(list = setdiff(ls(),c("result")))
        
        #Step 9: Creating the file with the tidy data result
        write.table(result, "result.txt", row.names = FALSE)
        
}else {
        print("Data set not detected. Closing...")
}
