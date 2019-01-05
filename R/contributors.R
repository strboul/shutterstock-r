
#' Get details about contributors
#'
#' @param id character. Contributor ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/contributors}}
#' @examples \dontrun{
#' getContributorDetails(id = c("800506", "1653538"))
#' }
#' @export
getContributorDetails <- function(id, ...) {
  check_required_args(id, "character")
  params <- list("id" = id, ...)
  send_request(
    method = "GET",
    resource = "contributors",
    parameters = params
  )
}

#' List contributors' collections
#'
#' @param contributor_id character. Contributor ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/contributors/\{contributor_id\}/collections}}
#' @examples \dontrun{
#' listContributorCollections(contributor_id = "800506", sort = "newest")
#' }
#' @export
listContributorCollections <- function(contributor_id, ...) {
  check_required_args(contributor_id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("contributors/%s/collections", contributor_id),
    parameters = params
  )
}

#' Get details about contributors' collections
#'
#' @param contributor_id character. Contributor ID. (required)
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/contributors/\{contributor_id\}/collections\{id\}}}
#' @examples \dontrun{
#' getContributorCollectionsDetails(contributor_id = "800506", id = "1991678")
#' }
#' @export
getContributorCollectionsDetails <- function(contributor_id, id, ...) {
  check_required_args(contributor_id, "character")
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("contributors/%s/collections/%s", contributor_id, id),
    parameters = params
  )
}

#' Get the items in contributors' collections
#'
#' @param contributor_id character. Contributor ID. (required)
#' @param id character. Collection ID. (required)
#' @param ... arguments to be passed by the source endpoint parameters.
#' @source \dQuote{\code{/contributors/\{contributor_id\}/collections\{id\}/items}}
#' @examples \dontrun{
#' getContributorCollectionsDetailsItems(contributor_id = "800506", id = "1991678", sort = "newest")
#' }
#' @export
getContributorCollectionsDetailsItems <- function(contributor_id, id, ...) {
  check_required_args(contributor_id, "character")
  check_required_args(id, "character")
  params <- list(...)
  send_request(
    method = "GET",
    resource = sprintf("contributors/%s/collections/%s/items", contributor_id, id),
    parameters = params
  )
}
