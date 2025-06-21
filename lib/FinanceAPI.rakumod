unit module FinanceAPI;

use Cro;
use Cro::HTTP::Client;
use JSON::Pretty;

use FinanceAPI::Vars;
use FinanceAPI::Classes;
use FinanceAPI::Subs;

# security
our $apikey is export = %*ENV<FINANCEAPI_APIKEY>;

sub path-v8FinanceSpark(
    # this is the daily stock history
    @symbols where (@symbols.elems < 11), # max of 10
    Str :$interval!, # = "1d",  # 1d...(1m 5m 15m 1d 1wk 1mo)
    Str :$range!,    # = "1y", # 1d 5d 1mo 3mo 6mo 1y 5y max

    :$lang = "EN",
    :$region = "US",
    :$prettify = True,
    :$debug,
) is export {
    # stock history

    # build the query string before handing it to Cro, note the form
    # of straight URL requests
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

    # $body is a JSON string, prettify it...
    if $prettify {
        $body = prettify-json $body;
    }

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
    :$prettify = True,
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

    # $body is a JSON string, prettify it...
    if $prettify {
        $body = prettify-json $body;
    }

    $body = "(null)" unless $body.chars;
    say $body if $debug;
    $body;
}

# Rarely used, voluminous textual data needs post-query processing to
# produce a readable text form with max of 72-80 chars. Idea candidate
# for PDF output.
sub path-v11FinanceQuoteSummary(
    Str $symbol, # only one symbol can be entered per query
    Bool :$all = False,
    :@modules = ["summaryDetail"],
    :$lang = "EN",
    :$region = "US",
    :$prettify = True,
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

    # $body is a JSON string, prettify it...
    if $prettify {
        $body = prettify-json $body;
    }

    $body = "(null)" unless $body.chars;
    say $body if $debug;
    $body;
}
