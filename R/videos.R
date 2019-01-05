
#' Search videos
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/search}}
#' @examples \dontrun{
#' searchVideos(query = "hot air balloon", duration_from = "30", sort = "popular")
#' }
#' @export
searchVideos <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "videos/search",
    parameters = params
  )
}

#' List videos
#'
#' @param id character. One or more Video IDs.
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos}}
#' @examples \dontrun{
#' listVideos(id = c("18002566", "17139196"))
#' }
#' @export
listVideos <- function(id, ...) {
  check_required_args(id, "character")
  params <- list("id" = id, ...)
  send_request(
    method = "GET",
    resource = "videos",
    parameters = params
  )
}

#' Get details about videos
#'
#' @param id character. One or more Video IDs.
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/\{id\}}}
#' @examples \dontrun{
#' # get details of a single video:
#' getVideoDetails(id = "18002566")
#'
#' # multiple videos by lapply:
#' lapply(c("18002566", "17139196"), function(v) getVideoDetails(id = v))
#'
#' # get multiple videos by for loop:
#' videos <- list()
#' for (v in c("18002566", "17139196")) {
#' videos[[v]] <- getVideoDetails(id = v)
#' }
#' }
#' @export
getVideoDetails <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("videos/%s", id),
    parameters = params
  )
}

#' List video categories
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/categories}}
#' @examples \dontrun{
#' listVideoCategories()
#' }
#' @export
listVideoCategories <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "videos/categories",
    parameters = params
  )
}

#' List similar videos
#'
#' @param id character. Video ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/\{id\}/similar}}
#' @examples \dontrun{
#' listSimilarVideos(id = "2140697")
#' }
#' @export
listSimilarVideos <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("videos/%s/similar", id),
    parameters = params
  )
}

#' List video licenses
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/licenses}}
#' @examples \dontrun{
#' listVideoLicenses(video_id = "2140697")
#' }
#' @export
listVideoLicenses <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "videos/licenses",
    parameters = params
  )
}

#' List video collections
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/collections/}}
#' @examples \dontrun{
#' listVideoCollections()
#' }
#' @export
listVideoCollections <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "videos/collections",
    parameters = params
  )
}

#' Get the details of video collections
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/collections/\{id\}}}
#' @examples \dontrun{
#' # enter an id from the collections you own:
#' getVideoCollections(id = "17555176")
#' }
#' @export
getVideoCollections <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("videos/collections/%s", id),
    parameters = params
  )
}

#' Get the contents of video collections
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/videos/collections/\{id\}/items}}
#' @examples \dontrun{
#' # enter an id from the collections you own:
#' getVideoCollectionsContent(id = "139149928")
#' }
#' @export
getVideoCollectionsContent <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("videos/collections/%s/items", id),
    parameters = params
  )
}
