#! /usr/bin/perl -w
use strict;
use warnings;

open DATFILE, '+>', "infile" or die "can not open text file: $!";

my $fstringMain = "%-2186s"; #formats the main line for 2086 characters
my $fstringInter = "%-120s"; #formats the interest string to be 120 char long (3 in main string)
my $fstringInst = "%-420s";  #formats the institution string to be 420 char long (8 in main string)
my $fstringTests = "%-252s"; #formats the tests string to be 252 char long (3 in main string)
my $fstringAll = $fstringMain.$fstringInter.$fstringInter.$fstringInter.$fstringInst.$fstringInst.$fstringInst.$fstringInst.$fstringInst.$fstringInst.$fstringInst.$fstringInst.$fstringTests.$fstringTests.$fstringTests;

my $count = 0;
my $rdsWanted = 10;

my $mn = "MainData";
my $mncn = "";
while ($count < $rdsWanted) {
	$mncn = $mn . ($count+1); 
	printf DATFILE $fstringAll,$mncn,"          HaroldMeijer","","          Curtis","          *Rd start Institution Data","","            InstitutionData1","            InstitutionData2","            InstitutionData3","            InstitutionData4","            InstitutionData5", "            InstitutionData6","            TestsData1","","            TestsData2";
	print DATFILE "\n";
	$count = $count + 1;
}
close DATFILE or die $!;
