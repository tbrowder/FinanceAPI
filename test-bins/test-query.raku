#!/usr/bin/env raku
use Cro;
use JSON::Fast;
use lib "./lib";
use FinanceAPI;

my $api = "t/api/yh-finance-api-specification.json";

=begin comment

# paths
/v8/finance/spark

/v11/finance/quoteSummary/{symbol}
  modules
=end comment

# build the query string before handing it to Cro note the form of
# straight URL requests
my $query = qq:to/HERE/;
https://yfapi.net
HERE
$query .= trim;
my $symbol = "JABAX";

#my $path = "/v11/finance/quoteSummary/{$symbol}";
my $path = "/v11/finance/quoteSummary/$symbol";
$query ~= $path;
my $lang = "en".uc;
my $chunk0 = "?lang={$lang}";
$query ~= $chunk0;
my $region = "us".uc;
my $chunk = "&region={$region}";
$query ~= $chunk;
my $modules = "financialData";
$chunk = "&modules={$modules}";
$query ~= $chunk;

# security
my $apikey = %*ENV<FINANCEAPI_KEY>;

#say "query: <|$query|>";
#say "DEBUG exit"; exit;

%*ENV<CRO_TRACE=1>;
=begin comment
my $resp = await Cro::HTTP::Client.get(
    $query
);
my Str $body = await $resp.body-text();
=end comment

say "query:";
say $query;
say "debug exit..."; exit;

my $client = Cro::HTTP::Client.new(
    headers => [
        accept => 'application/json',
        X-API-KEY => "$apikey",
    ],
);

my $resp = await $client.get($query);
my Str $body = await $resp.body-text();
say $body;

#my $uri = Cro::Uri.parse(<https://yhapi.net>);
#say $uri;
