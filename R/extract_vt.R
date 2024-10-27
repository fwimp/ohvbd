#' @title Parse data from requests to VecTraits
#' @description Extract the data returned by a call to [ohvbd::fetch_vt()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a list of responses from VecTraits as an `ohvbd.responses` object.
#' @param cols a character vector of columns to extract from the dataset.
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns.
#' @param check_src toggle pre-checking of source data.
#'
#' @return An `ohvbd.data.frame` containing the requested data.
#'
#' @examples
#' \dontrun{
#' fetch_vt(54) %>%
#'   extract_vt(cols=c("DatasetID",
#'                          "Interactor1Genus",
#'                          "Interactor1Species"),
#'                   returnunique=TRUE)
#' }
#'
#' @concept vectraits
#'
#' @export
#'

extract_vt <- function(res, cols = NA, returnunique = FALSE, check_src = TRUE) {

  if (is.null(attr(res, "db")) && check_src) {
    cli_alert_warning("Responses not necessarily from VecTraits.")
  } else if (attr(res, "db") != "vt" && check_src) {
    cli_abort(c("x" = "Responses not from VecTraits, Please use the appropriate {.fn extract_{attr(res, 'db')}} function.", "!" = "Detected db = {.val {attr(res, 'db')}}"))
  }

  if (any(class(res) == "httr2_response")) {
    # Detect if this is a single request
    out_data <- res %>% resp_body_json()
  } else if (any(class(res) == "httr2_error")) {
    # Detect single error
    cli_abort("Response contains error! (check to see if ID actually exists?)")
  } else {
    # Extract data from all successful responses
    out_data <- res %>%  resps_successes()  %>%  resps_data(\(resp) resp_body_json(resp))
  }

  # Parse each request in the list
  suppressWarnings({
    out_list <- lapply(out_data, rbindlist)
  })

  if (!any(is.na(cols))) {
    # Filter cols from each sublist
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
