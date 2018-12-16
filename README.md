
<!-- README.md is generated from README.Rmd. Please edit that file -->
shutterstock
============

[![Travis build status](https://travis-ci.org/strboul/shutterstock-r.svg?branch=master)](https://travis-ci.org/strboul/shutterstock-r) [![Coverage status](https://codecov.io/gh/strboul/shutterstock-r/branch/master/graph/badge.svg)](https://codecov.io/github/strboul/shutterstock-r?branch=master) [![CRAN status badge](https://www.r-pkg.org/badges/version/shutterstock)](https://cran.r-project.org/package=shutterstock)

R library for Shutterstock REST API. Shutterstock API provides an access to Shutterstock. Please refer to the official reference [here](https://api-reference.shutterstock.com/).

Installation
------------

<!--You can install the released version of shutterstock from
[CRAN](https://CRAN.R-project.org) with:
``` r
install.packages("shutterstock")
```-->
Install development version from Github:

``` r
# install.packages("devtools")
devtools::install_github("strboul/shutterstock")
```

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
```

<!-- ( a data can be plotted..) -->
Authentication
--------------

Read the Authentication with OAuth 2.0 article here.

Notes for developers
--------------------

Only `GET` methods are supported in the current version.

Please note that the 'shutterstock' project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree to abide by its terms.
