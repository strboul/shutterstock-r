
#' Authorize Shutterstock
#'
#' Authenticate and store user credentials to authorize requests for the
#' Shutterstock API. After a successful authentication, an OAuth token will be
#' cached inside the \code{.httr-oauth}, which is a file placed in the current
#' working directory. This workflow is mainly followed by the \code{httr}
#' package.
#'
#' @importFrom httr oauth_app oauth_callback oauth2.0_token
#' @export
sstk_auth <- function() {

  # return token from disk if file exists:
  file <- ".httr-oauth"
  if (file.exists(file)) {
    message(paste(
      "'", file, "' found in the directory.\n",
      "Already authenticated.\n",
      sep = ""))
    return(sstk_oauth_token())
  }

  oauth_app <- httr::oauth_app(
    appname = "shutterstock",
    key = sstk_id(),
    secret = sstk_secret(),
    redirect_uri = httr::oauth_callback()
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

#' Read OAuth token from .httr-oauth file
#'
#' @export
sstk_oauth_token <- function() {
  file <- ".httr-oauth"
  if (!file.exists(file)) {
    stop(paste(
      "'", file, "' not found.\n",
      "Please authenticate first with sstk_auth()",
      sep = ""), call. = FALSE)
  }
  token <- readRDS(file)
  token
}

#' OAuth token credentials
#'
#' To be added in the http header section.
#' @noRd
sstk_oauth_token_cred <- function() {
  token <- sstk_oauth_token()
  cred <- token[[1]][["credentials"]]
  paste(cred[["token_type"]], cred[["access_token"]])
}
