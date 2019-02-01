#' Optimize weights from list of 
#'
#' Converts the factor labels to numeric values and returns the factor as a numeric vector
#'
#' Returns a vector of numeric values. Elements in the input factor that cannot be converted to numeric will produce NA.
#'
#' @param outcome A factor
#' @param predictionlist A factor
#' @return Returns a numeric vector containing an optimal of the weights of the 
#' @author Claus Ekstrom \email{claus@@rprimer.dk}
#' @keywords manip
#' @examples
#'
#' m1 <- matrix(c(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, .5, .5, 0, 0, .5, .5), 4)
#' m1 # Prediction where certain on the top ranks
#' m2 <- matrix(c(.5, .5, 0, 0, .5, .5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1), 4)
#' m2  # Prediction where the groups are okay 
#' m3 <- matrix(c(.5, .5, 0, 0, .5, .5, 0, 0, 0, 0, .5, .5, 0, 0, .5, .5), 4)
#' m3  # Prediction where no clue about anything
#' m4 <- matrix(rep(1/4, 16), 4)
#' 
#' optimize_weights(1:4, list(m1, m2, m3, m4))
#'
#' @export
optimize_weights <- function(outcome, predictionlist) {
  # Sanity checks needed:
  # Check equal dimensions of matrices
  # Check match with outcome
  
  # Start by finding their individual RPS scores
  startrps <- sapply(predictionlist, function(mat) { rps(mat, outcome)} )
  
  # Should be possible to get much faster
  weightedrps <- function(weights) { 
    weights <- exp(weights)/sum(exp(weights))
    rps(Reduce('+', lapply(1:length(weights), function(i){weights[i]*predictionlist[[i]]})), outcome)
  }
  
  res <- optim(exp(-startrps), weightedrps)
   
  exp(res$par)/sum(exp(res$par))
}