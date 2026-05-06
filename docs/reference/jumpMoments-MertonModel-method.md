# Theoretical Moments of the Merton Jump-Diffusion Log-Return

Returns the theoretical mean, variance, skewness, and excess kurtosis of
the log-return distribution under the Merton (1976) model.

## Usage

``` r
# S4 method for class 'MertonModel'
jumpMoments(object)
```

## Arguments

- object:

  A
  [MertonModel](https://kennedy2244.github.io/JumpDiffSim/reference/MertonModel-class.md)
  object.

## Value

Named numeric vector with elements `mean`, `variance`, `skewness`,
`kurtosis`.

## Examples

``` r
m <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 1,
                 mu_j = -0.10, sigma_j = 0.15)
jumpMoments(m)
#>       mean   variance   skewness   kurtosis 
#>  0.0300000  0.0725000 -0.3970038  0.5648038 
```
