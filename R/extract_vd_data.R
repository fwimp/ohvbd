#' @title Parse data from requests to VecDyn
#' @description Extract the data returned by a call to [ohvbd::get_vd_byid()], filter columns of interest, and find unique rows if required.
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
#' vb_basereq() %>%
#'   get_vd_dataset_byid(247) %>%
#'   extract_vd_data(cols=c("species",
#'                          "sample_start_date",
#'                          "sample_value"),
#'                   returnunique=TRUE)
#' }
#'
#' @export
#'

extract_vd_data <-
function(res, cols=NA, returnunique=FALSE){

  if (any(class(res) == "httr2_response")){
    # Detect if this is a single request
    out_data <- res %>% resp_body_json()
  } else if (any(class(res) == "httr2_error")){
    cli_abort("Response contains error! (check to see if ID actually exists?)")
  } else {
    # Extract data from all successful responses
    out_df <- res %>%  resps_successes()  %>%  resps_data(\(resp) vd_extraction_helper(resp, cols))
  }


  if (returnunique){
    out_df <- unique(out_df)
  }

  return(as.data.frame(out_df))
}
