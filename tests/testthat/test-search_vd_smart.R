test_that("search_vd_smart creates correct requests", {
  withr::local_options(list(ohvbd_dryrun = TRUE))
  expect_equal(
    suppressMessages(search_vd_smart("SpeciesName", "contains", "ricinus"))[["url"]],
    "https://vectorbyte.crc.nd.edu/portal/api/vecdynbyprovider?format=json&field=SpeciesName&operator=contains&term=ricinus"
  )
})

test_that("search_vd_smart handles malformed requests", {
  withr::local_options(list(ohvbd_dryrun = TRUE))
  expect_error(
    suppressMessages(search_vd_smart("nonexistentfield", "contains", "ricinus"))
  )

  expect_snapshot(search_vd_smart("SpeciesName", "nonexistent", "ricinus"))

})

test_that("search_vd_smart returns a correctly parsed and formatted ohvbd.ids object", {
  vcr::local_cassette("search_vd_smart")
  searchout <- search_vd_smart("SpeciesName", "contains", "ricinus")
  expect_s3_class(searchout, "ohvbd.ids")
  expect_true(is_from(searchout, "vd"))
})
