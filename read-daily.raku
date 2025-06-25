#!/usr/bin/env raku

use JSON::Pretty;
use FinanceAPI;
use FinanceAPI::Subs;
use FinanceAPI::Vars;
use FinanceAPI::Security;

multi MAIN() {
    print qq:to/HERE/;
    Given a 'daily' JSON file produced by using its query exercising this package,
      show or process its JSON contents.
    Output data should be in this form:

       symbol, date (yyyy-mm-dd), close (currency/share)

    HERE
}

constant %daily-subkeys is export = %(
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
    for %h0.kv -> $k0, $v0 {
        # k0 is symbol, uppercase it
        # v0 can be a Str or an Array
        my $sym = $k0.uc;
        say "  DEBUG: key: '$k0'" if 0 or $debug;
        unless $v0 ~~ Hash {
            say "FATAL: Expected a Hash, but got a '{$v0.^name}'";
            exit;
        }

        my %h1;
        for $v0.kv -> $k1, $v1 {
            say "    DEBUG: key: '$k1'" if 0 or $debug;
            unless %daily-subkeys{$k1}:exists {
                say "FATAL: Unexpected daily subkey '$k1'";
                exit;
            }
            next if %daily-subkeys{$k1} == -1;
            # check the type of value
            my $typ = $v1.^name;
            say "    DEBUG: key: '$k1', value type: '$typ'" if 1 or $debug;
            %h1{$k1} = $v1;
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
