test_that("check_db_status correctly parses output", {
  vcr::local_cassette("check_db_status", record = "all")
  expect_snapshot(check_db_status())
  expect_true(suppressMessages(check_db_status()))
})
