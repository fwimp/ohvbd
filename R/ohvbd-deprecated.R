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
