get_current_vt_ids <-
function(basereq){
  resp <- basereq %>%
  req_url_path_append("vectraits-explorer") %>% 
  req_url_query("format" = "json") %>% 
  req_perform()
  overalldata <- resp %>% resp_body_json()
  present_ids <- as.numeric(overalldata$ids)
  return(present_ids)
}
