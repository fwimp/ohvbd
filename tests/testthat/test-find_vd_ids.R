test_that("find_vd_ids returns sensible ids", {
  vcr::local_cassette("find_vd_ids")
  out <- find_vd_ids()
  expect_s3_class(out, "ohvbd.ids")
  expect_equal(attr(out, "db"), "vd")
})
