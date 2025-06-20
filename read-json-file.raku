#!/usr/bin/env raku
#use JSON::Fast <pretty sorted-keys>;
use JSON::Pretty;

use lib "./lib";
use FinanceAPI;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <json file>

    Gives info about the structure of the input file.
    
    HERE
    exit;
}
my $f = @*ARGS.head; 
my $data = from-json $f.IO.slurp;

=begin comment
    # $res is a JSON string
    # pretty print it
    my $data = from-json $res;
    my $jstr = to-json $data;
    $fh.say: $jstr;
    $fh.close;
=end comment

if 0 {
my $jstr = to-json $data;
say $jstr;
exit;
}

inspect-json $data;
