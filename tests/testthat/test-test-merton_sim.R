library(JumpDiffSim)
library(testthat)

# T10 -- dimensions: paths matrix has correct rows and columns
test_that("simulateMerton() returns JDSimResult with correct dims", {
  m   <- MertonModel()
  sim <- simulateMerton(m, n = 50, T_ = 1, steps = 100)
  expect_s4_class(sim, "JDSimResult")
  expect_equal(nrow(sim@paths), 50)
  expect_equal(ncol(sim@paths), 101)   # steps + 1 (includes time 0)
})

# T11 -- reproducibility: same seed produces identical paths
test_that("simulateMerton() is reproducible with seed", {
  m    <- MertonModel()
  sim1 <- simulateMerton(m, n = 20, T_ = 1, steps = 50, seed = 7)
  sim2 <- simulateMerton(m, n = 20, T_ = 1, steps = 50, seed = 7)
  expect_identical(sim1@paths, sim2@paths)
})

# T12 -- diagnosticPlots: returns named list of 3 ggplot objects
test_that("diagnosticPlots() returns a named list of 3 ggplot objects", {
  m    <- MertonModel()
  sim  <- simulateMerton(m, n = 50, T_ = 1, steps = 100)
  plts <- diagnosticPlots(sim)
  expect_type(plts, "list")
  expect_length(plts, 3)
  expect_named(plts, c("fan_chart", "density", "acf_sq"))
  expect_s3_class(plts$fan_chart, "gg")
  expect_s3_class(plts$density,   "gg")
  expect_s3_class(plts$acf_sq,    "gg")
})
