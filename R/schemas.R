empty_date = purrr::compose(as.Date, character)
schema_daily_report = list(
  "Province/State" = "character",
  "Country/Region" = "character",
  "Last Update" = "empty_date",
  "Confirmed" = "numeric",
  "Deaths" = "numeric",
  "Recovered" = "numeric",
  "Latitude" = "numeric",
  "Longitude" = "numeric"
)
init_empty_daily_report = function(date) {
  warning(
    "There are no obs for the date: ", date
  )
  empty_report = schema_daily_report
  empty_report[] = lapply(
    schema_daily_report,
    function(type) get(type)()
  )
  dplyr::as_tibble(empty_report)
}
