#' @title Fetch GBIF dataset/s by ID
#' @description Retrieve GBIF dataset/s specified by their dataset ID.
#' @author Francis Windram
#'
#' @param ids a string or character vector of ids (preferably in an `ohvbd.ids` object) indicating the particular dataset/s to download.
#' @param filepath directory to save gbif download files into.
#'
#' @note
#' Only 300 datasets can be requested at once (for now) due to technical limitations originating from the GBIF server setup.
#' It is worth splitting longer lists of ids into a couple of chunks if you need more than this.
#'
#' If you regularly use ohvbd to download large numbers of datasets at once and chunking is causing you other issues, please raise an issue at https://github.com/fwimp/ohvbd/issues.
#'
#' @return A list of [rgbif occ_download_get][rgbif::occ_download_get] objects, as an `ohvbd.responses` object.
#'
#' @examples
#' \dontrun{
#' fetch_gbif("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc")
#' }
#'
#' @concept gbif
#'
#' @export
#'

fetch_gbif <- function(ids, filepath = ".") {
  if (!rlang::is_installed("rgbif")) {
    cli::cli_abort(c(
      "x" = "Retrieving GBIF data requires the {.pkg rgbif} package.",
      "i" = "Please ensure {.pkg rgbif} is installed and that you have set up your authentication details:",
      "{.url https://docs.ropensci.org/rgbif/articles/gbif_credentials.html}"
    ))
  }

  if (length(ids) > 300) {
    cli::cli_abort(c(
      "x" = "GBIF Request too large (>300 IDs).",
      "i" = "Please split your request into multiple chunks and/or raise an issue:",
      "{.url https://github.com/fwimp/ohvbd/issues}"
    ))
  }

  rowcount <- rgbif::occ_count(datasetKey = paste0(ids, collapse = ";")) # nolint: object_usage_linter

  cli_alert_info(
    "Requesting {.val {rowcount}} occurrence{?s} over {.val {length(ids)}} dataset{?s}..."
  )

  # Currently package up entire request into one download request
  preds <- rgbif::pred_in("datasetKey", ids)

  dlid <- tryCatch(
    {
      rgbif::occ_download(preds, format = "SIMPLE_CSV")
    },
    error = function(e) {
      # Try again just in case of "Error in the HTTP2 framing layer" error from previous cancelled job
      rgbif::occ_download(preds, format = "SIMPLE_CSV")
    }
  )

  # Note: If people end up requiring automatic chunking built in, this should wrap the below code.

  # Customised version of occ_download_wait with more sensible setup
  wait <- 0
  status_previous <- "submitting"
  status_current <- status_previous
  cli::cli_progress_message(
    "{cli::pb_spin} Job status: {cli::col_yellow(status_current)} {.timestamp {cli::pb_elapsed}}  ",
    clear = FALSE,
    format_done = "{cli::col_green(cli::symbol$tick)} Retrieved from GBIF {.timestamp {cli::pb_elapsed}}",
    format_failed = "{cli::col_red(cli::symbol$cross)} GBIF Job {status_current}! {.timestamp {cli::pb_elapsed}}"
  )
  while (TRUE) {
    cli::cli_progress_update()

    if (wait <= 0) {
      tmp <- rgbif::occ_download_meta(dlid, list(http_version = 2)) # Download with default curlopts
      status_current <- tolower(tmp$status)

      if (status_current %in% c("succeeded", "killed", "cancelled", "failed")) {
        if (status_current == "succeeded") {
          cli::cli_progress_done()
          break
        } else {
          cli::cli_progress_done(result = "failed")
          break
        }
      }

      wait <- 5 # Could be configurable
    }

    Sys.sleep(0.5)
    wait <- wait - 0.5
  }

  if (status_current != "succeeded") {
    cli::cli_abort(
      c(
        "x" = "Download failed (either killed/cancelled by the user or failed during processing)!"
      ),
      call = rlang::env_parent()
    )
  }

  suppressMessages({
    out <- rgbif::occ_download_get(dlid, path = filepath)
  })

  return(new_ohvbd.responses(list(out), db = "gbif"))
}
