# Assignment Submission for 'Getting and Cleaning Data' Course

by Momoko Price


### To generate the data set for Step 5: 



1. Download or clone the [assignment repo from Github](https://github.com/MogwaiMomo/getting-cleaning-data-assignment).

2. Open the file run_analysis.R in R or RStudio (RStudio is recommended!)

3. Source the file - a few important notes:

  - Upon source, this script will download the required data set from the zip URL given in the assignment instructions. 
  - Upon source, this script will store the data set in a folder called 'input', which will be created in whatever dir run_analysis.R is stored locally. 
  - Upon source, this script will save local files for the Step 4 and Step 5 data sets in a folder called 'output', also created in the same dir as run_analysis.R

4. To view the generated tidy data set for Step 5, you can either type `read.table('./output/Step_5_data.txt')` in the R console, or, if using RStudio, simply type `View(Step_5_final_dataset)` in your console after the script has run. 

5. To view the generated descriptive-but-not-yet-tidy data set for Step 4 (optional), you can either type `read.table('./output/Step_4_data.txt')` in the R console, or, if using RStudio, simply type `View(Step_4_final_dataset)` in your console after the script has run. 
  