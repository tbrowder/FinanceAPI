#!/usr/bin/env raku
use Cro;
use JSON::Pretty;

use lib "./lib";
use FinanceAPI;

my ($fo, $res, %h, $fh, $jstr);

my @symbols = ["JAGIX", "MRK"];
my $dir = "test-jsons".IO;

my @fo;
my $interval = "1d";
my $range    = "5d";
for @symbols -> $symbol {

    # get a time-stamp and file type
    my $dt = DateTime.now.posix; # in seconds, should be same timestamp type as used
                                 # by FianceAPI output
    say "dt = '$dt'"; 
    #say "DEBUG exit..."; exit;

    $res = path-v8FinanceChart $symbol, :$range; 
    $fo = "test-jsons/dividends-test-{$dt}.json";
    $fo.IO.spurt: $res;
    @fo.push: $fo;
}

say "See output JSON files:";
say "  $_" for @fo;
