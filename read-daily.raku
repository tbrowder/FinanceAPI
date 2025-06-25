#!/usr/bin/env raku

use JSON::Pretty;
use FinanceAPI;
use FinanceAPI::Subs;

multi MAIN() {
    print qq:to/HERE/;
    Given a 'daily' file produced by exercising this package,
      show or process its contents.
    It should be in this form:

       symbol date close

    HERE
}

my %daily-subkeys = %(
    # these are used:
    close => "",
    symbol => "",
    timestamp => "",
    # these are currently ignored:
    end => -1, 
    start => -1, 
    dataGranularity => -1, 
    previousClose => -1,
    chartPreviousClose => -1,
);

multi MAIN(
    'go', #$s where * ~~ /^ :i g /;
) {
    MAIN("xt/data/daily-test1.json");
}

multi MAIN(
    Str $jfile where *.IO.f, #= input JSON file
    :$debug,
) {
    
    say "DEBUG: reading JSON file '$jfile'" if 1 or $debug;
    my %h0 = from-json $jfile.IO.slurp;
    for %h0.kv -> $k, $v {
        # k is symbol, uppercase it
        # v can be a Str or an Array
        my $sym = $k.uc;
        say "  DEBUG: key: '$k'" if 1 or $debug;
        unless $v ~~ Hash {
            say "FATAL: Expected a Hash, but got a '{$v.^name}'";
            exit;
        }

        my %h1;
        for $v.kv -> $k1, $v1 {
            say "    DEBUG: key: '$k1'" if 1 or $debug;
            unless %daily-subkeys{$k1}:exists {
                say "FATAL: Unexpected daily subkey '$k1'";
                exit;
            }
            next if %daily-subkeys{$k1} == -1;
        }
    }
}

=finish
# the expected JSON format with only one top-level
# key: security symbol in lower or upper case
#   values: string keys, one of
#      close, end, start, symbol, dataGranularity, timestamp, previousClose
#      ignore all but: close, symbol, timestamp
#             
{
  "jagix" : {
    "close" : [
      72.47,
    ],
    "end" : null,
    "start" : null,
    "symbol" : "JAGIX",
    "dataGranularity" : 300,
    "timestamp" : [
      1749821400,
    ],
    "previousClose" : null,
    "chartPreviousClose" : 73.45
  },
}
