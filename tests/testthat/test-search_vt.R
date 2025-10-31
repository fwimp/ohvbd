test_that("search_vt creates correct request", {
  withr::with_options(
    list(ohvbd_dryrun = TRUE),
    expect_equal(
      suppressMessages(search_vt("Ixodes ricinus"))[["url"]],
      "https://vectorbyte.crc.nd.edu/portal/api/vectraits-explorer?format=json&keywords=Ixodes%20ricinus"
      )
  )
})

test_that("search_vt returns a correctly parsed and formatted ohvbd.ids object", {
  vcr::local_cassette("search_vt")
  searchout <- search_vt("atropalpus")
  expect_s3_class(searchout, "ohvbd.ids")
  expect_true(is_from(searchout, "vt"))
})
