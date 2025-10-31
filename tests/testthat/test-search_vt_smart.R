test_that("search_vt_smart creates correct requests", {
  withr::local_options(list(ohvbd_dryrun = TRUE))
  expect_equal(
    suppressMessages(search_vt_smart("Interactor1Genus", "contains", "Ixodes"))[["url"]],
    "https://vectorbyte.crc.nd.edu/portal/api/vectraits-explorer?format=json&field=Interactor1Genus&operator=contains&term=Ixodes"
  )
})

test_that("search_vt_smart handles malformed requests", {
  withr::local_options(list(ohvbd_dryrun = TRUE))
  expect_error(
    suppressMessages(search_vt_smart("nonexistentfield", "contains", "Ixodes"))
  )

  expect_snapshot(search_vt_smart("Interactor1Genus", "nonexistent", "Ixodes"))

})

test_that("search_vt_smart returns a correctly parsed and formatted ohvbd.ids object", {
  vcr::local_cassette("search_vt_smart")
  searchout <- search_vt_smart("Interactor1Species", "contains", "atropalpus")
  expect_s3_class(searchout, "ohvbd.ids")
  expect_true(is_from(searchout, "vt"))
})
