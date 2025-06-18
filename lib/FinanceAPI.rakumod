unit module FinanceAPI;

use Cro;
use JSON::Fast;
use FinanceAPI::Vars;
use FinanceAPI::Classes;

use Cro::HTTP::Client;
use Cro::HTTP::Router;
use Cro::HTTP::Server;

sub query(
    $query?,
    :$debug,
    ) is export {
    =begin comment
    my $client = Cro::HTTP::Client.get(
        'https://yfapi.net/v11/finance/quoteSummary/jabax?' \
        '&x-api-keyApiKeyAuth=bnq6WNGJde3hn8G8KIOPZ85SwCuLScFk3kBD7IMu'
    );
    =end comment
}

sub path-v11FinanceQuoteSummary(
    Str $symbol,
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
    @symbols where (@symbols.elems < 11), # max of 10
    :$interval = "1d",  # 1d...(1m 5m 15m 1d 1wk 1mo)
    :$range    = "max", # 1d 5d 1mo 3mo 6mo 1y 5y max

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
    $ticker,     # ticker! REQUIRED <= ticker=symbols of interest
    :$events = "div,long,cap", # not well defined...a comma-separated string, "div,split"
    :$comparisons,
    :$interval = "1m",  # 1m...(1m 5m 15m 1d 1wk 1mo)
    :$range    = "max", # 1d 5d 1mo 3mo 6mo 1y 5y 10y ytd max
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
    $chunk = "&range={$range}";
    $query ~= $chunk;

    # interval
    $chunk = "&interval={$interval}";
    $query ~= $chunk;

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
