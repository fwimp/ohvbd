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
