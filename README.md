## Preparing steps
Unzip the UCI HAR Dataset file and place the whole UCI "HAR Dataset" folder to your working directory.

## Process of script
1. Load in, combine, and extract the record data
2. Load in and combine the activity label ID
3. Transform the activity label ID into activity name
4. Load in and combine the subject ID
5. Combine all components to form the tidy dataset by using melt and ddply functions
