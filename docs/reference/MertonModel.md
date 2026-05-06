# Create a MertonModel Object

Create a MertonModel Object

## Usage

``` r
MertonModel(mu = 0.05, sigma = 0.2, lambda = 1, mu_j = -0.1, sigma_j = 0.15)
```

## Arguments

- mu:

  Numeric. Drift (default 0.05).

- sigma:

  Positive numeric. Diffusion volatility (default 0.20).

- lambda:

  Non-negative numeric. Jump intensity (default 1).

- mu_j:

  Numeric. Mean log-jump size (default -0.10).

- sigma_j:

  Positive numeric. Std dev of log-jumps (default 0.15).

## Value

A validated
[MertonModel](https://kennedy2244.github.io/JumpDiffSim/reference/MertonModel-class.md)
object.

## Examples

``` r
m <- MertonModel()
m <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 1,
                 mu_j = -0.10, sigma_j = 0.15)
```
