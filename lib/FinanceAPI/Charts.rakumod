unit module FinanceAPI::Charts;

=begin pod

This module provides routines and classes to convert a JSON
file from a FinanceAPI Chart query to other formats.
Currently the only output format supported is a CSV table.

The JSON format:

=begin code
{
  "chart" : {
    "error" : null,
    "result" : [
      {
        "events" : {
          "dividends" : {
            "1750080600" : {
              "date" : 1750080600,
              "amount" : 0.81
            }
          }
        },
        "indicators" : {
          "quote" : [
            {
              "close" : [
                81.70999908447266,
                80.95999908447266,
                78.27999877929688,
                79.29000091552734,
                79.059998
              ],
              "open" : [
                81.6500015258789,
                80.87999725341797,
                80.27999877929688,
                78.05000305175781,
                79.25
              ],
              "volume" : [
                14550500,
                12569400,
                14040600,
                23803400,
                33834700
              ],
              "high" : [
                82.440002,
                81.3499984741211,
                80.69999694824219,
                80.309998,
                79.91999816894531
              ],
              "low" : [
                81.44999694824219,
                79.70999908447266,
                78.190002,
                77.0999984741211,
                78.5999984741211
              ]
            }
          ],
          "adjclose" : [
            {
              "adjclose" : [
                80.9000015258789,
                80.95999908447266,
                78.27999877929688,
                79.29000091552734,
                79.059998
              ]
            }
          ]
        },
        "timestamp" : [
          1749821400,
          1750080600,
          1750167000,
          1750253400,
          1750426200
        ],
        "meta" : {
          "currentTradingPeriod" : {
            "post" : {
              "gmtoffset" : -14400,
              "start" : 1750449600,
              "timezone" : "EDT",
              "end" : 1750464000
            },
            "regular" : {
              "start" : 1750426200,
              "gmtoffset" : -14400,
              "timezone" : "EDT",
              "end" : 1750449600
            },
            "pre" : {
              "end" : 1750426200,
              "gmtoffset" : -14400,
              "start" : 1750406400,
              "timezone" : "EDT"
            }
          },
          "regularMarketDayLow" : 78.6,
          "regularMarketTime" : 1750449636,
          "exchangeTimezoneName" : "America/New_York",
          "regularMarketDayHigh" : 79.915,
          "fiftyTwoWeekLow" : 73.31,
          "fiftyTwoWeekHigh" : 134.63,
          "chartPreviousClose" : 81.82,
          "longName" : "Merck & Co., Inc.",
          "hasPrePostMarketData" : true,
          "symbol" : "MRK",
          "instrumentType" : "EQUITY",
          "priceHint" : 2,
          "fullExchangeName" : "NYSE",
          "exchangeName" : "NYQ",
          "range" : "5d",
          "firstTradeDate" : -252322200,
          "validRanges" : [
            "1d",
            "5d",
            "1mo",
            "3mo",
            "6mo",
            "1y",
            "2y",
            "5y",
            "10y",
            "ytd",
            "max"
          ],
          "shortName" : "Merck & Company, Inc.",
          "regularMarketPrice" : 79.06,
          "regularMarketVolume" : 33767792,
          "dataGranularity" : "1d",
          "currency" : "USD",
          "gmtoffset" : -14400,
          "timezone" : "EDT"
        }
      }
    ]
  }
}
=end code

The CSV format

=begin code
Date,Dividends (US currency/sh)
1991-10-01,0.020000
=end code


=end pod
