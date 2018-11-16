
#' Search images
#'
#' @examples \dontrun{
#'   today <- as.character(Sys.Date())
#'   searchImages(query = "farmer", sort = "popular", added_date = today)
#' }
#' @references Shutterstock API Reference:
#'   \url{https://api-reference.shutterstock.com/#images}
#' @export
searchImages <- function(...)
{
  params <- list(...)
  send_request("images/search", params)
}
}
