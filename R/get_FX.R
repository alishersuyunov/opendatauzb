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
#' @import httr rvest dplyr
#'
#' @importFrom glue glue
#' @importFrom assertive is_empty
#' @importFrom assertive is_true
#' @importFrom assertive assert_is_a_non_missing_nor_empty_string
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
get_FX <- function(currency = c("USD", "EUR"), from = "01-10-2020", to = "dd-mm-YYYY") {
  assertive::assert_is_a_non_missing_nor_empty_string(currency)
  currency <- toupper(currency)

  if (to == "dd-mm-YYYY") to <- format(lubridate::today() + lubridate::days(1), "%d-%m-%Y")

  checkDateFormat_UZRCE(from)
  checkDateFormat_UZRCE(to)

  type <- 1
  exchange_tool_id <- switch(currency, "USD" = 1, "EUR" = 6, "")
  created_at <- from #%>% anytime::anydate() %>% format("%d-%m-%Y")
  end_date <- to #%>% anytime::anydate() %>% format("%d-%m-%Y")

  crayon::green(paste("Downloading", currency, "exchange rates (UzRCE) from", from, "to", to)) %>% message()

  req <- glue::glue("http://uzrvb.uz/ru/trades-archive?",
                    "ExchangeVolatility%5Btype%5D={type}&",
                    "ExchangeVolatility%5Bexchange_tool_id%5D={exchange_tool_id}&",
                    "ExchangeVolatility%5Bcreated_at%5D={created_at}&",
                    "ExchangeVolatility%5Bend_date%5D={end_date}") %>%
    GET(add_headers("User-Agent" = "Mozilla/5.0 (compatible; opendatauzbBot)"))

  pages <- content(req) %>% xml_node(css = "#w1 > ul > li.last") %>% xml_contents() %>% xml_attr("data-page") %>% as.numeric() + 1

  if (assertive::is_empty(pages)) pages <- 1

  full <- purrr::map(1:pages, function(page_id) {
    GET(req$url, query = list(page = page_id)) %>%
      content() %>%
      html_table(fill = TRUE) %>%
      .[[12]] %>%
      return()
  })

  df <- full %>% data.table::rbindlist() %>% filter(`Exchange Tool ID` != "")

  if(length(colnames(df)) == 4) {
    df <- df %>% purrr::set_names(c("date", "exchange_tool", "exchange_rate", "total_amount_traded")) %>%
      mutate(date = lubridate::ymd(date),
             total_amount_traded = stringr::str_replace_all(total_amount_traded, " ", "") %>% stringr::str_replace_all(",", ".") %>% as.double()) %>%
      arrange(date)
  }

  return(df)
}

checkDateFormat_UZRCE <- function(dt) {
  if (assertive::is_true(lubridate::guess_formats(dt, "d0my") == "%d-%Om-%Y" || lubridate::guess_formats(dt, "d0my") == "%d-%m-%Y"
                         || lubridate::guess_formats(dt, "d0my") == "%d-%Om-%Y" || lubridate::guess_formats(dt, "d0my") == "%d-%m-%Y"
                         || lubridate::guess_formats(dt, "y0md") == "%Y-%Om-%d" || lubridate::guess_formats(dt, "y0md") == "%Y-%m-%d"
                         )) {
    return(TRUE)
  }
  else stop("Please express 'from' (or 'to') date in %d-%m-%Y format (e.g. '22-12-2020') or %Y-%m-%d format (e.g. '2020-12-20')")
}
