# Fit Model to Log-Returns via MLE

Fit Model to Log-Returns via MLE

## Usage

``` r
fit(object, log_returns, ...)
```

## Arguments

- object:

  A
  [JumpDiffModel](https://kennedy2244.github.io/JumpDiffSim/reference/JumpDiffModel-class.md)
  object.

- log_returns:

  Numeric vector of observed log returns.

- ...:

  Passed to [`optim`](https://rdrr.io/r/stats/optim.html).

## Value

A
[JDFitResult](https://kennedy2244.github.io/JumpDiffSim/reference/JDFitResult-class.md)
object.
