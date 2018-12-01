
### ----------------------------------------------------------------- ###
### SEARCH ----
### ----------------------------------------------------------------- ###

#' Search images
#'
#' Searching for images.
#'
#' @param ... arguments to be passed by the parameters in the source endpoint.
#' @source \code{\dQuote{images/search}}
#' @examples \dontrun{
#' today <- as.character(Sys.Date())
#' searchImages(query = "farmer", sort = "popular", added_date = today)
#' }
#' @export
searchImages <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "images/search",
    parameters = params
  )
}

#' List image categories
#'
#' Listing the categories (Shutterstock-assigned genres) that images can belong
#' to. \emph{This call takes no additional parameters.}
#'
#' @source \code{\dQuote{images/categories}}
#' @examples \dontrun{
#' listImageCategories()
#' }
#' @export
listImageCategories <- function() {
  send_request(
    method = "GET",
    resource = "images/categories"
  )
}

#' List similar images
#'
#' Returning images that are visually similar to an image that you specify.
#'
#' @param id character. Image ID. (required)
#' @source \code{\dQuote{images/\{id\}/similar}}
#' @examples \dontrun{
#' listSimilarImages(id = "620154782")
#' }
#' @export
listSimilarImages <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("images/%s/similar", id),
    parameters = params
  )
}

#' List recommended images
#'
#' Returning images that customers put in the same collection as the specified
#' image IDs.
#'
#' @param id character. One or more Image IDs.
#' @source \code{\dQuote{images/recommendations}}
#' @examples \dontrun{
#' listRecommendedImages(id = "620154782")
#' listRecommendedImages(id = c("620154782", "620154770"), max_items = 5)
#' }
#' @export
listRecommendedImages <- function(id, ...) {
  check_required_args(id, "character")
  params <- list("id" = id, ...)
  send_request(
    method = "GET",
    resource = "images/recommendations",
    parameters = params
  )
}

### ----------------------------------------------------------------- ###
### DETAILS ----
### ----------------------------------------------------------------- ###

#' Get details about images
#'
#' Showing information about an image, including a URL to a preview image and
#' the sizes that it is available in.
#'
#' @param id character. Image ID. (required)
#' @source \code{\dQuote{images/\{id\}}}
#' @examples \dontrun{
#' getImageDetails(id = "620154782")
#' }
#' @export
getImageDetails <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("images/%s", id),
    parameters = params
  )
}

#' List images
#'
#' Listing information about one or more images, including the available sizes.
#'
#' @param id character. One or more Image IDs.
#' @source \code{\dQuote{v2/images/}}
#' @examples \dontrun{
#' listImages(id = c("620154782", "620154770"), view = "minimal")
#' }
#' @export
listImages <- function(id, ...) {
  check_required_args(id, "character")
  params <- list("id" = id, ...)
  send_request(
    method = "GET",
    resource = "images",
    parameters = params
  )
}

### ----------------------------------------------------------------- ###
### LICENSES AND DOWNLOADS ----
### ----------------------------------------------------------------- ###

#' License images
#'
#' Getting licenses for one or more images.
#'
#' @examples \dontrun{
#' licenseImages(subscription_id = "<SUBSCRIPTION_ID>", format = "jpg", size =
#' "small", search_id = "Books")
#' }
#' @export
               resource = "images/licenses",
               parameters = params
  )
}

#' List licenses
#'
#' Listing existing licenses.
#'
#' @examples \dontrun{
#' listLicenses(image_id = "620154782")
#' }
#' @export
listLicenses <- function(...) {
  params <- list(...)
               resource = "images/licenses",
               parameters = params
  send_request(
    method = "GET",
  )
}

### ----------------------------------------------------------------- ###
### COLLECTIONS ----
### ----------------------------------------------------------------- ###
#' List image collections
#'
#' @examples \dontrun{
#' listImageCollections()
#' }
#' @export
listImageCollections <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "images/collections",
    parameters = params,
    scope = "collections.view"
  )
}
