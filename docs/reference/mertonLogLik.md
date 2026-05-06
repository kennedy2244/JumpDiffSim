# Negative Log-Likelihood for the Merton Jump-Diffusion Model

Evaluates the negative log-likelihood of observing `log_returns` under
the Merton (1976) model. The density is approximated by a Gaussian
mixture truncated at `N_max = 50` terms.

## Usage

``` r
mertonLogLik(params, log_returns, dt = 1/252, N_max = 50L)
```

## Arguments

- params:

  Named numeric vector: `c(mu, sigma, lambda, mu_j, sigma_j)`.

- log_returns:

  Numeric vector of observed log asset returns.

- dt:

  Numeric. Length of each time step (default 1/252).

- N_max:

  Integer. Number of mixture terms (default 50).

## Value

Scalar. Negative log-likelihood. Returns `Inf` for invalid parameter
values.

## Examples

``` r
if (FALSE) { # \dontrun{
ret <- jdSampleData("merton", n = 200, seed = 42)
p   <- c(mu = 0.05, sigma = 0.2, lambda = 1, mu_j = -0.1, sigma_j = 0.15)
mertonLogLik(p, ret)
} # }
```
