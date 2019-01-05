
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shutterstock

[![Travis build
status](https://travis-ci.org/strboul/shutterstock-r.svg?branch=master)](https://travis-ci.org/strboul/shutterstock-r)
[![Coverage
status](https://codecov.io/gh/strboul/shutterstock-r/branch/master/graph/badge.svg)](https://codecov.io/github/strboul/shutterstock-r?branch=master)
[![CRAN status
badge](https://www.r-pkg.org/badges/version/shutterstock)](https://cran.r-project.org/package=shutterstock)

R library for Shutterstock REST API. Please refer to the official
reference [here](https://api-reference.shutterstock.com/).

## Installation

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

## Usage

Search the most popular images about *Amsterdam* added today:

``` r
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
```

## OAuth 2.0 Authentication

OAuth 2.0 authentication is better to use for the queries as its scope
is greater than the capabilities of the basic authentication. Read the
vignette for more information. For general OAuth problems, please read
the [Shutterstock OAuth 2.0
guide](https://api-reference.shutterstock.com/#authentication-oauth-authentication-h2)
thoroughly.

## Development

PRs are welcomed\!

Only `GET` methods are supported in the current version.

Please note that the ‘shutterstock’ project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to
this project, you agree to abide by its terms.
