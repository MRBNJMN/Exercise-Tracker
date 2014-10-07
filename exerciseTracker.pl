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

use Getopt::Long;
use DBI;
require 'Exercise.pl';

# To be used with GetOpt::Long to accept command line parameters
my ($logMy, $weight, $reps, $distance, $time, $seeMy, $onDate);

# To be used for database connection
my ($DB, $user, $pass) = 
	("dbi:mysql:exerciseTracker", "exerciseUser", "ax4GuXhXjKxvj76F");

# To be used for storage by date
# sprintf ensures consistency with leading zeroes
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my $storeDate = sprintf ("%d%02d%02d", $year + 1900, $mon + 1, $mday);

# Pull options from the command line
GetOptions (
	'l|logMy=s' => \$logMy,
	'w|weight=f' => \$weight,
	'r|reps=i' => \$reps,
	'd|distance=f' => \$distance,
	't|time=f' => \$time,
	's|seeMy=s' => \$seeMy,
	'o|onDate=i' => \$onDate,
);

die "Usage error\n" if (
	not ($logMy || $onDate)
	or ($logMy && ($onDate || $seeMy))
	or ($onDate && ($logMy || $weight || $reps || $distance || $time)));

# Create an Exercise object
my $exercise = Exercise->new({
	'logMy' => $logMy,
	'weight' => $weight,
	'reps' => $reps,
	'distance' => $distance,
	'time' => $time,
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
