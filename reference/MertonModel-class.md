# MertonModel: Merton (1976) Jump-Diffusion Model

Extends
[JumpDiffModel](https://kennedy2244.github.io/JumpDiffSim/reference/JumpDiffModel-class.md)
with log-normal jump parameters.

## Usage

``` r
# S4 method for class 'MertonModel'
show(object)
```

## Arguments

- object:

  A MertonModel object.

## Slots

- `mu_j`:

  Numeric. Mean log-jump size.

- `sigma_j`:

  Positive numeric. Std dev of log-jump sizes.

## References

Merton, R.C. (1976). Option pricing when underlying stock returns are
discontinuous. *Journal of Financial Economics*, 3(1-2), 125-144.
