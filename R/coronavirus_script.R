COVID19_repository = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data"
COVID19_repository_dayli = paste(COVID19_repository, "csse_covid_19_daily_reports", sep = "/")

repository = "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports"
current_date = format(Sys.Date() - 1, "%m-%d-%Y")  # formatujemy date, zeby pasowala do naszych danych - mozesz zobaczyc jak wygladaja klikajac w powyzszy link
file = paste0(current_date, ".csv")
path = paste(repository, file, sep = "/")
print(path)  # warto zobaczyc czy nasza sciezka jest poprawnie skonstruowana
d = readr::read_csv(path)

getDailyReport = function(date = format(Sys.Date() - 1, "%m-%d-%Y"),
                          repository = COVID19_repository_dayli) {
  file = paste0(date, ".csv")
  path = paste(repository, file, sep = "/")
  print(path)  # warto zobaczyc czy nasza sciezka jest poprawnie skonstruowana
  readr::read_csv(path)
}
getDailyReports = function() {
  
}