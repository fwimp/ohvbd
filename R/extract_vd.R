#' @title Parse data from requests to VecDyn
#' @description Extract the data returned by a call to [ohvbd::get_vd()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a list of responses from VecDyn.
#' @param cols a character vector of columns to extract from the dataset.
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns.
#'
#' @return A dataframe containing the extracted data.
#'
#' @examples
#' \dontrun{
#' get_vd_dataset_byid(247) %>%
#'   extract_vd(cols=c("species",
#'                          "sample_start_date",
#'                          "sample_value"),
#'                   returnunique=TRUE)
#' }
#'
#' @concept vecdyn
#'
#' @export
#'

extract_vd <- function(res, cols = NA, returnunique = FALSE) {

  if (is.null(attr(res, "db"))) {
    cli_alert_warning("Responses not necessarily from VecDyn.")
  } else if (attr(res, "db") != "vd") {
    cli_abort(c("x" = "Responses not from VecDyn, Please use the appropriate {.fn extract_x} function.", "!" = "Detected db = {.val {attr(res, 'db')}}"))
  }

  if (any(class(res) == "httr2_response")) {
    # Detect if this is a single request
    out_df <- res %>% resp_body_json()
  } else if (any(class(res) == "httr2_error")) {
    cli_abort("Response contains error! (check to see if ID actually exists?)")
  } else {
    # Extract data from all successful responses
    out_df <- res %>%  resps_successes()  %>%  resps_data(\(resp) vd_extraction_helper(resp, cols))
  }


  if (returnunique) {
    out_df <- unique(out_df)
  }

  out_final <- as.data.frame(out_df)
  attr(out_final, "db") <- "vd"

  return(out_final)
}
