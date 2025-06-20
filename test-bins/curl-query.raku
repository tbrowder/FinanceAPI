#!/usr/bin/env raku

use LibCurl;
#use Net::Curl::NativeCallq;
use JSON::Fast;

use lib "./lib";
use FinanceAPI;

my $api = "t/api/yh-finance-api-specification.json";
my $apikey = %*ENV<FINANCEAPI_KEY>;

=begin comment

# paths
/v8/finance/spark

/v11/finance/quoteSummary/{symbol}

=end comment

my $query = "https://yfapi.net";
# build the query string before handing it to Cro
# note the form of straight URL requests
$query .= trim;
my $symbol = "JABAX";
my $path = "/v8/finance/spark";
$query ~= $path;
my $interval = "1d";
my $chunk0 = "?interval={$interval}";
$query ~= $chunk0;
my $range = "5d";
my $chunk = "&range={$range}";
$query ~= $chunk;
my $symbols = "jabax,jagix"; # max of 10 symbols
$chunk = "&symbols={$symbols}";
$query ~= $chunk;

=begin comment
my $region = "us";
my $chunk = "&region={$region}";
$query ~= $chunk;
my $modules = "financialData";
$chunk = "&modules={$modules}";
$query ~= $chunk;

# security
=begin comment
#$chunk = "&ApiKeyAuth={$apikey}";
$chunk = "&x-api-key={$apikey}";
$query ~= $chunk;
# "ApiKeyAuth":"[]"
=end comment

#say "query: <|$query|>";
#say "DEBUG exit"; exit;

%*ENV<CRO_TRACE=1>;
=begin comment
my $resp = await Cro::HTTP::Client.get(
    $query
);
my Str $body = await $resp.body-text();
=end comment

my $client = Cro::HTTP::Client.new(
    headers => [
        'accept: application/json',
        "X-API-KEY: $apikey",
    ],
);

my $resp = await $client.get($query);
my Str $body = await $resp.body-text();
say $body;

#my $uri = Cro::Uri.parse(<https://yhapi.net>);
#say $uri;


