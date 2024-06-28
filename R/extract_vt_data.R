#' @title Parse data from requests to VecTraits
#' @description Extract the data returned by a call to [ohvbd::get_vt_dataset_byid()], filter columns of interest, and find unique rows if required.
#' @author Francis Windram
#'
#' @param res a response list (such as `response$data`) from vectraits
#' @param cols a character vector of columns to extract from the dataset
#' @param returnunique whether to return only the unique rows within each dataset according to the filtered columns
#'
#' @return Returns a dataframe containing the requested data
#'
#' @examples
#' \dontrun{
#' req <- generate_vb_basereq()
#' res <- get_vt_dataset_byid(54, req)
#' extract_vt_data(res$data,
#'                 cols=c(
#'                   "DatasetID",
#'                   "Interactor1Genus",
#'                   "Interactor1Species"),
#'                 returnunique=TRUE)
#' }
#'
#' @export
#'

extract_vt_data <-
function(res, cols=NA, returnunique=FALSE){
  # Extract just the columns that we need...
  suppressWarnings({
    df_filtered <- rbindlist(res$results)
      if (!any(is.na(cols))){
        df_filtered <- df_filtered %>%
          select(any_of(cols))
      }
  })

  # Return unique rows as this could be a common thing to do
  if (returnunique == TRUE){
    df_filtered <- unique(df_filtered)
  }
  return(as.data.frame(df_filtered))
}
