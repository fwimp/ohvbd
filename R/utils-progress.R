#' @title Reimplementation of cli's default progress style
#' @return list of characters for a progress bar
#' @keywords internal
#'

default_progress_style <- function() {
  # Shim to add infix NULL defaulting
  `%||%` <- rlang::`%||%`

  opt <- progress_style(getOption("cli.progress_bar_style"))
  if (cli::is_utf8_output()) {
    opu <- progress_style(getOption("cli.progress_bar_style_unicode"))
    list(
      complete = opu$complete %||% opt$complete %||% "\u25A0",
      current = opu$current %||%
        opt$current %||%
        opu$complete %||%
        opt$complete %||%
        "\u25A0",
      incomplete = opu$incomplete %||% opt$incomplete %||% "\u00a0"
    )
  } else {
    opa <- progress_style(getOption("cli.progress_bar_style_ascii"))
    list(
      complete = opa$complete %||% opt$complete %||% "=",
      current = opa$current %||%
        opt$current %||%
        opa$complete %||%
        opt$complete %||%
        ">",
      incomplete = opa$incomplete %||% opt$incomplete %||% "-"
    )
  }
}


#' @title Reimplementation of cli's progress style shim
#' @param x a string to find in [cli::cli_progress_styles()].
#' @return a formatting list from [cli::cli_progress_styles()].
#' @keywords internal
#'
progress_style <- function(x) {
  if (is.null(x)) {
    return(x)
  }
  if (rlang::is_string(x)) {
    return(cli::cli_progress_styles()[[x]])
  }
  x
}

#' @title Format and print date overlaps
#' @description Format and output to the terminal a visualisation of the overlaps between a given period and another set of dates.
#' This is mostly used in the error handling of [glean_ad()] however it can also be used independently.
#' It was designed to fill a more general role within UI design using the cli package, and should be usable (or hackable) by others needing the same tool.
#' @author Francis Windram
#'
#' @param start the date that the reference period begins (as Date object).
#' @param end the date that the reference period ends (as Date object).
#' @param targets a vector of dates.
#' @param targetrange is the target a range? If so this will treat the first two elements of `targets` as the start and end of the range.
#' @param twobar whether to render as two bars or as one with different colours for overlaps.
#' @param width the width of the bars in characters. Defaults to 0.5 * console width.
#' @param style a style from [cli::cli_progress_styles()] to use as a format.
#'
#'
#' @return No return value
#'
#' @examples
#' format_time_overlap_bar(
#'   start = as.Date("2022-08-04"),
#'   end = as.Date("2022-08-11"),
#'   targets = c(as.Date("2022-08-05"), as.Date("2022-08-12")),
#'   targetrange = TRUE, twobar=TRUE
#' )
#'
#'
#' @export
#'

format_time_overlap_bar <- function(
  start,
  end,
  targets,
  targetrange = FALSE,
  twobar = FALSE,
  width = NULL,
  style = list()
) {
  if (is.null(width)) {
    width <- round(cli::console_width() * 0.5)
  }

  min_time <- min(c(start, end, targets))
  max_time <- max(c(start, end, targets)) + days(1)
  # Add 1 to interval length to be inclusive
  total_seconds <- lubridate::time_length(
    interval(min_time, max_time),
    "seconds"
  )
  secondsperbar <- total_seconds / width

  def <- default_progress_style()
  chr_complete <- style[["complete"]] %||% def[["complete"]]
  chr_incomplete <- style[["incomplete"]] %||% def[["incomplete"]]
  chr_current <- style[["current"]] %||% def[["current"]]

  bar_source <- c(chr_incomplete, chr_complete, chr_current)

  outbar <- min_time + lubridate::seconds(seq(0, width) * secondsperbar)
  bar_intervals <- lubridate::int_diff(outbar)

  coverage_interval <- interval(start, end + days(1))
  # Find bars covered by main interval
  within_coverage <- lubridate::int_overlaps(bar_intervals, coverage_interval)

  if (targetrange) {
    target_start <- targets[1]
    target_end <- targets[2] + days(1) # Add one day to make sure we're inclusive
    target_interval <- interval(target_start, target_end)
    within_target <- lubridate::int_overlaps(bar_intervals, target_interval)
  } else {
    target_intervals <- interval(targets, targets + days(1))
    within_target <- rep(FALSE, width)
    for (i in 1:width) {
      within_target[i] <- any(lubridate::int_overlaps(
        target_intervals,
        bar_intervals[i]
      ))
    }
  }

  cat(paste0(
    paste0(rep(" ", 4), collapse = ""),
    min_time,
    paste0(rep(" ", width - 7), collapse = ""),
    max_time,
    "\n"
  ))
  cat(paste0(
    paste0(rep(" ", 9), collapse = ""),
    "|",
    paste0(rep(" ", width + 2), collapse = ""),
    "|\n"
  ))

  if (twobar) {
    # Generate bar dates
    coverage_bar <- bar_source[as.numeric(within_coverage) + 1]
    target_bar <- bar_source[as.numeric(within_target) + 1]
    cat(cli::col_green("   Data: "))
    cat("| ")
    cat(paste0(cli::col_green(coverage_bar), collapse = ""))
    cat(" |")
    cat("\n")
    cat(cli::col_red("Targets: "))
    cat("| ")
    cat(paste0(cli::col_red(target_bar), collapse = ""))
    cat(" |")
    cat("\n")
  } else {
    # Onebar mode
    onebar_source <- c(
      chr_incomplete,
      cli::col_green(chr_complete),
      cli::col_red(chr_complete),
      cli::col_blue(chr_complete)
    )
    # Functionally convert bars into a 2 bit bitmap when summed
    # 0 = nothing, 1 = coverage, 2 = target, 3 = both
    coverage_bar_numeric <- as.numeric(within_coverage)
    target_bar_numeric <- as.numeric(within_target) * 2

    final_bar <- coverage_bar_numeric + target_bar_numeric
    cat(paste0(rep(" ", 9), collapse = ""))
    cat("| ")
    cat(paste0(onebar_source[final_bar + 1], collapse = ""))
    cat(" |")
    cat("\n")
    cat(paste0(
      onebar_source[1],
      " = No dates, ",
      onebar_source[2],
      " = Data only, ",
      onebar_source[3],
      " = Target only, ",
      onebar_source[4],
      " = Overlap"
    ))
  }
  cat("\n")
  invisible(NULL)
}
