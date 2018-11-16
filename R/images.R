
#' Search images
#'
#' Searching for images. Use the parameters specified in the link
#' \href{here}{https://api-reference.shutterstock.com/#images}.
#'
#' @param ... additional arguments to be passed by \code{images/search} API
#'   endpoint parameters.
#' @examples \dontrun{
#'   today <- as.character(Sys.Date())
#'   searchImages(query = "farmer", sort = "popular", added_date = today)
#' }
#' @export
searchImages <- function(...) {
  params <- list(...)
  send_request("images/search", params)
}

#' List image categories
#'
#' Listing the categories (Shutterstock-assigned genres) that images can belong
#' to. This call takes no parameters.
#'
#' @examples \dontrun{
#'    listImageCategories()
#' }
#' @export
listImageCategories <- function() {
  send_request("images/categories")
}

#' List similar images
#'
#' Returning images that are visually similar to an image that you specify.
#'
#' @param id character. Image ID.
#' @param ... additional arguments to be passed by \code{images/similar} API
#'   endpoint parameters.
#' @examples \dontrun{
#'    listSimilarImages(id = "465011609")
#' }
#' @export
listSimilarImages <- function(id, ...) {
  if (missing(id)) require_arg(id)
  assert_type(id, "character")
  params <- list(...)
  send_request(sprintf("images/%s/similar", id), params)
}
