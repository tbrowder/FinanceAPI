
=begin comment

📦 JSON::ToCSV — Raku Module
✅ Features
Flatten nested JSON (Hash/Array)

Export to CSV

Configurable:

Key style: dot or underscore

Type annotations

Key filtering

Safe CSV escaping

📁 Suggested File Structure

lib/
└── JSON/
    └── ToCSV.rakumod
bin/
└── json2csv.raku       # CLI script (optional, imports the module)


=end comment

unit module JSON::ToCSV;

use JSON::Fast;

# Escape CSV safely
sub escape-csv(Str $v --> Str) {
    my $s = $v;
    $s ~~ s:g/\"/""/;
    return $s ~~ /[",\n]/ ?? "\"$s\"" !! $s;
}

# Recursive flattener
sub flatten-json(
    $data,
    :$dot = True,
    :$with-types = True,
    :$prefix = ''
) returns Hash {
    my %flat;

    given $data {
        when Hash {
            for $data.kv -> $k, $v {
                my $key = $prefix eq ''
                    ?? $k
                    !! $dot
                        ?? "$prefix.$k"
                        !! "$prefix" ~ '_' ~ $k;
                %flat.append: flatten-json($v, :$dot, :$with-types, :prefix($key));
            }
        }
        when Array {
            for $data.kv -> $i, $v {
                my $key = $prefix ~ ($dot ?? ".{$i}" !! "_$i");
                %flat.append: flatten-json($v, :$dot, :$with-types, :prefix($key));
            }
        }
        default {
            my $type = $with-types ?? ':' ~ $data.^name.lc !! '';
            %flat{$prefix ~ $type} = $data;
        }
    }

    return %flat;
}

# Main export: convert JSON array to CSV string
sub json-to-csv(
    $json-data,
    :$dot = True,
    :$with-types = True,
    :@filter-keys = (),
    :$escape = True
) returns Str {

    die "Input must be an array of hashes" unless $json-data ~~ Array;

    my @flat = $json-data.map({
        flatten-json($_, :$dot, :$with-types);
    });

    my @headers = @flat.map(*.keys).flat.unique.sort;
    @headers = @headers.grep({ @filter-keys.grep(* eq $_).elems }) if @filter-keys.elems;

    my @lines;
    @lines.push: @headers.join(',');

    for @flat -> %row {
        my @values = @headers.map({
            my $val = %row{$_} // '';
            $escape ?? escape-csv($val.Str) !! $val.Str
        });
        @lines.push: @values.join(',');
    }

    return @lines.join("\n");
}

# Exported subs
export &json-to-csv, &flatten-json;

=begin pod

🧪 Example Usage
In a script:

=begin code
use lib 'lib';
use JSON::ToCSV;
use JSON::Fast;

my $data = from-json(slurp 'data.json');

my $csv = json-to-csv($data, :dot, :with-types, :filter-keys<name projects_0_title>);

spurt 'output.csv', $csv;
=end code

=end pod
