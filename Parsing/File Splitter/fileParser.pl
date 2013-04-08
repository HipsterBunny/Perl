#! /usr/bin/perl -w
#*---------------------------------------------------
#* Program Written by Emely Curtis
#* 02/06/2013
#*---------------------------------------------------
use strict;
use warnings;
use Cwd;

# infile name has been predetermined (infile) in sub function 'open_all_files'
# read in command line argument
my $deleteFiles = $ARGV[0] || die "\n>> Type 'y' to DELETE old file versions, or 'n' to KEEP old versions.
                                   \n>> ex: 'perl $0 y'\n\n";
chomp ($deleteFiles);

# formatted Date for the file names, the numerical date, and the current time
my @currentDateReturn = current_data_return(); # return all needed date and time data
my $fileNameDate = $currentDateReturn[0]; # DDMMYYYY
my $numericDate = $currentDateReturn[1];  # DD/MM/YYYY
my $time = $currentDateReturn[2];         # HH:MM

open_all_files($fileNameDate);

# *********************length of each file record.  Change if fields are added
my $mainLength = 2186;
my $intLength = 120;
my $insLength = 420;
my $testLength = 252;

my $numberOfint = 3; # number of interest records
my $numberOfins = 8; # number of institution records
my $numberOftes = 3; # number of test records
# ***********************************************************************************

# File name information
my $header        = "HD";
my @main         = ("MN","_main");
my @interests    = ("INT","_intr");
my @institutions = ("INST","_inst");
my @tests        = ("TEST","_tests");
# Final file names for the 5 main files
my $headerFileName = $header . $fileNameDate;
my $mainFileName =  $main[0] . $main[1];
my $interestsFileName =  $interests[0] . $interests[1];
my $institutionsFileName =  $institutions[0] . $institutions[1];
my $testsFileName =  $tests[0] . $tests[1];
# End of file name

# ~~~~~~~~!start of main script

my $splitAllDataAt = "";
# unpack input string for sep. files
$splitAllDataAt = create_unpack_string 
                ($mainLength, $intLength, $insLength, $testLength, $numberOfint, $numberOfins, $numberOftes);

my $splitRecords = 'A10 A30 A*'; #used to split the int/inst/and test files to check to see if record exists

my @data = <INFILE>; # bring in all of the data from the text file
my $currentLine = "";
my $dataArraySize = @data;

my $count = 0; # count will count how many records.  count and dataArraySize should be the same
               # value by the end of the program.  This will be the number of main records
my $interestCount = 0; # number of interest records on file
my $institutionCount = 0; # number of institutions records on file
my $testsCount = 0; # number of tests records on file.

while($count < $dataArraySize) {
    $currentLine = $data[$count];

    my @splitData = unpack ($splitAllDataAt, $currentLine); #holds all the split srings
    my $splitDataArraySize = @splitData;

    my $dataCount = 1;
    my $currentTotal = $numberOfint; #number to count till

    my $currentDataLine = $splitData[0]; # main record line
	
    print_main_file($count, $currentDataLine); # prints main line to main file

    while ($dataCount <= $currentTotal) { # while loop for interests
    	my $currentDataLine = $splitData[$dataCount];
    	my @splitInterest = unpack ($splitRecords, $currentDataLine); #holds all the split srings


    	if ($splitInterest[1] =~ /[[:alpha:]]/) { # if the string has characters
    	    print_to_interests_file($interestCount, $currentDataLine);   		
    	    $interestCount = $interestCount +1;
    	}
    	$dataCount = $dataCount + 1;
    }

    $currentTotal = $currentTotal + $numberOfins;
    while ($dataCount <= $currentTotal) { # while loop for institutions
    	my $currentDataLine = $splitData[$dataCount];
    	my @splitInstitutions = unpack ($splitRecords, $currentDataLine); #holds all the split srings

    	if ($splitInstitutions[1] =~ /[[:alpha:]]/) { # if the string has characters
    	    print_to_institutions_file($institutionCount, $currentDataLine);
    	    $institutionCount = $institutionCount +1;
    	}
    	$dataCount = $dataCount + 1;
    }
    
    $currentTotal = $currentTotal + $numberOftes;
    while ($dataCount <= $currentTotal) { # while loop for test
    	my $currentDataLine = $splitData[$dataCount];
    	my @splitTests = unpack ($splitRecords, $currentDataLine); #holds all the split srings

    	if ($splitTests[1] =~ /[[:alpha:]]/) { # if the string has characters
    	    print_to_tests_file($testsCount, $currentDataLine);
    	    $testsCount = $testsCount + 1;
    	}
    	$dataCount = $dataCount + 1;
    }
    $count = $count + 1;
}

# Print header - will need to add and pass the individual counts for the different files here
my $headerInfoString = "HD ". $numericDate. "  " . $time . "  " . $count ." applications\n";
print_header_file ($headerInfoString, $mainFileName, $interestsFileName, 
	 $institutionsFileName, $testsFileName, $count, $interestCount, $institutionCount, $testsCount);

# End of header info
#!!** Print all files before this point **!!

close_all_files(); # close all open files

if ($deleteFiles eq 'y') { # if the user wants the old files to be deleted
    delete_old_files($header, $main[0], $interests[0], $institutions[0], $tests[0]); 
}
rename_files ($headerFileName, $mainFileName, $interestsFileName, $institutionsFileName, $testsFileName);
# ~~~~~~~~~~!End main script

#**************************************SUB-FUNCTIONS***********************************
# will close all open file folders
sub  close_all_files {
	# start file closing and renaming opperations
	close INFILE or die $!;               
	close HEADERFILE or die $!;        # 1-header       file
	close MAINFILE or die $!;          # 2-main         file
	close INTERESTSFILE or die $!;     # 3-intersts     file
	close INSTITUTIONSFILE, or die $!; # 4-institutions file
	close TESTSFILE or die $!;         # 5-tests        file
}

#create unpack string from the given record data
sub create_unpack_string {
    my $mainLength = shift @_;
    my $intLength = shift @_;
    my $insLength = shift @_;
    my $testLength = shift @_;

    my $numberOfint = shift @_; # number of interest records
    my $numberOfins = shift @_; # number of institution records
    my $numberOftes = shift @_; # number of test records

    my $splitAllDataAt = 'A'.$mainLength . " ";
    my $i = 0; #iterator created specificaly to use in for loop
    for ($i = 0; $i < $numberOfint; $i++) {
        $splitAllDataAt = $splitAllDataAt . 'A'. $intLength . " ";
    }

    for ($i = 0; $i < $numberOfins; $i++) {
        $splitAllDataAt = $splitAllDataAt . 'A'. $insLength . " ";
    }

    for ($i = 0; $i < $numberOftes; $i++) {
        $splitAllDataAt = $splitAllDataAt . 'A'. $testLength . " ";
    }
    return $splitAllDataAt;
}

# will return data that can be found from the localtime() Perl function
sub current_data_return {
    my $type = shift @_;
    my $fileDate = "";
    my $numericDate = "";
    my $time = "";

    my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
    my $year = 1900 + $yearOffset;
    $month = $month + 1;
    $dayOfWeek = $dayOfWeek + 1;
	
    # for the month and the day, make sure they display MM or DD if the day or month is a single digit
    if ($month < 10) {
 	$month = "0". $month;
    }
    if ($dayOfMonth < 10) {
 	$dayOfMonth = "0" . $dayOfMonth;
    }
    if ($hour < 10) {
	$hour = "0". $hour;
    }
    if ($minute < 10) {
	$minute = "0". $minute;
    }
    $fileDate = "$month$dayOfMonth$year";
    $numericDate = "$month/$dayOfMonth/$year";	
    $time = "$hour:$minute";
    return ($fileDate, $numericDate, $time);		
}

# This functions will erase all of the old files 
sub delete_old_files {
    my $headerTell = shift @_;
    my $mainTell = shift @_;
    my $interestsTell = shift @_;
    my $institutionsTell = shift @_;
    my $testsTell = shift @_;

    my $dir = getcwd(); # get path to current directory
              opendir DIR, $dir or die "cannot open the directory $dir: $!";
    my @allFileNames = readdir (DIR); # read all filed in directory into an array
    closedir (DIR);
    my $numberOfFiles = @allFileNames;
    my $count = 0; 
    my $substringFound = "f";

    while ($count < $numberOfFiles) {
	$currentLine = $allFileNames[$count];
	$currentLine =~ s/^\s+|\s+$//g; #remove all white space from current line

	# If the tell for the given files is in the file name ...
	if ((index($currentLine, $headerTell) != -1) or (index($currentLine, $mainTell) != -1) 
	   or (index($currentLine, $interestsTell) != -1) or (index($currentLine, $institutionsTell) != -1)
	   or (index($currentLine, $testsTell) != -1)) {
		$substringFound = "t"; # change the substring to reflect a file found
	}
		
	# Determine if the file needs to be deleted
	if ($substringFound eq "t") {
		my $deleteFormat = "%-25s %-15s";
		printf $deleteFormat, $currentLine, " - Deleted";
		print "\n";
		unlink("$currentLine");
	}
	$substringFound = "f";
	$count = $count + 1;
    }
}

# this will open all of the files to be written to
sub open_all_files {
    my $fileDate = shift @_;
    my $inFileName = "infile";
	
    open INFILE, '<', $inFileName or die "can not open infile: $!";

    # all these files will be renamed at the end of the script
    open HEADERFILE,'+>', "header.txt" or die $!;
    open MAINFILE,'+>', "main.txt" or die $!; 
    open INTERESTSFILE, '+>', "interests.txt" or die $!; 
    open INSTITUTIONSFILE, '+>', "institutions.txt" or die $!; 
    open TESTSFILE, '+>', "tests.txt" or die $!; 
} 

# print the header file
sub print_header_file {
    my $headerInfoString = shift @_;
    my $mainFileName = shift @_;
    my $interestsFileName = shift @_;
    my $institutionsFileName = shift @_;
    my $testsFileName = shift @_;
	
    my $count = sprintf("%05d", shift @_);
    my $interestCount = sprintf("%05d", shift @_);
    my $institutionCount = sprintf("%05d", shift @_);
    my $testsCount = sprintf("%05d", shift @_);
		
    print HEADERFILE $headerInfoString;
    print HEADERFILE $mainFileName. "             ". $count."\n";
    print HEADERFILE $interestsFileName. "            ".  $interestCount."\n";
    print HEADERFILE $institutionsFileName. "           ". $institutionCount."\n";
    print HEADERFILE $testsFileName. "          ". $testsCount;
}

# prints the main file information to the main file
sub print_main_file {
    my $count = shift @_;
    my $currentDataLine = shift @_;
		
    if ($count == 0) {
	print MAINFILE $currentDataLine; # print the record to the main file
    }
    else {
	print MAINFILE "\n". $currentDataLine;
    }
}

# with the input data this function will print to the interests file 	
sub print_to_interests_file {
    my $recordCount = shift @_;
    my $currentDataLine = shift @_;

    if ($recordCount == 0) {
 	print INTERESTSFILE $currentDataLine;
    }
    else {
	print INTERESTSFILE  "\n".$currentDataLine; #print into file
    }
}

# with the input data this function will print to the institutions file 	
sub print_to_institutions_file {
    my $recordCount = shift @_;
    my $currentDataLine = shift @_;

    if ($recordCount == 0) {
	print INSTITUTIONSFILE $currentDataLine;
    }
    else {
	print INSTITUTIONSFILE  "\n".$currentDataLine; #print into file
    }
}

# with the input data this function will print to the tests file 	
sub print_to_tests_file {
    my $recordCount = shift @_;
    my $currentDataLine = shift @_;

    if ($recordCount == 0) {
	print TESTSFILE $currentDataLine;
    }
    else {
	print TESTSFILE  "\n".$currentDataLine; #print into file
    }
}

# this subfile will rename all of the generic file names to the appropriate titles
sub rename_files {
    my $headerFileName = shift @_;
    my $mainFileName = shift @_;
    my $interestsFileName = shift @_;
    my $institutionsFileName = shift @_;
    my $testsFileName = shift @_;

    # rename all 5 created files to their proper names
    rename 'header.txt', $headerFileName;
    rename 'main.txt', $mainFileName;
    rename 'interests.txt', $interestsFileName;
    rename 'institutions.txt', $institutionsFileName;
    rename 'tests.txt', $testsFileName;
}

