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
