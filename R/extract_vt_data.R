#' @title Parse data from requests to VecTraits
#' @description Extract the data returned by a call to [ohvbd::get_vt_byid()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a list of responses from VecTraits.
#' @param cols a character vector of columns to extract from the dataset.
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns.
#'
#' @return A dataframe containing the extracted data.
#'
#' @examples
#' \dontrun{
#' vb_basereq() %>%
#'   get_vt_dataset_byid(54) %>%
#'   extract_vt_data(cols=c("DatasetID",
#'                          "Interactor1Genus",
#'                          "Interactor1Species"),
#'                   returnunique=TRUE)
#' }
#'
#' @export
#'

extract_vt_data <-
function(res, cols=NA, returnunique=FALSE){

  if (any(class(res) == "httr2_response")){
    # Detect if this is a single request
    out_data <- res %>% resp_body_json()
  } else if (any(class(res) == "httr2_error")){
    stop("Response contains error! (check to see if ID actually exists?)")
  } else {
    # Extract data from all successful responses
    out_data <- res %>%  resps_successes()  %>%  resps_data(\(resp) resp_body_json(resp))
  }

  # Parse each request in the list
  suppressWarnings({out_list <- lapply(out_data, rbindlist)})

  if (!any(is.na(cols))){
    # Filter cols from each sublist
    out_list <- lapply(out_list, select, any_of(cols))
  }
  # Finally explode the list into a df
  out_df <- rbindlist(out_list)

  if (returnunique){
    out_df <- unique(out_df)
  }

  return(as.data.frame(out_df))
}
