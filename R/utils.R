
#' Check the content type of response
#'
#' Checks Content-Type of an HTTP response. If it returns an error because of a
#' wrong design by the API creator, just let them know and drop the check until
#' it is fixed.
#'
#' @importFrom httr http_type
#' @noRd
check_http_type <- function(resp, type = c("application/json")) {
  stopifnot(inherits(resp, "response"))
  selected.type <- match.arg(type)
  actual <- httr::http_type(resp)
  if (!identical(actual, selected.type)) {
    stop(paste(
      "'", actual, "'",
      " response does not match with expected ",
      "'", selected.type, "'",
      sep = ""
    ),
    call. = FALSE)
  }
}

#' Fetch and parse content of a response
#'
#' Advised to use \code{"text"} for \code{as} argument in
#' \code{\link[httr]{content}} call.
#'
#' @importFrom httr content
#' @noRd
prepare_content <- function(resp) {
  stopifnot(inherits(resp, "response"))
  cont <- httr::content(resp, as = "text")

  jsonlite::fromJSON(cont, simplifyVector = FALSE)
}
