test_that("vb_basereq defaults work", {
  br <- vb_basereq()
  expect_s3_class(br, "httr2_request")
  expect_equal(br$url, "https://vectorbyte.crc.nd.edu/portal/api/")
  expect_equal(br$options$useragent, "ROHVBD")
})

test_that("vb_basereq arguments work", {
  br <- vb_basereq("url", "agent")
  expect_equal(br$url, "url")
  expect_equal(br$options$useragent, "agent")
})

test_that("vb_basereq ssl verification switch works", {
  expect_equal(vb_basereq()$options$ssl_verifypeer, NULL)
  expect_equal(vb_basereq(unsafe = TRUE)$options$ssl_verifypeer, 0)
})
