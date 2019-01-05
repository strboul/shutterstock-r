
#' Search editorial content
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/editorial/search}}
#' @examples \dontrun{
#' searchEditorial(query = "history", country = "TR")
#' searchEditorial(query = "windmills", country = "NL", sort = "newest", date_start = "2018-11-01")
#' }
#' @export
searchEditorial <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "editorial/search",
    parameters = params
  )
}

#' Get details about editorial content
#'
#' @param id character. Editorial ID.
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/editorial/\{id\}}}
#' @examples \dontrun{
#' getEditorialDetails(id = "9926131a")
#' }
#' @export
getEditorialDetails <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("editorial/%s", id),
    parameters = params
  )
}

#' Get editorial livefeed list
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/editorial/livefeeds}}
#' @examples \dontrun{
#' getEditorialLivefeedList(country = "TR")
#' }
#' @export
getEditorialLivefeedList <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "editorial/livefeeds",
    parameters = params
  )
}

#' Get editorial livefeed
#'
#' @param id character. Editorial livefeed ID (in URI encoded string form).
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/editorial/livefeeds/\{id\}}}
#' @examples \dontrun{
#' getEditorialLivefeed(
#' id = "2018%2F10%2F15%2FWomen%20of%20the%20Year%20Lunch%20%26%20Awards%2C%20London", country = "USA"
#' )
#' }
#' @export
getEditorialLivefeed <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("editorial/livefeeds/%s", id),
    parameters = params
  )
}

#' Get editorial livefeed items
#'
#' @param id character. Editorial livefeed ID (in URI encoded string form).
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/editorial/livefeeds/\{id\}/items}}
#' @examples \dontrun{
#' getEditorialLivefeedItems(
#' id = "2018%2F10%2F15%2FWomen%20of%20the%20Year%20Lunch%20%26%20Awards%2C%20London",
#' country = "USA"
#' )
#' }
#' @export
getEditorialLivefeedItems <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("editorial/livefeeds/%s/items", id),
    parameters = params
  )
}
