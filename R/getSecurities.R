#'  Downloading the securities listed on the Republican Stock Exchange "Toshkent"
#'
#'  Returns a data frame with the list of securities from the Republican Stock Exchange "Toshkent" database
#'
#' @author Alisher Suyunov
#'
#' @import httr readxl rvest dplyr glue lubridate tidyr stringr jsonlite assertive xml2 utils RcppSimdJson
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
    `colnames<-`(c("SecurityCode", "Ticker", "Issuer", "Type")) %>%
    select(4, 1:3)

  message(glue("{nrow(sct_list)} securities are found. Out of which are:"))
  message(paste0(capture.output(sct_list %>% group_by(Type) %>% count()), collapse = "\n"))

  return(sct_list)
}

requestNames <- function(security_code) {
  GET("https://uzse.uz/isu_infos/names",
      query = list(mkt_id = security_code),
      add_headers("User-Agent" = "Mozilla/5.0 (compatible; opendatauzbBot",
                  Referer = glue("https://uzse.uz"),
                  "Accept" = "application/json")) %>%
    content(type = "text", encoding = "UTF-8") %>%
    fparse() %>%  #fromJSON() %>%
    as_tibble() %>%
    mutate(type = security_code) %>%
    return()
}
