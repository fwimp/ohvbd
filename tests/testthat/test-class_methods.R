test_that("db field checking methods correctly detect a set db", {
  x <- c(1,2,3)
  attr(x, "db") <- "vt"  # Set db manually for testing
  expect_true(has_db(x))
  expect_true(is_from(x, "vt"))
  expect_false(is_from(x, "vd"))
  expect_equal(ohvbd_db(x), "vt")
})

test_that("db field checking methods correctly detect an unset db", {
  x <- c(1,2,3)
  expect_false(has_db(x))
  expect_false(is_from(x, "vt"))
  expect_null(ohvbd_db(x))
})

test_that("db field setting correctly sets db", {
  x <- c(1,2,3)
  ohvbd_db(x) <- "vt"
  expect_true(has_db(x))
  expect_true(is_from(x, "vt"))
  expect_equal(ohvbd_db(x), "vt")
})

test_that("ohvbd.ids indexing creates an ohvbd.ids object", {
  expect_s3_class(ohvbd.ids(c(1, 2, 3), db = "vt")[1], "ohvbd.ids")
})

test_that("All S3 print/summary methods create output", {
  expect_output(print(ohvbd.ids(c(1, 2, 3), "vt")))
  expect_output(print(new_ohvbd.data.frame(
    data.frame(x = c(1, 2, 3), y = c(4, 5, 6)),
    "vt"
  )))
  expect_output(print(new_ohvbd.ad.matrix(
    matrix(c(1, 2, 3, 4, 5, 6), nrow = 2),
    gid = 2,
    metric = "temp",
    cached = TRUE,
    db = "vt"
  )))
  expect_output(print(new_ohvbd.hub.search(
    list(list(
      id = "test_id",
      title = "test_title",
      doi = "test_doi",
      type = "test_type",
      citation = "test_cite",
      db = "vd"
    )),
    query = "test",
    searchparams = list()
  )))
  expect_output(summary(new_ohvbd.hub.search(
    list(list(
      id = "test_id",
      title = "test_title",
      doi = "test_doi",
      type = "test_type",
      citation = "test_cite",
      db = "vd"
    )),
    query = "test",
    searchparams = list()
  )))
})

# TODO: Test fetch

# TODO: Test glean
