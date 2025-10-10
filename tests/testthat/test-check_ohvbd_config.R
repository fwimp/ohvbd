test_that("configuration changes are correctly detected", {
  withr::with_options(
    list(ohvbd_compat = NULL),
    expect_false(suppressMessages(check_ohvbd_config()))
  )
  withr::with_options(
    list(ohvbd_compat = TRUE),
    expect_true(suppressMessages(check_ohvbd_config()))
  )
  withr::with_options(
    list(ohvbd_compat = FALSE),
    expect_true(suppressMessages(check_ohvbd_config()))
  )
  withr::with_options(
    list(tmp_test_option = TRUE),
    expect_true(suppressMessages(check_ohvbd_config("tmp_test_option")))
  )
})
