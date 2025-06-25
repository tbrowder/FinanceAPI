unit class FinanceAPI::ExtractJSON; # a candidate for a separate module

use JSON::Pretty;

# Source can be a JSON file OR a JSON string, but not both.
has IO::Path $.file;
has Str      $.string;

# Other attributes...
my $data;

# Methods...

submethod TWEAK {
    if $!file.IO.r {
        $!string.IO.slurp;
    }
    elsif $!string.chars {
        ; # ok
    }
    else {
        die "FATAL: No valid input file or JSON string was provided.":
    }
    $data = from-json $!string;
}



# Read and parse data from a JSON file
# A recursive subroutine using the data from a JSON file.
# Courtesy of ChatGPT (with my tweaks)
#   my $json-text = "data.json".IO.slurp;
#   my $data = from-json $json-text;
# This can be used as a filter by a parent sub
# or class # to extract data from a JSON string.

# This version has been modified so the actual data are
# inserted into a set of classes.

method extract-json-data {
    
    while 1 {
        inspect-json $data;
    }
}

sub inspect-json(
    # $data is output from 'from-json $json-string'
    # often a plain Hash, but not always.
    $data,
    $indent = 0,
    :$debug,
    ) is export {
    my $prefix = " " x $indent;

    given $data {
        when Hash {
            =begin comment
            say "{$prefix}Hash \{"; for $data.kv -> $key, $value {
                print "{$prefix}  $key: ";
                inspect-json $value, $indent + 4;
            }
            say "{$prefix}\}";
            =end comment
        }
        when Array {
            =begin comment
            say "{$prefix}Array \[";
            for $data.values -> $value {
                inspect-json $value, $indent + 4;
            }
            say "{$prefix}\]";
            =end comment
        }
        when Str {
            =begin comment
            say "{$prefix}Str: $data";
            =end comment
        }
        default {
            =begin comment
            say "{$prefix}{$data.raku}";
            =end comment
        }
    }
}
