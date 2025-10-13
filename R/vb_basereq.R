#' @title Generate a base request object for the vectorbyte databases
#' @description This request is used as the basis for all calls to the vectorbyte API.
#' It does not contain any tokens or session ids, and thus can be regenerated at any time.
#'
#' @param baseurl the base url for the vectorbyte API.
#' @param useragent the user agent string used when contacting vectorbyte.
#' @param unsafe disable ssl verification (shouldn't ever be required unless you are otherwise experiencing SSL issues!)
#' @author Francis Windram
#' @return Returns an httr2 request object, pointing at baseurl using useragent.
#'
#' @examples
#' basereq <- vb_basereq(
#'   baseurl="https://vectorbyte.crc.nd.edu/portal/api/",
#'   useragent="ROHVBD")
#'
#' @concept basereq
#'
#' @export
#'

vb_basereq <- function(
  baseurl = "https://vectorbyte.crc.nd.edu/portal/api/",
  useragent = "ROHVBD",
  unsafe = FALSE
) {
  if (getOption("ohvbd_compat", default = FALSE) && isFALSE(unsafe)) {
    unsafe <- TRUE
  }

  req <- request(baseurl) |> req_user_agent(useragent)
  if (unsafe) {
    req <- req |> req_options(ssl_verifypeer = 0)
  }
  return(req)
}


#' @title Set ohvbd compatability mode to TRUE
#' @description Set ohvbd to disable ssl verification for calls to external APIs.
#' This should not be needed (and not be performed) unless you are otherwise experiencing SSL issues when using the package!
#'
#' When in interactive mode, checks with you to make sure you want to do this. Does not check when run in a script.
#'
#' @param value The boolean value to set ohvbd_compat to.
#' @author Francis Windram
#' @return NULL
#'
#'
#' @export
#'
#' @examplesIf interactive()
#' set_ohvbd_compat()

set_ohvbd_compat <- function(value = TRUE) {
  if (!is_bool(value)) {
    cli_abort(c(
      "x" = "{.arg value} must be a boolean (TRUE/FALSE)! Provided {.val {value}}"
    ))
  }

  # Choice mechanism derived from ui_yep in usethis/R/utils-ui.R and https://github.com/r-lib/cli/issues/228#issuecomment-1453614104

  # Define choices
  yes_choices <- c(
    "Yes",
    "Definitely",
    "For sure",
    "Yup",
    "Yeah",
    "I agree",
    "Absolutely"
  )
  no_choices <- c(
    "No way",
    "Not now",
    "Negative",
    "No",
    "Nope",
    "Absolutely not",
    "Get me out of here!"
  )

  # Find choices for this run
  yes_selected <- sample(yes_choices, 1)
  no_selected <- sample(no_choices, 2)

  # Format choices (and created unformatted variant)
  choices_unformatted <- c(yes_selected, no_selected)
  choices <- c(cli::col_green(yes_selected), cli::col_red(no_selected))

  # Shuffle choices and unformatted in the same order
  choice_idxs <- sample(seq_along(choices))
  choices_unformatted <- choices_unformatted[choice_idxs]
  choices <- choices[choice_idxs]

  if (rlang::is_interactive()) {
    cat("\n")
    cli::cli_inform(c(
      "x" = cli::col_red(
        "Setting this to TRUE disables checking of SSL certificates for this session."
      ),
      "",
      cli::col_yellow(
        "This is technically dangerous as someone could intercept the traffic between"
      ),
      cli::col_yellow(
        "your computer and the servers and force you to download malicious payloads."
      ),
      "",
      cli::col_yellow(
        "You should NOT enable this unless ohvbd is not working in its standard configuration!"
      ),
      "",
      cli::col_yellow("Do you want to proceed?"),
      ""
    ))
    cli::cli_ol(choices)
    cat("\n")
    repeat {
      selected <- readline("Selection: ")
      if (selected %in% c("0", seq_along(choices))) {
        break
      }
      cli::cli_inform("Enter an item from the menu, or 0 to exit")
    }
    selected <- as.integer(selected)
    if (selected == 0) {
      cli::cli_alert_danger("Cancelling...")
      return(invisible())
    }

    if (!(choices_unformatted[selected] %in% yes_choices)) {
      cli::cli_alert_danger("Cancelling...")
      return(invisible())
    }
  }

  # Actually do the thing
  options(ohvbd_compat = value)
  cli_alert_success(
    "Set compatibility mode = {.val {getOption('ohvbd_compat')}}"
  )
  invisible(NULL)
}
