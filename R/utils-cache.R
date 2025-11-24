#' @title write data from AREAdata to cache file
#'
#' @param d data to write.
#' @param path cache path.
#' @param metric metric downloaded (inferred if not provided).
#' @param gid gid of data (inferred if not provided).
#' @param format format to store data in (currenly unused).
#' @param compression_type type of compression to use when caching.
#' @param compression_level level of compression to use while caching.
#'
#' @return NULL
#' @keywords internal
#'

write_ad_cache <- function(
  d,
  path,
  metric = NA,
  gid = NA,
  format = "rda",
  compression_type = "bzip2",
  compression_level = 9
) {
  if (is.na(metric)) {
    metric <- attr(d, "metric")
  }

  if (is.na(gid)) {
    gid <- attr(d, "gid")
  }

  # Log that this is a cached version of the file.
  attr(d, "cached") <- TRUE

  # Make cache path if necessary
  ifelse(!dir.exists(path), dir.create(path, recursive = TRUE), FALSE)
  writetime <- lubridate::now()
  save(
    d,
    writetime,
    file = file.path(path, paste0(metric, "-", gid, ".rda")),
    compress = compression_type,
    compression_level = compression_level
  )
  # Return file hash if desired
  # cli::cli_alert_info(cli::hash_obj_emoji(d)$emojis)  # nolint: commented_code_linter
}

#' @title Read AREAdata from cache file
#'
#' @param path cache path.
#' @param metric metric to retrieve.
#' @param gid gid to retrieve.
#' @param warn Whether to warn if a cached file is older than 6 months.
#'
#' @return cached data.
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
    if (timediff > months(6)) {
      warning(
        "Cached data older than 6 months!\nConsider deleting or recreating the cache."
      )
    }
  }
  # Return file hash if desired
  # cli::cli_alert_info(cli::hash_obj_emoji(d)$emojis)  # nolint: commented_code_linter
  return(d)
}

#' @title Delete all rda files from ohvbd AREAdata cache
#' @author Francis Windram
#'
#' @param cache_location location within which to remove rda files.
#'
#' @return NULL
#'
#' @examplesIf interactive()
#' clean_ad_cache()
#'
#' @export
#'
clean_ad_cache <- function(cache_location = "user") {
  if (tolower(cache_location) == "user") {
    # Have to do some horrible path substitution to make this work nicely on windows. It may cause errors later in which case another solution may be better.
    cache_location <- get_default_ohvbd_cache("adcache")
  }

  cli::cli_alert_warning(
    "Removing all rda files from {.path {cache_location}}:"
  )
  to_remove <- list.files(cache_location, "*.rda")
  cli::cli_ul(to_remove)
  remove_path <- file.path(cache_location, "*.rda")
  unlink(remove_path)
  remaining_files <- list.files(cache_location, "*.rda")
  num_removed <- length(to_remove) - length(remaining_files) # nolint: object_usage_linter
  cli::cli_alert_success("Removed {num_removed} file{?s}")
  invisible(NULL)
}

#' @title Get ohvbd cache locations
#' @author Francis Windram
#'
#' @param subdir The subdirectory within the cache to find/create (optional).
#' @param create Whether to create the cache location if it does not already exist (defaults to TRUE).
#'
#' @return ohvbd cache path as a string
#'
#' @examplesIf interactive()
#' get_default_ohvbd_cache()
#'
#' @export
get_default_ohvbd_cache <- function(subdir = NULL, create = TRUE) {
  outpath <- tools::R_user_dir("ohvbd", which="cache")
  if (!is.null(subdir)) {
    outpath <- file.path(outpath, subdir)
  }
  # Convert windows-style paths to forward slash paths
  outpath <- gsub("\\\\","/", outpath)
  if (create && !dir.exists(outpath)) {
    success <- dir.create(outpath, recursive=TRUE)
    if (!success) {
      cli::cli_abort(c("x" = "Failed to create cache directory at {.path {outpath}}"))
    } else {
      cli::cli_alert_success("Created new cache at {.path {outpath}}")
    }
  }
  outpath
}

#' @title Check whether an object has been loaded from cache by ohvbd
#' @author Francis Windram
#'
#' @param x The object to check.
#'
#' @return NULL
#'
#' @examplesIf interactive()
#' is.cached(c(1,2,3))
#'
#' @export
#'
is_cached <- function(x) {
  return(attr(x, "cached") %||% FALSE)
}
