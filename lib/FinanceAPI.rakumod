unit module FinanceAPI;

use Cro;
use Cro::HTTP::Client;
use JSON::Pretty;

use FinanceAPI::Vars;
use FinanceAPI::Security;
use FinanceAPI::Subs;

# security
our $apikey is export = %*ENV<FINANCEAPI_APIKEY>;

sub path-v8FinanceSpark(
    # this is the daily security price  history
    
    # max of 10, leave empty for default values for the free tier
    @symbols is copy where (@symbols.elems < 11), 
    # defaults for free tier for JAGIX, MRK
    Str :$interval = "1d",  # 1d...(1m 5m 15m 1d 1wk 1mo)
    Str :$range    = "6mo", # 1d 5d 1mo 3mo 6mo 1y 5y max

    # other defaults
    :$lang     = "EN",
    :$region   = "US",
    :$prettify = True,
    :$debug,
) is export {
    unless @symbols.elems {
        # defaults for free tier for JAGIX, MRK
        @symbols = ["JAGIX", "MRK"];
    }

    # stock history

    my ($query, $chunk0, $chunk, $path, Str $body, $resp, $client);
    # build the query string before handing it to Cro, note the form
    # of straight URL requests
    $query = <https://yfapi.net>;
    $path = "/v8/finance/spark/";
    $query ~= $path;
    $chunk0 = "?lang={$lang}";
    $query ~= $chunk0;

    # region
    $chunk  = "&region={$region}";
    $query ~= $chunk;

    # interval
    $chunk  = "&interval={$interval}";
    $query ~= $chunk;

    # range
    $chunk  = "&range={$range}";
    $query ~= $chunk;

    # symbols
    my $symbols = @symbols.join(',');
    $chunk  = "&symbols={$symbols}";
    $query ~= $chunk;

    $client = Cro::HTTP::Client.new(
        headers => [
            accept => 'application/json',
            X-API-KEY => "$apikey",
        ],
    );

    $resp = await $client.get($query);
    $body = await $resp.body-text();

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
    :$events  = "div,split", # not well defined...a comma-separated string
    :$comparisons, # not required

    # defaults for the free tier:
    :$interval = "1d",  # (1m 5m 15m 1d 1wk 1mo)
    :$range    = "6mo", # 1d 5d 1mo 3mo 6mo 1y 5y 10y ytd max

    # other defaults
    :$lang     = "EN",
    :$region   = "US",
    :$prettify = True,
    :$debug,
) is export {
    # other history

    my ($query, $chunk0, $chunk, $path, Str $body, $resp, $client);
    # build the query string before handing it to Cro, note the form of
    # straight URL requests
    $query   = <https://yfapi.net>;
    $path   = "/v8/finance/chart/{$ticker}"; # {ticker}
    $query ~= $path;
    $chunk0 = "?lang={$lang}";
    $query ~= $chunk0;

    # region
    $chunk  = "&region={$region}";
    $query ~= $chunk;

    # range
    if $range {
        $chunk  = "&range={$range}";
        $query ~= $chunk;
    }

    # interval
    if $interval {
        $chunk  = "&interval={$interval}";
        $query ~= $chunk;
    }

    # comparisons
    if $comparisons {
        $chunk  = "&comparisons={$comparisons}";
        $query ~= $chunk;
    }

    # events
    if $events {
        $chunk  = "&events={$events}";
        $query ~= $chunk;
    }

    $client = Cro::HTTP::Client.new(
        headers => [
            accept => 'application/json',
            X-API-KEY => "$apikey",
        ],
    );

    $resp = await $client.get($query);
    $body = await $resp.body-text();

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
    Str $symbol = "MRK", # only one symbol can be entered per query
    Bool :$all = False,
    :@modules = ["summaryDetail"],

    # other defaults
    :$lang     = "EN",
    :$region   = "US",
    :$prettify = True,
    :$debug,
) is export {

    my ($query, $chunk0, $chunk, $path, Str $body, $resp, $client);
    # build the query string before handing it to Cro, note the form of
    # straight URL requests
    $query  = <https://yfapi.net>;
    $path   = "/v11/finance/quoteSummary/$symbol";
    $query ~= $path;
    $chunk0 = "?lang={$lang}";
    $query ~= $chunk0;

    $chunk  = "&modules={@modules.sort.join(',')}";
    $query ~= $chunk;

    # region
    $chunk  = "&region={$region}";
    $query ~= $chunk;

    # lang
    $chunk  = "&lang={$lang}";
    $query ~= $chunk;

    $client = Cro::HTTP::Client.new(
        headers => [
            accept => 'application/json',
            X-API-KEY => "$apikey",
        ],
    );

    $resp = await $client.get($query);
    $body = await $resp.body-text();

    # $body is a JSON string, prettify it...
    if $prettify {
        $body = prettify-json $body;
    }

    $body = "(null)" unless $body.chars;
    say $body if $debug;
    $body;
}
