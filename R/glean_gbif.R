#' @title Parse data from requests to GBIF
#' @description Extract the data returned by a call to [fetch_gbif()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a list of responses from GBIF as an `ohvbd.responses` object.
#' @param cols a character vector of columns to extract from the dataset.
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns.
#'
#' @return An `ohvbd.data.frame` containing the requested data.
#'
#' @examplesIf interactive()
#' fetch_gbif("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc") |>
#'   glean_gbif()
#'
#' ohvbd.ids("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc", "gbif") |>
#'   fetch() |>
#'   glean() # Calls glean_gbif()
#'
#' @concept gbif
#'
#' @export
#'

glean_gbif <- function(res, cols = NA, returnunique = FALSE) {
  if (is.null(attr(res, "db"))) {
    cli::cli_alert_warning("Responses not necessarily from GBIF.")
  } else if (attr(res, "db") != "gbif") {
    cli::cli_abort(c(
      "x" = "Responses not from GBIF, Please use the appropriate {.fn glean_{attr(res, 'db')}} function.",
      "!" = "Detected db = {.val {attr(res, 'db')}}"
    ))
  }

  if (!rlang::is_installed("rgbif")) {
    cli::cli_abort(c(
      "x" = "Extracting retrieved GBIF data requires the {.pkg rgbif} package.",
      "i" = "Please ensure {.pkg rgbif} is installed."
    ))
  }

  # Extract data and put together as one df
  out_data <- lapply(res, rgbif::occ_download_import)
  out_df <- rbindlist(out_data)

  if (!any(is.na(cols))) {
    # Filter cols if required
    out_df <- out_df |> select(any_of(cols))
  }

  if (returnunique) {
    out_df <- unique(out_df)
  }

  out_final <- as.data.frame(out_df)
  out_final <- new_ohvbd.data.frame(df = out_final, db = "gbif")

  return(out_final)
}
