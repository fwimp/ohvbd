#' @title Check whether databases are currently online
#' @description Attempt to access all presently supported databases and report if they were accessible.
#'
#' @author Francis Windram
#'
#' @return TRUE if all DB checks pass, else FALSE
#'
#' @examplesIf interactive()
#'   check_db_status()
#'
#' @export
#'

check_db_status <- function() {
  db_list <- c(
    VectorByte = "https://vectorbyte.crc.nd.edu/portal/api/",
    Areadata = "https://github.com/pearselab/areadata/raw/main/output/",
    GBIF = "https://api.gbif.org/v1/"
    # TODO: Add figshare
  )

  successes <- 0

  cli::cli_rule(left = "Database Status Check")

  for (i in seq_along(db_list)) {
      statuscode <- tryCatch(
        {
          out <- request(db_list[i]) |>
            req_user_agent("ROHVBD") |>
            req_perform()
          out$status_code
        },
        error = function(cnd) {
          out <- last_response()
          out$status_code
        }
      )
    if (!is.null(statuscode)) {
      if (200 <= statuscode && statuscode < 300) {
        cli::cli_alert_success("{names(db_list)[i]}")
        successes <- successes + 1
      } else {
        cli::cli_alert_danger("{names(db_list)[i]}")
      }
    } else {
      cli::cli_alert_danger("{names(db_list)[i]} db unresolved")
    }
  }

  cli::cli_rule(left = "Summary")

  if (successes == length(db_list)) {
    cli::cli_alert_success("All databases UP ({successes}/{length(db_list)}).")
  } else if (successes == 0) {
    cli::cli_alert_danger("All databases DOWN! Check your internet connection?")
  } else {
    cli::cli_alert_warning("Not all databases UP! {successes}/{length(db_list)}")
  }
  invisible(successes == length(db_list))
}
