
<!-- README.md is generated from README.Rmd. Please edit that file -->
shutterstock
============

[![Travis build status](https://travis-ci.org/strboul/shutterstock-r.svg?branch=master)](https://travis-ci.org/strboul/shutterstock-r) [![CRAN status badge](https://www.r-pkg.org/badges/version/shutterstock)](https://cran.r-project.org/package=shutterstock) [![Coverage status](https://codecov.io/gh/strboul/shutterstock-r/branch/master/graph/badge.svg)](https://codecov.io/github/strboul/shutterstock-r?branch=master)

R library for Shutterstock REST API

Installation
------------

<!--You can install the released version of shutterstock from
[CRAN](https://CRAN.R-project.org) with:
``` r
install.packages("shutterstock")
```-->
You can install development version:

``` r
# install.packages("devtools")
devtools::install_github("strboul/shutterstock")
```

Authenticate with OAuth 2.0
---------------------------

OAuth 2.0 authentication is better to use for the queries as its scope is greater than the capabilities of the basic authentication.

After registering into the developer's app, you will receive a client id and secret. During the registration, the app requires the callback URL and hostname to be explicitly defined. For instance, if you set your Callback URL as `http://localhost:3000` then the hostname should be set as `localhost`.

A general use of `.Renviron` is to store API keys. Create an `.Renviron` file and add the following variables in that form (be sure the values are in quotes):

    SHUTTERSTOCK_CLIENT_ID="<enter-your-client-key>"
    SHUTTERSTOCK_CLIENT_SECRET="<enter-your-client-secret>"
    SHUTTERSTOCK_CALLBACK_URL="<enter-your-callback-url>"

Don't forget to restart your environment. Check `sstk_keys()` to see if the variables are properly set up.

After all, you are ready to authenticate with:

``` r
sstk_auth()
```

After the authentication process has been successfully completed, a token file `.httr-oauth` will be written to your working directory. Do not share this token with others. Since some API endpoints require an access token for different scopes or permissions, scopes can be added to the call such as `sstk_auth(scopes = c("collections.view", "licenses.view"))`. You can see which scopes do you need by looking an individual endpoint reference.

If you want to change the scope of your token, delete the existing `.httr-oauth` file, re-authenticate again with `sstk_auth` by providing required scopes.

For general OAuth problems, please read the [Shutterstock OAuth 2.0 guide](https://api-reference.shutterstock.com/#authentication-oauth-authentication-h2) throughly.

Usage
-----

Search top *Amsterdam* images added today:

``` r
library("shutterstock")

today <- as.character(Sys.Date())
farmer_data <- searchImages(query = "Amsterdam", sort = "popular", added_date = today)

# move focus to the 'data' node:
d <- farmer_data[["data"]]
do.call(rbind, lapply(seq_along(d), function(x) {
  data.frame(
    id = d[[x]][["id"]],
    description = paste(d[[x]][["description"]], "..."), # truncate description a little bit
    preview = d[[x]][["assets"]][["preview"]][["url"]],
    stringsAsFactors = FALSE
  )
})) -> top
head(top)
#> NULL
```

( a data can be plotted..)

Development
-----------

Only `GET` methods are supported in the current version.

Please note that the 'shutterstock' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
