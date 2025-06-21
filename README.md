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

Note the API key obtained *must* be assigned to the user's environment variable `FINANCEAPI_APIKEY`. In a Linux OS one could do this in the user's `$HOME/.bash_aliases` file:

    export FINANCEAPI_APIKEY='dEfvhygSrfbFttgyhjfe3huj'

Note tests in /t do not need an API key, but tests in /xt do.

Current status
--------------

The following three query paths and their routines are currently available.

  * ?

  * ?

  * ?

Other query paths are defined the Financeapi.net website, but they have not yet been handled. File an issue or, better yet, submit a PR if you want others.

Their default values should give usable data for the past six months. Their default values are set for the author's convenience for testing the free tier:

`EN` languageavailable

AUTHOR
======

Tom Browder <tbrowder@acm.org>

COPYRIGHT AND LICENSE
=====================

© 2025 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

