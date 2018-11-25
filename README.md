
<!-- README.md is generated from README.Rmd. Please edit that file -->
shutterstock
============

[![CRAN status badge](https://www.r-pkg.org/badges/version/shutterstock)](https://cran.r-project.org/package=shutterstock)

> R library for Shutterstock REST API

Installation
------------

You can install the released version of shutterstock from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("shutterstock")
```

You can also install development version with `devtools::install_github("strboul/shutterstock")`.

Authenticate with OAuth 2.0
---------------------------

OAuth 2.0 authentication is better to use as its scope is greater than the capabilities of the basic authentication.

A general use of `.Renviron` is to store API keys. Client Id and secret can be get after registering the app. Shutterstock API requires to define the callback URL explicitly. For instance, if you set your Callback URL as `http://localhost:3000/auth/shutterstock/callback/` then the hostname should be set as `localhost`.

Add the following variables to the file (be sure the values are in quotes):

    SHUTTERSTOCK_CLIENT_ID="<enter-your-client-key>"
    SHUTTERSTOCK_CLIENT_SECRET="<enter-your-client-secret>"
    SHUTTERSTOCK_CALLBACK_URL="<enter-your-callback-url>"

Don't forget to restart your environment. Check `sstk_keys()` to see if the variables are properly set up. Please read the [OAuth 2.0 guide](https://developers.shutterstock.com/oauth-20) throughly.

Examples
--------

Search images:

``` r
today <- as.character(Sys.Date())
searchImages(query = "farmer", sort = "popular", added_date = today)
```

LICENSE
-------

MIT
