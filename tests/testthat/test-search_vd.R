test_that("search_vd creates correct request", {
  withr::with_options(
    list(ohvbd_dryrun = TRUE),
    expect_equal(
      suppressMessages(search_vd("Ixodes ricinus"))[["url"]],
      "https://vectorbyte.crc.nd.edu/portal/api/vecdynbyprovider?format=json&keywords=Ixodes%20ricinus"
    )
  )
})

test_that("search_vd returns a correctly parsed and formatted ohvbd.ids object", {
  vcr::local_cassette("search_vd")
  searchout <- search_vd("atropalpus")
  expect_s3_class(searchout, "ohvbd.ids")
  expect_true(is_from(searchout, "vd"))
})
