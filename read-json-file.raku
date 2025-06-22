#!/usr/bin/env raku
use JSON::Pretty;
use File::Find;

use lib "./lib";
use FinanceAPI;
use FinanceAPI::Subs;
use FinanceAPI::Classes;
use FinanceAPI::ExtractJSON;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <json file> | go | test

    Gives info about the structure of the input file or
      the files in dir '/test-jsons'.

    With the 'test' mode, the experimental routines
      in FinanceAPI::ExtractJSON is used.

    HERE
    exit;
}

# First, determine the source of the JSON files to be inspected.
my @f;
my $tf = @*ARGS.head; 
if $tf.IO.r {
    $tf = @*ARGS.shift;
    @f.push: $tf;
    $tf = 0;
}
else {
    $tf = 0;
    my $dir = "test-jsons";
    @f = find :$dir, :type<file>, :name(/'.json' $/);
}

my $test  = 0;
my $debug = 0;
for @*ARGS {
    when /t [est]? / {
        ++$test;
    }
    when /d [ebug]? / {
        ++$debug;
    }
    default {
        say "FATAL: Unknown arg '$_'";
        exit;
    }
}

say "Testing JSON analysis...";
for @f -> $f {
    my $o = FinanceAPI::ExtractJSON.new: :file($f);
    $o.extract-json-data;
}


=finish

# my $data = from-json $f.IO.slurp;
# inspect-json $data;

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

