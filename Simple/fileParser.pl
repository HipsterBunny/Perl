if ($#ARGV != 0) { # if the user does not specify in-file...
    # print message to help them properly run the script
    print ">> usage: perl fileParser.pl data.txt\n";
    print ">> Please enter data infile text\n";
    exit;
}

$inputfile = $ARGV[0];      # In-file name as given by user
$count = 0;
$parseAt = ":D"; # this is what we are taking out of our datafile

# open the in-file.  If there is no data file by the given name 
# then print an error message for the user.
open  IN, '<' , $inputfile || die (">> Could not open file $inputfile\n");
open OUT, '+>', "outData.txt" || die (">> Something wrong with outData.txt\n");

# while the in-file is being read...
while (<IN>) {

    $location = index($_, $parseAt);
    if ($location != -1) { # if the parse phrase is in the current line
	# split at the the phrase and put into 'field' array
        @field = split /$parseAt/, $_;
	$fieldSize = @field;
	
	$data = $data . "~"; # start the line with ~  
	# put all the array into the data line separated by spaces
        while ($count < $fieldSize) {
	    $data = $data . " " . $field[$count];
	    $count = $count + 1;
        }
	$count = 0;
    }
    else { # if the parse phrase does not exist in the current line
        $data = $data. "~" ."$_"; # add the line to data (adding ~ between 
			          # the new and old data
    }   
}
print OUT $data . "\n";

close IN;
close OUT;

sub current_year {
  my ($second, $minute, $hour, $dayOfMonth, $month, 
      $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
  my $year = 1900 + $yearOffset;
  
  return ($year);
}
