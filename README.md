# Course Assignment - Getting and Cleaning Data
Adam Sartiel

>R-Script description - run_analysis.R

This script performs the following task:
1. Opens the dyplr and tidyr libraries
2. Set working directory where the Samsung data files are
3. Read the training and test raw data and combines them into mergeddata data frame.
4. Similarity merge the list of train/test activities (1-6) and subject numbers (1-30) into totalactivities, and totalsubjects, respectively
5. Read the activity_labels file into the activities table, and create the Activity_Name textvector from the activities labels vector in the table. This would replace the number list with a descriptive text, e.g. 'LAYING'
6. Read the features file into 'columnnames' and add them as the names for the mergeddata data frame.
7. Use grep to create vectors of column numbers including 'mean' and 'std' labels, and unite them into 'selected' vector.
8. Filter mergeddata into workdata

totalactivities factors



