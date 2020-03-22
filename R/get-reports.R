#' @importFrom assertthat assert_that
#' @importFrom assertthat is.date
#' @importFrom readr read_csv
#' @importFrom purrr safely
enrich = function(raw_data, date) {
  names(raw_data) = names(raw_data) %>%
    stringr::str_replace("\\/| ", "_") %>%
    tolower()
  raw_data$date = date
  return(raw_data)
}
get_daily_report = function(date,
                            repository = COVID19_repository_dayli,
                            verbose = TRUE) {
  assertthat::assert_that(
    is.date(as.Date(date))
  )
  date = format(date, "%m-%d-%Y")
  file = paste0(date, ".csv")
  path = paste(repository, file, sep = "/")
  if (verbose) message(path)
  safely(read_csv)(path)$result %>%
    enrich(date)
}

#' @title Get the data about COVID-19 from the CSSE repository
#'
#' @param start_date Date object YYYY-MM-DD (default to a date before the current date)
#' @param end_date Date object YYYY-MM-DD (default to a date before the current date)
#' @param ... additional args. See below:
#' @details
#' * repository: default to the COVID19_repository_daily global variable
#' * verbose: should it print out some messages. Default to TRUE
#' @md
#'
#' @return data.frame. It should have the same structure as in here:
#' https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/01-22-2020.csv
#' @export get_reports
#'
#' @examples
#' covid_cases = rcovid19::get_reports(Sys.Date() - 1, Sys.Date() - 30)
get_reports = function(start_date = Sys.Date() - 1,
                       end_date = Sys.Date() - 1,
                       ...) {
  assertthat::assert_that(
    is.date(as.Date(start_date)),
    is.date(as.Date(end_date))
  )
  seq(start_date, end_date, by = 1) %>%
    purrr::map_dfr(get_daily_report)
}