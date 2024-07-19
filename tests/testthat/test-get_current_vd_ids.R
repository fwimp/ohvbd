test_that("ids returned", {
  out <- get_current_vd_ids(vb_basereq())
  expect_type(out, "double")
  expect_gte(length(out), 1)
})
