#' @title Fetch AREAdata dataset
#' @description Retrieve AREAdata dataset/s specified by metric and spatial scale (GID).
#' @author Francis Windram
#'
#' @param metric the metric to retrieve from areadata.
#' @param gid the spatial scale to retrieve (0 = country-level, 1=province-level ...).
#' @param use_cache load files from cache if possible, and save them if not present.
#' @param cache_location path to cache location (defaults to user directory obtained from [tools::R_user_dir()][tools::R_user_dir()]).
#' @param refresh_cache force a refresh of the relevant cached data.
#' @param timeout timeout for data download from figshare/github in seconds.
#' @param basereq the url of the AREAdata database (usually generated by [ad_basereq()]). If `NA`, uses the default.
#'
#' @return A `ohvbd.ad.matrix` of the requested data (with added attributes for gid and metric).
#'
#' @section Valid metrics:
#' The following metrics are valid (alternative names are listed in brackets):
#' - `temp` (*temperature*)
#' - `spechumid` (*specific humidity*)
#' - `relhumid` (*relative humidity*)
#' - `uv` (*ultraviolet*)
#' - `precip` (*precipitation, rainfall*)
#' - `popdens` (*population density, population*)
#' - `forecast` (*future climate, future*)
#'
#' @examples
#' \dontrun{
#' fetch_ad(metric="temp", gid=0)
#' }
#'
#' @concept areadata
#'
#' @export
#'

fetch_ad <- function(metric = "temp", gid = 0, use_cache = FALSE, cache_location = "user", refresh_cache = FALSE, timeout = 240, basereq = NA) {

  if (all(is.na(basereq))) {
    basereq <- ad_basereq()
  }

  if (gid > 1 && !use_cache) {
    cli_alert_warning("GID2 datasets are quite large.")
    cli_alert_info("It is recommended to set {.arg use_cache=TRUE} to enable caching.")
  }

  if (tolower(cache_location) == "user") {
    # Have to do some horrible path substitution to make this work nicely on windows. It may cause errors later in which case another solution may be better.
    cache_location <- file.path(gsub("\\\\", "/", tools::R_user_dir("ohvbd", which = "cache")), "adcache")
  }

  loaded_cache <- FALSE
  final_url <- paste0(basereq, "output/")
  # TODO: Consider using match.arg() to do fuzzy matching because that'd be super cool
  poss_metrics <- c(
    "temp" = 1, "temperature" = 1,
    "spechumid" = 2, "specific humidity" = 2,
    "relhumid" = 3, "relative humidity" = 3,
    "uv" = 4, "ultraviolet" = 4,
    "precip" = 5, "precipitation" = 5, "rainfall" = 5,
    "popdens" = 6, "population density" = 6, "population" = 6,
    "forecast" = 7, "future climate" = 7, "future" = 7
  )
  final_metrics <- c("temp", "spechumid", "relhumid", "uv", "precip", "popdens", "forecast")

  metric <- tolower(metric)
  if (metric %in% names(poss_metrics)) {
    metricid <- poss_metrics[metric]
    final_metric <- final_metrics[metricid]
  } else {
    # Just for warning message
    cli_alert_warning("Metric {.val {metric}} not an allowed metric!")
    cli_rule(left = "Allowed metrics")
    cli_ul(final_metrics)
    cli_rule()
    final_metric <- "temp"
    metricid <- 1
    cli_alert_warning("Defaulting to {.val {final_metric}}")
  }
  outmat <- NA
  # Try to load cache
  if (use_cache && !refresh_cache) {
    outmat <- tryCatch({
      cli_progress_message("{cli::symbol$pointer} Loading AREAdata cache: {final_metric}-{gid} ...")
      suppressWarnings(read_ad_cache(cache_location, final_metric, gid))
    }, error = function(e) {
      cli_alert_danger("Failed to load AREAdata cache: {final_metric}-{gid}!")
      NA
    })
  }

  if (any(!is.na(outmat))) {
    loaded_cache <- TRUE
    cli_alert_success("Loaded AREAdata cache {final_metric}-{gid}.")
  }

  if (!loaded_cache) {
    loadloc <- c("github", "github", "figshare") # nolint: object_usage_linter
    cli_progress_message("{cli::symbol$pointer} Loading AREAdata {final_metric}-{gid} from {loadloc[gid + 1]}...")
    gid_str <- c("countries", "GID1", "GID2")[gid + 1]

    if (gid < 2) {
      if (metricid <= 5) {
        # Daily Climate
        final_url <- paste0(final_url, final_metric, "-dailymean-", gid_str, "-cleaned.RDS")
      } else if (metricid == 6) {
        # Population Density
        final_url <- paste0(final_url, "population-density-", gid_str, ".RDS")
      } else {
        # Future climate Scenario Forecasts
        final_url <- paste0(final_url, "annual-mean-temperature-forecast-", gid_str, ".RDS")
      }
    } else {
      if (metricid <= 5) {
        # Retrieve AD article from figshare
        figshare_data <- httr2::request("https://api.figshare.com/v2/articles/") |>
          httr2::req_user_agent("ROHVBD") |>
          httr2::req_url_path_append(16587311) |>
          httr2::req_perform() |>
          httr2::resp_body_json()
        figshare_df <- data.table::rbindlist(figshare_data$files)
        # Extract file list
        figshare_df <- figshare_df |>
          dplyr::filter(grepl(".RDS", .data$name, fixed = TRUE)) |>  # Get only RDS files
          dplyr::group_by(.data$name) |>  # Group by name
          dplyr::slice_max(.data$id, with_ties = FALSE) |>  # Get max id (assuming ids monotonically increase!)
          dplyr::ungroup() |>  # Ungroup as we don't need that any more, should now be 1 row per file
          tidyr::separate_wider_delim(.data$name, delim = "-", names = c("metric", "agg", "gid", "cleaned")) |>  # Split name into cols
          tidyr::separate_wider_delim(.data$cleaned, delim = ".", names = c("cleaned", "fileext")) |>  # Further split out file extension
          dplyr::select(-one_of(c("agg", "cleaned"))) |>  # Drop unnecessary columns
          dplyr::filter(gid == "GID2")  # Get only GID2

        # Could throw an error if not found. Might have to handle that later if necessary
        final_url <- figshare_df$download_url[which(figshare_df$metric == final_metric)][1]
      } else if (metricid == 6) {
        cli_alert_warning("{.val {final_metric}} not available at GID level 2. Defaulting to GID level 1...")
        final_url <- paste0(final_url, "population-density-GID1.RDS")
      } else {
        cli_alert_warning("{.val {final_metric}} not available at GID level 2. Defaulting to GID level 1...")
        final_url <- paste0(final_url, "annual-mean-temperature-forecast-GID1.RDS")
      }
    }

    # Handle download timeout
    timeout_bak <- getOption("timeout")
    outmat <- tryCatch({
      options(timeout = timeout)
      suppressWarnings(outmat <- readRDS(url(final_url)))
      cli_alert_success("Loaded AREAdata {final_metric}-{gid} from {loadloc[gid + 1]}.")
      outmat
    }, error = function(e) {
      NULL
    }, finally = {
      # Make sure timeout gets reset no matter what happens
      options(timeout = timeout_bak)
    })
    if (is.null(outmat)) {
      cli_progress_done()
      cli_abort(c("x" = "Failed to load AREAdata {final_metric}-{gid} from {loadloc[gid + 1]}.", "!" = "Try increasing the {.arg timeout} parameter."))
    }

    # Add gid attribute to matrix to allow easier parsing later down the line
    outmat <- new_ohvbd.ad.matrix(m = outmat, metric = final_metric, gid = gid, cached = FALSE, db = "ad")
  }

  if (use_cache) {
    if (!loaded_cache || refresh_cache) {
      cli_progress_message("{cli::symbol$pointer} Caching AREAdata {final_metric}-{gid} in {.path {cache_location}}...")
      write_ad_cache(outmat, path = cache_location, metric = final_metric, gid = gid, format = "rda")
      cli_alert_success("Cached AREAdata {final_metric}-{gid} in {.path {cache_location}}.")
    }
  }

  cli_progress_done()

  return(outmat)
}
