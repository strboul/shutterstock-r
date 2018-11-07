
#' Search images
#'
#' @param query a list.
#' @examples \dontrun{
#' searchImages(query = "farmer")
#' }
#' @export
searchImages <- function(query) {
  url <- httr::modify_url("https://api.shutterstock.com/v2/images/search",
                          query = list(query = query))
  httr::GET(url)
}
