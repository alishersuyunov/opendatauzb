#'  Downloading Stock Market Data
#'
#'  Obtains stock market prices over the period given
#'
#' @param symbol A unique identifier of the security (e.g. UZ7011340005). Note: Don't confuse with ISIN code
#' @param from A string representing the start date of the period of interest in date.month.year date format
#' @param to A string representing the end date of the period of interest in date.month.year date format
#'
#' @author Alisher Suyunov
#'
#' @import httr readxl rvest dplyr glue lubridate tidyr stringr jsonlite assertive xml2
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{getSecurities}} or \code{\link{RegisteredSecurities}} to see the complete list of available securities
#' @seealso \code{\link{getMarketIndex}} to download stock market indices by sector
#'
#' @examples
#'  \dontrun{
#'  getTicker("UZ7011340005")
#'  getTicker("UZ7011340005", from = "01.01.2020", to = "01.05.2020")}
getTicker <- function(symbol, from = "01.01.2020", to = "dd.mm.yyyy") {

  assert_is_a_non_missing_nor_empty_string(symbol)

  symbol <- str_trim(symbol)
  from <- str_trim(from)
  to <- str_trim(to)

  if(to == "dd.mm.yyyy") {
    to <- today() %>% format(format = "%d.%m.%Y")
  }

  checkDateFormat(from)
  checkDateFormat(to)

  request_parameters <- list(begin_date = from,
                             end_date = to)

  res_stock <- GET(
      glue("https://uzse.uz/isu_infos/{symbol}/conclusions.xlsx"),
      query = request_parameters,
      add_headers("User-Agent" = "Mozilla/5.0 (compatible; opendatauzbBot)",
                  Referer = glue("https://uzse.uz"),
                  "Accept-Encoding" = "gzip, deflate, br")
    )

  if(status_code(res_stock) == "200") {
  temp_downloaded_stock <- tempfile(fileext = ".xlsx")
  content(res_stock, type = "raw") %>% writeBin(temp_downloaded_stock)

  historical_data <- read_excel(temp_downloaded_stock) %>% mutate(symbol = symbol, Date = as_date(Date, format = "%d.%m.%Y")) %>% arrange(Date)
  unlink(temp_downloaded_stock)
  rm(temp_downloaded_stock)

  message(glue("{symbol} has been downloaded for {from}-{to}"))

  return(historical_data)
  }
}
