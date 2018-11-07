
#' Read environment variables
#'
#' Reads environment variables from the \code{.Renviron} file, which is a safe
#' way to store and retrieve API keys.
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

#' @seealso \code{\link[httr]{oauth_callback}}
sstk_callback <- function() {
  read_renvr("SSTK_CALLBACK")
}

#' @references https://cran.r-project.org/web/packages/httr/vignettes/api-packages.html
read_renvr <- function(var) {
  pat <- Sys.getenv(var)
  if (identical(pat, "")) {
    renvr_error(var)
  }
  pat
}

renvr_error <- function(which) {
  stop(paste("Please set env var", which, "to your Shutterstock personal access token"), call. = FALSE)
}
