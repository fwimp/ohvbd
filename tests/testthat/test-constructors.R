test_that("ohvbd.ids creates an ohvbd.ids object", {
  expect_s3_class(ohvbd.ids(c(1, 2, 3), db = "vt"), "ohvbd.ids")
})

test_that("ohvbd.ids correctly handles all supported databases", {
  expect_no_error(ohvbd.ids(c(1, 2, 3), db = "vt"))
  expect_no_error(ohvbd.ids(c(1, 2, 3), db = "vd"))
  expect_no_error(ohvbd.ids(
    c("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc"),
    db = "gbif"
  ))
})

test_that("ohvbd.ids correctly errors on non-numeric input", {
  expect_error(ohvbd.ids(c("dbc4a3ae-680f-44e6-ab25-c70e27b38dbc"), db = "vt"))
})
