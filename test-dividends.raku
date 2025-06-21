#!/usr/bin/env raku
use Cro;
use JSON::Pretty;

use lib "./lib";
use FinanceAPI;

my ($fo, $res, %h, $fh, $jstr);

my @symbols = ["JAGIX", "MRK"];

my @fo;
my $interval = "1d";
my $range    = "5d";
$res = path-v8FinanceChart $symbol, :$range; 
$fo = "dividends-default.json";
$fo.IO.spurt: $res;

say "See output JSON files:";
say "  $_" for @fo;
