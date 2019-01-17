
### ----------------------------------------------------------------- ###
### HTTP CONNECTION CALLS ----
### ----------------------------------------------------------------- ###

#' Send request
#'
#' Bring everything together. First, get a response from the server. Second,
#' stop if response returns an error status. Then, check if HTTP type matches.
#' Last, return parsed content.
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
#' @param body data-list elements for the POST requests.
#' @importFrom httr GET POST DELETE modify_url add_headers
#' @noRd
get_response <- function(method = c("GET", "POST", "DELETE"),
                         resource, parameters = NULL, body = NULL, encode = NULL) {

  selected.method <- tryCatch(match.arg(method),
                              error = function(e) method)

  # decompose list parameters for the multiple entries:
  if (!is.null(parameters)) {
    cond <- vapply(parameters, function(x) length(x) > 1L, logical(1))
    if (any(cond)) {
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
  ua <- user_agent_header()
  url <- httr::modify_url(paste0(
    getOption("sstk.api.root.url"),
    getOption("sstk.api.version"),
    resource
  ),
  query = parameters)

  if (identical(selected.method, "GET")) {
    httr::GET(url, ua, httr::add_headers(Authorization = auth))
  } else if (identical(selected.method, "POST")) {
    httr::POST(url, ua, httr::add_headers(Authorization = auth), body = body, encode = encode)
  } else if (identical(selected.method, "DELETE")) {
    httr::DELETE(url, ua, httr::add_headers(Authorization = auth))
  } else {
    stop(
      paste(
        "(Internal). This HTTP method not implemented:", selected.method
      ),
      call. = FALSE)
  }
}

#' Check the content type of an HTTP response
#'
#' Note: If it returns an error because of a wrong design by the API creator,
#' just let them know and drop the check until it is fixed.
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

#' Supplementary message when an HTTP error occurs
#'
#' When an error occurs during the connection, an explanatory error message
#' should be thrown for the particular HTTP error status code. The call mostly
#' relies on \code{\link[httr]{http_error}} function.
#'
#' @importFrom httr http_error status_code http_condition content
#' @noRd
stop_error_status <- function(response) {
  stopifnot(is_response(response))
  if (httr::http_error(response)) {
    descrp <- switch(
      as.character(httr::status_code(response)),
      "400" = "Be sure parameters are valid and well-formed",
      "401" = "Please authenticate with sstk_auth()",
      "403" = "You are not permitted for the request",
      "404" = "The resource does not exist",
      "429" = "The rate limit is exceeded"
    )
    cond <- httr::http_condition(response, "error")
    respmsg <- httr::content(response)[["message"]]
    stop(
      sprintf(
        "Shutterstock API request failed:\n %s %s\n\n%s",
        cond[["message"]],
        if (identical(length(descrp), 1L)) descrp else "",
        respmsg
      ),
      call. = FALSE
    )
  }
}

#' Fetch and parse content of a response
#'
#' It is advised to provide \code{"text"} value in \code{as} argument in the
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

#' User-Agent request header
#'
#' Sending only the Shutterstock R package version and the VCS repository URL.
#'
#' @importFrom httr user_agent
#' @importFrom utils packageVersion
#' @noRd
user_agent_header <- function() {
  pkg <- paste("shutterstock", utils::packageVersion("shutterstock"), sep = "/")
  url <- "https://github.com/strboul/shutterstock-r"
  h <- paste(pkg, url, colllapse = "")
  httr::user_agent(h)
}

### ----------------------------------------------------------------- ###
### AUTHENTICATION ----
### ----------------------------------------------------------------- ###

#' Authorize Shutterstock R package
#'
#' Authenticate and store user credentials to authorize requests for the
#' Shutterstock API.
#'
#' @param scopes character. The default value is \code{NULL}. See details below
#'   for more information.
#' @importFrom httr oauth_app oauth_callback oauth2.0_token
#' @details
#'
#' This call starts the OAuth 2.0 authentication process. After successful
#' authentication, an OAuth token will be cached inside the \code{.httr-oauth},
#' which is a file placed in the current working directory. Shutterstock package
#' searches for a token saved in \code{.httr-oauth} file in different R
#' sessions. If the token is not found in the directory, the call launches OAuth
#' 2.0 authentication flow. This workflow is mainly followed by the \code{httr}
#' package.
#'
#' The argument \strong{\code{scopes}} accept a list of OAuth scopes defined in
#' the Shutterstock API. The default value is set to \code{NULL} but that
#' includes the \dQuote{\code{user.view}} scope which the Shutterstock API
#' grants by default when no additional scopes have been provided. Use
#' \dQuote{\code{all}} keyword to demand all scopes to be included in the OAuth
#' token.
#'
#' See the full Shutterstock API OAuth scope list here:
#' \url{https://api-reference.shutterstock.com/#authentication-oauth-scopes-h2}
#'
#' @examples \dontrun{
#' # apply collections.view and licenses.view scopes:
#' sstk_auth(scopes = c("collections.view", "licenses.view"))
#'
#' # apply all available scopes:
#' sstk_auth(scopes = "all")
#' }
#' @export
sstk_auth <- function(scopes = NULL) { #nocov start

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
} #nocov end

#' OAuth 2.0 endpoints
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

#' Get a scope name defined in the Shutterstock API
#' @noRd
sstk_oauth_scope <- function(name) {
  stopifnot(is.character(name) || is.null(name))
  # update this vector below by adding and removing new and gone scopes:
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
  if (identical(name, "all")) {
    scopes_list
  } else {
    if (all(name %in% scopes_list)) {
      name[name %in% scopes_list]
    } else {
      stop(
        sprintf("Not a valid Shutterstock OAuth scope: %s",
                name[!name %in% scopes_list]),
        call. = FALSE
      )
    }
  }
}

#' Read OAuth token from the .httr-oauth file
#'
#' The information in the token file is recorded in a different environment than
#' the Global, spared for the caching purposes, after the first read. The
#' subsequent actions needed to access the contents of this file will not
#' repeatedly read it from the disk; instead, it calls it from caching
#' environment which is persistent during an R session.
#'
#' @noRd
read_sstk_oauth_token <- function(file) {
  # read from caching:
  if (exists(file, envir = cacheEnv)) {
    return(get(file, envir = cacheEnv))
  }

  if (!file.exists(file)) {
    message(sprintf("'%s' not found", file))
  }
  # return a NULL credentials if file can't be read:
  null.file <- list(list(credentials = NULL))

  token <- tryCatch(
    readRDS(file),
    error = function(e) null.file,
    warning = function(w) null.file
  )
  # caching to environment:
  assign(file, token, envir = cacheEnv)
  token
}

#' OAuth token credentials
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
#' Reading environment variables either specified in the \code{.Renviron} file,
#' which is a safe place to locally store and retrieve API keys, or directly
#' from the environment variables set via \code{\link{sstk_set_keys}}.
#'
#' @export
sstk_get_keys <- function() { #nocov start
  list(
    id = sstk_id(),
    secret = sstk_secret(),
    callback = sstk_callback()
  )
} #nocov end

#' Set environment variables
#'
#' @param id character. The client id from your application.
#' @param secret character. The secret id from your application.
#' @param callback character. The callback (or redirect) URI specified in your
#'   application.
#' @export
sstk_set_keys <- function(id, secret, callback) { #nocov start
  x <- list(id, secret, callback)
  cond <- vapply(x, is.character, logical(1))
  if (!all(cond)) {
    # display only the first cond error at a time:
    stop(
      sprintf("\"%s\" not valid. Provide only character type in the arguments.",
              unlist(x[!cond])[1L])
    )
  }
  vars <- list(
    "SHUTTERSTOCK_CLIENT_ID" = id,
    "SHUTTERSTOCK_CLIENT_SECRET" = secret,
    "SHUTTERSTOCK_CALLBACK_URL" = callback
  )
  do.call(Sys.setenv, vars)
} #nocov end

sstk_id <- function() { #nocov start
  read_renvr("SHUTTERSTOCK_CLIENT_ID")
} #nocov end

sstk_secret <- function() { #nocov start
  read_renvr("SHUTTERSTOCK_CLIENT_SECRET")
} #nocov end

#' OAuth callback URL
#'
#' Since the package is depending on the \code{httr} package, some options have
#' to be altered accordingly.
#'
#' @importFrom httr parse_url
#' @noRd
sstk_callback <- function() { #nocov start
  url <- read_renvr("SHUTTERSTOCK_CALLBACK_URL")
  p <- httr::parse_url(url)
  Sys.setenv("HTTR_PORT" = p[["hostname"]])
  Sys.setenv("HTTR_SERVER_PORT" = p[["port"]])
  url
} #nocov end

read_renvr <- function(var) { #nocov start
  pat <- Sys.getenv(var)
  if (identical(pat, "")) {
    renvr_error(var)
  }
  pat
} #nocov end

renvr_error <- function(which) { #nocov start
  stop(
    paste0(
      "Set environment variable ",
      "'",
      which,
      "'",
      " from your Shutterstock personal access token"
    ),
    call. = FALSE
  )
} #nocov end
