
# HTTP connection calls

#' Send request
#'
#' Bring everything together. First, get a response from server. Second, stop if
#' response returns an error status. Then, check if http type matches. Last,
#' return parsed content.
#'
#' @noRd
send_request <- function(...) {
  resp <- get_response(...)
  stop_error_status(resp)
  check_http_type(resp)
  return_content(resp)
}

#' Get response
#'
#' @param resource character. A Shutterstock API resource.
#' @param parameters list. query parameters.
#' @importFrom httr modify_url GET add_headers
#' @noRd
get_response <- function(resource, parameters) {
  stopifnot(is.character(resource))
  stopifnot(is.list(parameters))
  auth <- sstk_oauth_token_cred()
  url <- httr::modify_url(
    paste0(getOption("sstk.api.root.url"), resource),
    query = parameters
  )
  httr::GET(url, httr::add_headers(Authorization = auth))
}

#' Check the content type of response
#'
#' Checks Content-Type of an HTTP response. If it returns an error because of a
#' wrong design by the API creator, just let them know and drop the check until
#' it is fixed.
#'
#' @importFrom httr http_type
#' @noRd
check_http_type <- function(response, type = c("application/json")) {
  stopifnot(is.response(response))
  selected.type <- match.arg(type)
  actual <- httr::http_type(response)
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
stop_error_status <- function(response) {
  stopifnot(is.response(response))
  if (httr::http_error(response)) {
    # additional descriptions by the HTTP error status codes:
    descrp <- switch(
      as.character(httr::status_code(response)),
      "401" = "Authenticate with sstk_auth()",
      "404" = "That resource does not seem to exist",
      "403" = "May need to authenticate with sstk_auth()"
    )
    cond <- httr::http_condition(response, "error")
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
return_content <- function(response) {
  stopifnot(is.response(response))
  cont <- httr::content(response, as = "text")

  jsonlite::fromJSON(cont, simplifyVector = FALSE)
}

#' Check if an object has response class
is.response <- function(x) {
  inherits(x, "response")
}
