#'  Available Datasets
#'
#'  Obtains the list of available datasets from the \url{data.gov.uz}
#'
#' @author Alisher Suyunov
#'
#' @param id Numeric or String Numeric. An identifier of the organisation/authority providing the dataset
#'
#' @import dplyr httr
#'
#' @importFrom glue glue
#' @importFrom jsonlite fromJSON
#' @importFrom assertive assert_any_are_numeric_strings
#'
#' @return Returns a data frame
#' @export
#'
#' @seealso \code{\link{getData}} to download available datasets by their \code{id}
#' @name availableDatasets
#' @examples
#' \dontrun{
#'  availableDatasets()
#'  availableDataSources()
#'  availableDatasets_by_source(143) }
availableDatasets <- function() {
  formRequest("dataset") %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    return()
}

#' @describeIn availableDatasets Obtains the list of available datasets published by particular organisation/authority
#' @export
availableDatasets_by_source <- function(id) {
  id <- as.character(id)
  assertive::assert_any_are_numeric_strings(id, severity = "stop")

  glue::glue("organization/{id}/dataset") %>%
    formRequest() %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE)
}

#' @describeIn availableDatasets Obtains the list of available datasources - organisations
#' @export
availableDataSources <- function() {
  formRequest("organization") %>%
    GET() %>%
    content("text") %>%
    jsonlite::fromJSON(flatten = TRUE)
}
