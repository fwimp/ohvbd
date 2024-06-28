get_vt_dataset_byid <-
function(id_to_find, basereq){
  resp <- tryCatch({
    resp <- basereq %>%
    req_url_path_append("vectraits-dataset") %>% 
    req_url_path_append(id_to_find) %>% 
    req_url_query("format" = "json") %>% 
    req_perform()
    resp
  }, error = function(e){
    # Get the last response instead
    last_response()
  })
  
  # Extract status code and json
  statuscode <- resp$status_code
  res <- resp %>% resp_body_json()
  
  return(list(status=statuscode, data=res))
}
