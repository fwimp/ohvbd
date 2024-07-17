#' @title Check whether databases are currently online
#' @description Attempt to access all presently supported databases and report if they were accessible.
#'
#' @author Francis Windram
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#'   check_db_status()
#' }
#'
#' @export
#'

check_db_status <- function() {
  db_list <- c(
    VectorByte = "https://vectorbyte.crc.nd.edu/portal/api/",
    Areadata = "https://github.com/pearselab/areadata/raw/main/output/"
  )

  successes <- 0

  cli_rule(left = "Database Status Check")

  for (i in seq_along(db_list)){
    statuscode <- tryCatch({
      out <- request(db_list[i]) %>% req_user_agent("ROHVBD") %>% req_perform()
      out$status_code
    }, error = function(cnd) {
      out <- last_response()
      out$status_code
    }
    )
    if (!is.null(statuscode)) {
      if (200 <= statuscode && statuscode < 300) {
        cli_alert_success("{names(db_list)[i]}")
        successes <- successes + 1
      } else {
        cli_alert_danger("{names(db_list)[i]}")
      }
    } else {
      cli_alert_danger("{names(db_list)[i]} db unresolved")
    }
  }

  cli_rule(left = "Summary")

  if (successes == length(db_list)) {
    cli_alert_success("All databases UP ({successes}/{length(db_list)}).")
  } else if (successes == 0) {
    cli_alert_danger("All databases DOWN! Check your internet connection?")
  } else {
    cli_alert_warning("Not all databases UP! {successes}/{length(db_list)}")
  }
}
