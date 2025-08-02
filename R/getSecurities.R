#'  Downloading the securities listed on the Republican Stock Exchange "Toshkent"
#'
#'  Returns a data frame with the list of securities in the Republican Stock Exchange "Toshkent" database
#'
#' @author Alisher Suyunov
#'
#' @import httr dplyr tidyr crayon checkmate
#'
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#' @importFrom utils capture.output
#' @importFrom stringr str_length
#'
#' @return Returns a data frame
#' @export
#'
#' @examples
#'  \dontrun{
#'  getSecurities()}
getSecurities <- function() {
  sct_list <- c("STK", "BND", "RPO", "FCT") %>%
    lapply(requestNames) %>%
    bind_rows() %>%
    as_tibble() %>%
    `colnames<-`(c("SecurityCode", "Ticker", "Issuer", "Type")) %>%
    select(4, 1:3)

  message(crayon::green(glue::glue("{nrow(sct_list)} securities are found. Out of which are:")))
  message(crayon::blue(paste0(utils::capture.output(sct_list %>% group_by(Type) %>% count() %>% arrange(desc(n))), collapse = "\n")))

  return(sct_list)
}

requestNames <- function(security_code) {
  GET("https://uzse.uz/isu_infos/names",
      query = list(mkt_id = security_code),
      add_headers("User-Agent" = "Mozilla/5.0 (compatible; opendatauzbBot)",
                  Referer = "https://uzse.uz",
                  "Accept" = "application/json")) %>%
    content(type = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE) %>% #fparse() %>%
    as.data.frame() %>%
    mutate(type = security_code) %>%
    return()
}

requestTicker <- function(security_code, type = "STK") {
  checkmate::assert_string(security_code, min.chars = 1)
  checkmate::assert_string(type,          min.chars = 1)

  requestNames(type) %>% filter(V1 == security_code) %>% .[2] %>% as.character() %>% return()
}

requestSecurityCode <- function(ticker, type = "STK") {
  checkmate::assert_string(ticker, min.chars = 1)
  checkmate::assert_string(type,   min.chars = 1)

  requestNames(type) %>% filter(V2 == toupper(ticker)) %>% .[1] %>% as.character() %>% return()
}
