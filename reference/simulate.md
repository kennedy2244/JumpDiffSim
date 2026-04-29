# Simulate Asset Price Paths

Simulate Asset Price Paths

## Usage

``` r
simulate(object, n, T_, steps, seed = NULL, ...)
```

## Arguments

- object:

  A
  [JumpDiffModel](https://kennedy2244.github.io/JumpDiffSim/reference/JumpDiffModel-class.md)
  object.

- n:

  Integer. Number of simulated paths.

- T\_:

  Positive numeric. Time horizon in years.

- steps:

  Positive integer. Number of time steps.

- seed:

  Optional integer seed for reproducibility.

- ...:

  Additional arguments passed to methods.

## Value

A
[JDSimResult](https://kennedy2244.github.io/JumpDiffSim/reference/JDSimResult-class.md)
object.
