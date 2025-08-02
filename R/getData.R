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
#' @import dplyr httr checkmate
#'
#' @importFrom jsonlite fromJSON
#' @importFrom glue glue
#' @importFrom readr read_delim
#' @importFrom stringr fixed
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
  id <- as.character(id)
  checkmate::assert_character(id, any.missing = FALSE)

  # ensure at least one element of `id` is a numeric‐only string
  checkmate::assert_true(
    any(grepl("^[0-9]+$", id)),
    .var.name = "id",
    .var.info = "at least one element must consist of digits only"
  )

  if(format == "csv") {
    readr::read_delim(glue::glue("https://data.gov.uz/ru/datasets/download/{id}/{format}"),
                      delim = stringr::fixed(sep),
                      col_names = FALSE) %>% return()
  } else if(format == "json") {
    glue::glue("https://data.gov.uz/ru/datasets/download/{id}/{format}") %>% GET() %>% content("text") %>% jsonlite::fromJSON() %>% return()
  }
}

#' @describeIn getData Downloads a dataset dictionary (variables) for the datasets
#' @export
getData_dictionary <- function(id, sep = ";", header = FALSE) {
  id <- as.character(id)
  checkmate::assert_character(id, any.missing = FALSE)

  # ensure at least one element of `id` is a numeric‐only string
  checkmate::assert_true(
    any(grepl("^[0-9]+$", id)),
    .var.name = "id",
    .var.info = "at least one element must consist of digits only"
  )

  glue::glue("https://data.gov.uz/ru/convert/download/{id}?ext=csv") %>%
    readr::read_delim(delim = stringr::fixed(sep), col_names = header) %>%
    return()
}

#' @describeIn getData Obtains a data frame with dataset history containing publication date and version
#' @export
getData_history <- function(id) {
  id <- as.character(id)
  checkmate::assert_character(id, any.missing = FALSE)

  # ensure at least one element of `id` is a numeric‐only string
  checkmate::assert_true(
    any(grepl("^[0-9]+$", id)),
    .var.name = "id",
    .var.info = "at least one element must consist of digits only"
  )

  glue::glue("dataset/{id}/version") %>%
    formRequest() %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    arrange(publication_date) %>%
    return()
}

#' @keywords internal
getData_by_version <- function(id, version) {
  id <- as.character(id)
  version <- as.character(version)

  checkmate::assert_character(id, any.missing = FALSE)

  # ensure at least one element of `id` is a numeric‐only string
  checkmate::assert_true(
    any(grepl("^[0-9]+$", id)),
    .var.name = "id",
    .var.info = "at least one element must consist of digits only"
  )
  checkmate::assert_character(version, any.missing = FALSE, min.chars = 1)

  # ensure at least one element is a purely numeric string
  checkmate::assert_true(
    any(grepl("^[0-9]+$", version)),
    .var.name = "version",
    .var.info = "at least one element must consist only of digits"
  )

  glue::glue("dataset/{id}/version/{version}") %>%
    formRequest() %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON() %>%
    return()
}
