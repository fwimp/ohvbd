#' @title Extract data from AREAdata datasets
#' @description Extract the data returned by a call to [get_ad()], filter columns of interest and by dates of interest.
#'
#' Currently this does not handle Population Density or Forecast matrices, however the other 5 metrics are handled natively.
#' @author Francis Windram
#'
#' @param ad_matrix a matrix of data from AREAdata.
#' @param targetdate either: The date to search for in ISO 8601 (e.g. "2020", "2021-09", or "2022-09-21"). OR the start date for a range of dates.
#' @param enddate The (exclusive) end of the range of dates to search for. If this is unfilled, only the `targetdate` is searched for.
#' @param places A character vector or single string describing what locality to search for in the dataset.
#' @param gid the spatial scale of the AREAdata matrix (this is not needed if the matrix has been supplied by [get_ad()]).
#'
#' @return A matrix containing the extracted data.
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
#' So "2020-04" will internally become "2020-04-01"
#'
#' If an incomplete date is specified as the `targetdate` and no `enddate` is specified, the range to search is inferred from the minimum temporal scale provided in `targetdate`.
#'
#' For example "2020-04" will be taken to mean the month of April in 2020, and the `enddate` will internally be set to "2020-05-01".
#'
#' @examples
#' \dontrun{
#' ad_basereq() %>%
#'   get_ad("temp", gid=0) %>%
#'   extract_ad_data("2022-08-04", "2022-08-06",
#'                   places=c("Albania", "Thailand"))
#' }
#'
#' @export
#'

extract_ad_data <-
function(ad_matrix, targetdate=NA, enddate=NA, places=NA, gid=NA){
  # Enddate SHOULD BE EXCLUSIVE

  # try to infer gid from ad_matrix
  # This will allow us to automagically fill or filter by countries even when we only have GID codes.
  if (is.na(gid)){
    pot_gid <- attr(ad_matrix, "gid")
    if (!is.null(pot_gid)){gid <- pot_gid}
  }

  metric <- attr(ad_matrix, "metric")
  if (metric == "popdens"){
    warning("Dataset appears to be Population Density! This does not need extracting.")
    return(ad_matrix)
  } else if (metric == "popdens"){
    warning("Dataset appears to be a Forecast! This is not currently processed by the extractor.")
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

  if (!is.na(targetdate)){
    # Search by date
    present_dates <- as.Date(colnames(ad_matrix))
    filter_date <- TRUE

    # Try to make targetdate into a date
    suppressWarnings(targetdate_final <- as_date(targetdate))
    if (is.na(targetdate_final)){
      # Maybe it's a YYYY-MM
      suppressWarnings(targetdate_final <- as_date(paste0(targetdate, "-01")))
      date_filterlevel <- "months"
      if (is.na(targetdate_final)){
        # Maybe it's a YYYY
        suppressWarnings(targetdate_final <- as_date(paste0(targetdate, "-01-01")))
        date_filterlevel <- "years"
        if (is.na(targetdate_final)){
          # Dunno, stop filtering date
          filter_date <- FALSE
          warning(paste0('Could not make "', targetdate, '" into a usable date.\n  Try ISO 8601 yyyy-mm-dd format.\nNot filtering date.'))
        }
      }
    }
  }
  if (filter_date == TRUE){
    if (!is.na(enddate)){
      # Try to make enddate into a date
      suppressWarnings(enddate_final <- as_date(enddate))
      if (is.na(enddate_final)){
        # Maybe it's a YYYY-MM
        suppressWarnings(enddate_final <- as_date(paste0(enddate, "-01")))
        if (is.na(enddate_final)){
          # Maybe it's a YYYY
          suppressWarnings(enddate_final <- as_date(paste0(enddate, "-01-01")))
          if (is.na(enddate_final)){
            # Dunno, infer enddate
            infer_enddate <- TRUE
            warning(paste0('Could not make "', enddate, '" into a usable date.\n  Try ISO 8601 yyyy-mm-dd format.\nInferring end date from targetdate.'))
          }
        }
      }
    } else {
      # If enddate is NA, infer it.
      infer_enddate <- TRUE
    }

    if (infer_enddate == TRUE){
      # Infer enddate at the resolution of the date provided
      enddate_final <- targetdate_final + period(1, units=date_filterlevel)
    }
    # Convert enddate to inclusive spec
    enddate_final <- enddate_final - days(1)
    # Actually find the columns
    selected_cols <- which(present_dates %within% interval(targetdate_final, enddate_final))
  }

  if (!any(is.na(places))){
    if (!all(places %in% rownames(ad_matrix))){
      # If any listed places are not in df
      # Try to convert places to equivalents in the correct GID system
      if(!is.na(gid)){
        places <- convert_place_togid(places, gid)
      }
    }
    selected_rows <- places[which(places %in% rownames(ad_matrix))]
  }

  return(ad_matrix[selected_rows, selected_cols])
}
