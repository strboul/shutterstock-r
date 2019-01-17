
#' Shutterstock API client
#'
#' The endpoint descriptions are retrieved from Shutterstock API Reference
#' documentation.
#'
#' @section Running tests:
#'
#' \enumerate{
#'
#' \item Insert unit tests by using \code{testthat} package
#'
#' \item Copy \code{.httr-oauth} file into \code{tests/testthat} directory (but
#' remove that later)
#'
#' \item Add/uncomment \code{httptest::start_capturing()} and
#' \code{httptest::stop_capturing()} recording lines between the tests
#'
#' \item Run specific tests one by one e.g. \code{devtools::test(filter = "audio")}
#'
#' \item When the API files are created/updated, remove/comment the recording
#' lines
#'
#' \item Wrap tests with \code{with_mock_api} calls
#'
#' \item Run the tests again with the same filter
#'
#' \item Done if all tests pass. Move to the next one.
#'
#' }
#'
#' @section Design principles:
#'
#' \itemize{
#'
#' \item To make the package dev structure loose coupled, the name of the
#' parameters passed to a call are not hard-coded in the code. The parameters
#' are handled by the HTTP requests which receive the parameters from function
#' calls by the ellipsis (\code{...}).
#'
#' \item
#' For the calls containing that kind of parameters are validated by e.g.
#' \code{check_required_args(id, "numeric")}. It is considered as required
#' especially if that parameter is tied to a URL.
#'
#' }
#'
#' @section Package options:
#'
#' \describe{
#'
#' \item{\code{sstk.api.root.url}}{The base URL for retrieving the API
#' endpoints. Default: \code{https://api.shutterstock.com/}}
#'
#' }
#'
#' @references Shutterstock API Reference:
#'   \url{https://api-reference.shutterstock.com/}
#' @keywords internal
"_PACKAGE"
