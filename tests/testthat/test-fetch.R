test_that("fetch_vt returns vt ohvbd.responses object", {
  vcr::local_cassette("fetch_vt")
  out <- suppressMessages(ohvbd.ids(1, "vt") |> fetch_vt())
  expect_s3_class(out, "ohvbd.responses")
  expect_true(is_from(out, "vt"))
})

test_that("fetch_vd returns vd ohvbd.responses object", {
  vcr::local_cassette("fetch_vd")
  out <- suppressMessages(ohvbd.ids(364, "vd") |> fetch_vd())
  expect_s3_class(out, "ohvbd.responses")
  expect_true(is_from(out, "vd"))
})

test_that("fetch generic route correctly dispatches", {
  suppressMessages(
    out_vt <- {
      vcr::local_cassette("fetch_vt")
      ohvbd.ids(1, "vt") |> fetch()
    }
  )
  suppressMessages(
    out_vd <- {
      vcr::local_cassette("fetch_vd")
      ohvbd.ids(364, "vd") |> fetch()
    }
  )

  expect_true(is_from(out_vt, "vt"))
  expect_true(is_from(out_vd, "vd"))
})

test_that("fetch_* functions reject incompatible ids", {
  expect_error(
    suppressMessages({
      out_vt <- {
        vcr::local_cassette("fetch_vt") # Just in case the test fails, will still pull from vcr
        ohvbd.ids(1, "vd") |> fetch_vt()
      }
    })
  )

  expect_error(
    suppressMessages({
      out_vt <- {
        vcr::local_cassette("fetch_vd") # Just in case the test fails, will still pull from vcr
        ohvbd.ids(1, "vt") |> fetch_vd()
      }
    })
  )
})

# TODO: Test handling of non-ohvbd.ids inputs
