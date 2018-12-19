
### ----------------------------------------------------------------- ###
### HTTP CONNECTION CALLS ----
### ----------------------------------------------------------------- ###

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
#' @param parameters query parameters.
#' @param body data list elements for the POST requests.
#' @importFrom httr GET POST DELETE modify_url add_headers
#' @noRd
get_response <- function(method = c("GET", "POST", "DELETE"),
                         resource, parameters = NULL, body = NULL, encode = NULL) {

  selected.method <- tryCatch(match.arg(method),
                              error = function(e) method)

  # decompose list parameters for the multiple entries:
  if (!is.null(parameters)) {
    cond <- vapply(parameters, function(x) length(x) > 1L, logical(1))
    if (!all(cond)) {
      elements <- parameters[cond]
      recycled <- lapply(names(elements), function(n) {
        el <- as.list(elements[[n]])
        names(el) <- rep(n, length(el))
        el
      })
      # reassign 'parameters' with the rest:
      parameters <- c(do.call("c", recycled), parameters[!cond])
    }
  }

  auth <- sstk_oauth_token_cred()
  url <- httr::modify_url(
    paste0(getOption("sstk.api.root.url"), getOption("sstk.api.version"),
           resource
    ),
    query = parameters)

  if (identical(selected.method, "GET")) {
    httr::GET(url, httr::add_headers(Authorization = auth))
  } else if (identical(selected.method, "POST")) {
    httr::POST(url, httr::add_headers(Authorization = auth), body = body, encode = encode)
  } else if (identical(selected.method, "DELETE")) {
    httr::DELETE(url, httr::add_headers(Authorization = auth))
  } else {
    stop(
      paste(
        "(Internal). method has not been implemented:", selected.method
      ),
      call. = FALSE)
  }
}

#' Check the content type of response
#'
#' Checks Content-Type of an HTTP response. If it returns an error because of a
#' wrong design by the API creator, just let them know and drop the check until
#' it is fixed.
#'
#' @importFrom httr http_type
#' @noRd
check_http_type <- function(response,
                            type = c("application/json", "text/html")) {
  stopifnot(is_response(response))
  selected.type <- match.arg(type)
  actual <- httr::http_type(response)
  if (!identical(actual, selected.type)) {
    stop(
      paste(
        "(Internal). response's actual content type '", actual,
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
  stopifnot(is_response(response))
  if (httr::http_error(response)) {
    # additional descriptions along the HTTP error status codes:
    descrp <- switch(
      as.character(httr::status_code(response)),
      "400" = "Be sure parameters are valid and well-formed",
      "401" = "Please authenticate with sstk_auth()",
      "403" = "You are not permitted for the request",
      "404" = "The resource does not exist",
      "429" = "The rate limit is exceeded"
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
  stopifnot(is_response(response))
  cont <- httr::content(response, as = "text")

  jsonlite::fromJSON(cont, simplifyVector = FALSE)
}

#' Check if an object has response class
#' @noRd
is_response <- function(x) {
  inherits(x, "response")
}

### ----------------------------------------------------------------- ###
### AUTHENTICATION ----
### ----------------------------------------------------------------- ###

#' Authorize Shutterstock
#'
#' Authenticate and store user credentials to authorize requests for the
#' Shutterstock API. After a successful authentication, an OAuth token will be
#' cached inside the \code{.httr-oauth}, which is a file placed in the current
#' working directory. This workflow is mainly followed by the \code{httr}
#' package.
#'
#' @param scopes A list of scopes defined in the Shutterstock API.
#'   Default value is set to \code{NULL} which Shutterstock grants the
#'   \code{user.view} scope by default when no additional scopes have been
#'   provided.
#' @importFrom httr oauth_app oauth_callback oauth2.0_token
#' @details
#'
#' See the OAuth scope list
#' \url{https://api-reference.shutterstock.com/#authentication-oauth-scopes-h2}
#'
#' @examples \dontrun{
#' sstk_auth(scopes = c("collections.view", "licenses.view"))
#' }
#' @export
sstk_auth <- function(scopes = NULL) {

  # return token from disk if file exists:
  file <- ".httr-oauth"
  if (file.exists(file)) {
    message(paste(
      "'", file, "' found in the directory.\n",
      "Already authenticated.\n",
      sep = ""))
    return(read_sstk_oauth_token(file))
  }

  oauth_app <- httr::oauth_app(
    appname = "shutterstock",
    key = sstk_id(),
    secret = sstk_secret(),
    redirect_uri = httr::oauth_callback()
  )

  token <- httr::oauth2.0_token(
    endpoint = sstk_oauth_endpoint(),
    app = oauth_app,
    scope = sstk_oauth_scope(scopes)
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

#' Check a scope name if belongs to Shutterstock OAuth scopes
#' @noRd
sstk_oauth_scope <- function(name) {
  stopifnot(is.character(name) || is.null(name))
  c(
    "collections.edit",
    "collections.view",
    "earnings.view",
    "licenses.create",
    "licenses.view",
    "media.edit",
    "media.submit",
    "media.upload",
    "organization.address",
    "organization.view",
    "purchases.view",
    "reseller.purchase",
    "reseller.view",
    "user.address",
    "user.edit",
    "user.email",
    "user.view"
  ) -> scopes_list
  if (!all(name %in% scopes_list)) {
    stop(
      paste("Not a valid Shutterstock OAuth scope:",
            dQuote(name[!name %in% scopes_list])),
      call. = FALSE
    )
  } else {
    name[name %in% scopes_list]
  }
}

#' Read OAuth token from .httr-oauth file
#'
#' @noRd
read_sstk_oauth_token <- function(file) {
  if (!file.exists(file)) {
    message(paste(
      "'", file, "' not found.\n",
      "Please authenticate first with sstk_auth()",
      sep = ""))
  }
  # return a NULL credentials if file can't be read:
  null.file <- list(list(credentials = NULL))
  token <- tryCatch(
    readRDS(file),
    error = function(e) null.file,
    warning = function(w) null.file
  )
  token
}

#' OAuth token credentials
#'
#' To be added in the http header section.
#' @noRd
sstk_oauth_token_cred <- function() {
  token <- read_sstk_oauth_token(".httr-oauth")
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
