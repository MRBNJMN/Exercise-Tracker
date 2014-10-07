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
	# This information will be hardcoded into the program for now
}

# Disconnects from the DB (for good housekeeping)
sub disconnectDB {
	my $self = shift;
	
	# Disconnect from DB
	# This will happen at the end of the program
}

# Stores the exercise in the DB according to date
sub storeExercise {
	my $self = shift;
	
	my $date = shift;
	my $exercise = shift; # Reference to object

	# Parse $exercise->{} and store the results
}

sub pullExerciseList {
	my $self = shift;
	
	my $date = shift;

	# Pull exercise names based on date
}

sub pullExercise {
	my $self = shift;

	my $name = shift;
	my $date = shift;

	# Pull exercise specifics based on name and date
}

