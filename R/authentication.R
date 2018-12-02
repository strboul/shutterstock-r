
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
    "authorize" = paste0(
      getOption("sstk.api.root.url"),
      getOption("sstk.api.version"),
      "oauth/authorize"
    ),
    "access" = paste0(
      getOption("sstk.api.root.url"),
      getOption("sstk.api.version"),
      "oauth/access_token"
    )
  )
}

#' Read OAuth token from .httr-oauth file
#'
#' @noRd
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

### ----------------------------------------------------------------- ###
### ENVIRONMENT VARIABLES ----
### ----------------------------------------------------------------- ###

#' Read environment variables
#'
#' Reads environment variables from the \code{.Renviron} file, which is a safe
#' place to locally store and retrieve API keys.
#' @export
sstk_keys <- function() {
  list(
    id = sstk_id(),
    secret = sstk_secret(),
    callback = sstk_callback()
  )
}

sstk_id <- function() {
  read_renvr("SSTK_ID")
}

sstk_secret <- function() {
  read_renvr("SSTK_SECRET")
}

#' OAuth callback URL
#'
#' Since the package is dependent on the \code{httr} package, some options has
#' to be altered accordingly.
#' @importFrom httr parse_url
#' @noRd
sstk_callback <- function() {
  url <- read_renvr("SSTK_CALLBACK")
  p <- httr::parse_url(url)
  Sys.setenv("HTTR_PORT" = p[["hostname"]])
  Sys.setenv("HTTR_SERVER_PORT" = p[["port"]])
  url
}

read_renvr <- function(var) {
  pat <- Sys.getenv(var)
  if (identical(pat, "")) {
    renvr_error(var)
  }
  pat
}

renvr_error <- function(which) {
  stop(paste0(
    "Set environment variable ",
    "'", which, "'",
    " from your Shutterstock personal access token"
  ),
  call. = FALSE)
}
