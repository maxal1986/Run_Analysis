# Description of `run_analysis.R` script 

***Note 1:*** If you like to work with a clean console and workspace, uncomment the first lines and you will start the script clearing both the console and the workspace. 

***Note 2:*** You need to have the ["UCI HAR DATASET"](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) in your working directory.

***Note 3:*** Make sure you have the package `dplyr` installed in your computer.

This README includes the steps used in the script `run_analysis.R` as the final product of the Course Project in the Getting and Cleaning Data Course by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD.

### Initial set up: Reading folder and files

The following variables are used to represent the folders and files needed:

* **Folder variables**
    + Root folder: `root`
    + Folder with the testing files: `test_folder`
    + Folder with the training files: `train_folder`

* **File variables**
    + File with the 6 activity codes: `activity_file`
    + File with the 561 feature codes: `features_file`
    + File with the subject code for each observation: `subjects_<test or train>_file`
    + File with the features data for each observation: `X_<test or train>_file`
    + File with the activity code for each observation: `Y_<test or train>_file`

### Step 1: Reading Features (561 features)

1. The code reads the features in `features_file` and sets the 2nd column as character. This column indicates the name of each feature.

2. Since only mean() and std() features are required, we use `grep()` over the features names to select those features that we need. In total, we need 33 features for the mean () and 33 features for the std(). ***Hint:*** This indicates that the final tidy data will have at least 66 variables.

### Step 2: Reading Activities (6 activities)

1. The code reads the activities in `activity_file` and sets the 2nd column as character. This column indicates the name of each activity.

### Step 3: Reading observations of 561 Features (2947 test and 7352 train)

1. The codes reads all the observations for each of the 561 features included in the `X_<test or train>_file`.

2. We use the `selected_features` generated in Step 1.2 and we filter the observations for each of the 66 selected features.

3. We set names to identify each feature.

### Step 4: Reading the activity associated to each observation (2947 test and 7352 train)

1. The codes reads all the observations included in the `Y_<test or train>_file`. Each observation indicates which activity was executed. ***Hint:*** This indicates that the final tidy data will have one more variable (66 + 1 = 67).

2. Using `merge()` we merge the activity name instead of a number. 

### Step 5: Reading the subject associated to each observation (2947 test and 7352 train)

1. The codes reads all the observations included in the `subjects_<test or train>_file`. Each observation indicates a subject. ***Hint:*** This indicates that the final tidy data will have one more variable (67 + 1 = 68).

2. We set the variable name to `SubjectId`.

### Step 6: Creating the combined data (68 variables per observation)

1. We join the variables together for each subset using `data.frame(subject_data, activity_data, features_data)`

    + Testing data dimensions: 2947 observations x 68 variables 
    + Training data dimensions: 7352 observations x 68 variables 

2. We set the variable name `Activity` to the activity data so we can bind the data in the next step. 

### Step 7: Creating the combined data with the 2 data sets (10299 obervations of 68 variables)

1. Using `rbind()` we combine the train and test data sets.

### Step 8: Creating the tidy data result with the mean of the Features

**Note:** Remember that library `dplyr` needs to be installed for executing this step

1. We use `group_by()` to group the data using `SubjectId` and `Activity`

2. We use `summarise_each_()` to summarize the data applying `mean()` to the 66 features selected.

### Step 9: Creating the file with the tidy data result

1. We use `write.table()` to create a `result.txt` file including the tidy data.





