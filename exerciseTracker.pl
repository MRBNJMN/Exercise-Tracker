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

use Getopt::Long qw(:config no_ignore_case);
use DBI;
require 'Exercise.pl';

# To be used with GetOpt::Long to accept command line parameters
my ($create, $read, $update, $delete, $weight, $reps, $distance, $time, $onDate);

# To be used for database connection
my ($DB, $user, $pass) = 
	("dbi:mysql:exerciseTracker", "exerciseUser", "ax4GuXhXjKxvj76F");

# Today's date is the default table name (i.e. d_YYYYMMDD)
# sprintf ensures consistency with leading zeroes
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my $storeDate = sprintf ("%d%02d%02d", $year + 1900, $mon + 1, $mday);

# Pull options from the command line
GetOptions (
	'C|create=s' => \$create,
	'R|read:s' => \$read,
	'U|update=s' => \$update,
	'D|delete=s' => \$delete,
	'w|weight=f' => \$weight,
	'r|reps=i' => \$reps,
	'd|distance=f' => \$distance,
	't|time=f' => \$time,
	'o|onDate=i' => \$onDate,
);

die "Usage error\n" if (
	not ($create || defined $read || $update || $delete)
	or ($create && (defined $read || $update || $delete))
	or (defined $read && ($create || $update || $delete || $weight || $reps || $distance || $time))
	or ($update && ($create || defined $read || $delete))
	or ($delete && ($create || defined $read || $update || $weight || $reps || $distance || $time))
);

# If the user specified a date, use it
$storeDate = $onDate if $onDate;

if (defined $create) {
	my $exercise = Exercise->new({
		'name' => $create,
		'weight' => $weight,
		'reps' => $reps,
		'distance' => $distance,
		'time' => $time,
	});
	$exercise->connectDB($DB, $user, $pass);
	$exercise->storeExercise($storeDate);	
	$exercise->disconnectDB();
}
elsif (defined $read) {
	if ($read) {
		my $exercise = Exercise->new({
			'name' => $read,
		});
		$exercise->connectDB($DB, $user, $pass);
		$exercise->pullExercise($storeDate);
		$exercise->disconnectDB();
	} else {
		my $exercise = Exercise->new({});
		$exercise->connectDB($DB, $user, $pass);
		$exercise->pullExerciseList($storeDate);
		$exercise->disconnectDB();
	}
}
elsif (defined $update) {
	my $exercise = Exercise->new({
		'name' => $update,
		'weight' => $weight,
		'reps' => $reps,
		'distance' => $distance,
		'time' => $time,
	});
	$exercise->connectDB($DB, $user, $pass);
	$exercise->updateExercise($storeDate, 'weight', $weight) if $weight;
	$exercise->updateExercise($storeDate, 'reps', $reps) if $reps;
	$exercise->updateExercise($storeDate, 'distance', $distance) if $distance;
	$exercise->updateExercise($storeDate, 'time', $time) if $time;
	$exercise->disconnectDB();
}
elsif (defined $delete) {
	my $exercise = Exercise->new({
		'name' => $delete,
	});
	$exercise->connectDB($DB, $user, $pass);
	$exercise->deleteExercise($storeDate);
	$exercise->disconnectDB();
}
else { print "Unknown Error!\n"; }

