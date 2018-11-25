
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
get_environment <- function(which = 1, exclude = NA_character_) {
  stopifnot(is.numeric(which))
  stopifnot(is.character(exclude))
  e <- sys.frames()[[which]]
  args <- as.list(e, all.names = TRUE)
  args[names(args)[!names(args) %in% exclude]]
}

#' Check required args for the API endpoint parameters
#' @noRd
check_required_args <- function(x, type = c("character", "numeric", "integer", "data.frame", "list")) {
  if (missing(x)) {
    x.name <- deparse(substitute(x))
    require_args_error(x.name)
  }
  selected.type <- match.arg(type)
  switch (selected.type,
    "character" = is.character,
    "numeric" = is.numeric,
    "integer" = is.integer,
    "data.frame" = is.data.frame,
    "list" = is.list
  ) -> funTypeCheck
  if (!funTypeCheck(x)) {
    stop(paste(x, "not", selected.type), call. = FALSE)
  }
}

#' Require call arguments
#' @noRd
require_args_error <- function(x) {
  stop(paste(
    "Please provide required parameter(s):", x
  ),
  call. = FALSE)
}
