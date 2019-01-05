
#' Shutterstock API client
#'
#' The endpoint descriptions are retrieved from Shutterstock API Reference
#' documentation.
#'
#' @section Design principles:
#'
#' \itemize{
#'
#' \item To make the API client library loose coupled, the name of the
#' parameters passed to a call are not hard-coded in the code. The parameters
#' are handled by the HTTP requests which receive the parameters from function
#' calls by the ellipsis (\code{...}).
#'
#' \item
#' For the calls containing that kind of parameters are validated by e.g.
#' \code{check_required_args(id, "numeric")}. It is considered as required
#' especially if that parameter is tied to a URL.
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
