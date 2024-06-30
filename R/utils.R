#' @title Retrieve and format error message from failed vt calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vt_error_body <- function(resp) {
  paste("Error retrieving VT ID", resp$request$headers$ohvbd)
}

#' @title collapse a list of character strings to a JS space-separated single string
#' @param resp a vector to format
#' @return collapsed string
#' @keywords internal
#'

space_collapse <- function(v){
  paste(v, collapse = "%20")
}
