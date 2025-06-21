unit module FinanceAPI::Subs;

use JSON::Pretty;

# Note all routines here should NOT depend on the top-level
# modules.

sub from-timestamp(
    UInt $time,
    :$debug,
    --> DateTime
    ) is export {
}


# Read and parse data from a JSON file
# A recursive subroutine using the data from a JSON file
# Courtesy of ChatGPT (with my tweaks)
#   my $json-text = "data.json".IO.slurp;
#   my $data = from-json $json-text;
# This can be used as a filter by a parent sub
# to extract data from a JSON string
sub inspect-json(
    $data, # output from "from-json $json-string
    $indent = 0;
    :$debug,
    ) is export {
    my $prefix = " " x $indent;

    given $data {
        when Hash {
            say "{$prefix}Hash \{";
            for $data.kv -> $key, $value {
                print "{$prefix}  $key: ";
                inspect-json $value, $indent + 4;
            }
            say "{$prefix}\}";
        }
        when Array {
            say "{$prefix}Array \[";
            for $data.values -> $value {
                inspect-json $value, $indent + 4;
            }
            say "{$prefix}\]";
        }
        when Str {
            say "{$prefix}Str: $data";
        }
        default {
            say "{$prefix}{$data.raku}";
        }
    }
}

sub prettify-json(
    Str $jstr, # a JSON string
    :$debug,
    --> Str
    ) is export {
    require JSON::Pretty;
    my $tmp = from-json $jstr;
    (to-json $tmp);
}

sub get-file-handle(
    $fname,
    :$force,
    :$debug,
    --> IO::Handle
    ) is export {
    my $fo = $fname;
    if $fo.IO.e {
        if not $force {
            say "WARNING: File '$fo' exists, aborting...";
            exit;
        }
        elsif $force {
            say "NOTE: File '$fo' exists, overwriting...";
        }
    }
    my $fh = open $fo, :w;
    $fh;
}


sub read-daily(
    Str $jstr,
    :$debug,
    --> Str
    ) is export {
    # Input is a JSON string
}

sub read-events(
    Str $jstr,
    :$debug,
    --> Str
    ) is export {
    # Input is a JSON string
}
