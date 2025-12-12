#' @title Match species names to their GBIF backbone ids
#'
#' @description
#'
#' Match species names to their GBIF backbone ids using [rgbif::name_backbone_checklist()].
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
#' @concept convenience
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

#' @title Match country names to their equivalent naturalearth WKT polygons
#'
#' @description
#' Match country names to their equivalent naturalearth WKT polygons using [rnaturalearth::ne_countries()].
#'
#'
#' @author Francis Windram
#'
#' @param countrynames a vector of country names to match to naturalearth.
#' @param returnmulti return the GBIF taxon ids only (otherwise return the full lookup dataframe).
#' @param onlywkt only return location_wkt (see note for more details).
#'
#' @returns A list containing:
#' - `$location_wkt`: a multipolygon containing all locations (or a named vector of individual country polygons).
#' - `$missing_locs`: any provided countries not found in naturalearth.
#' - `$found_locs`: any provided countries that were found in naturalearth.
#'
#' @concept convenience
#'
#' @export
#'
#' @examples
#' match_countries(c("United Kingdom", "Germany"))
#'
match_countries <- function(countrynames, returnmulti = TRUE, onlywkt = FALSE) {
  rlang::check_installed("rnaturalearth")

  location_out <- tryCatch(expr = {
    # Get countries from naturalearth and convert to a spatvect
    world <- rnaturalearth::ne_countries(country = countrynames)
    lookup_countries <- terra::vect(world)
    # Find missing locations
    missing_locs <- setdiff(countrynames, lookup_countries$sovereignt)
    # Format location_wkt for return
    if (returnmulti) {
      location_wkt <- spatvect_to_multipolygon(lookup_countries)
    } else {
      location_wkt <- terra::geom(lookup_countries, wkt = TRUE)
      names(location_wkt) <- lookup_countries$sovereignt
    }
    list(location_wkt = location_wkt, missing_locs = missing_locs, found_locs = lookup_countries$sovereignt)
  }, error = \(e) {
    cli::cli_alert_danger(cli::col_red("Could not resolve any locations!"))
    list(location_wkt = NULL, missing_locs = countrynames, found_locs = NULL)
  })

  if (onlywkt) {
    return(location_out$location_wkt)
  } else {
    return(location_out)
  }
}
