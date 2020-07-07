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
#' @import dplyr jsonlite httr assertive stringr glue readr
#' @importFrom glue glue
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
  assert_any_are_numeric_strings(id, severity = "stop")

  if(format == "csv") {
    read_delim(glue("https://data.gov.uz/ru/datasets/download/{id}/{format}"),
             delim = fixed(sep),
             col_names = FALSE) %>% return()
  } else if(format == "json") {
    glue("https://data.gov.uz/ru/datasets/download/{id}/{format}") %>% fromJSON() %>% return()
  }
}

#' @describeIn getData Downloads a dataset dictionary (variables) for the datasets
#' @export
getData_dictionary <- function(id, sep = ";", header = FALSE) {
    assert_any_are_numeric_strings(id, severity = "stop")
    glue("https://data.gov.uz/ru/convert/download/{id}?ext=csv") %>%
    read_delim(delim = fixed(sep), col_names = header) %>%
    return()
}

#' @describeIn getData Obtains a data frame with dataset history containing publication date and version
#' @export
getData_history <- function(id) {
  assert_any_are_numeric_strings(id, severity = "stop")
  glue("dataset/{id}/version") %>%
    formRequest() %>%
    fromJSON(flatten = TRUE) %>%
    arrange(publication_date) %>%
    return()
}

#' @keywords internal
getData_by_version <- function(id, version) {
  assert_any_are_numeric_strings(id, severity = "stop")
  assert_any_are_numeric_strings(version, severity = "stop")

  glue("dataset/{id}/version/{version}") %>%
    formRequest() %>%
    fromJSON() %>%
    return()
}
