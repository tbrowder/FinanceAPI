#!/usr/bin/env raku

my %portfolio = %(
    # mandatory:
    MRK => { # the ticker symbol for queries
    type   => "security type", # stock, fund, option
    # required but may be left empty
    lots => {
        =begin comment
        # use your own lot key style as desired
        idl => {
            symbol => "sym1",
            buy-date => "yyyy-mm-dd",
            buy-total-price => 420.25,
            number-shares   => 40.0,
            sell-date => "", # format if sold: yyyy-mm-dd
            sell-total-price => "", # format if sold: 420.25
            
        },
        # etc.
        =end comment
    },
},    
);

say $_ for %portfolio.keys;

