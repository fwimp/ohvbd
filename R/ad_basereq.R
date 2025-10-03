#' @title Generate a base request string for the AREAdata database
#' @description This string is used as the basis for all calls to AREAdata.
#' It does not contain any tokens or session ids, and thus can be regenerated at any time.
#'
#' @author Francis Windram
#' @return Returns a string containing the root address of the AREAdata dataset.
#'
#' @examples
#' basereq <- ad_basereq()
#'
#' @concept basereq
#'
#' @export
#'

ad_basereq <- function() {
  return("https://github.com/pearselab/areadata/raw/main/")
}
