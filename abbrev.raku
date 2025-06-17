#!/usr/bin/env raku

use Abbreviations;

my @w = <
    daily
    gains
    dividends
>;

for @w -> $w {
   my $a = abbrev $w;
   say "[$a]";
}

