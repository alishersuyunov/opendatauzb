#'  Downloading Foreign Currency Exchange Data
#'
#'  Obtains foreign currency exchange rate from the Republican Currency Exchange over the period given
#'
#' @param currency A currency code according to ISO 4217 (e.g. USD or EUR)
#' @param from A string representing the start date of the period of interest in date-month-year date format
#' @param to A string representing the end date of the period of interest in date-month-year date format
#'
#' @author Alisher Suyunov
#'
#' @import httr rvest dplyr checkmate lubridate stringr
#'
#' @importFrom glue glue
#' @importFrom purrr map
#' @importFrom purrr set_names
#' @importFrom data.table rbindlist
#' @importFrom lubridate ymd
#' @importFrom lubridate today
#' @importFrom lubridate days
#' @importFrom lubridate guess_formats
#' @importFrom stringr str_replace_all
#' @importFrom crayon green
#'
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{getSecurities}} or \code{\link{RegisteredSecurities}} to see the complete list of available securities
#' @seealso \code{\link{getTicker}} to download stock market prices
#' @seealso \code{\link{getMarketIndex}} to download stock market indices by sector
#'
#' @examples
#'  \dontrun{
#'  get_FX("USD")
#'  get_FX("EUR", from = "01-01-2018", to = "12-10-2020")}
get_FX <- function(currency = c("USD", "EUR"), from = "01-01-2022", to = "dd-mm-YYYY") {
  checkmate::assert_string(currency, min.chars = 1)
  currency <- toupper(currency)

  if (to == "dd-mm-YYYY") to <- format(lubridate::today() + lubridate::days(1), "%d-%m-%Y")

  checkDateFormat_UZRCE(from)
  checkDateFormat_UZRCE(to)

  type <- 1
  exchange_tool_id <- switch(currency, "USD" = 7, "EUR" = 6, "")
  created_at <- from #%>% anytime::anydate() %>% format("%d-%m-%Y")
  end_date <- to #%>% anytime::anydate() %>% format("%d-%m-%Y")

  crayon::green(paste("Downloading", currency, "exchange rates (UzRCE) from", from, "to", to)) %>% message()

  req <- GET("https://uzrvb.uz/rynki-i-torgi/arhiv-kursov",
             add_headers("User-Agent" = "Mozilla/5.0 (compatible; opendatauzbBot)",
             "referrer" = "https://uzrvb.uz/rynki-i-torgi/arhiv-kursov"))

  tbl <- content(req, as = "text", encoding = "UTF-8") %>%
    read_html() %>%
    html_element("table.table-exel") %>%
    html_table(fill = TRUE)

  # clean & rename
  df <- tbl[-1, ]
  # rename without purrr::set_names()
  names(df) <- c("date", "currency", "exchange_rate", "total_volume")

  df <- df %>%
    mutate(
      date          = dmy(date),
      currency      = toupper(currency),
      exchange_rate = as.numeric(str_replace_all(exchange_rate, "[\\s]", "") %>%
                                   str_replace_all(",", ".")),
      total_volume  = as.numeric(str_replace_all(total_volume, "[\\s]", "") %>%
                                   str_replace_all(",", "."))
    ) %>%
    arrange(date)

  return(df)
}

checkDateFormat_UZRCE <- function(dt) {
  # Try day-month-year and year-month-day
  parsed_dmy <- lubridate::dmy(dt, quiet = TRUE)

  if (is.na(parsed_dmy)) {
    stop(
      "Please express 'from' (or 'to') date in dd-mm-YYYY (e.g. '22-12-2020') format."
    )
  }

  return(TRUE)
}
