#'  Downloading Datasets
#'
#'  Downloads available datasets and related information from data.gov.uz API
#'
#' @param id a numeric or character that represents the dataset identifier
#' @param format a character. A format (CSV or JSON) of the response from the server
#' @param sep a field separator character. Values on each line of the file are separated by this character. By default it is a semicolon ';'. The separator character is passed to the function read.csv.
#' @param header a logical value representing if the file contains variable names on its first line
#'
#' @author Alisher Suyunov
#'
#' @import dplyr httr
#'
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#' @importFrom readr read_delim
#' @importFrom stringr fixed
#' @importFrom assertive assert_any_are_numeric_strings
#'
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{availableDatasets}} to get the data frame with the list of available datasets and corresponding \code{id}
#'
#' @name getData
#'
#' @examples
#'  \dontrun{
#'  getData(7)
#'  getData("7")
#'  getData_dictionary(7)
#'  getData_history(7) }
getData <- function(id, format = "csv", sep = ";") {
  assertive::assert_any_are_numeric_strings(id, severity = "stop")

  if(format == "csv") {
    readr::read_delim(glue::glue("https://data.gov.uz/ru/datasets/download/{id}/{format}"),
             delim = stringr::fixed(sep),
             col_names = FALSE) %>% return()
  } else if(format == "json") {
    glue::glue("https://data.gov.uz/ru/datasets/download/{id}/{format}") %>% jsonlite::fromJSON() %>% return()
  }
}

#' @describeIn getData Downloads a dataset dictionary (variables) for the datasets
#' @export
getData_dictionary <- function(id, sep = ";", header = FALSE) {
    assertive::assert_any_are_numeric_strings(id, severity = "stop")
    glue::glue("https://data.gov.uz/ru/convert/download/{id}?ext=csv") %>%
    readr::read_delim(delim = stringr::fixed(sep), col_names = header) %>%
    return()
}

#' @describeIn getData Obtains a data frame with dataset history containing publication date and version
#' @export
getData_history <- function(id) {
  assertive::assert_any_are_numeric_strings(id, severity = "stop")
  glue::glue("dataset/{id}/version") %>%
    formRequest() %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    arrange(publication_date) %>%
    return()
}

#' @keywords internal
getData_by_version <- function(id, version) {
  assertive::assert_any_are_numeric_strings(id, severity = "stop")
  assertive::assert_any_are_numeric_strings(version, severity = "stop")

  glue::glue("dataset/{id}/version/{version}") %>%
    formRequest() %>%
    jsonlite::fromJSON() %>%
    return()
}
