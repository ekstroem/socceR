#include <Rcpp.h>
using namespace Rcpp ;

//' Computes the rank probability score for a tournament
//'
//' @description Fill down missing values with the latest non-missing value
//' @param m A prediction matrix 
//' @param outcome A prediction matrix 
//' @param rankweights A prediction matrix 
//' @return A vector or list with the NA's replaced by the last observed value.
//' @author Claus Ekstrom <ekstrom@@sund.ku.dk>
//' @examples
//'
//'
//' @export
// [[Rcpp::export]]
double rps(const NumericMatrix& m, NumericVector outcome, NumericVector rankweights=1) {
  double result = 0.0;
  double cumsum = 0.0;

  // Expand weight if it was just a single number
  if (rankweights.size() != m.nrow())
    rankweights = NumericVector(m.nrow(), rankweights(0));

  // Should the weight be normalized

  int CO = 0;
  // Iterate over teams (columns)
  for (int j = 0; j < m.ncol()-1; ++j) {
    CO = 0;
    cumsum = m(0, j);
    if (outcome(j)==1) {
      CO = 1;
    }
    result += rankweights(0)*(cumsum - CO)*(cumsum - CO);
    //        Rcout << result << std::endl;
    // We have already taken the first row above so start at second row
    for (int i = 1; i < m.nrow()-1; ++i) {
      if (outcome(j) == (i+1)) {
	CO = 1;
      }
      cumsum += m(i, j);
      result += rankweights(i)*(cumsum - CO)*(cumsum - CO);
      //           Rcout << "   " << result << std::endl;

    }
  }
  return result/(m.rows()-1);
}
