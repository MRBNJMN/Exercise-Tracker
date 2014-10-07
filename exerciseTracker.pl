#!/usr/bin/env perl 

#===============================================================================
#         FILE: exerciseTracker.pl
#
#        USAGE: ./exerciseTracker.pl  
#
#  DESCRIPTION: Command-line tool to store exercises to a database by date
#
#       AUTHOR: Ben Wheeler, bwheeler@altair.com
#      VERSION: 0.9.0
#      CREATED: 14-10-07 10:21:00 AM
#===============================================================================

use 5.010;
use strict;
use warnings;

use GetOpt::Long;
use DBI;
use Exercise;

# To be used with GetOpt::Long to accept command line parameters
my ($logMy, $weight, $reps, $distance, $time, $seeMy, $onDate);

# To be used for database connection
my ($DB, $user, $pass) = 
	("exerciseTracker", "exerciseUser", "ax4GuXhXjKxvj76F");

# To be used for storage by date
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
	localtime(time);
my $storeDate = $year + 1900 . $mon + 1 . $mday;

# Pull options from the command line
GetOptions (
	'l|logMy=s' = \$logMy,
	'w|weight=i' = \$weight,
	'r|reps=i' = \$reps,
	'd|distance=i' = \$distance,
	't|time=i' = \$time,
	's|seeMy=s' = \$seeMy,
	'o|onDate=i' = \$onDate,
);

# Create an Exercise object
my $exercise = new->Exercise({
	'logMy' = $logMy,
	'weight' = $weight,
	'reps' = $reps,
	'distance' = $distance,
	'time' = $time,
});

# Connect to the DB
$exercise->connectDB($DB, $user, $pass);

# If $logMy has been specified, store the exercise in the DB by date
if ($logMy) {
	$exercise->storeExercise($storeDate);
}

# If $onDate has been specified, we need to fetch
if ($onDate) {
	# If the name of the exercise has been specified, get the specifics
	if ($seeMy) { $exercise->pullExercise($seeMy, $onDate); }
	# Else, list the exercises performed on that date
	else { $exercise->pullExerciseList($onDate); }
}

$exercise->disconnectDB();
