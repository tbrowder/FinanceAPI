#!/usr/bin/env raku
use Cro;
use JSON::Pretty;

use lib "./lib";
use FinanceAPI;
use FinanceAPI::Vars;

my ($fo, $res, %h, $fh, $jstr);

my @symbols = ["jagax"];

my $set = 0;
my @fo;
my $interval = "1d";
my $range     = "5d";
while @symbols {
    my @s;
    if @symbols.elems > 10 {
        @s.push(@symbols.shift) for (0..^10);
    }
    else {
        @s.push(@symbols.shift) while @symbols;
    }
    ++$set;
    $res = path-v8FinanceSpark @s, :$interval, :$range;
    $fo = "daily-default-set{$set}.json";
    @fo.push: $fo;
    $fo.IO.spurt: $res;
}
say "See output JSON files:";
say "  $_" for @fo;
