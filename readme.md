# Exercise Tracker

## Description
Exercise Tracker records exercises based on name, weight, reps, distance, and/or time. Exercises are stored by date in a database running locally. All four CRUD operations are supported - exercises can be created, read, updated, and deleted by date. If a date is not specified for any operation, the current date is used.

## Files
Exercise.pl - contains the Exercise class, with methods for database connection and disconnection, table creation, and exercise create, read, update, and delete actions.  
exerciseTracker.pl - command line program that utilizes the mathods of the Exercise class. Accepts arguments to create, read, update, and delete exercises, as well as specify date, weight, reps, distance, and/or time.

## Usage
Create:  
`$ ./exerciseTracker.pl --create <ARG> (OPTIONS)`  
  
Read:  
`$ ./exerciseTracker.pl --read (ARG) (OPTIONS)`  
  
Update:  
`$ ./exerciseTracker.pl --update <ARG> (OPTIONS)`  
  
Delete:  
`$ ./exerciseTracker.pl --delete <ARG> (OPTIONS)`

## Options
`-h, --help`  
See USAGE and OPTIONS  
  
`-m, --man`  
See the man page for full instruction  
  
Exercise Tracker requires that exactly one of these four options be specified:  
  
`-C, --create`  
Creates an exercise. Requires an argument for exercise name.  
Optional additional parameters: `-o, -w, -r, -d, -t`  
  
`-R, --read`  
Reads details of an exercise. Allows an argument for exercise name. If no name is specified, displays all exercises on a particular day.  
Optional additional parameters: `-o`  
  
`-U, --update`  
Updates a detail of an exercise. Requires an argument for exercise name.  
Mandatory additional parameter (only one): `-w, -r, -d, -t`  
Optional additional parameters: `-o`  
  
`-D, --delete`  
Deletes an exercise. Requires an argument for exercise name.  
Optional additional parameters: `-o`  
  
Additional Parameters:  
  
`-o, --onDate`  
Specifies date for any CRUD operation  
Format: YYYYMMDD  
  
`-w, --weight`  
Specifies weight for --create or --update operations  
  
`-r, --reps`  
Specifies reps for --create or --update operations  
  
`-d, --distance`  
Specifies distance for --create or --update operations  
  
`-t, --time`  
Specifies time for --create or --update operations  

## Examples
Create an exercise called 'Squats', performed on the current date:  
`$ ./exerciseTracker.pl --create 'Squats'`  

Create an exercise called 'Bench Press' @ 135 pounds and 5 reps, performed on October 8th, 2014:  
`$ ./exerciseTracker.pl --create 'Bench Press' -w 135 -r 5 -o 20141008`  

Create an exercise called 'Jogging' @ 3 miles and 30 minutes, performed on the current date:  
`$ ./exerciseTracker.pl --create 'Jogging' -d 3 -t 30`  

Read all exercises performed on the current date:  
`$ ./exerciseTracker.pl --read`  

Read all exercises performed on October 8th, 2014:  
`$ ./exerciseTracker.pl --read -o 20141008`  

Read the specifics of 'Bench Press', performed on October 8th, 2014:  
`$ ./exerciseTracker.pl --read 'Bench Press' -o 20141008`  

Update 'Bench Press' performed on October 8th, 2014 with weight 155:  
`$ ./exerciseTracker.pl --update 'Bench Press' -w 155 -o 20141008`  

Update 'Jogging' performed on the current date with a time of 3 and a half hours:  
`$ ./exerciseTracker.pl --update 'Jogging' -t 3.5`  

Delete 'Squats' performed today:  
`$ ./exerciseTracker.pl --delete 'Squats'`  

Delete 'Bench Press' performed on October 8th, 2014:  
`$ ./exerciseTracker.pl --delete 'Bench Press' -o 20141008`

## Future Improvements
* Read, update, and delete operations should be improved to target single instances, rather than all instances, of an exercise  
* User should be able to update multiple parameters at the same time, rather than just one  
* User should have fine-tuned control over units used for distance, time, and weight  

## Author
Ben Wheeler  
Altair Engineering  
bwheeler@altair.com
