
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

#' Get a response
#'
#' @param method character. A defined HTTP method.
#' @param resource character. A Shutterstock API resource.
#' @param parameters list. query parameters.
#' @importFrom httr GET POST PUT HEAD DELETE PATCH modify_url add_headers
#' @noRd
get_response <- function(method = c("GET", "POST", "PUT", "HEAD", "DELETE", "PATCH"),
                         resource, parameters) {
    selected.method <- match.arg(method)
    switch (selected.method,
            "GET" = httr::GET,
            "POST" = httr::POST,
            "PUT" = httr::PUT,
            "HEAD" = httr::HEAD,
            "DELETE" = httr::DELETE,
            "PATCH" = httr::PATCH
    ) -> httrMethodCall

    if (missing(parameters)) parameters <- NULL

    stopifnot(is.character(resource))
    stopifnot(is.list(parameters) || is.null(parameters))

    # decompose list parameters for the multiple entries:
    cond <- vapply(parameters, function(x) length(x) > 1L, logical(1))
    if (!all(cond)) {
      elements <- parameters[cond]
      lapply(names(elements), function(n) {
        el <- as.list(elements[[n]])
        names(el) <- rep(n, length(el))
        el
      }) -> recycled
      # reassign 'parameters' with the rest:
      parameters <- c(do.call("c", recycled), parameters[!cond])
    }

    auth <- sstk_oauth_token_cred()
    url <- httr::modify_url(
      paste0(getOption("sstk.api.root.url"), getOption("sstk.api.version"),
             resource
      ),
      query = parameters)
    httrMethodCall(url, httr::add_headers(Authorization = auth))
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
      "(Internal). Response actual content type '", actual,
      "' does not match with the expected one ",
      "'", selected.type, "'.",
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
    # additional descriptions along the HTTP error status codes:
    descrp <- switch(
      as.character(httr::status_code(response)),
      "400" = "Be sure parameters are valid and well-formed",
      "401" = "Please authenticate with sstk_auth()",
      "403" = "You are not permitted for the request",
      "404" = "The resource does not exist"
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
#' @importFrom jsonlite fromJSON
#' @noRd
return_content <- function(response) {
  stopifnot(is.response(response))
  cont <- httr::content(response, as = "text")

  jsonlite::fromJSON(cont, simplifyVector = FALSE)
}

#' Check if an object has response class
#' @noRd
is.response <- function(x) {
  inherits(x, "response")
}
