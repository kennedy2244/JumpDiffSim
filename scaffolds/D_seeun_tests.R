# ============================================================
# JumpDiffTrial -- Student Scaffold
# Member  : Lee Se Eun (D)
# Role    : Unit Testing (T1 - T9)
# Files   : tests/testthat/test-merton_model.R
#           tests/testthat/test-merton_fit.R
# Branch  : feature/seeun-tests
# Week    : Week 3, Days 2-4
# ============================================================
# INSTRUCTIONS:
#   1. Open tests/testthat/test-merton_model.R
#      Copy SECTION 1 into that file exactly as written
#   2. Open tests/testthat/test-merton_fit.R
#      Copy SECTION 2 into that file exactly as written
#   3. Run devtools::test() after each section
#   4. All tests must pass (green) before opening your PR
#   NOTE: Do NOT paste these into the R Console --
#         they belong inside the test files only
# ============================================================


# ── SECTION 1: test-merton_model.R ───────────────────────────
# Copy EVERYTHING between the dashes into
# tests/testthat/test-merton_model.R

# ------------------------------------------------------------------
library(JumpDiffSim)
library(testthat)

# T1 -- valid constructor: correct class inheritance
test_that("MertonModel() returns correct S4 class", {
  m <- MertonModel(mu = 0.05, sigma = 0.20,
                   lambda = 1, mu_j = -0.1, sigma_j = 0.15)
  expect_s4_class(m, "MertonModel")
  expect_true(is(m, "JumpDiffModel"))   # must inherit virtual base
  expect_equal(m@sigma,  0.20)
  expect_equal(m@lambda, 1)
})

# T2 -- sigma guard: reject zero and negative diffusion volatility
test_that("MertonModel() rejects sigma <= 0", {
  expect_error(
    MertonModel(mu = 0, sigma = -0.1, lambda = 1,
                mu_j = 0, sigma_j = 0.1),
    regexp = "sigma"
  )
  expect_error(
    MertonModel(mu = 0, sigma = 0, lambda = 1,
                mu_j = 0, sigma_j = 0.1),
    regexp = "sigma"
  )
})

# T3 -- lambda guard: reject negative jump intensity
test_that("MertonModel() rejects lambda < 0", {
  expect_error(
    MertonModel(mu = 0, sigma = 0.2, lambda = -1,
                mu_j = 0, sigma_j = 0.1),
    regexp = "lambda"
  )
})

# T4 -- sigma_j guard: reject zero and negative jump volatility
test_that("MertonModel() rejects sigma_j <= 0", {
  expect_error(
    MertonModel(mu = 0, sigma = 0.2, lambda = 1,
                mu_j = 0, sigma_j = -0.05),
    regexp = "sigma_j"
  )
})
# ------------------------------------------------------------------


# ── SECTION 2: test-merton_fit.R ─────────────────────────────
# Copy EVERYTHING between the dashes into
# tests/testthat/test-merton_fit.R

# ------------------------------------------------------------------
library(JumpDiffSim)
library(testthat)

# T5 -- log-likelihood: finite scalar for valid parameters
test_that("mertonLogLik() returns finite scalar for valid params", {
  ret <- jdSampleData("merton", n = 200, seed = 42)
  p   <- c(mu = 0.05, sigma = 0.20, lambda = 1,
           mu_j = -0.1, sigma_j = 0.15)
  ll  <- mertonLogLik(p, ret)
  expect_true(is.finite(ll))
  expect_true(is.numeric(ll) && length(ll) == 1)
})

# T6 -- log-likelihood guard: return Inf for invalid sigma
test_that("mertonLogLik() returns Inf for sigma <= 0", {
  ret   <- jdSampleData("merton", n = 200, seed = 42)
  p_bad <- c(mu = 0, sigma = -0.1, lambda = 1,
             mu_j = 0, sigma_j = 0.1)
  ll_bad <- mertonLogLik(p_bad, ret)
  expect_true(!is.finite(ll_bad) || ll_bad == Inf)
})

# T7 -- fitMerton: convergence on synthetic data
test_that("fitMerton() converges on synthetic data", {
  ret <- jdSampleData("merton", n = 500, seed = 42)
  fit <- fitMerton(ret)
  expect_s4_class(fit, "JDFitResult")
  expect_true(fit@converged)
  expect_true(is.finite(fit@loglik))
})

# T8 -- parameter recovery: lambda within 25% of true value
test_that("fitMerton() recovers lambda within 25%", {
  ret <- jdSampleData("merton", n = 1000, seed = 42)
  fit <- fitMerton(ret)
  expect_lt(abs(fit@estimates["lambda"] - 1.0) / 1.0, 0.25)
})

# T9 -- confint: valid 5x2 matrix with lower <= upper
test_that("confint() returns a 2-column finite matrix", {
  ret <- jdSampleData("merton", n = 500, seed = 42)
  fit <- fitMerton(ret)
  ci  <- confint(fit)
  expect_equal(ncol(ci), 2)
  expect_true(all(is.finite(ci) | is.na(ci)))   # NA ok if Hessian singular
  expect_true(all(ci[, 1] <= ci[, 2], na.rm = TRUE))
})
# ------------------------------------------------------------------


# ── HOW TO RUN YOUR TESTS ────────────────────────────────────
# In the R Console tab run:
#
#   devtools::test()
#
# You should see:
#   [ PASS  4 ] test-merton_model.R
#   [ PASS  5 ] test-merton_fit.R
#
# All 9 tests green before opening your Pull Request.
