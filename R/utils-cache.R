#' @title write data from AREAdata to cache file
#'
#' @param d data to write.
#' @param metric metric downloaded (inferred if not provided).
#' @param gid gid of data (inferred if not provided).
#' @param path cache path.
#' @param format format to store data in (currenly unused).
#' @param compression_type type of compression to use when caching.
#' @param compression_level level of compression to use while caching.
#'
#' @return Path of cached file (invisibly)
#' @keywords internal
#'

write_ad_cache <- function(
  d,
  metric = NULL,
  gid = NULL,
  path = NULL,
  format = "rda",
  compression_type = "bzip2",
  compression_level = 9
) {

  metric <- metric %||% attr(d, "metric")
  gid <- gid %||% attr(d, "gid")


  # Log that this is a cached version of the file.
  attr(d, "cached") <- TRUE

  # Log the write time of this cached object
  attr(d, "writetime") <- lubridate::now()

  # Default cache if path is not defined
  path <- path %||% get_default_ohvbd_cache("adcache")

  # Make cache path if necessary
  ifelse(!dir.exists(path), dir.create(path, recursive = TRUE), FALSE)
  outpath <- file.path(path, paste0(metric, "-", gid, ".rda"))
  save(
    d,
    file = outpath,
    compress = compression_type,
    compression_level = compression_level
  )
  invisible(outpath)
  # Return file hash if desired
  # cli::cli_alert_info(cli::hash_obj_emoji(d)$emojis)  # nolint: commented_code_linter
}

#' @title Read AREAdata from cache file
#'
#' @param metric metric to retrieve.
#' @param gid gid to retrieve.
#' @param path cache path.
#' @param warn Whether to warn if a cached file is older than 6 months.
#'
#' @return cached data.
#'
#' @keywords internal
#'

read_ad_cache <- function(metric, gid, path=NULL, warn = TRUE) {
  d <- NA

  # Default cache if path is not defined
  path <- path %||% get_default_ohvbd_cache("adcache")

  load(file.path(path, paste0(metric, "-", gid, ".rda")))
  gid <- attr(d, "writetime") %||% lubridate::now()
  readtime <- lubridate::now()
  if (warn) {
    timediff <- readtime - writetime
    if (timediff > months(6)) {
      cli::cli_warn(
        "!" = "Cached data older than 6 months!\nConsider deleting or recreating the cache."
      )
    }
  }
  # Return file hash if desired
  # cli::cli_alert_info(cli::hash_obj_emoji(d)$emojis)  # nolint: commented_code_linter
  return(d)
}

#' @title Delete files from ohvbd cache directories
#' @author Francis Windram
#'
#' @param cache_location location within which to remove rda files. (Defaults to the standard ohvbd cache location).
#' @param subdir a subdirectory or list of subdirectories to clean.
#' @param dryrun if `TRUE` list files that would be deleted, but do not remove.
#'
#' @return NULL
#'
#' @examplesIf interactive()
#' clean_ad_cache()
#'
#' @export
clean_ohvbd_cache <- function(cache_location = NULL, subdir = NULL, dryrun = FALSE) {
  if (is.null(cache_location)) {
    cache_location <- get_default_ohvbd_cache()
  }
  if (length(list.files(cache_location, include.dirs = FALSE, recursive = TRUE)) < 1) {
    cli::cli_alert_success("Cache is clear")
    return(invisible(NULL))
  }

  list_ohvbd_cache(cache_location, subdir = subdir)

  if (dryrun) {
    cli::cli_alert_info("Dry run, so deleting nothing.")
    return(invisible(NULL))
  } else {
    cli::cli_text("")
    cli::cli_alert_warning(paste("This will", cli::col_red("permanently delete"), "files from your computer!"))
    cli::cli_alert_info("Are you sure? [y/N]")
    confirmation <- readline(">>")
    if (tolower(confirmation) != "y") {
      cli::cli_alert_danger("Aborting.")
      return(invisible(NULL))
    }
  }

  prev_files <- 0
  removed_files <- 0
  if (!is.null(subdir)) {
    # Clean only the specified dirs
    for (d in subdir) {
      working_path <- file.path(cache_location, d)
      prev_files <- prev_files + length(list.files(file.path(working_path), recursive = TRUE))
      cli::cli_alert_info("Clearing files from {.path {working_path}}")
      unlink(file.path(working_path, "*"), recursive = TRUE)
      removed_files <- removed_files + length(list.files(file.path(working_path), recursive = TRUE))
    }
  } else {
    # Clean the whole cache
    remove_path <- file.path(cache_location, "*")
    prev_files <- prev_files + length(list.files(file.path(cache_location), recursive = TRUE))
    cli::cli_alert_info("Clearing files from {.path {cache_location}}")
    unlink(remove_path, recursive = TRUE)
    removed_files <- removed_files + length(list.files(file.path(cache_location), recursive = TRUE))
  }
  num_removed <- prev_files - removed_files # nolint: object_usage_linter
  cli::cli_alert_success("Removed {num_removed} file{?s}")
  invisible(NULL)
}


#' @title Format directory as df ready for tree plotting
#'
#' @param d directory to format
#'
#' @return data.frame of file sytem nodes and children
#' @keywords internal
.format_dir_as_tree <- function(d) {
  d_members <- c(d, list.files(d, full.names = TRUE, recursive = TRUE, include.dirs = TRUE))
  d_members_short <- c(d, list.files(d, full.names = FALSE, recursive = TRUE, include.dirs = TRUE))
  d_members_short <- lapply(d_members_short, \(x) {tail(strsplit(x, "/")[[1]], 1)})
  d_members_children <- lapply(d_members, list.files)
  outdf <- data.frame(
    stringsAsFactors = FALSE,
    files = as.character(d_members_short),
    children = I(d_members_children))
  return(outdf)
}

#' @title List all ohvbd cached files
#' @author Francis Windram
#'
#' @param cache_location location within which to list files. (Defaults to the standard ohvbd cache location).
#' @param subdir a subdirectory or list of subdirectories to list.
#' @return NULL
#'
#' @examplesIf interactive()
#' list_ohvbd_cache()
#'
#' @export
list_ohvbd_cache <- function(cache_location = NULL, subdir = NULL, treemode = TRUE) {
  if (is.null(cache_location)) {
    cache_location <- get_default_ohvbd_cache()
  }
  cache_dirs_tmp <- list.dirs(cache_location, full.names = FALSE)
  if (!is.null(subdir)) {
    cache_dirs <- cache_dirs_tmp[which(cache_dirs_tmp %in% subdir)]
    if (length(cache_dirs) < 1) {
      cli::cli_abort(c("x" = "Dir{?s} {.val {subdir}} not found in cache location."))
    } else if (length(cache_dirs) < length(subdir)) {

      cli::cli_warn(c("!" = "Dir{?s} {.val {setdiff(subdir, cache_dirs)}} not found in cache location."))
    }
  } else {
    cache_dirs <- cache_dirs_tmp
  }
  cli::cli_h1("Cached files")
  cli::cli_text("Cache location: {.path {cache_location}}")
  if (treemode) {
    cli::cli_text("")
    cli::cli_verbatim(cli::tree(.format_dir_as_tree(cache_location)))
    cli::cli_text("")
  } else {
    for (x in cache_dirs) {
      subdir_files <- list.files(file.path(cache_location, x), recursive = FALSE)
      subdir_files <- subdir_files[which(!(subdir_files %in% cache_dirs))]
      if (x == "") {
        cli::cli_h2("<root>: {length(subdir_files)} file{?s}")
      } else {
        cli::cli_h2("{x}: {length(subdir_files)} file{?s}")
      }
      if (length(subdir_files) < 1) {
        cli::cli_text("{.emph {'none'}}")
      } else {
        cli::cli_ul(subdir_files)
      }
    }
  }
  invisible()
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
  outpath <- tools::R_user_dir("ohvbd", which = "cache")
  if (!is.null(subdir)) {
    outpath <- file.path(outpath, subdir)
  }
  # Convert windows-style paths to forward slash paths
  outpath <- gsub("\\\\", "/", outpath)
  if (create && !dir.exists(outpath)) {
    success <- dir.create(outpath, recursive = TRUE)
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
