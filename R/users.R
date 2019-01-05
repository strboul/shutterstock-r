
#' Get user details
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/user}}
#' @examples \dontrun{
#' getUserDetails()
#' }
#' @export
getUserDetails <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "user",
    parameters = params
  )
}

#' List user subscriptions
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/user/subscriptions}}
#' @examples \dontrun{
#' listUserSubscriptions()
#' }
#' @export
listUserSubscriptions <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "user/subscriptions",
    parameters = params
  )
}
