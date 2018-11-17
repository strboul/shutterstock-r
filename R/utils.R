
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

#' Require call arguments
#' @noRd
require_args <- function(arg) {
  stop(sprintf(
    "'%s' required. Please provide missing arguments.",
    paste(arg, collapse = ", ")
  ),
  call. = FALSE)
}

#' Assert type for the call arguments
#' @noRd
assert_type <- function(x, type = c("character", "numeric", "integer", "data.frame")) {
  selected.type <- match.arg(type)
  switch (selected.type,
    "character" = is.character,
    "numeric" = is.numeric,
    "integer" = is.integer,
    "data.frame" = is.data.frame
  ) -> funTypeCheck
  if (!funTypeCheck(x)) {
    stop(paste(x, "is not", selected.type), call. = FALSE)
  }
}
