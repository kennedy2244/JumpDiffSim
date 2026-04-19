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
