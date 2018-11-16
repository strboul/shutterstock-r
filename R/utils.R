
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

#' Require a call argument
#' @noRd
require_arg <- function(arg) {
  stop(paste(arg, "is required. Please provide"), call. = FALSE)
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
    stop(paste(id, "is not", selected.type), call. = FALSE)
  }
}
