skip_on_cran()
skip_on_ci()
# For now just skip unless we're specifically running this test manually.
# To run, execute: options("ohvbd_devmode" = TRUE)
if (!getOption("ohvbd_devmode", default = FALSE)) {
  skip(message = "Not running in ohvbd local test mode.")
}

# Check caching
  # get_default_ohvbd_cache
test_that("Default ohvbd cache location is correctly found", {
  expected_dir <- getOption("ohvbd_cache")
  if (is.null(expected_dir)) {
    expected_dir <- file.path(tempdir(), "ohvbd")
  }
  expected_dir <- gsub("\\\\", "/", expected_dir)
  expect_equal(get_default_ohvbd_cache(), expected_dir)
  expect_equal(get_default_ohvbd_cache("test"), file.path(expected_dir, "test"))
})

# Set up test cache for rest of testing (once we know that the function works)
test_cache <- get_default_ohvbd_cache("test")

  # is_cached
test_that("Cached flag is correctly detected", {
  x <- c(1, 2, 3)
  attr(x, "cached") <- TRUE
  expect_true(is_cached(x))
})

test_that("Data is correctly cached and retrieved", {
  # write_ad_cache
  testdata <- c(1, 2, 3)
  attr(testdata, "gid") <- 0
  attr(testdata, "metric") <- "test"
  testpath <- write_ad_cache(testdata, path = test_cache)
  expect_equal(testpath, file.path(test_cache, paste0("test-0.rda")))
  expect_true(file.exists(testpath))
  rm("testdata")

  # read_ad_cache
  testdata <- read_ad_cache(metric = "test", gid = "0", path = test_cache)
  expect_equal(testdata, c(1, 2, 3), ignore_attr = TRUE) # Must ignore attributes when testing equality
  expect_true(!is.null(attr(testdata, "writetime")))

  # Check file age warning
  # modify writetime and resave, then attempt to load
  attr(testdata, "writetime") <- lubridate::now() - months(7)
  d <- testdata
  save(
    d,
    file = testpath,
    compress = "bzip2",
    compression_level = 9
  )
  rm(list = c("testdata", "d"))
  expect_warning(read_ad_cache(metric = "test", gid = "0", path = test_cache))
})

# Check basic download
test_that("Basic AD download works", {
  temp_0 <- suppressMessages(fetch_ad(metric = "temp", gid = 0, use_cache = TRUE, cache_location = test_cache))
  expect_equal(nrow(temp_0), 256)
})

# Check gadm sf download
test_that("gadm sf download works", {
  gadm_sfs <- suppressMessages(fetch_gadm_sfs(gid = 2, cache_location = test_cache))
  expect_s4_class(gadm_sfs, "SpatVector")
})

# Check glean_ad
test_that("Glean from AD retrieves the correct data", {
  temp_0 <- suppressMessages(fetch_ad(metric = "temp", gid = 0, use_cache = TRUE, cache_location = test_cache))
  base_ncol <- ncol(temp_0)
  base_nrow <- nrow(temp_0)

  one_date_all_locs <- temp_0 |> glean_ad(targetdate = "2020-06-06")
  expect_shape(one_date_all_locs, dim = c(base_nrow, 1))

  all_dates_one_loc <- temp_0 |> glean_ad(places = "Angola")
  expect_shape(all_dates_one_loc, dim = c(1, base_ncol))

  all_dates_two_locs <- temp_0 |> glean_ad(places = c("Angola", "Zimbabwe"))
  expect_shape(all_dates_two_locs, dim = c(2, base_ncol))

  one_date_one_loc <- temp_0 |> glean_ad(targetdate = "2020-06-06", places = "Angola")
  expect_shape(one_date_one_loc, dim = c(1, 1))

  range_date_all_locs <- temp_0 |> glean_ad(targetdate = "2020-06-06", enddate = "2020-06-09")
  expect_shape(range_date_all_locs, dim = c(base_nrow, 3))

  multi_date_all_locs <- temp_0 |> glean_ad(targetdate = c("2020-06-06", "2020-06-09"))
  expect_shape(multi_date_all_locs, dim = c(base_nrow, 2))

  # Check error handling
  fake_vd <- c(1,2,3)
  ohvbd_db(fake_vd) <- "vd"
  expect_error(glean_ad(fake_vd))

  expect_warning(suppressMessages(glean_ad(temp_0, targetdate = "test")))
  expect_warning(suppressMessages(glean_ad(temp_0, targetdate = "2020-06-06", enddate = "test")))
  # Capture output to suppress error bar format
  expect_error(glean_ad(temp_0, targetdate = "2010-06-06", printbars = FALSE))
  expect_error(glean_ad(temp_0, targetdate = "2110-06-06", printbars = FALSE))
  expect_error(glean_ad(temp_0, targetdate = "2010-06-06", enddate = "2012-06-06", printbars = FALSE))
  expect_error(glean_ad(temp_0, targetdate = "2110-06-06", enddate = "2112-06-06", printbars = FALSE))
  expect_error(glean_ad(temp_0, targetdate = c("2010-06-06", "2010-06-07"), printbars = FALSE))
})

# Check assoc_gadm
# Note: this always loads GID2 gadm shapefiles
test_that("GADM codes are correctly associated", {
  lonlatdf <- data.frame(
    Latitude = c(
      53.813727033336384, 50.94133730102917, 41.502614374776414, 37.09584576240546,
      46.190816816324634, 43.40408987260468, 34.02921305111613
    ),
    Longitude = c(
      -1.5631510640531983, 6.95792487354786, -73.96228644647785,
      -2.0967211553577694, 11.135228310071971, 28.148385835241964,
      -84.36091597146886
    ),
    count = c(6, 36, 340, 202, 802, 541, 325)
  )

  assoc_lonlatdf <- suppressMessages(assoc_gadm(lonlatdf, cache_location = test_cache))
  expect_shape(assoc_lonlatdf, dim = c(7, 9))
  # Did all the columns come out correctly (including inputs?)
  expect_equal(
    colnames(assoc_lonlatdf),
    c("Latitude", "Longitude", "count",
      "NAME_0", "NAME_1", "NAME_2",
      "GID_0", "GID_1", "GID_2")
  )
  # If we got the correct GID2 answers, the others should be fine.
  expect_equal(
    assoc_lonlatdf[,"GID_2"],
    c("GBR.1.49_1", "DEU.10.24_1", "USA.33.14_1", "ESP.1.1_1",
      "ITA.17.2_1", "BGR.3.1_1", "USA.11.60_1")
    )
})

# Check assoc_ad
test_that("Areadata is correctly associated", {
  # This test seems to occasionally crash the test suite (because it takes a lot of memory)
  # As such skip unless we're running in devmode
  if (!getOption("ohvbd_devmode", default = FALSE)) {
    skip(message = "Not running in ohvbd local dev mode.")
  }
  lonlatdf <- data.frame(
    Latitude = c(
      53.813727033336384, 50.94133730102917, 41.502614374776414, 37.09584576240546,
      46.190816816324634, 43.40408987260468, 34.02921305111613
    ),
    Longitude = c(
      -1.5631510640531983, 6.95792487354786, -73.96228644647785,
      -2.0967211553577694, 11.135228310071971, 28.148385835241964,
      -84.36091597146886
    ),
    count = c(6, 36, 340, 202, 802, 541, 325)
  )

  temp_0 <- suppressMessages(fetch_ad(metric = "temp", gid = 0, use_cache = TRUE, cache_location = test_cache))
  relhumid_1 <- suppressMessages(fetch_ad(metric = "relhumid", gid = 1, use_cache = TRUE, cache_location = test_cache))
  uv_2 <- suppressMessages(fetch_ad(metric = "uv", gid = 2, use_cache = TRUE, cache_location = test_cache))

  gid0_assoc <- suppressMessages(lonlatdf |> assoc_ad(temp_0, targetdate = c("2020-06-06", "2020-06-09"), cache_location = test_cache))
  gid1_assoc <- suppressMessages(lonlatdf |> assoc_ad(relhumid_1, targetdate = c("2020-06-06", "2020-06-09"), cache_location = test_cache))
  gid2_assoc <- suppressMessages(lonlatdf |> assoc_ad(uv_2, targetdate = c("2020-06-06", "2020-06-09"), cache_location = test_cache))

  # Test shape
  expect_shape(gid0_assoc, dim = c(7, 5))
  expect_shape(gid1_assoc, dim = c(7, 5))
  expect_shape(gid2_assoc, dim = c(7, 5))

  # Test column structure
  expect_equal(colnames(gid0_assoc), c("Latitude", "Longitude", "count", "temp_2020.06.06", "temp_2020.06.09"))
  expect_equal(colnames(gid1_assoc), c("Latitude", "Longitude", "count", "relhumid_2020.06.06", "relhumid_2020.06.09"))
  expect_equal(colnames(gid2_assoc), c("Latitude", "Longitude", "count", "uv_2020.06.06", "uv_2020.06.09"))

  # Test values
  expect_equal(gid0_assoc$temp_2020.06.06, c(
    10.601385116577148, 13.835270881652832, 22.585718154907227, 22.06835174560547,
    20.46324348449707, 22.577526092529297, 22.585718154907227
  ))
  expect_equal(gid1_assoc$relhumid_2020.06.06, c(
    74.00518798828125, 65.86283111572266, 71.74412536621094, 54.274227142333984,
    79.04522705078125, 56.951412200927734, 71.83679962158203
  ))
  expect_equal(gid2_assoc$uv_2020.06.06, c(
    77382.0546875, 99386.7109375, 123628.8671875, 134555.8125, 97607.15625,
    127833.3984375, 108944.4375
  ))
})

# Check cache clear
# This should actually be its own test
if (!getOption("ohvbd_devmode", default = FALSE)) {
  # Clear cache everywhere except when running ohvbd devmode (speeds up dev)
  suppressMessages(clean_ohvbd_cache(subdir = "test", force = TRUE))
}
