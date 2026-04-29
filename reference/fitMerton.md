# Fit Merton Jump-Diffusion Model via MLE

Maximises the log-likelihood of the Merton (1976) model using L-BFGS-B
optimisation. Returns a
[JDFitResult](https://kennedy2244.github.io/JumpDiffSim/reference/JDFitResult-class.md)
object containing parameter estimates, standard errors, and convergence
info.

## Usage

``` r
fitMerton(
  log_returns,
  start = c(mu = 0.05, sigma = 0.2, lambda = 1, mu_j = -0.1, sigma_j = 0.15),
  dt = 1/252,
  N_max = 50L,
  verbose = FALSE
)
```

## Arguments

- log_returns:

  Numeric vector of observed log asset returns.

- start:

  Named numeric vector of starting values. Defaults to
  `c(mu=0.05, sigma=0.20, lambda=1, mu_j=-0.10, sigma_j=0.15)`.

- dt:

  Numeric. Time step length (default 1/252).

- N_max:

  Integer. Mixture truncation (default 50).

- verbose:

  Logical. Print progress? (default FALSE).

## Value

A
[JDFitResult](https://kennedy2244.github.io/JumpDiffSim/reference/JDFitResult-class.md)
object.

## Examples

``` r
if (FALSE) { # \dontrun{
ret <- jdSampleData("merton", n = 500, seed = 42)
fit <- fitMerton(ret, verbose = TRUE)
print(fit)
confint(fit)
} # }
```
