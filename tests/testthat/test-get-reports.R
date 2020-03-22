context("Daily reports")
start_date = as.Date("2020-03-01")
end_date = as.Date("2020-03-06")
some_future_date = Sys.Date() + 10
expected_names_old = c("province_state",
                   "country_region",
                   "last_update",
                   "confirmed",
                   "deaths",
                   "recovered",
                   "date")
expected_names = c("province_state",
                   "country_region",
                   "last_update",
                   "confirmed",
                   "deaths",
                   "recovered",
                   'latitude',
                   'longitude',
                   "date")
test_that("Daily report returns data with a correct format", {
  df = get_daily_report(start_date)
  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_true(all(names(df) %in% c(names(schema_daily_report), "date")))
})
test_that("Dates above the existing timerange returns empty data.frame instead of an error", {
  df = get_daily_report(some_future_date)
  expect_equal(nrow(df), 0)
})
test_that("Reports with a custom timerange returns data with a correct format", {
  df = get_reports(start_date, end_date)
  expect_is(df, "data.frame")
  expect_gt(nrow(df), 0)
  expect_named(df, expected_names)
})
