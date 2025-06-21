#!/usr/bin/env raku
use JSON::Pretty;
use File::Find;

use lib "./lib";
use FinanceAPI;
use FinanceAPI::Subs;
use FinanceAPI::Classes;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <json file> | go

    Gives info about the structure of the input file or
    the files in dir '/test-jsons'.
    
    HERE
    exit;
}
my $f = @*ARGS.head; 
if $f.IO.r {
    my $data = from-json $f.IO.slurp;
    inspect-json $data;
}
else {
    my @jfils = find :$dir, :type<file>, :name(//);:
}



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

