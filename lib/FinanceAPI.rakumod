unit module FinanceAPI;

=begin comment

/v11/finance/quoteSummary/{symbol}

parameters
==========

name      description
---------------------
lang
string    en fr de it es zh
(query)

region
string    us au ca fr de hk it es gb in
(query)

modules * required
(query) financialData (and LOTS of other modules)


/v8/finance/spark

parameters
==========

name      description
---------------------
interval
string    1m 5m 15m 1d 1wk 1mo
(query)

range
string    1d 5d 1mo 3mo 6mo 1y 5y max
(query)

symbols   * required
string    Separated by commas
(query)   Max 10

=end comment

use JSON::Fast;
use JSON::Path;
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
