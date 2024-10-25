#' @title Print current ohvbd configuration variables
#' @description Access ohvbd options and configured variables, and print them to the command line.
#'
#' @param options_list An (optional) list of variables to search for.
#' @author Francis Windram
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#'   check_ohvbd_config()
#' }
#'
#' @export
#'

check_ohvbd_config <- function(options_list = NULL) {
  if (missing(options_list)) {
    options_list <- c("ohvbd_compat")
  }
  curr_options <- options()
  # Filter the options list to only include vars set in options
  present_options_list <- options_list[which(options_list %in% names(curr_options))]
  absent_options_list <- options_list[which(!(options_list %in% names(curr_options)))]
  found_option_values <- curr_options[present_options_list]
  found_option_names <- names(found_option_values)
  for (i in seq_along(found_option_names)) {
    cli::cli_alert_success("{found_option_names[i]}: {.val {found_option_values[i]}}")
  }
  for (x in absent_options_list) {
    cli::cli_alert_danger("{x}: {.val {NA}}")
  }
  invisible()
}
