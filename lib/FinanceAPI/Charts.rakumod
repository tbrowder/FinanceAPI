unit module FinanceAPI::Charts;

use Hash2Class;

class Chart does Hash2Class[
  '@close'           => Rat,
  '@timestamp'       => Int,
  chartPreviousClose => Rat,
  dataGranularity    => Int,
  end                => Any,
  previousClose      => Any,
  start              => Any,
  symbol             => Str,
] { }

# we use the class in an exported subroutine
sub get-chart-data(
    $data, # 
    :$debug,
    ) is export {
}

