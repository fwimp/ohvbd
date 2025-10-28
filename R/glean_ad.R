#' @title Extract data from AREAdata datasets
#' @description Extract the data returned by a call to [fetch_ad()], filter columns of interest and by dates of interest.
#'
#' Currently this does not handle Population Density or Forecast matrices, however the other 5 metrics are handled natively.
#' @author Francis Windram
#'
#' @param ad_matrix A matrix or `ohvbd.ad.matrix` of data from AREAdata.
#' @param targetdate **ONE OF** the following:
#' * The date to search for in ISO 8601 (e.g. "2020", "2021-09", or "2022-09-21").
#' * The start date for a range of dates.
#' * A character vector of fully specified dates to search for (i.e. "yyyy-mm-dd")
#' @param enddate The (exclusive) end of the range of dates to search for. If this is unfilled, only the `targetdate` is searched for.
#' @param places A character vector or single string describing what locality to search for in the dataset.
#' @param gid The spatial scale of the AREAdata matrix (this is not needed if the matrix has been supplied by [fetch_ad()]).
#'
#' @return An `ohvbd.ad.matrix` or a named vector containing the extracted data.
#'
#' @section Place matching:
#' This function attempts to intelligently infer place selections based upon the provided gid and place names.
#'
#' So if you have an AREAdata dataset at `gid=1`, and provide country names, the function will attempt to match those country names and retrieve any GID1-level data that is present.
#'
#' Occasionally (such as in the case of "Albania", the municipality in La Guajira, Columbia) the name of a place may occur in locations other than those expected by the researcher.
#'
#' Unfortunately this is not an easy problem to mitigate, and as such it is worthwhile checking the output of this function to make sure it is as you expect.
#'
#' @section Date ranges:
#' The date range is a partially open interval. That is to say the lower bound (`targetdate`) is inclusive, but the upper bound (`enddate`) is exclusive.
#'
#' For example a date range of "2020-08-04" - "2020-08-12" will return the 7 days from the 4th through to the 11th of August, but *not* the 12th.
#'
#' @section Date inference:
#'
#' In cases where a full date is not provided, the earliest date possible with the available data is chosen.
#'
#' So "2020-04" will internally become "2020-04-01".
#'
#' If an incomplete date is specified as the `targetdate` and no `enddate` is specified, the range to search is inferred from the minimum temporal scale provided in `targetdate`.
#'
#' For example "2020-04" will be taken to mean the month of April in 2020, and the `enddate` will internally be set to "2020-05-01".
#'
#' @examplesIf interactive()
#' # All dates in August 2022
#' fetch_ad("temp", gid=0) |>
#'   glean_ad(
#'     targetdate = "2022-08",
#'     places = c("Albania", "Thailand")
#'   )
#'
#' # 4th, 5th, and 6th of August 2022 (remember the enddate is EXCLUSIVE)
#' fetch_ad("temp", gid=0) |>
#'   glean_ad(
#'     targetdate = "2022-08-04", enddate="2022-08-07",
#'     places = c("Albania", "Thailand")
#'   )
#'
#' # 4th of August 2022 and 1st of August 2023
#' fetch_ad("temp", gid=0) |>
#'   glean_ad(
#'     targetdate = c("2022-08-04", "2023-08-01"),
#'     places = c("Albania", "Thailand")
#'   )
#'
#' @concept areadata
#'
#' @export
#'

glean_ad <- function(
  ad_matrix,
  targetdate = NA,
  enddate = NA,
  places = NA,
  gid = NA
) {
  # Enddate SHOULD BE EXCLUSIVE

  if (!has_db(ad_matrix)) {
    cli::cli_alert_warning("Data not necessarily from AREAdata.")
  } else if (!is_from(ad_matrix, "ad")) {
    cli::cli_abort(c(
      "x" = "Data not from AREAdata, Please use the appropriate {.fn glean_{ohvbd_db(ad_matrix)}} function.",
      "!" = "Detected database = {.val {ohvbd_db(ad_matrix)}}"
    ))
  }

  # try to infer gid from ad_matrix
  # This will allow us to automagically fill or filter by countries even when we only have GID codes.
  if (is.na(gid)) {
    pot_gid <- attr(ad_matrix, "gid")
    if (!is.null(pot_gid)) {
      gid <- pot_gid
    }
  }

  metric <- attr(ad_matrix, "metric")
  if (metric == "popdens") {
    cli::cli_alert_warning(
      "Dataset appears to be Population Density! This does not need extracting."
    )
    return(ad_matrix)
  } else if (metric == "forecast") {
    cli::cli_alert_warning(
      "Dataset appears to be a Forecast! This is not currently processed by the extractor."
    )
    return(ad_matrix)
  }

  filter_date <- FALSE
  infer_enddate <- FALSE
  targetdate_final <- NA
  enddate_final <- NA
  date_filterlevel <- "days"
  selected_cols <- seq_len(ncol(ad_matrix))
  selected_rows <- seq_len(nrow(ad_matrix))

  # All this is just trying to intelligently process possible date searches

  if (!any(is.na(targetdate))) {
    # Search by date
    present_dates <- as.Date(colnames(ad_matrix))
    filter_date <- TRUE

    # Try to make targetdate into a date
    suppressWarnings(targetdate_final <- as_date(targetdate))
    if (any(is.na(targetdate_final))) {
      # Maybe it's a YYYY-MM
      suppressWarnings(targetdate_final <- as_date(paste0(targetdate, "-01")))
      date_filterlevel <- "months"
      if (any(is.na(targetdate_final))) {
        # Maybe it's a YYYY
        suppressWarnings(
          targetdate_final <- as_date(paste0(targetdate, "-01-01"))
        )
        date_filterlevel <- "years"
        if (any(is.na(targetdate_final))) {
          # Dunno, stop filtering date
          filter_date <- FALSE
          cli::cli_alert_warning(
            "Could not make {.val {targetdate}} into a usable date."
          )
          cli::cli_alert_warning("Not filtering by date.")
          cli::cli_alert_info("Try ISO 8601 {.val yyyy-mm-dd} format")
        }
      }
    }
  }
  if (filter_date == TRUE) {
    if (length(targetdate) <= 1) {
      if (!is.na(enddate)) {
        # Try to make enddate into a date
        suppressWarnings(enddate_final <- as_date(enddate))
        if (is.na(enddate_final)) {
          # Maybe it's a YYYY-MM
          suppressWarnings(enddate_final <- as_date(paste0(enddate, "-01")))
          if (is.na(enddate_final)) {
            # Maybe it's a YYYY
            suppressWarnings(
              enddate_final <- as_date(paste0(enddate, "-01-01"))
            )
            if (is.na(enddate_final)) {
              # Dunno, infer enddate
              infer_enddate <- TRUE
              cli::cli_alert_warning(
                "Could not make {.val targetdate} into a usable date."
              )
              cli::cli_alert_warning("Inferring end date from {.arg targetdate}.")
              cli::cli_alert_info("Try ISO 8601 {.val yyyy-mm-dd} format")
            }
          }
        }
      } else {
        # If enddate is NA, infer it.
        infer_enddate <- TRUE
      }

      if (infer_enddate == TRUE) {
        # Infer enddate at the resolution of the date provided
        enddate_final <- targetdate_final + period(1, units = date_filterlevel)
      }
      # Convert enddate to inclusive spec
      enddate_final <- enddate_final - days(1)

      # Actually find the columns
      selected_cols <- which(
        present_dates %within% interval(targetdate_final, enddate_final)
      )

      if (length(selected_cols) <= 0) {
        if (targetdate_final == enddate_final) {
          format_time_overlap_bar(
            min(present_dates),
            max(present_dates),
            targetdate_final,
            targetrange = FALSE,
            twobar = TRUE
          )
          cli::cli_abort(c(
            "x" = "Date {.val {targetdate_final}} outside of data range {.val {min(present_dates)}} -> {.val {max(present_dates)}}!"
          ))
        } else {
          format_time_overlap_bar(
            min(present_dates),
            max(present_dates),
            c(targetdate_final, enddate_final),
            targetrange = TRUE,
            twobar = TRUE
          )
          cli::cli_abort(c(
            "x" = "Inclusive interval {.val {targetdate_final}} -> {.val {enddate_final}} outside of data range {.val {min(present_dates)}} -> {.val {max(present_dates)}}!"
          ))
        }
      }
    } else {
      if (date_filterlevel == "days") {
        # If it's a vector of dates then just check if they're present
        selected_cols <- which(present_dates %in% targetdate_final)
        # Check if anything was selected. If not then throw error as none of the selected cols are in the AD data
        if (length(selected_cols) <= 0) {
          format_time_overlap_bar(
            min(present_dates),
            max(present_dates),
            targetdate_final,
            targetrange = FALSE,
            twobar = TRUE
          )
          cli::cli_abort(c(
            "x" = "Dates {.val {targetdate_final}} entirely outside of data range {.val {min(present_dates)}} -> {.val {max(present_dates)}}!"
          ))
        }
      } else {
        cli::cli_abort(c(
          "x" = "Incomplete dates in {.arg targetdate} vector: {.val {targetdate}}"
        ))
      }
    }
  }

  if (!any(is.na(places))) {
    # Convert places to underscore format
    places <- gsub(" ", "_", places)
    if (!all(places %in% rownames(ad_matrix))) {
      # If any listed places are not in df
      # Try to convert places to equivalents in the correct GID system
      if (!is.na(gid)) {
        places <- convert_place_togid(places, gid)
      }
    }
    selected_rows <- places[which(places %in% rownames(ad_matrix))]
  }

  outmat <- ad_matrix[selected_rows, selected_cols]
  if (inherits(outmat, "matrix")) {
    outmat <- new_ohvbd.ad.matrix(
      m = outmat,
      metric = metric,
      gid = gid,
      cached = attr(ad_matrix, "cached"),
      db = "ad"
    )
  } else {
    ohvbd_db(outmat) <- "ad"
  }
  return(outmat)
}
