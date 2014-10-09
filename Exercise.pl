package Exercise;

# Constructor (left generic for inheritance purposes)
sub new {
	my $class = shift;
	# $objRef is a reference to an anonymous hash, passed to the constructor
	# by the program based on command line variables specified by the user.
	# Keys: name, weight, reps, distance, time, onDate
	my $objRef = shift;

	bless $objRef, $class;
	return $objRef;
}

# Establishes a connection to the DB
sub connectDB {
	my $self = shift;
	my $DB = shift;
	my $user = shift;
	my $pass = shift;

	# Connect to DB
	$self->{'DBH'} = DBI->connect($DB, $user, $pass, {
		'PrintError' => 1, # Warnings
		'RaiseError' => 1, # Dies
	}) or die "Can't connect to DB $DB: $DBI::errstr";
}

# Disconnects from the DB (for good housekeeping)
sub disconnectDB {
	my $self = shift;
	
	# Disconnect from DB
	$self->{'rc'} = $self->{'DBH'}->disconnect
		or warn "Couldn't disconnect: $self->{'DBH'}->errstr";
}

# Stores the exercise in the DB according to date
sub storeExercise {
	my $self = shift;
	my $date = shift;
	my $statement; # Used to query the DB with interpolation available
	my $sth; # Used as a statement handler

	# Create the table if it doesn't exist
	$statement =
		"CREATE TABLE IF NOT EXISTS d_$date (name VARCHAR(64), weight FLOAT, reps FLOAT, distance FLOAT, time FLOAT)";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute() or die "Table could not be created!\n";

	# Parse $self->{} and store the results
	$statement =
		"INSERT INTO d_$date (name, weight, reps, distance, time) VALUES ('$self->{'name'}', '$self->{'weight'}', '$self->{'reps'}', '$self->{'distance'}', '$self->{'time'}')";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute() or die "Records could not be stored!\n";
}

# Pulls details of all exercises with a specified name on a particular date
sub pullExercise {
	my $self = shift;
	my $date = shift;
	my $statement; # Used to query the DB with interpolation available
	my $sth; # Used as a statement handler

	# SELECT all information FROM the table representing the date specified WHERE the name of the exercise matches
	$statement = "SELECT * FROM d_$date WHERE name = '$self->{'name'}'";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute; 
	
	die "No records for $self->{'name'} on $date\n" if $sth->rows == 0;

	# Print the results, unless the result is 0
	while ( my ($namePull, $weightPull, $repsPull, $distancePull, $timePull) =  $sth->fetchrow_array() ) {
		print "name: $namePull\n";
		print "weight: $weightPull\n" unless $weightPull == 0;
		print "reps: $repsPull\n" unless $repsPull == 0;
		print "distance: $distancePull\n" unless $distancePull == 0;
		print "time: $timePull\n" unless $timePull == 0;
	};
}

# Pulls all exercises performed on a particular date
sub pullExerciseList {
	my $self = shift;
	my $date = shift;
	my $statement; # Used to query the DB with interpolation available
	my $sth; # Used as a statement handler

	# SELECT exercise names FROM the table representing the date specified (YYYYMMDD)
	$statement = "SELECT name FROM d_$date";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute or die "No records for $date\n";

	# Print the results
	print "Here's what you did on $date:\n";
	while ( my $namePull = $sth->fetchrow_array() ) {
		print "$namePull\n";
	}
}

sub updateExercise {
	my $self = shift;
	my $date = shift;
	my $field = shift;
	my $value = shift;
	my $statement;
	my $sth;
	
	$statement = "UPDATE d_$date SET $field = $value WHERE name = '$self->{'name'}'";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute or die "Record for $self->{'name'} not found\n";

	print "Record $self->{'name'} on $date updated\n";
}

sub deleteExercise {
	my $self = shift;
	my $date = shift;
	my $statement;
	my $sth;

	$statement = "DELETE FROM d_$date WHERE name = '$self->{'name'}'";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute or die "No records for $self->{'name'} on $date\n";

	# Print a confirmation
	print "Record $self->{'name'} on $date deleted\n";
}

1;
