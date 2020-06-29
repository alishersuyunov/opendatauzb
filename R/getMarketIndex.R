#'  Downloading Market Indices (Uzbekistan Composite Index, UCI)
#'
#'  Provides stock market indices over the period given
#'
#' @param sector A string that indicates the sector: all, finance, industry, agriculture, construction, social, transport, trade, other
#' @param from A string representing the start date of the period of interest in date.month.year date format
#' @param to A string representing the end date of the period of interest in date.month.year date format
#'
#' @author Alisher Suyunov
#'
#' @import httr readxl rvest dplyr glue lubridate tidyr stringr jsonlite assertive
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{getSecurities}} or \code{\link{RegisteredSecurities}} to see the complete list of available securities
#' @seealso \code{\link{getTicker}} to download stock prices of the certain stock
#'
#' @examples
#'  \dontrun{
#'  getMarketIndex(sector = "all")
#'  getMarketIndex(sector = "finance", from = "01.01.2020, to = "01.05.2020")}
getMarketIndex <- function(sector = c("all", "finance", "industry", "agriculture",
                                      "construction", "social", "transport", "trade", "other"),
                           from = "01.01.2019",
                           to = "dd.mm.yyyy") {

  from <- str_trim(from)
  to <- str_trim(to)

  if (to == "dd.mm.yyyy") {
    to <- today() %>% format(format = "%d.%m.%Y")
  }

  assert_is_a_non_missing_nor_empty_string(sector)

  checkDateFormat(from)
  checkDateFormat(to)

  are_intersecting_sets(tolower(str_trim(sector)),
                        c("all", "finance", "industry", "agriculture", "construction", "social", "transport", "trade", "other"))

  sector_code <- switch(tolower(str_trim(sector)),
         "all" = "001",
         "finance" = "002",
         "industry" = "003",
         "agriculture" = "004",
         "construction" = "005",
         "social" = "006",
         "transport" = "007",
         "trade" = "008",
         "other" = "009" #, "tci" = "tcis"
         )

  request_parameters <- list(ind_idx_cd = sector_code,
                             begin_date = from,
                             end_date = to)

  res <- GET(
      "https://uzse.uz/price_indices/histories",
      query = request_parameters,
      add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.104",
                  Referer = glue("https://uzse.uz/price_indices?idx_ind_cd={sector_code}"),
                  "Accept-Encoding" = "gzip, deflate, br",
                  "Accept" = 'application/json')
    )

  glue("Uzbekistan Composite Index (Sector: {str_to_sentence(sector)}) will be downloaded for {from}-{to}") %>%
    message()

  content(res, as = "text", type = "raw", encoding = "UTF-8") %>%
  fromJSON(flatten = TRUE) %>%
  `colnames<-`(c("date", "open_price", "high_price", "low_price", "price", "previous_day_price", "marketcap", "trading_volume", "trading_value")) %>%
  mutate(date = as_date(date)) %>%
  return()
}

checkDateFormat <- function(dt) {
  if(is_true(guess_formats(dt, "d0my") == "%d.%Om.%Y" || guess_formats(dt, "d0my") == "%d.%m.%Y")) {
    return(TRUE)
  } else stop("Please state 'from' (or 'to') date in %d.%m.%Y format e.g. '22.12.2020'")
}
