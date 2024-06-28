get_vt_datasets_multiid <-
function(ids_to_find, basereq, cols=NA, returnunique=FALSE, sleeptime=0.2){
  pb <- progress_bar$new(format = "  downloading VecTraits id :what [:bar] :current/:total (:percent) eta: :eta", total=length(ids_to_find), show_after=0)
  errs = character()
  resultscreated = FALSE
  pb$tick(0)
  # For each id
  for (id in ids_to_find){
    # print(id)
    pb$tick(tokens = list(what = id))
    
    # Get the dataset
    out <- get_vt_dataset_byid(id, basereq)
    if (out$status >= 300 || out$status < 200){
      # If errored
      errs <- c(errs, out$data$message)
    } else {
      if (resultscreated == FALSE){
        # If no results already, don't rbind
        results <- extract_vt_data(out$data, cols, returnunique = returnunique)
        resultscreated = TRUE
      } else {
        results <- rbind(results, extract_vt_data(out$data, cols, returnunique = returnunique))
      }
    }
  # Rate limit
  Sys.sleep(sleeptime)
  }
  return(list(df=results, errs=errs))
}
