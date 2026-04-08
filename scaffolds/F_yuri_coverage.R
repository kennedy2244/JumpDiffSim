# ============================================================
# JumpDiffTrial -- Student Scaffold
# Member  : Yuri Shin (F)
# Role    : Simulation Tests + Coverage Reporting (T10 - T12)
# Files   : tests/testthat/test-merton_sim.R
#           tests/testthat/test-utils.R
# Branch  : feature/yuri-coverage
# Week    : Week 3, Days 3-5
# ============================================================
# INSTRUCTIONS:
#   1. Open tests/testthat/test-merton_sim.R
#      Copy SECTION 1 into that file exactly as written
#   2. Open tests/testthat/test-utils.R
#      Copy SECTION 2 into that file exactly as written
#   3. Run devtools::test() to confirm all tests pass
#   4. Run the coverage commands in SECTION 3 in the Console
#   5. Paste the coverage output into your Pull Request
#   NOTE: Do NOT paste these into the R Console --
#         sections 1 and 2 belong inside the test files only
# ============================================================


# ── SECTION 1: test-merton_sim.R ─────────────────────────────
# Copy EVERYTHING between the dashes into
# tests/testthat/test-merton_sim.R

# ------------------------------------------------------------------
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
# ------------------------------------------------------------------


# ── SECTION 2: test-utils.R ──────────────────────────────────
# Copy EVERYTHING between the dashes into
# tests/testthat/test-utils.R

# ------------------------------------------------------------------
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
  expect_equal(jm["skewness"], 0, tolerance = 1e-10)
  expect_equal(jm["kurtosis"], 0, tolerance = 1e-10)
})
# ------------------------------------------------------------------


# ── SECTION 3: Coverage reporting ────────────────────────────
# Run these lines in the R Console tab (NOT inside any test file)
# Copy and paste them one at a time

# Step 1 -- Run all tests first
# devtools::test()

# Step 2 -- Measure package-wide coverage
# cov <- covr::package_coverage()

# Step 3 -- Print summary to console
# print(cov)

# Step 4 -- Open interactive HTML report in browser
# covr::report(cov)

# Step 5 -- Check a single file if coverage is low
# covr::file_coverage(
#   source_files = "R/utils.R",
#   test_files   = "tests/testthat/test-utils.R"
# )


# ── WHAT GOOD COVERAGE LOOKS LIKE ────────────────────────────
# After all tests from Lee Se Eun (T1-T9) and your tests
# (T10-T12, TU1-TU2) are in place, you should see something like:
#
#   JumpDiffSim Coverage: 83.24%
#   R/merton_model.R : 96.3%
#   R/merton_fit.R   : 88.5%
#   R/merton_sim.R   : 79.2%
#   R/utils.R        : 74.1%
#
# Target: overall >= 80%
# If any file is below 70%, open the HTML report and look for
# uncovered lines -- then add a small targeted test to cover them.


# ── HOW TO RUN YOUR TESTS ────────────────────────────────────
# In the R Console tab run:
#
#   devtools::test()
#
# You should see:
#   [ PASS  3 ] test-merton_sim.R
#   [ PASS  2 ] test-utils.R
#
# All 5 tests green before opening your Pull Request.
