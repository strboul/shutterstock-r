
### ----------------------------------------------------------------- ###
### SEARCH ----
### ----------------------------------------------------------------- ###

#' Search images
#'
#' Searching for images.
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/search}}
#' @examples \dontrun{
#' searchImages(query = "paris")
#'
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
#' to.
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/categories}}
#' @examples \dontrun{
#' listImageCategories()
#' }
#' @export
listImageCategories <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "images/categories",
    parameters = params
  )
}

#' List similar images
#'
#' Returning the images that are visually similar to an image that you specify.
#'
#' @param id character. Image ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/\{id\}/similar}}
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
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/recommendations}}
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
#' Showing information about an image, including its URL and preview image and
#' the sizes that it is available in.
#'
#' @param id character. Image ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/\{id\}}}
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
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/}}
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

#' List image licenses
#'
#' Listing your existing licenses.
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/licenses}}
#' @examples \dontrun{
#' listImageLicenses(image_id = "620154782")
#' }
#' @export
listImageLicenses <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "images/licenses",
    parameters = params
  )
}

### ----------------------------------------------------------------- ###
### COLLECTIONS ----
### ----------------------------------------------------------------- ###

#' List image collections
#'
#' Listing your collections of images and their basic attributes.
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/collections/}}
#' @examples \dontrun{
#' listImageCollections()
#' }
#' @export
listImageCollections <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "images/collections",
    parameters = params
  )
}

#' Get the details of image collections
#'
#' Giving more detailed information about a collection such as its cover image,
#' creation and most recent update time.
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/collections/\{id\}}}
#' @examples \dontrun{
#' # enter an id from the collections you own:
#' getImageCollections(id = "139149928")
#' }
#' @export
getImageCollections <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("images/collections/%s", id),
    parameters = params
  )
}

#' Get the details of image collections
#'
#' Listing the image IDs and date when added to a collection.
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/collections/\{id\}/items}}
#' @examples \dontrun{
#' getImageCollectionsDetails(id = "139149928")
#' }
#' @export
getImageCollectionsDetails <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("images/collections/%s/items", id),
    parameters = params
  )
}

### ----------------------------------------------------------------- ###
### FEATURED COLLECTIONS ----
### ----------------------------------------------------------------- ###

#' List featured collections
#'
#' Listing featured collections based on their types.
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/collections/featured/}}
#' @examples \dontrun{
#' listFeaturedCollections()
#' listFeaturedCollections(type = "photo")
#' }
#' @export
listFeaturedCollections <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "images/collections/featured",
    parameters = params
  )
}

#' Get the details of featured collections
#'
#' Giving more detailed information about a featured collection such as its
#' cover image, creation and most recent update time.
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/collections/featured/\{id\}}}
#' @examples \dontrun{
#' getFeaturedCollections(id = "136351027")
#' }
#' @export
getFeaturedCollections <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("images/collections/featured/%s", id),
    parameters = params
  )
}

#' Get the contents of featured collections
#'
#' Listing the image IDs and date when added to a featured collection.
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/images/collections/featured/\{id\}/items}}
#' @examples \dontrun{
#' getFeaturedCollectionsItems(id = "136351027")
#' }
#' @export
getFeaturedCollectionsItems <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("images/collections/featured/%s/items", id),
    parameters = params
  )
}
