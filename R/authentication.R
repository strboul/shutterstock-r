
#' Authorize Shutterstock
#'
#' Authenticate user and store user credentials inside the \code{.httr-oauth}
#' file placed in the working directory.
#' @importFrom httr oauth_app oauth_callback oauth2.0_token
#' @export
sstk_auth <- function() {
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

sstk_oauth_token <- function() {
  file <- ".httr-oauth"
  if (!file.exists(file)) {
    stop(paste(
      "'", file, "' not found.\n",
      "Please authenticate first with sstk_auth()",
      sep = ""), call. = FALSE)
  }

  token <- readRDS(file)
  cred <- token[[1]][["credentials"]]
  paste(cred[["token_type"]], cred[["access_token"]])
}
