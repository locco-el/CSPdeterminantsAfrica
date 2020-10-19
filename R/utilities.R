#' Remove non-numeric characters from a string
#'
#' @param string string
#'
#' @export
#'
remove_non_num <- function(string) {
  gsub("[^0-9.-]", "", string)
}

#' Convert non-numeric variables and coerce to numeric
#'
#' @param string string
#'
#' @export
#'
coerce_num_cln <- function(string) {
  as.numeric(gsub("[^0-9.-]", "", string))
}

#' Select columns of numeric variables
#'
#' @param dat dataframe
#'
#' @export
#'
select_num_vars <- function(dat) {
  subset(dat, select = sapply(dat, is.numeric))
}

#' Remove columns which are all the same value for numeric variables
#'
#' @param dat dataframe
#'
#' @export
#'
rem_zero_var_cols <- function(dat) {
  subset(dat, select = -as.numeric(which(apply(dat, 2, stats::var) == 0)))
}

#' #' @export
#' #'
#' combine_vars <- function(varlist) {
#'   lapply(varlist, function(x) paste0(names(x), varlist)))
#' }
