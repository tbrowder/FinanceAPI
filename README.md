[![Actions Status](https://github.com/tbrowder/FinanceAPI/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/FinanceAPI/actions) [![Actions Status](https://github.com/tbrowder/FinanceAPI/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/FinanceAPI/actions) [![Actions Status](https://github.com/tbrowder/FinanceAPI/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/FinanceAPI/actions)

NAME
====

**FinanceAPI** - Provides routines for querying securities information using 'https://Financeapi.net'

SYNOPSIS
========

```raku
use FinanceAPI;
...
```

DESCRIPTION
===========

**FinanceAPI** has a set of routines to extract financial data from various markets around the world using their APIs. There is a free tier with a limit of 100 queries per day. The user must obtain a personal API key in order to successfully use the full capability of this module to get desired data. See the details at [https://financeapi.net](https://financeapi.net).

Yhe API key obtained *must* be assigned to the user's environment variable `FINANCEAPI_APIKEY`. On a Linux OS host, one can do this in the user's `$HOME/.bash_aliases` file:

    export FINANCEAPI_APIKEY='dEfvhygSrfbFttgyhjfe3huj'

Note tests in directory '/t' **do not** need an API key, but tests in directory '/xt' **do**.

Local data location and use
---------------------------

Currently, data are output to CSV tables, one uniquely named file per security `symbol` (also known as `ticker`). (Note an SQLite database is a desirable possibility for the future, PRs welcome!).

The file collections are first searched for in the directory defined by environment variable `FINANCEAPI_DATA`. If that exists, it is used, otherwise, the current directory is used and a subdirectory named `financeapi_data` is used (after creating it if it does not exist). Existing data tables are first read and checked to ensure only new data are appended.

The CSV table file naming format:

    {$data-directory}/{$symbol}-{$table-type}.csv

where:

`$symbol` - the market symbol for the security, e.g., 'JAGIX', 'MRK'

`$table-type` - the query type, e.g., 'daily', 'event'

### CSV table formats

All tables are kept in date order from earliest to latest. For those tables that may have multiple events on the same day, the second key is the event type which are:

  * **BU** - Buy

  * **SE** - Sell

  * **SP** - Split

  * **DI** - Dividend

  * **RC** - Return of capital

  * **RS** - Reverse split

  * **SO** - Split

Daily

    Date | Symbol | Close ($currency/share)

Event

    Date | Symbol | Event | Amount ($currency/share) | Notes

Current status
--------------

The following query paths and their routines are currently available. Given the ticker symbol of a security of interest, we can use it as a key to the hashes returned by each query to output the data in any desired format.

### Daily closing prices of securities

  * path

### Dividend and split dates and amounts

  * path

Other query paths are defined on the [FinanceAPI](https://financeapi.net) website, but they have not yet been handled. File an issue or, better yet, submit a PR if you want others.

Their default values should give usable data for the past six months. Their default values are set for the author's convenience for testing the free tier:

`EN` language `US` region

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2025 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

