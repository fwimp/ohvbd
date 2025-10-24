test_that("find_vt_ids returns sensible ids", {
  vcr::local_cassette("find_vt_ids")
  out <- find_vt_ids()
  expect_s3_class(out, "ohvbd.ids")
  expect_true(is_from(out, "vt"))
})
