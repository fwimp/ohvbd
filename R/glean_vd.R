#' @title Parse data from requests to VecDyn
#' @description Extract the data returned by a call to [fetch_vd()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a list of responses from VecDyn as an `ohvbd.responses` object.
#' @param cols a character vector of columns to extract from the dataset. If specified, this will be adjusted to always include the "dataset_id" column.
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns.
#'
#' @return An `ohvbd.data.frame` containing the requested data.
#'
#' @examplesIf interactive()
#' fetch_vd(247) |>
#'   glean_vd(cols=c("species",
#'                     "sample_start_date",
#'                     "sample_value"),
#'              returnunique=TRUE)
#'
#' ohvbd.ids(247, "vd") |>
#'   fetch() |>
#'   glean() # Calls glean_vd()
#'
#' @concept vecdyn
#'
#' @export
#'

glean_vd <- function(res, cols = NA, returnunique = FALSE) {
  check_provenance(res, "vd", altfunc = "glean", objtype = "Responses")

  if (!any(is.na(cols))) {
    if (!("dataset_id" %in% cols)) {
      cli::cli_alert_info("Added {.val dataset_id} column to requested columns.")
      cols <- c("dataset_id", cols)
    }
  }

  if (any(class(res) == "httr2_response")) {
    # Detect if this is a single request
    out_df <- res |> resp_body_json()
  } else if (any(class(res) == "httr2_error")) {
    # Detect single error
    cli::cli_abort("Response contains error! (check to see if ID actually exists?)")
  } else {
    # Extract data from all successful responses
    out_df <- res |>
      resps_successes() |>
      resps_data(\(resp) vd_extraction_helper(resp, cols))
  }

  if (returnunique) {
    out_df <- unique(out_df)
  }

  out_final <- as.data.frame(out_df)
  out_final <- new_ohvbd.data.frame(df = out_final, db = "vd")
  return(out_final)
}
