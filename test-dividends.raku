#!/usr/bin/env raku
use Cro;
use JSON::Pretty;

use lib "./lib";
use FinanceAPI;
use FinanceAPI:Vars;

my ($fo, $res, %h, $fh, $jstr);

my $symbol = "jagix";

my @fo;
#my $interval = "1d";
my $range     = "1y";
$res = path-v8FinanceChart $symbol, :$range; 
$fo = "dividends-default.json";
$fo.IO.spurt: $res;

say "See output JSON files:";
say "  $_" for @fo;
