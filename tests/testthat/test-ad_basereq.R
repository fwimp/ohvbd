test_that("ad_basereq returns correct url", {
  expect_equal(ad_basereq(), "https://github.com/pearselab/areadata/raw/main/")
})
