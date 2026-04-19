library(JumpDiffSim)
library(testthat)

# TU1 -- jumpMoments: returns named finite numeric vector
test_that("jumpMoments() returns a named finite numeric vector", {
  m  <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 1,
                    mu_j = -0.1, sigma_j = 0.15)
  jm <- jumpMoments(m)
  expect_true(is.numeric(jm))
  expect_true(all(is.finite(jm)))
  expect_named(jm, c("mean", "variance", "skewness", "kurtosis"))
})

# TU2 -- jumpMoments: zero lambda gives zero skewness and kurtosis
test_that("jumpMoments() with lambda=0 gives zero skewness and kurtosis", {
  m  <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 0,
                    mu_j = 0, sigma_j = 0.1)
  jm <- jumpMoments(m)
  expect_equal(unname(jm["skewness"]), 0, tolerance = 1e-10)
  expect_equal(unname(jm["kurtosis"]), 0, tolerance = 1e-10)
})
