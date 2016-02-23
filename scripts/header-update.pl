#!/usr/bin/perl

use v5.14.0;
use autodie;
use strict;
use POSIX qw(strftime);
use Getopt::Std;

our %opts;
our $VERSION = "0.0.1";
$Getopt::Std::STANDARD_HELP_VERSION = 1;

sub HELP_MESSAGE {
	print <<EOF
  Usage: $0 [OPTIONS] FILES
  -t            Update timestamp
  --help        Print this help message
  --version     Print version message
EOF
}

sub VERSION_MESSAGE {
	print "$0 version $main::VERSION\n";
}

getopts('t', \%opts) or die "Failed to process command line arguments";
unless(@ARGV) {
	say "Nothing to do.";
	exit(0);
}

my @date = split /\s+/, strftime "%m/%d %H:%M:%S %Y", localtime;
$^I = "";

while (<>) {
	s/\b1999-\d{4}/1999-$date[2]/;
	s|\b\d{4}(?:/\d{2}){2}.*Exp|$date[2]/$date[0] $date[1] Exp|
		if ($opts{t});
	print;
}
