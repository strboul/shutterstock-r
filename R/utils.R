
#' Get parent call environment variables
#'
#' Return all function argument names and values - and exclude some, if
#' required. \code{sys.frames()} accesses to different call environments in the
#' call stack.
#'
#' @param which integer. the frame number in the call stack.
#' @param exclude character. which arguments should be excluded?
#' @seealso \code{?sys.parent}
#' @noRd
get_environment <- function(which = 1L, exclude = NA_character_) {
  stopifnot(is.integer(which))
  stopifnot(is.character(exclude))
  e <- sys.frames()[[which]]
  args <- as.list(e, all.names = TRUE)
  args[names(args)[!names(args) %in% exclude]]
}
