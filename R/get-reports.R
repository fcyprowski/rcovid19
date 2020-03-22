#' @importFrom assertthat assert_that
#' @importFrom assertthat is.date
#' @importFrom assertthat is.flag
#' @importFrom assertthat is.string
#' @importFrom readr read_csv
#' @importFrom purrr safely
#' @importFrom purrr when
enrich = function(raw_data, date) {
  assert_that(
    is.date(as.Date(date)),
    is.data.frame(raw_data)
  )
  if (nrow(raw_data) > 0) {
    raw_data$date = date
  } else {
    raw_data$date = empty_date()
  }
  return(raw_data)
}
read_or_init_empty_table = function(filepath, date, verbose) {
  safely(
    ~read_csv(filepath, progress = verbose),
    otherwise = init_empty_daily_report(date),
    quiet = verbose
  )(path)$result
}
build_filepath = function(date, repository) {
  file_date = format(date, "%m-%d-%Y")
  file = paste0(file_date, ".csv")
  paste(repository, file, sep = "/")
}
get_daily_report = function(date,
                            verbose = FALSE,
                            repository = COVID19_repository_dayli) {
  assertthat::assert_that(
    is.date(as.Date(date)),
    is.flag(verbose),
    is.string(repository)
  )
  path = build_filepath(date, repository)
  if (verbose) message(path)
  path %>%
    read_or_init_empty_table(
      date = date,
      verbose = verbose
    ) %>%
    enrich(date)
}
rename_for_some_standards = function(raw_data) {
  names(raw_data) = names(raw_data) %>%
    stringr::str_replace("\\/| ", "_") %>%
    tolower()
  return(raw_data)
}
#' @title Get the data about COVID-19 from the CSSE repository
#'
#' @param start_date Date object YYYY-MM-DD (default to a date before the current date)
#' @param end_date Date object YYYY-MM-DD (default to a date before the current date)
#' @param ... additional args. See below:
#' @details
#' * repository: default to the COVID19_repository_daily global variable
#' * verbose: should it print out some messages (like the github filepath and readr progress)? Default to TRUE
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
                       verbose = FALSE,
                       ...) {
  assertthat::assert_that(
    is.date(as.Date(start_date)),
    is.date(as.Date(end_date)),
    end_date >= start_date
  )
  date_seq(start_date, end_date) %>%
    purrr::map_dfr(~get_daily_report(...)) %>%
    rename_for_some_standards()
}
