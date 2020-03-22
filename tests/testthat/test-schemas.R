context("schemas")

test_that("Initialization of empty table works as expected", {
  df = init_empty_daily_report(Sys.Date())
  expect_is(df, "data.frame")
  expect_equal(nrow(df), 0)
  expect_named(df, names(schema_daily_report))
})
