test_that("search_vt works", {
  vcr::local_cassette("search_vt")
  searchout <- search_vt("atropalpus")
  expect_s3_class(searchout, "ohvbd.ids")
  expect_true(is_from(searchout, "vt"))
})
