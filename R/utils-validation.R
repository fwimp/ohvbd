#' @title Tee a pipeline to extract the data at a given point
#'
#' @description
#' Add a tee to a pipeline to get the data coming in through the pipe.
#'
#' @author Francis Windram
#'
#' @param speciesnames a vector of species names to match to the GBIF backbone.
#' @param exact whether to only return exact *species* matches.
#' @param returnids return the GBIF taxon ids only (otherwise return the full lookup dataframe).
#' @param omit omit missing taxon ids (inactive when `returnids = FALSE`).
#'
#' @note
#' If `exact = TRUE` and you search for a genus name, this will not be returned.
#' If you want more control over id filtering, use `returnids = FALSE` to get the source dataframe.
#'
#' @returns The GBIF taxonids associated with `speciesnames` or the full GBIF lookup dataframe if `returnids = TRUE`.
#'
#' @export
#'
#' @examples
#' match_species(c("Araneus diadematus", "Aedes aegypti"))
#'
match_species <- function(speciesnames, exact = FALSE, returnids = TRUE, omit = TRUE) {
  rlang::check_installed("rgbif")
  # TODO: Possibly filter based on confidence?
  matched_names <- rgbif::name_backbone_checklist(speciesnames)

  # Detect if all missing
  if (all(matched_names$matchType == "NONE")) {
    cli::cli_alert_danger(cli::col_red("Could not resolve any species!"))
    taxonids <- as.numeric(rlang::rep_along(speciesnames, NA))
    names(taxonids) <- speciesnames
  } else {
    # If not, get the usagekey column
    taxonids <- matched_names$usageKey

    # If in exact mode, replace anything that's not "EXACT" based upon the matchType column with NA.
    if (exact) {
      taxonids[which(matched_names$matchType != "EXACT")] <- NA
    }

    # Add the input names as the names of the vector
    names(taxonids) <- speciesnames
  }

  if (!returnids) {
    return(matched_names)
  }

  # Filter any NAs if required.
  if (omit) {
    taxonids <- taxonids[which(!is.na(taxonids))]
  }
  return(taxonids)
}
