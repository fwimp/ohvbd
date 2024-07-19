test_that("ids returned", {
  out <- get_current_vd_ids(basereq = vb_basereq(unsafe = TRUE))
  expect_type(out, "double")
  expect_gte(length(out), 1)
})
