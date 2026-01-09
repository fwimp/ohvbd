#' @title Parse data from requests to VecTraits
#' @description Extract the data returned by a call to [fetch_vt()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a list of responses from VecTraits as an `ohvbd.responses` object.
#' @param cols a character vector of columns to extract from the dataset.
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns.
#'
#' @return An `ohvbd.data.frame` containing the requested data.
#'
#' @examplesIf interactive()
#' fetch_vt(54) |>
#'   glean_vt(cols=c("DatasetID",
#'                     "Interactor1Genus",
#'                     "Interactor1Species"),
#'              returnunique=TRUE)
#'
#' ohvbd.ids(54, "vt") |>
#'   fetch() |>
#'   glean() # Calls glean_vt()
#' @concept vectraits
#'
#' @export
#'

glean_vt <- function(res, cols = NA, returnunique = FALSE) {
  check_provenance(res, "vt", altfunc = "glean", objtype = "Responses")

  if (any(class(res) == "httr2_response")) {
    # Detect if this is a single request
    out_data <- res |> resp_body_json()
  } else if (any(class(res) == "httr2_error")) {
    # Detect single error
    cli::cli_abort("Response contains error! (check to see if ID actually exists?)")
  } else {
    # Extract data from all successful responses
    out_data <- res |>
      resps_successes() |>
      resps_data(\(resp) resp_body_json(resp))
  }

  # Parse each request in the list
  suppressWarnings({
    out_list <- lapply(out_data, rbindlist)
  })

  if (!any(is.na(cols))) {
    # Filter cols from each sublist
    if (!("DatasetID" %in% cols)) {
      cli::cli_alert_info("Added {.val DatasetID} column to requested columns.")
      cols <- c("DatasetID", cols)
    }
    out_list <- lapply(out_list, select, any_of(cols))
  }
  # Finally explode the list into a df
  out_df <- suppressWarnings(rbindlist(out_list))

  if (returnunique) {
    out_df <- unique(out_df)
  }

  out_final <- as.data.frame(out_df)
  out_final <- new_ohvbd.data.frame(df = out_final, db = "vt")

  return(out_final)
}
