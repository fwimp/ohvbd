#' @title Generate a base request object for the vectorbyte databases
#' @description This request is used as the basis for all calls to the vectorbyte API.
#' It does not contain any tokens or session ids, and thus can be regenerated at any time.
#'
#' @param baseurl the base url for the vectorbyte API
#' @param useragent the user agent string used when contacting vectorbyte
#' @param unsafe disable ssl verification (should only ever be required on Linux, **do not enable this by default**)
#' @author Francis Windram
#' @return Returns an httr2 request object, pointing at baseurl using useragent
#'
#' @examples
#' \dontrun{
#' basereq <- vb_basereq(
#'   baseurl="https://vectorbyte.crc.nd.edu/portal/api/",
#'   useragent="ROHVBD")
#' }
#'
#'
#' @export
#'


vb_basereq <- function(baseurl = "https://vectorbyte.crc.nd.edu/portal/api/", useragent = "ROHVBD", unsafe = FALSE) {
  req <- request(baseurl) %>% req_user_agent(useragent)
  if (unsafe) {
    req <- req %>% req_options(ssl_verifypeer = 0)
  }
  return(req)
}
