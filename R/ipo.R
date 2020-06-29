#'  Obtaining schedule of public offerings (IPO/SPO/PO (the government shares))
#'
#'  Returns a data frame with public offerings in last five years
#'
#' @param key A unique identifier of the security (e.g. UZ7011340005). Note: Don't confuse with ISIN code
#' @param plus_n_years End of the period
#'
#' @author Alisher Suyunov
#'
#' @import httr readxl rvest dplyr glue lubridate tidyr stringr jsonlite assertive
#' @return Returns a data frame
#' @export
#'
#' @examples
#'  \dontrun{
#'  ipo()
#'  ipo(plus_n_years = 2)}
ipo <- function(key = "", plus_n_years = 1) {

  assert_is_a_number(plus_n_years)

  glue('https://uzse.uz/ipos?search_key={key}&search_date={as.character(format(today() + years(plus_n_years), "%d.%m.%Y"))}') %>%
    read_html() %>%
    html_table() %>%
    .[[1]] %>%
    select(-"", Code = 2) %>%
    separate(Code, c("Code", "Title"), sep = "\n") %>%
    mutate(Code = str_replace_all(Code, "[[:punct:]]", " "), Title = str_trim(Title)) %>%
    return()
}
