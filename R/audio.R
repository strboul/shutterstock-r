
#' Search tracks
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio/search}}
#' @examples \dontrun{
#' searchAudio(query = "bluegrass", duration_from = "60", moods = "uplifting")
#' }
#' @export
searchAudio <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "audio/search",
    parameters = params
  )
}

#' List audio tracks
#'
#' @param id character. One or more Audio IDs.
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio}}
#' @examples \dontrun{
#' listAudioTracks(id = "442583")
#' listAudioTracks(id = c("442583", "434750"))
#' }
#' @export
listAudioTracks <- function(id, ...) {
  check_required_args(id, "character")
  params <- list("id" = id, ...)
  send_request(
    method = "GET",
    resource = "audio",
    parameters = params
  )
}

#' Get the details of image collections
#'
#' @param id character. Audio track ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio/\{id\}}}
#' @examples \dontrun{
#' getAudioDetails(id = "442583")
#' }
#' @export
getAudioDetails <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("audio/%s", id),
    parameters = params
  )
}

#' List audio licenses
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio/licenses}}
#' @examples \dontrun{
#' listAudioLicenses()
#' listAudioLicenses(audio_id = 442583)
#' }
#' @export
listAudioLicenses <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "audio/licenses",
    parameters = params
  )
}

#' List audio collections
#'
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio/collections}}
#' @examples \dontrun{
#' listAudioCollections()
#' }
#' @export
listAudioCollections <- function(...) {
  params <- list(...)
  send_request(
    method = "GET",
    resource = "audio/collections",
    parameters = params
  )
}

#' Get the details of audio collections
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio/collections/\{id\}}}
#' @examples \dontrun{
#' getAudioCollections(id = "48433107")
#' }
#' @export
getAudioCollections <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("audio/collections/%s", id),
    parameters = params
  )
}

#' Get the contents of audio collections
#'
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/audio/collections/\{id\}/items}}
#' @examples \dontrun{
#' getAudioCollectionsContent(id = "48433113")
#' }
#' @export
getAudioCollectionsContent <- function(id, ...) {
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("audio/collections/%s/items", id),
    parameters = params
  )
}
