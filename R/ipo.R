#'  Obtaining schedule of public offerings (IPO/SPO/PO (the government shares))
#'
#'  Returns a data frame with public offerings in last five years
#'
#' @param key A unique identifier of the security (e.g. UZ7011340005). Note: Don't confuse with ISIN code
#' @param plus_n_years End of the period
#'
#' @author Alisher Suyunov
#'
#' @import httr readxl dplyr lubridate tidyr jsonlite
#'
#' @importFrom glue glue
#' @importFrom assertive assert_is_a_number
#' @importFrom xml2 read_html
#' @importFrom rvest html_table
#' @importFrom stringr str_trim str_replace_all
#'
#' @return Returns a data frame
#' @export
#'
#' @examples
#'  \dontrun{
#'  ipo()
#'  ipo(plus_n_years = 2)}
ipo <- function(key = "", plus_n_years = 1) {

  assertive::assert_is_a_number(plus_n_years)

  glue::glue('https://uzse.uz/ipos?search_key={key}&search_date={as.character(format(today() + years(plus_n_years), "%d.%m.%Y"))}') %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    .[[1]] %>%
    select(-"", Code = 2) %>%
    separate(Code, c("Code", "Title"), sep = "\n") %>%
    mutate(Code = stringr::str_replace_all(Code, "[[:punct:]]", " "), Title = stringr::str_trim(Title)) %>%
    return()
}
