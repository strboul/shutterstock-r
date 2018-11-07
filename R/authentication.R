
#' Authorize Shutterstock
#'
#' In principle, user credentials are stored inside the \code{.httr-oauth} in
#' the working directory.
#'
#' @export
sstk_auth <- function() {
  oauth_app <- httr::oauth_app(
    appname = "shutterstock",
    key = sstk_id(),
    secret = sstk_secret(),
    redirect_uri = sstk_callback()
  )

  token <- httr::oauth2.0_token(
    endpoint = sstk_oauth_endpoint(),
    app = oauth_app
  )
}

#' Provide OAuth endpoints
#'
#' @importFrom httr oauth_endpoint
#' @noRd
sstk_oauth_endpoint <- function() {
  httr::oauth_endpoint(
    "authorize" = "https://api.shutterstock.com/v2/oauth/authorize",
    "access" = "https://api.shutterstock.com/v2/oauth/access_token"
  )
}
