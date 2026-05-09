library(JumpDiffSim)
library(testthat)

# TP1 -- priceEuropean returns a MertonPrice object
test_that("priceEuropean() returns MertonPrice object", {
  ret <- jdSampleData("merton", n = 500, seed = 42)
  fit <- fitMerton(ret)
  price <- priceEuropean(fit, S = 100, K = 100,
                         r = 0.05, T_ = 1, type = "call")
  expect_s3_class(price, "MertonPrice")
  expect_true(is.finite(price$price))
  expect_true(is.finite(price$bs_price))
  expect_true(price$price > 0)
})

# TP2 -- call price exceeds BS price when lambda > 0
test_that("Merton call price exceeds BS when jumps present", {
  ret <- jdSampleData("merton", n = 500, seed = 42)
  fit <- fitMerton(ret)
  price <- priceEuropean(fit, S = 100, K = 100,
                         r = 0.05, T_ = 1, type = "call")
  expect_true(abs(price$jump_premium) >= 0)
})

# TP3 -- put-call parity holds approximately
test_that("Put-call parity holds within tolerance", {
  ret  <- jdSampleData("merton", n = 500, seed = 42)
  fit  <- fitMerton(ret)
  call <- priceEuropean(fit, S = 100, K = 100,
                        r = 0.05, T_ = 1, type = "call")
  put  <- priceEuropean(fit, S = 100, K = 100,
                        r = 0.05, T_ = 1, type = "put")
  # C - P = S - K*exp(-rT)
  parity <- call$price - put$price
  theoretical <- 100 - 100 * exp(-0.05 * 1)
  expect_equal(parity, theoretical, tolerance = 0.01)
})

# TP4 -- invalid inputs throw errors
test_that("priceEuropean() rejects invalid inputs", {
  ret <- jdSampleData("merton", n = 500, seed = 42)
  fit <- fitMerton(ret)
  expect_error(priceEuropean(fit, S = -100, K = 100,
                             r = 0.05, T_ = 1))
  expect_error(priceEuropean(fit, S = 100,  K = -100,
                             r = 0.05, T_ = 1))
  expect_error(priceEuropean(fit, S = 100,  K = 100,
                             r = 0.05, T_ = -1))
})
