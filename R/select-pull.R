#' @title Subset a `MultiAssayExperiment` by `SummarizedExperiment`s.
#'
#' @description 
#'
#' @param .data A `MultiAssayExperiment`.
#' @param ... The names of the `SummarizedExperiment`s to be kept, unquoted.
#'
#' @return A `MultiAssayExperiment` containing the selected
#'   `SummarizedExperiment`s. The output has the following properties:
#'   \itemize{\item `colData`, `rowData`, and `assay`s of selected experiments
#'   are not affected. \item Output experiments are a subset of input
#'   experiments, potentially with a different order.}
#'
#' @export
select <- function(.data, ...) {
  UseMethod("select")
}

#' @rdname select
#' @export
select.MultiAssayExperiment <- function(.data, ...) {
  # Convert `...` into a vector of strings of experiment names
  experiment_vector <- rlang::quos(...) %>% map(rlang::quo_text) %>% unlist()
  return(.data[, , experiment_vector]) 
}

#' @title Extract a single `SummarizedExperiment`.
#'
#' @description `pull()` is similar to `[[]]`.
#'
#' @param .data A `MultiAssayExperiment` containing at least one
#'   `SummarizedExperiment`.
#' @param  var A variable specified as: \itemize{ \item a positive integer,
#'   giving the position of the experiment counting from the top; \item a
#'   negative integer, giving the position of the experiment counting from the
#'   bottom. } 
#'   The default returns the last experiment. If there is only one experiment
#'   (e.g. if \code{\link{select}} has been used to select a single experiment
#'   from the `MultiAssayExperiment`), then this will be chosen.
#'
#' @return
#' @export
pull <- function(.data, var = -1) {
  UseMethod("pull")
}

#' @rdname pull
#' @export
pull.MultiAssayExperiment <- function(.data, var = -1) {
  if(is.numeric(var) & var < 0) {
    # Convert negative index to positive index
    var <- experiments(.data) %>% length() + 1 + var
  }
  return(.data[, , var][[1]])
}