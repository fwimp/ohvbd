#' @title Retrieve and format error message from failed vt calls
#' @param resp An errored response to format
#' @return error string
#' @keywords internal
#'

vt_error_body <- function(resp) {
  paste("Error retrieving VT ID", resp$request$headers$ohvbd)
}
