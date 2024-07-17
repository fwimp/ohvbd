#' @title write data from AREAdata to cache file
#'
#' @param d data to write
#' @param path cache path
#' @param metric metric downloaded (inferred if not provided)
#' @param gid gid of data (inferred if not provided)
#' @param format format to store data in (currenly unused)
#' @param compression_type type of compression to use when caching
#' @param compression_level level of compression to use while caching
#'
#' @return NULL
#' @keywords internal
#'

write_ad_cache <- function(d, path, metric = NA, gid = NA, format = "rda", compression_type = "bzip2", compression_level = 9) {
  if (is.na(metric)) {
    metric <- attr(d, "metric")
  }

  if (is.na(gid)) {
    gid <- attr(d, "gid")
  }

  # Make cache path if necessary
  ifelse(!dir.exists(path), dir.create(path), FALSE)
  writetime <- lubridate::now()
  save(d, writetime,
       file = file.path(path, paste0(metric, "-", gid, ".rda")),
       compress = compression_type,
       compression_level = compression_level)
}

#' @title Retrieve and format error message from failed vt calls
#'
#' @param path cache path
#' @param metric metric to retrieve
#' @param gid gid to retrieve
#' @param warn Whether to warn if a cached file is older than 6 months
#'
#' @return cached data
#'
#' @keywords internal
#'


read_ad_cache <- function(path, metric, gid, warn = TRUE) {
  writetime <- 0
  d <- NA
  load(file.path(path, paste0(metric, "-", gid, ".rda")))
  readtime <- lubridate::now()
  if (warn) {
    timediff <- readtime - writetime
    if (timediff > months(6))
      warning("Cached data older than 6 months!\nConsider deleting or recreating the cache.")
  }
  return(d)
}
