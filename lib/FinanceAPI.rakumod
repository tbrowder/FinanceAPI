unit module FinanceAPI;

use Cro;
use JSON::Fast;
use FinanceAPI::Vars;
use FinanceAPI::Classes;

use Cro::HTTP::Client;

# Rarely used, voluminous textual data
# needs post-query processing to produce a
# readable text form with max of 72-80 chars. Idea
# candidate for PDF output.
sub path-v11FinanceQuoteSummary(
    Str $symbol, # only one symbol can be entered per query
    Bool :$all = False,
    :@modules = ["summaryDetail"],
    :$lang = "EN",
    :$region = "US",
    :$debug,
) is export {

    # build the query string before handing it to Cro, note the form of
    # straight URL requests
    my $query = <https://yfapi.net>;
    my $path = "/v11/finance/quoteSummary/$symbol";
    $query ~= $path;
    my $chunk0 = "?lang={$lang}";
    $query ~= $chunk0;
    my $chunk = "&region={$region}";
    $query ~= $chunk;
    $chunk = "&modules={@modules.sort.join(',')}";
    $query ~= $chunk;
    my $client = Cro::HTTP::Client.new(
        headers => [
            accept => 'application/json',
            X-API-KEY => "$apikey",
        ],
    );

    my $resp = await $client.get($query);
    my Str $body = await $resp.body-text();
    $body = "(null)" unless $body.chars;
    say $body if $debug;
    $body;
}

sub path-v8FinanceSpark(
    # this is the daily
    @symbols where (@symbols.elems < 11), # max of 10
    Str :$interval!, # = "1d",  # 1d...(1m 5m 15m 1d 1wk 1mo)
    Str :$range!,    # = "1y", # 1d 5d 1mo 3mo 6mo 1y 5y max

    :$lang = "EN",
    :$region = "US",
    :$debug,
) is export {
    # stock history

    # build the query string before handing it to Cro, note the form of
    # straight URL requests
    my $query = <https://yfapi.net>;
    my $path = "/v8/finance/spark/";
    $query ~= $path;
    my $chunk0 = "?lang={$lang}";
    $query ~= $chunk0;

    # region
    my $chunk = "&region={$region}";
    $query ~= $chunk;

    # interval
    $chunk = "&interval={$interval}";
    $query ~= $chunk;

    # range
    $chunk = "&range={$range}";
    $query ~= $chunk;

    # symbols
    my $symbols = @symbols.join(',');
    $chunk = "&symbols={$symbols}";
    $query ~= $chunk;

    my $client = Cro::HTTP::Client.new(
        headers => [
            accept => 'application/json',
            X-API-KEY => "$apikey",
        ],
    );

    my $resp = await $client.get($query);
    my Str $body = await $resp.body-text();
    $body = "(null)" unless $body.chars;
    say $body if $debug;
    $body;
}

sub path-v8FinanceChart( # {ticker} # misleading, comparisons not needed
    $ticker,  # ticker! REQUIRED <= ticker=symbol of interest
    :$events, #  = "div,split", # not well defined...a comma-separated string
    :$comparisons,
    :$interval, # not required = "1d",  # 1m...(1m 5m 15m 1d 1wk 1mo)
    :$range, # not required    = "max", # 1d 5d 1mo 3mo 6mo 1y 5y 10y ytd max
    :$lang = "EN",
    :$region = "US",
    :$debug,
) is export {
  # other history

    # build the query string before handing it to Cro, note the form of
    # straight URL requests
    my $query = <https://yfapi.net>;
    my $path = "/v8/finance/chart/{$ticker}"; # {ticker}
    $query ~= $path;
    my $chunk0 = "?lang={$lang}";
    $query ~= $chunk0;

    # region
    my $chunk = "&region={$region}";
    $query ~= $chunk;

    # range
    if $range {
        $chunk = "&range={$range}";
        $query ~= $chunk;
    }

    # interval
    if $interval {
        $chunk = "&interval={$interval}";
        $query ~= $chunk;
    }

    # comparisons
    if $comparisons {
        $chunk = "&comparisons={$comparisons}";
        $query ~= $chunk;
    }

    # events
    if $events {
        $chunk = "&events={$events}";
        $query ~= $chunk;
    }

    my $client = Cro::HTTP::Client.new(
        headers => [
            accept => 'application/json',
            X-API-KEY => "$apikey",
        ],
    );

    my $resp = await $client.get($query);
    my Str $body = await $resp.body-text();
    $body = "(null)" unless $body.chars;
    say $body if $debug;
    $body;
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

sub from-timestamp(
    UInt $time,
    :$debug,
    --> DateTime
    ) is export {
}

sub read-daily(
    ) is export {
    # Input is a JSON string
}

sub read-dividends(
    ) is export {
    # Input is a JSON string
}

# Read and parse data from a JSON file
# A recursive subroutine using the data from a JSON file
# Courtesy of ChatGPT
#   my $json-text = "data.json".IO.slurp;
#   my $data = from-json $json-text;
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
        =begin comment
        when Numeric {
            say "{$prefix}: {$data.Numeric}";
        }
        when Int {
            say "{$prefix}: {$data.Str}";
        }
        =end comment
        default {
#           say "FATAL: Unknown object '{$data.raku}'";
#           exit;
            say "{$prefix}{$data.raku}";
        }
    }
}

