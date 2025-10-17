test_that("search_vd works", {
  vcr::local_cassette("search_vd")
  searchout <- search_vd("atropalpus")
  expect_s3_class(searchout, "ohvbd.ids")
  expect_equal(attr(searchout, "db"), "vd")
})
