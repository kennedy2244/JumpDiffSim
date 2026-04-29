# Generate Synthetic Log-Returns from a Jump-Diffusion Model

Convenience function for generating reproducible synthetic log-returns
for use in examples, tests, and vignettes. All package examples and
tests use this function to avoid any dependency on live market data.

## Usage

``` r
jdSampleData(
  model = "merton",
  n = 500,
  mu = 0.05,
  sigma = 0.2,
  lambda = 1,
  mu_j = -0.1,
  sigma_j = 0.15,
  dt = 1/252,
  seed = 42L
)
```

## Arguments

- model:

  Character. Model type: `"merton"` (default).

- n:

  Integer. Number of log-returns to generate (default 500).

- mu:

  Numeric. Drift (default 0.05).

- sigma:

  Positive numeric. Diffusion vol (default 0.20).

- lambda:

  Non-negative numeric. Jump intensity (default 1).

- mu_j:

  Numeric. Mean log-jump (default -0.10).

- sigma_j:

  Positive numeric. Std dev of log-jumps (default 0.15).

- dt:

  Numeric. Time step (default 1/252).

- seed:

  Integer. Random seed (default 42).

## Value

Numeric vector of `n` log-returns.

## Examples

``` r
ret <- jdSampleData()
ret <- jdSampleData("merton", n = 200, seed = 7)
hist(ret, breaks = 40, main = "Synthetic Merton Returns")

```
