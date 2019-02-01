#' Convert factor to numeric vector
#'
#' Converts the factor labels to numeric values and returns the factor as a numeric vector
#'
#' Returns a vector of numeric values. Elements in the input factor that cannot be converted to numeric will produce NA.
#'
#' @param ranks A factor
#' @return Returns a numeric vector of the same length as x
#' @author Claus Ekstrom \email{claus@@rprimer.dk}
#' @keywords manip
#' @examples
#'
#' f <- factor(c(1,2,1,3,2,1,2,3,1))
#' fac2num(f)
#'
#' @export
collapse_prediction <- function(ranks=c(1, 2, 3, 4, 8, 16, 32)) {
  m <- matrix(0, ncol=max(ranks), nrow=length(ranks))
  start <- 1
  for (i in 1:length(ranks)) {
    m[i, start:ranks[i]] <- 1
    start <- ranks[i]+1
  }
  m
}