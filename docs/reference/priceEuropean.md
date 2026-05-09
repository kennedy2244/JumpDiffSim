# Price a European Option under the Merton Jump-Diffusion Model

Computes the European call or put price under the Merton (1976)
jump-diffusion model using the analytic series expansion. The price is
expressed as a Poisson-weighted sum of Black-Scholes prices with
jump-adjusted drift and volatility.

The formula is: \$\$C = \sum\_{n=0}^{N} \frac{e^{-\lambda' T}(\lambda'
T)^n}{n!} \cdot BS(S, K, r_n, \sigma_n, T)\$\$ where \\\lambda' =
\lambda(1 + \bar\mu_J)\\, \\r_n = r - \lambda\bar\mu_J +
n\log(1+\bar\mu_J)/T\\, and \\\sigma_n^2 = \sigma^2 + n\sigma_J^2/T\\.

## Usage

``` r
priceEuropean(
  fit,
  S = 100,
  K = 100,
  r = 0.05,
  T_ = 1,
  type = "call",
  N_max = 50L
)
```

## Arguments

- fit:

  A
  [JDFitResult](https://kennedy2244.github.io/JumpDiffSim/reference/JDFitResult-class.md)
  object from
  [`fitMerton`](https://kennedy2244.github.io/JumpDiffSim/reference/fitMerton.md).

- S:

  Positive numeric. Current asset price.

- K:

  Positive numeric. Strike price.

- r:

  Numeric. Continuously compounded risk-free rate.

- T\_:

  Positive numeric. Time to expiry in years.

- type:

  Character. Either `"call"` or `"put"`.

- N_max:

  Integer. Number of series terms (default 50).

## Value

A named list with elements:

- price:

  Merton jump-diffusion option price.

- bs_price:

  Black-Scholes benchmark price (no jumps).

- jump_premium:

  Difference between Merton and BS price.

- params:

  List of inputs and fitted parameters used.

## References

Merton, R.C. (1976). Option pricing when underlying stock returns are
discontinuous. *Journal of Financial Economics*, 3(1-2), 125-144.

## Examples

``` r
if (FALSE) { # \dontrun{
ret <- jdSampleData("merton", n = 500, seed = 42)
fit <- fitMerton(ret)
price <- priceEuropean(fit, S = 100, K = 100,
                       r = 0.05, T_ = 1, type = "call")
print(price)
} # }
```
