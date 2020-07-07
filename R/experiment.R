library(httr)
library(readxl)
library(rvest)
library(dplyr)
library(glue)
library(lubridate)
# library(anytime)
library(tidyr)
library(stringr)
library(jsonlite)
library(assertive)
# library(gsheet)


# IPO list
ipo <- function(key = "", plus_n_years = 1) {

  assert_is_a_number(plus_n_years)

  glue('https://uzse.uz/ipos?search_key={key}&search_date={as.character(format(today() + years(plus_n_years), "%d.%m.%Y"))}') %>%
    read_html() %>%
    html_table() %>% .[[1]] %>%
    select(-"", Code = 2) %>%
    separate(Code, c("Code", "Title"), sep = "\n") %>%
    mutate(Title = str_trim(Title)) %>%
    return()
}

# decode.CFI <- function(code) {
#   message("The decoder relies on CFI decoder available from http://www.iotafinance.com/en/CFI-code-query-tool-ISO-10962-2015.html")
#   message("For manual decoding you can refer to https://www.quotemedia.com/docs/cfi_code_2001.html")
#   message("or ISO 10962:2015")
#
#   request <- POST(url = "http://www.iotafinance.com/ajax/clcCFI.php",
#                   body = list(fctSelect = 1,
#                               code = code,
#                               siteLang = ""),
#                   encode = "form",
#                   add_headers(
#                     Referer = "http://www.iotafinance.com/en/CFI-code-query-tool-ISO-10962-2015.html",
#                     "Content-Type" = "application/x-www-form-urlencoded; charset=UTF-8",
#                     Accept = "*/*",
#                     "Accept-Encoding" = "text/html",
#                     "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.104"
#                   )) %>%
#     content(type = "text", encoding = "UTF-8") %>%
#     fromJSON()
#
#   data.frame(
#   Category = request[[1]][["cat"]]$cfi_category_name_en,
#   Group = request[[1]][["grp"]]$cfi_group_name_en,
#   VotingRight = request[[1]][["at1"]]$set_name_en,
#   Ownership = request[[1]][["at2"]]$set_name_en,
#   PaymentStatus = request[[1]][["at3"]]$set_name_en,
#   Form = request[[1]][["at4"]]$set_name_en
#   )
# }

# all securitiesList
RegisteredSecurities <- function(){
  read_html("http://www.deponet.uz/cgi-bin/asb_all.cgi") %>%
    xml_nodes("table") %>% .[7] %>%
    html_table() %>% .[[1]] %>%
    return()
}

requestNames <- function(security_code) {
  GET("https://uzse.uz/isu_infos/names",
    query = list(mkt_id = security_code),
    add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.104",
                Referer = glue("https://uzse.uz"),
                "Accept" = 'application/json')) %>%
    content(type = "text", encoding = "UTF-8") %>%
    fromJSON() %>%
    as_tibble() %>%
    mutate(type = security_code) %>%
    return()
}

# names from UZSE
getSecurities <- function(){
  sct_list <- c("STK", "BND", "RPO", "FCT") %>%
    lapply(requestNames) %>%
    bind_rows() %>%
    `colnames<-`(c("SecurityCode", "Ticker", "Issuer", "Type")) %>%
    select(4, 1:3)

  message(glue("{nrow(sct_list)} securities are found. Out of which are:"))
  message(paste0(capture.output(sct_list %>% group_by(Type) %>% count()), collapse = "\n"))

  return(sct_list)
}

# market indices
checkDateFormat <- function(dt) {
  if(is_true(guess_formats(dt, "d0my") == "%d.%Om.%Y" || guess_formats(dt, "d0my") == "%d.%m.%Y")) {
      return(TRUE)
  } else stop("Please state 'from' (or 'to') date in %d.%m.%Y format e.g. '22.12.2020'")
}

getMarketIndex <- function(sector = c("all", "finance", "industry", "agriculture",
                                      "construction", "social", "transport", "trade", "other"),
                           from = "01.01.2019",
                           to = "dd.mm.yyyy") {

  from <- str_trim(from)
  to <- str_trim(to)

  if(to == "dd.mm.yyyy") {
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

# getTicker
getTicker <- function(symbol, from = "01.01.2019", to = "dd.mm.yyyy") {

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
      add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36 OPR/68.0.3618.104",
                  Referer = glue("https://uzse.uz"),
                  "Accept-Encoding" = "gzip, deflate, br")
    )

  if(status_code(res_stock) == "200") {
  temp_downloaded_stock <- tempfile(fileext = ".xlsx")
  content(res_stock, type = "raw") %>% writeBin(temp_downloaded_stock)

  historical_data <- read_excel(temp_downloaded_stock) %>% mutate(symbol = symbol)
  historical_data$Date <- as_date(historical_data$Date, format = "%d.%m.%Y")
  unlink(temp_downloaded_stock)
  rm(temp_downloaded_stock)

  message(glue("{symbol} has been downloaded"))

  return(historical_data)
  }
}


# https://uzse.uz/isu_infos?search_key=&begin_date=01.04.1994&end_date=24.06.2020
# https://uzse.uz/asking_prices?ord_dd=27.06.2020&mkt_id=STK&isu_cd=UZ7025770007

currentBidsAsks <- function(security_code = "", security_type = "STK") {
    security_type <- str_trim(security_type)
    security_code <- str_trim(security_code)

    glue('https://uzse.uz/asking_prices?ord_dd={today() %>% format(format = "%d.%m.%Y")}&mkt_id={security_type}&isu_cd={security_code}') %>%
    GET() %>%
    content(type = "text", encoding = "UTF-8") %>%
    read_html() %>%
    html_table() %>% .[[1]] %>%
    return()
}

### Offers
# offers_nrt <- xmlParse("https://uzse.uz/offers.xml")


### Dividends paid
## https://uzse.uz/abouts/dividends
## Google Sheet table: https://docs.google.com/spreadsheets/d/e/2PACX-1vTrQBmUeLBYEky2V_bf0lpFSbQGiYWvbyd5F0tKlAIsumqC1x9So8ym9US848XHzWS3_25X8Y-TOpng/pubhtml?widget=true&headers=false
# dividends <- "https://docs.google.com/spreadsheets/d/e/2PACX-1vTrQBmUeLBYEky2V_bf0lpFSbQGiYWvbyd5F0tKlAIsumqC1x9So8ym9US848XHzWS3_25X8Y-TOpng/pubhtml" %>%
#   gsheet2tbl()


# df <- getTicker("UZ7011340005")
# df <- c("UZ7011340005", "UZ7001560000") %>% lapply(getTicker) %>% bind_rows()

comparer <- function(id) {
  data.frame(id = id,
             isIdentical = identical(getData(id, format = "csv"),
                                     getData(id, format = "json"))) %>% return()
}

ids <- availableDatasets()$id %>% as.numeric()
result <- ids %>% lapply(comparer) %>% bind_rows()


exp_json <- function() {
  temp_downloaded_stock <- tempfile(fileext = ".json")
  GET("https://data.gov.uz/ru/api/v1/json/dataset?access_key=46b7bb492f5379d5a464dc73476e4316") %>%
    content(type = "raw") %>%
    writeBin(temp_downloaded_stock)
  temp_downloaded_stock %>% RcppSimdJson:::.load_json()
}
