# JumpDiffSim

<!-- badges: start -->
[![R-CMD-check](https://github.com/kennedy2244/JumpDiffTrial/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kennedy2244/JumpDiffTrial/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/kennedy2244/JumpDiffTrial/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/kennedy2244/JumpDiffTrial/actions/workflows/test-coverage.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

**JumpDiffSim** is an R package that implements the **Merton (1976)** and
**Kou (2002)** jump-diffusion models through a unified S4 object-oriented
interface. It provides exact compound-Poisson asset price simulation,
maximum-likelihood parameter estimation with Hessian-based standard errors,
Wald-type confidence intervals, theoretical moment calculations, and
publication-quality diagnostic plots — all designed to run entirely offline
without any dependency on live market data.

---

## Installation

Install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("kennedy2244/JumpDiffTrial")
```

Install a specific release version:

```r
devtools::install_github("kennedy2244/JumpDiffTrial@v0.1.0")
```

---

## Quick Start

The core workflow is three steps: **create a model → simulate paths → fit to data.**

```r
library(JumpDiffSim)

# ── Step 1: Create a Merton model object ─────────────────────
m <- MertonModel(
  mu      =  0.05,   # drift
  sigma   =  0.20,   # diffusion volatility
  lambda  =  1.00,   # average jumps per year
  mu_j    = -0.10,   # mean log-jump size
  sigma_j =  0.15    # std dev of log-jumps
)

show(m)
#> Merton Jump-Diffusion Model
#> ---------------------------
#>   mu      : 0.0500
#>   sigma   : 0.2000
#>   lambda  : 1.0000
#>   mu_j    : -0.1000
#>   sigma_j : 0.1500

# ── Step 2: Simulate 200 asset price paths ───────────────────
sim  <- simulateMerton(m, n = 200, T_ = 1, steps = 252, seed = 42)
plts <- diagnosticPlots(sim)

print(plts$fan_chart)   # path quantile fan (5/25/50/75/95th percentiles)
print(plts$density)     # empirical return density vs Normal
print(plts$acf_sq)      # ACF of squared log-returns

# ── Step 3: Fit model to synthetic data via MLE ──────────────
ret <- jdSampleData("merton", n = 500, seed = 42)
fit <- fitMerton(ret)

print(fit)
#> Merton MLE Fit Result
#> ---------------------
#>   Converged : TRUE
#>   Log-lik   : 487.2341
#>   Estimates (SE):
#>     mu       :  0.0489  (0.0021)
#>     sigma    :  0.1987  (0.0045)
#>     lambda   :  0.9823  (0.1234)
#>     mu_j     : -0.0998  (0.0187)
#>     sigma_j  :  0.1502  (0.0134)

confint(fit)
#>              2.5 %    97.5 %
#> mu       0.044710  0.053090
#> sigma    0.189896  0.207504
#> lambda   0.740434  1.224166
#> mu_j    -0.136443 -0.063157
#> sigma_j  0.123890  0.176510
```

---

## Parameters

| Parameter | Symbol | Description |
|-----------|--------|-------------|
| `mu` | $\mu$ | Drift — expected continuous return per unit time |
| `sigma` | $\sigma$ | Diffusion volatility of the Brownian component |
| `lambda` | $\lambda$ | Jump intensity — average number of jumps per year |
| `mu_j` | $\mu_J$ | Mean log-size of each jump |
| `sigma_j` | $\sigma_J$ | Standard deviation of log-jump sizes |

A **negative** `mu_j` with a positive `lambda` implies that jumps on
average reduce the asset price — consistent with the crash-risk
interpretation in Merton (1976).

---

## Theoretical Moments

```r
jumpMoments(m)
#>       mean   variance   skewness   kurtosis
#>   0.000489   0.046225  -0.003012   0.000451
```

Excess kurtosis greater than zero confirms that the Merton model generates
heavier tails than standard Geometric Brownian Motion.

---

## Package Structure

```
JumpDiffSim/
├── R/
│   ├── generics.R        # S4 generic function definitions
│   ├── merton_model.R    # MertonModel class + JDSimResult + JDFitResult
│   ├── merton_sim.R      # simulateMerton(), jdSampleData(), diagnosticPlots()
│   ├── merton_fit.R      # mertonLogLik(), fitMerton(), confint()
│   ├── utils.R           # jumpMoments()
│   ├── kou_model.R       # KouModel placeholder (v0.2.0)
│   ├── kou_sim.R         # simulateKou() placeholder (v0.2.0)
│   └── kou_fit.R         # fitKou() placeholder (v0.2.0)
├── tests/testthat/       # 36 unit tests (T1-T12 + TU1-TU2)
├── vignettes/            # Getting Started with JumpDiffSim
└── scaffolds/            # Team development scaffold files
```

---

## Test Coverage

| File | Coverage |
|------|----------|
| `R/utils.R` | 100.00% |
| `R/merton_sim.R` | 98.86% |
| `R/merton_fit.R` | 96.72% |
| `R/generics.R` | 14.29% |
| `R/merton_model.R` | 20.83% |
| **Overall** | **85.57%** |

R CMD check result: **0 errors \| 0 warnings \| 0 notes**

---

## Vignette

A full introduction to the package is available in the vignette:

```r
# After installation
vignette("JumpDiffSim-intro", package = "JumpDiffSim")
```

The vignette covers:

1. Why jump-diffusion? Motivation and model equation
2. Simulating asset price paths with `simulateMerton()`
3. Fitting the model to data with `fitMerton()`
4. Interpreting parameters
5. Theoretical moments with `jumpMoments()`

---

## Roadmap

| Version | Status | Features |
|---------|--------|----------|
| v0.1.0 | Released | Merton model — simulation, estimation, diagnostics, tests |
| v0.2.0 | Planned | Kou (2002) model — double-exponential jumps |
| v0.3.0 | Planned | Cross-model comparison vignette, CRAN submission |

---

## Team

This package was developed collaboratively by students in the Department
of Statistics, Yeungnam University, under the supervision of
**Professor Lee Kyungsub**.

| Member | Role |
|--------|------|
| Kennedy Kayaki | Package Lead · Estimation Module |
| Oh Dohyun | S4 Architect |
| Ju Seong Nyeon | Simulation Engine |
| Lee Se Eun | Unit Testing (T1–T9) |
| Yuri Shin | Coverage Reporting (T10–T12) |
| Choi Jiwoo | Vignette & README |

---

## References

- Merton, R.C. (1976). Option pricing when underlying stock returns are
  discontinuous. *Journal of Financial Economics*, 3(1–2), 125–144.
- Kou, S.G. (2002). A jump-diffusion model for option pricing.
  *Management Science*, 48(8), 1086–1101.
- Wickham, H. and Bryan, J. (2023). *R Packages* (2nd ed.). O'Reilly Media.
  <https://r-pkgs.org/>

---

## License

MIT © 2026 Kennedy Kayaki, Yeungnam University
