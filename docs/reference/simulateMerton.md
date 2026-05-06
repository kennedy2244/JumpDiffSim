# Simulate Merton Jump-Diffusion Asset Paths

Generates `n` exact compound-Poisson asset price paths under the Merton
(1976) jump-diffusion model. Simulation is exact in the sense that jump
arrivals are drawn directly from the Poisson process rather than
approximated via Euler discretisation.

## Usage

``` r
simulateMerton(object, n = 100, T_ = 1, steps = 252, S0 = 1, seed = NULL, ...)
```

## Arguments

- object:

  A
  [MertonModel](https://kennedy2244.github.io/JumpDiffSim/reference/MertonModel-class.md)
  object.

- n:

  Integer. Number of paths to simulate.

- T\_:

  Positive numeric. Time horizon in years (default 1).

- steps:

  Positive integer. Number of time steps (default 252).

- S0:

  Numeric. Initial asset price (default 1).

- seed:

  Optional integer. Random seed for reproducibility.

- ...:

  Unused.

## Value

A
[JDSimResult](https://kennedy2244.github.io/JumpDiffSim/reference/JDSimResult-class.md)
object.

## Examples

``` r
m   <- MertonModel()
sim <- simulateMerton(m, n = 200, T_ = 1, steps = 252, seed = 42)
dim(sim@paths)   # should be 200 x 253
#> [1] 200 253
```
