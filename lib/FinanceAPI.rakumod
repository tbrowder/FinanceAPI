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

sub v11FinanceQuoteSummary(
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

sub v8FinanceSpark(
) is export {
}
