generate_basereq <-
function(baseurl="https://vectorbyte.crc.nd.edu/portal/api/", useragent="ROHVBD"){
  req <- request(baseurl) %>% req_user_agent(useragent)
  return(req)
}
