#' @title Generate a vectraits template from a short set of survey responses
#'
#' @description Given the large number of fields in vectraits it can be hard to
#'   know which of these you need to fill out. This generator asks a series of
#'   questions to determine what columns should be included in one's dataset.
#' @author Francis Windram
#'
#' @return A character vector containing the column headers of the desired vectraits template or NULL.
#'
#' @examplesIf interactive()
#'
#' generate_vt_template()
#'
#' @concept vectraits
#'
#' @export

generate_vt_template <- function() {
  if (!interactive()) {
    cli::cli_warn(c("!" = "VecTraits template generator is an interactive function meant to be used from the command line.", "i" = "Please run in an interactive session."))
    return(invisible())
  }
  # A more robust approach would be to evaluate the json at https://vectorbyte.crc.nd.edu/portal/api/vectraits-columns/
  # This could then be used to evaluate what is a required field
  required <- c(
    "Citation",
    "ContributorEmail",
    "EmbargoRelease",
    "Location",
    "LocationDatePrecision",
    "OriginalID",
    "OriginalTraitUnit",
    "OriginalTraitValue",
    "Published",
    "SubmittedBy"
  )
  fieldids <- c("IndividualID", "OriginalID", "OriginalTraitName",
                "OriginalTraitDef", "StandardisedTraitName", "StandardisedTraitDef",
                "OriginalTraitValue", "OriginalTraitUnit", "OriginalErrorPos",
                "OriginalErrorNeg", "OriginalErrorUnit", "StandardisedTraitValue",
                "StandardisedTraitUnit", "StandardisedErrorPos", "StandardisedErrorNeg",
                "StandardisedErrorUnit", "Replicates", "Habitat", "LabField",
                "ArenaValue", "ArenaUnit", "ArenaValueSI", "ArenaUnitSI", "AmbientTemp",
                "AmbientTempMethod", "AmbientTempUnit", "AmbientLight", "AmbientLightUnit",
                "SecondStressor", "SecondStressorDef", "SecondStressorValue",
                "SecondStressorUnit", "TimeStart", "TimeEnd", "TotalObsTimeValue",
                "TotalObsTimeUnit", "TotalObsTimeValueSI", "TotalObsTimeUnitSI",
                "TotalObsTimeNotes", "ResRepValue", "ResRepUnit", "ResRepValueSI",
                "ResRepUnitSI", "Location", "LocationType", "OriginalLocationDate",
                "LocationDate", "LocationDatePrecision", "CoordinateType", "Latitude",
                "Longitude", "Interactor1", "Interactor1Common", "Interactor1Wholepart",
                "Interactor1WholePartType", "Interactor1Number", "Interactor1Kingdom",
                "Interactor1Phylum", "Interactor1Class", "Interactor1Order",
                "Interactor1Family", "Interactor1Genus", "Interactor1Species",
                "Interactor1Stage", "Interactor1Sex", "Interactor1Temp", "Interactor1TempUnit",
                "Interactor1TempMethod", "Interactor1GrowthTemp", "Interactor1GrowthTempUnit",
                "Interactor1GrowthDur", "Interactor1GrowthdDurUnit", "Interactor1GrowthType",
                "Interactor1Acc", "Interactor1AccTemp", "Interactor1AccTempNotes",
                "Interactor1AccTime", "Interactor1AccTimeNotes", "Interactor1AccTimeUnit",
                "Interactor1OrigTemp", "Interactor1OrigTempNotes", "Interactor1OrigTime",
                "Interactor1OrigTimeNotes", "Interactor1OrigTimeUnit", "Interactor1EquilibTimeValue",
                "Interactor1EquilibTimeUnit", "Interactor1Size", "Interactor1SizeUnit",
                "Interactor1SizeType", "Interactor1SizeSI", "Interactor1SizeUnitSI",
                "Interactor1DenValue", "Interactor1DenUnit", "Interactor1DenTypeSI",
                "Interactor1DenValueSI", "Interactor1DenUnitSI", "Interactor1MassValueSI",
                "Interactor1MassUnitSI", "Interactor2", "Interactor2Common",
                "Interactor2Kingdom", "Interactor2Phylum", "Interactor2Class",
                "Interactor2Order", "Interactor2Family", "Interactor2Genus",
                "Interactor2Species", "Interactor2Stage", "Interactor2Sex", "Interactor2Temp",
                "Interactor2TempUnit", "Interactor2TempMethod", "Interactor2GrowthTemp",
                "Interactor2GrowthTempUnit", "Interactor2GrowthDur", "Interactor2GrowthDurUnit",
                "Interactor2GrowthType", "Interactor2Acc", "Interactor2AccTemp",
                "Interactor2AccTempNotes", "Interactor2AccTime", "Interactor2AccTimeNotes",
                "Interactor2AccTimeUnit", "Interactor2OrigTemp", "Interactor2OrigTempNotes",
                "Interactor2OrigTime", "Interactor2OrigTimeNotes", "Interactor2OrigTimeUnit",
                "Interactor2EquilibTimeValue", "Interactor2EquilibTimeUnit",
                "Interactor2Size", "Interactor2SizeUnit", "Interactor2SizeType",
                "Interactor2SizeSI", "Interactor2SizeUnitSI", "Interactor2DenValue",
                "Interactor2DenUnit", "Interactor2DenTypeSI", "Interactor2DenValueSI",
                "Interactor2DenUnitSI", "Interactor2MassValueSI", "Interactor2MassUnitSI",
                "PhysicalProcess", "PhysicalProcess_1", "PhysicalProcess_2",
                "FigureTable", "Citation", "CuratedByCitation", "CuratedByDOI",
                "DOI", "SubmittedBy", "ContributorEmail", "Notes", "EmbargoRelease")
  outids <- fieldids

  cat("This builder is designed to help you create a customised vectraits template for upload.\n")
  cat("If you do not know the answer, it is best to select Yes (or 1).\n")
  cat("Enter 0 to exit.\n")

  cat(cli::col_blue("\nQuestion 1: Do you have more than ", cli::col_yellow(cli::style_bold("1")), " interactor?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Interactor2", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 2: Do you have a ", cli::col_yellow(cli::style_bold("temperature")), " component?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Temp", outids, fixed = TRUE)))]
    outids <- outids[which(!(!(outids %in% required) & grepl("OrigTime", outids, fixed = TRUE)))]
    outids <- outids[which(!(!(outids %in% required) & grepl("EquilibTime", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 3: Have you ", cli::col_yellow(cli::style_bold("re-standardised")), " the data?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Standardised", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 4: Are there any ", cli::col_yellow(cli::style_bold("extra stressors")), "?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("SecondStressor", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 5: Did you measure ", cli::col_yellow(cli::style_bold("ambient light")), "?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("AmbientLight", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 6: Do you have ", cli::col_yellow(cli::style_bold("exact")), " location data?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & outids %in% c("Latitude", "Longitude")))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 7: Did you measure ", cli::col_yellow(cli::style_bold("interactor masses")), "?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Mass", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 8: Did you measure ", cli::col_yellow(cli::style_bold("interactor density")), "?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Den", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 9: Did you measure ", cli::col_yellow(cli::style_bold("interactor growth")), "?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Growth", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 10: Did you ", cli::col_yellow(cli::style_bold("acclimate")), " individuals to different temperatures prior to study?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Acc", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 11: Did you ", cli::col_yellow(cli::style_bold("replace")), " resources or interactors during the experiment?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("ResRep", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 12: Did you take temperature observations ", cli::col_yellow(cli::style_bold("instantaneously")), " or for a ", cli::col_yellow(cli::style_bold("fixed time")), " during the experiment?\n"))
  ans <- utils::menu(c("Fixed", "Instantaneous"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("TotalObsTime", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  cat(cli::col_blue("\nQuestion 13: Did you measure the ", cli::col_yellow(cli::style_bold("size")), " of the arena for the experiment?\n"))
  ans <- utils::menu(c("Yes", "No"))
  if (ans > 1) {
    outids <- outids[which(!(!(outids %in% required) & grepl("Arena", outids, fixed = TRUE)))]
  } else if (ans == 0) {
    return(outids)
  }

  return(outids)
}
