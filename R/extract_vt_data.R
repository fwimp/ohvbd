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
  return(df_filtered)
}
