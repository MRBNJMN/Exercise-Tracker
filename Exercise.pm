package Exercise;

# Constructor (left generic for inheritance purposes)
sub new {
	my $class = shift;
	# $objRef is a reference to an anonymous hash, passed to the constructor
	# by the program based on command line variables specified by the user.
	# Keys: name (required), weight, reps, sets, time, distance
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
		'PrintError' = 1, # Warnings
		'RaiseError' = 1, # Dies
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
		"CREATE TABLE IF NOT EXISTS $date (
			 logMy		VARCHAR(64) NOT NULL,
			 weight 	INTEGER,
			 reps		INTEGER,
			 distance 	INTEGER,
			 time 		INTEGER
		 )";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute();

	# Parse $self->{} and store the results
	$statement =
		"INSERT INTO $date (logMy, weight, reps, distance, time) VALUES
		($self->{'logMy'}, $self->{'weight'}, $self->{'reps'}, $self->{'distance'}, $self->{'time'})";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute();
}

sub pullExerciseList {
	my $self = shift;
	my $date = shift;
	my $statement; # Used to query the DB with interpolation available
	my $sth; # Used as a statement handler

	# Pull exercise names based on date
	$statement =
		"SELECT logMy
		FROM $date";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute;
}

sub pullExercise {
	my $self = shift;
	my $name = shift;
	my $date = shift;
	my $statement; # Used to query the DB with interpolation available
	my $sth; # Used as a statement handler

	# Pull exercise specifics based on name and date
	$statement =
		"SELECT *
		FROM $date
		WHERE logMy = $name";
	$sth = $self->{'DBH'}->prepare($statement);
	$sth->execute;

	# Process the query
	while ( my ($logMyPull, $weightPull, $repsPull, $distancePull, $timePull) =  $sth->fetchrow_array() ) {
		print
		"logMy: $logMyPull\n
		weight: $weightPull\n
		reps: $repsPull\n
		distance: $distancePull\n
		time: $timePull\n
		\n"
	};
}

