# socceR package


Development version of the R package `socceR` for evaluating and comparing sport tournament predictions.

To install the development version of `socceR` run the following command from 
within R (this requires that the `devtools` package is already installed on the system.)


    devtools::install_github('ekstroem/MESS')


## Evaluating predictions

```
m1 <- matrix(c(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, .5, .5, 0, 0, .5, .5), 4)
m1 # Prediction where certain on the top ranks
m2 <- matrix(c(.5, .5, 0, 0, .5, .5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1), 4)
m2  # Prediction where the groups are okay 
m3 <- matrix(c(.5, .5, 0, 0, .5, .5, 0, 0, 0, 0, .5, .5, 0, 0, .5, .5), 4)
m3  # Prediction where no clue about anything
m4 <- matrix(rep(1/4, 16), 4)
m4

rps(m1, c(1, 2, 3, 4)) # Better prediction
rps(m2, c(1, 2, 3, 4)) # Slightly worse prediction
rps(m3, c(1, 2, 3, 4)) # Slightly worse prediction
rps(m4, c(1, 2, 3, 4)) # Slightly worse prediction

optimize_weights(list(m1, m2, m3, m4), 1:4)

```

# Weighing predictions over multiple tournaments

This section is not quite finished yet and is more or less just proof-of-concept

Let's create another set of predictions fro another tournament but with the same methods as above.

```
M1 <- matrix(c(.8, .2, 0, 0, .1, .7, .2, 0, .05, .05, .4, .5, .05, .05, .4, .5), 4)
M1 # Prediction where certain on the top ranks
M2 <- matrix(rev(c(.8, .2, 0, 0, .1, .7, .2, 0, .05, .05, .4, .5, .05, .05, .4, .5)), 4)
M2  # Prediction where the groups are okay 
M3 <- matrix(c(.5, .5, 0, 0, .5, .5, 0, 0, 0, 0, .5, .5, 0, 0, .5, .5), 4)
M3  # Prediction where no clue about anything
M4 <- matrix(rep(1/4, 16), 4)
M4
```

Let us find the optimal weights (and assume that outcome was the same in the two tournaments)


```
optimize_weights2 <- function(predictionlist, outcome, FUN=rps) {
  # Sanity checks needed:
  # Check equal dimensions of matrices
  # Check match with outcome
  
  # Start by finding their individual RPS scores
  startrps <- rowSums(sapply(predictionlist, function(plist) { sapply(plist, function(mat) { FUN(mat, outcome)} )})
  )  
  # Should be possible to get much faster
  weightedrps <- function(weights) { 
    weights <- exp(weights)/sum(exp(weights))
    Reduce('+', lapply(predictionlist, function(x) {
    FUN(Reduce('+', lapply(1:length(weights), function(i){weights[i]*x[[i]]})), outcome)
    }))
  }
  
  res <- optim(exp(-startrps), weightedrps)
  
  exp(res$par)/sum(exp(res$par))
}
```

The function above should probably be wrapped in a proper function. If we run


```
optimize_weights2(list(list(m1, m2, m3, m4), list(M1, M2, M3, M4)), 1:4)
```

then we get the optimal weights across multiple tournaments.