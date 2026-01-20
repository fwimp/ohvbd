#' @title Extract specified data from a set of responses (Deprecated)
#'
#' @description
#' This is a convenience method that infers and applies the correct extractor for the input.
#' @author Francis Windram
#'
#' @note
#' [extract()] is now deprecated and should not be used. Please use [glean()] instead.
#'
#' @param res An object of type `ohvbd.responses` or `ohvbd.ad.matrix` generated from [fetch()]
#' and containing data from one of the supported databases.
#' @param ... Any arguments to be passed to the underlying extractors (see [glean_vt()] and [glean_ad()] for specific arguments).
#' @returns The extracted data, either as an `ohvbd.data.frame` or `ohvbd.ad.matrix` object.
#' @concept deprecated
#' @export
extract <- function(res, ...) {
  .Deprecated("glean")
  return(glean(res, ...))
}

#' @title Delete all rda files from ohvbd AREAdata cache (Deprecated)
#' @author Francis Windram
#'
#' @note
#' [clean_ad_cache()] is now deprecated and should not be used. Please use [clean_ohvbd_cache()] instead.
#'
#' @param cache_location location of the cache.
#'
#' @return NULL
#'
#' @concept deprecated
#' @export
clean_ad_cache <- function(cache_location = NULL) {
  .Deprecated("clean_ohvbd_cache")
  if (!is.null(cache_location) && cache_location == "user") {
    cache_location <- NULL
  }
  return(clean_ohvbd_cache(path = cache_location))
}
