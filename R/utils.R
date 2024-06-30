#' @title Retrieve and format error message from failed vt calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vt_error_body <- function(resp) {
  paste("Error retrieving VT ID", resp$request$headers$ohvbd)
}

#' @title Retrieve and format error message from failed vd calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vd_error_body <- function(resp) {
  paste("Error retrieving VD ID", resp$request$headers$ohvbd)
}

#' @title collapse a list of character strings to a JS space-separated single string
#' @param resp a vector to format
#' @return collapsed string
#' @keywords internal
#'

space_collapse <- function(v){
  paste(v, collapse = "%20")
}

#' @title Extract a single vd response, including consistent data
#' @param resp A response to extract from
#' @return dataframe of all relevant data in the response
#' @keywords internal
#'

vd_extraction_helper <- function(resp, cols=NA){
  resp_parse <- resp %>% resp_body_json()
  df <- rbindlist(resp_parse$results)
  df2 <- as.data.frame(resp_parse$consistent_data)
  df_out <- bind_cols(df2, df)
  if (resp_parse$count > 0){
    df_out$dataset_id <- resp$request$headers$ohvbd
  }
  if (!any(is.na(cols))){
    # Filter cols from each sublist
    df_out <- df_out %>%  select(any_of(cols))
  }
  return(df_out)
}
