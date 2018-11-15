
#' Search images
#'
#' @param query character.
#' @param sort character.
#' @examples \dontrun{
#' searchImages(query = "farmer")
#' }
#' @export
searchImages <- function(query, sort = "popular") {
  parameters <- get_environment()
  send_request("images/search", parameters)
}
