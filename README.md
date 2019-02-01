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

optimize_weights(1:4, list(m1, m2, m3, m4))

```