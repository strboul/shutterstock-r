
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

#' HTTP error message
#'
#' When an error occurs during the connection, an explanatory error message is
#' thrown for particular HTTP error status codes. The call is mostly relied on
#' \code{\link[httr]{http_error}} function.
#'
#' @importFrom httr http_error status_code http_condition
#' @noRd
stop_error_status <- function(resp) {
  stopifnot(inherits(resp, "response"))
  if (httr::http_error(resp)) {
    # additional descriptions by the HTTP error status codes:
    descrp <- switch(
      as.character(httr::status_code(resp)),
      "401" = "Authenticate with sstk_auth()",
      "404" = "That resource does not seem to exist",
      "403" = "May need to authenticate with sstk_auth()"
    )
    cond <- httr::http_condition(resp, "error")
    stop(
      sprintf(
        "Shutterstock API request failed:\n %s\n %s",
        cond[["message"]],
        if (identical(length(descrp), 1L)) descrp else ""
      ),
      call. = FALSE
    )
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
