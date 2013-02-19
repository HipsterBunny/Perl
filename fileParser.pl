#!/xampp/perl/bin/perl -w

use MIME::Base64;
use DBI;
use DBD::mysql;

$database = "test";
$host = "localhost";
$user = "";
$pw = "";

$connect = DBI->connect("DBI:mysql:$database:$host", $user, $pw)
  or die "UNABLE TO CONNECT: $DBI::errstr\n";

if ($#ARGV != 0){
 	print "usage: ./fileParser.pl data.txt\n";
 	exit;
}

if (defined $connect) {
  print "Populating Database...\n";
}

$inputfile=$ARGV[0];      # File given as arg
$data = "";
$year = current_year();
$count = 0;

open  IN, '<' , $inputfile || die ("Could not open file $inputfile");

while (<IN>) {

    $location = index($_, "*");
    if ($location != -1) {
       @field=split /\*/, $_;
       chomp $field[1];

       $populate = $connect->prepare("INSERT INTO table (userName, userData, year) VALUES(?,?,?)");

       $data =  encode_base64($data);

       #test to see if user already exists for the given year
       $test = $connect->prepare("SELECT ID, userName, userData, year FROM table WHERE userName = ?");
       $test->execute("$field[1]");

       while (my $row = $test->fetchrow_hashref()) {
          if ($row->{userName} eq $field[1]){
             if ($row->{year} == $year) {
                die ("\nUser data has already been entered for this year.\nNo changes made.\n\n");
             }
          }
       }
       $populate->execute("$field[1]", "$data", "$year");
       $count = $count +1;
       $data = ""; #make empty for new user data
  }
  else {
    $data = $data. "~" ."$_"; #bring in each line of user data from infile
  }
}
print "\n$count Records added to the database.\n";
close IN;

sub current_year {
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime();
  my $year = 1900 + $yearOffset;

  return ($year);    
}
