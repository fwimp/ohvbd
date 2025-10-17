test_that("search_hub works and returns ohvbd.hub.search objects", {
  testwkt <- gsub(
    "\n",
    "",
    "MULTIPOLYGON(
                        ((
                          -4.601692249172345 59.18721395065515,
                          -1.5564374591013461 59.09157727402243,
                          2.7317784697742695 51.70725619550282,
                          -0.3756243772367611 50.100597554419096,
                          -6.27968978655835 49.53924199886393,
                          -5.47176504633498 52.357229445873315,
                          -6.031097558797256 53.92277755807382,
                          -8.889908178047193 54.323411308259836,
                          -8.392723722525744 58.21875779916627,
                          -4.601692249172345 59.18721395065515
                        ))
                      )"
  )
  vcr::local_cassette("search_hub")
  aedes_uk_results <- suppressMessages(search_hub(
    "Aedes",
    locationpoly = testwkt
  ))
  tyrnava_results <- suppressMessages(search_hub(
    "2000-2010 in Tyrnava",
    exact = TRUE
  ))

  expect_s3_class(aedes_uk_results, "ohvbd.hub.search")
  expect_s3_class(tyrnava_results, "ohvbd.hub.search")
})

test_that("filter_db correctly filters from hub searches", {
  hits <- list(
    list(
      id = "b10b4c57-e186-4699-8e1c-0350c4993972",
      title = "test_GBIF",
      type = "occurrence",
      doi = "test_doi",
      db = "gbif"
    ),
    list(
      id = "1",
      title = "test_vt",
      type = "trait",
      doi = "test_doi",
      db = "vt"
    ),
    list(
      id = "364",
      title = "test_vd",
      type = "abundance",
      doi = "test_doi",
      db = "vd"
    ),
    list(
      id = "PX999999",
      title = "test_px",
      type = "proteomic",
      doi = "test_doi",
      db = "px"
    )
  )

  search_return <- new_ohvbd.hub.search(
    hits,
    query = "testquery",
    searchparams = list()
  )
  expect_length(
    {
      search_return |> filter_db("gbif")
    },
    1
  )
  expect_length(
    {
      search_return |> filter_db("vt")
    },
    1
  )
  expect_length(
    {
      search_return |> filter_db("vd")
    },
    1
  )
  expect_length(
    {
      search_return |> filter_db("px")
    },
    1
  )
  expect_length(
    {
      search_return |> filter_db("test")
    },
    0
  )

  # Check supplying multiple dbs returns first with a warning
  expect_warning({
    search_return |> filter_db(c("vt", "vd"))
  })
  expect_equal(
    suppressWarnings(attr(
      {
        search_return |> filter_db(c("vt", "vd"))
      },
      "db"
    )),
    "vt"
  )

  # Check filter_db returns an ohvbd.ids vector of correct db
  expect_s3_class(
    {
      search_return |> filter_db("vt")
    },
    "ohvbd.ids"
  )
  expect_equal(
    attr(
      {
        search_return |> filter_db("vt")
      },
      "db"
    ),
    "vt"
  )
})
