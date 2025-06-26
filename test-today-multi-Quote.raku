#!/usr/bin/env raku
use Cro;
use JSON::Pretty;

# the input file:  test-today-multi-Quote.raku
# the output file: test-today-multi-Quote{1..N}.json

use lib "./lib";
use FinanceAPI;

my ($fo, $res, %h, $fh, $jstr);

my @symbols = ["JAGIX", "MRK"];
my $dir = "test-jsons".IO;

my @fo;
my $interval = "1d";
my $range    = "5d";
while @symbols {
    my @s;
    if @symbols.elems > 10 {
        @s.push(@symbols.shift) for (0..^10);
    }
    else {
        @s.push(@symbols.shift) while @symbols;
    }

    # get a time-stamp and file type
    my $dt = DateTime.now.posix; # in seconds, should be same timestamp type as used
                                 # by FianceAPI output
    say "dt = '$dt'"; 
    #say "DEBUG exit..."; exit;

    $res = path-v6FinanceQuote @s;
    # the output file: test-today-multi-Quote{1..N}.raku
    $fo = "test-jsons/test-today-multi-Spark-{$dt}.json";
    @fo.push: $fo;
    $fo.IO.spurt: $res;
}
say "See output JSON files:";
say "  $_" for @fo;
