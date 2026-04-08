# ============================================================
# JumpDiffTrial -- Student Scaffold
# Member  : Ju Seong Nyeon (C)
# Role    : Simulation Engine
# Files   : R/merton_sim.R
# Branch  : feature/juseong-simulation
# Week    : Week 2, Days 1-4
# ============================================================
# INSTRUCTIONS:
#   1. Open R/merton_sim.R in RStudio
#   2. Copy ALL sections below into that file in order
#   3. Run devtools::load_all() after pasting
#   4. Run the verification block at the bottom when done
# ============================================================


# ── SECTION 1: Internal step functions ───────────────────────
# These are internal helpers -- not exported, no @export tag

# One-step exact compound-Poisson simulation
# Returns a single log-return for time step dt
.merton_step <- function(mu, sigma, lambda, mu_j, sigma_j,
                         dt, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  # 1. Sample number of jumps in this interval
  n_jumps <- rpois(1, lambda * dt)

  # 2. Sample Brownian component
  z <- rnorm(1, mean = 0, sd = sqrt(dt))
  diffusion_part <- (mu - 0.5 * sigma^2 - lambda * mu_j) * dt +
    sigma * z

  # 3. Sample jump component (sum of n_jumps log-normal jumps)
  jump_part <- if (n_jumps > 0) {
    sum(rnorm(n_jumps, mean = mu_j, sd = sigma_j))
  } else {
    0
  }

  diffusion_part + jump_part
}

# Simulate a full price path of length (steps + 1)
# Returns a numeric vector starting at S0
.merton_path <- function(mu, sigma, lambda, mu_j, sigma_j,
                         T_, steps, S0 = 1) {
  dt     <- T_ / steps
  prices <- numeric(steps + 1)
  prices[1] <- S0

  for (i in seq_len(steps)) {
    r           <- .merton_step(mu, sigma, lambda, mu_j, sigma_j, dt)
    prices[i+1] <- prices[i] * exp(r)
  }
  prices
}


# ── SECTION 2: simulateMerton() -- exported ──────────────────

#' Simulate Merton Jump-Diffusion Asset Paths
#'
#' @description
#' Generates \code{n} exact compound-Poisson asset price paths under the
#' Merton (1976) jump-diffusion model. Simulation is exact in the sense
#' that jump arrivals are drawn directly from the Poisson process rather
#' than approximated via Euler discretisation.
#'
#' @param object A \linkS4class{MertonModel} object.
#' @param n      Integer. Number of paths to simulate.
#' @param T_     Positive numeric. Time horizon in years (default 1).
#' @param steps  Positive integer. Number of time steps (default 252).
#' @param S0     Numeric. Initial asset price (default 1).
#' @param seed   Optional integer. Random seed for reproducibility.
#' @param ...    Unused.
#' @return A \linkS4class{JDSimResult} object.
#'
#' @examples
#' m   <- MertonModel()
#' sim <- simulateMerton(m, n = 200, T_ = 1, steps = 252, seed = 42)
#' dim(sim@paths)   # should be 200 x 253
#'
#' @importFrom stats rpois rnorm
#' @export
simulateMerton <- function(object, n = 100, T_ = 1, steps = 252,
                           S0 = 1, seed = NULL, ...) {
  if (!is.null(seed)) set.seed(seed)

  mu      <- object@mu
  sigma   <- object@sigma
  lambda  <- object@lambda
  mu_j    <- object@mu_j
  sigma_j <- object@sigma_j

  # Simulate n paths -- each row is one path
  paths <- matrix(NA_real_, nrow = n, ncol = steps + 1)
  for (i in seq_len(n)) {
    paths[i, ] <- .merton_path(mu, sigma, lambda, mu_j, sigma_j,
                               T_, steps, S0)
  }

  times <- seq(0, T_, length.out = steps + 1)

  new("JDSimResult",
      paths      = paths,
      times      = times,
      params     = list(mu = mu, sigma = sigma, lambda = lambda,
                        mu_j = mu_j, sigma_j = sigma_j,
                        T_ = T_, steps = steps, S0 = S0, n = n),
      model_type = "Merton")
}


# ── SECTION 3: jdSampleData() -- exported ────────────────────

#' Generate Synthetic Log-Returns from a Jump-Diffusion Model
#'
#' @description
#' Convenience function for generating reproducible synthetic log-returns
#' for use in examples, tests, and vignettes. All package examples and
#' tests use this function to avoid any dependency on live market data.
#'
#' @param model Character. Model type: \code{"merton"} (default).
#' @param n     Integer. Number of log-returns to generate (default 500).
#' @param mu      Numeric. Drift (default 0.05).
#' @param sigma   Positive numeric. Diffusion vol (default 0.20).
#' @param lambda  Non-negative numeric. Jump intensity (default 1).
#' @param mu_j    Numeric. Mean log-jump (default -0.10).
#' @param sigma_j Positive numeric. Std dev of log-jumps (default 0.15).
#' @param dt      Numeric. Time step (default 1/252).
#' @param seed    Integer. Random seed (default 42).
#'
#' @return Numeric vector of \code{n} log-returns.
#'
#' @examples
#' ret <- jdSampleData()
#' ret <- jdSampleData("merton", n = 200, seed = 7)
#' hist(ret, breaks = 40, main = "Synthetic Merton Returns")
#'
#' @importFrom stats rpois rnorm
#' @export
jdSampleData <- function(model   = "merton",
                         n       = 500,
                         mu      =  0.05,
                         sigma   =  0.20,
                         lambda  =  1.00,
                         mu_j    = -0.10,
                         sigma_j =  0.15,
                         dt      =  1/252,
                         seed    =  42L) {
  set.seed(seed)
  model <- match.arg(model, "merton")

  replicate(n, .merton_step(mu, sigma, lambda, mu_j, sigma_j, dt))
}


# ── SECTION 4: diagnosticPlots() -- exported ─────────────────

#' Diagnostic Plots for a JDSimResult Object
#'
#' @description
#' Returns a named list of three \pkg{ggplot2} objects:
#' \describe{
#'   \item{\code{fan_chart}}{Simulated path quantile fan (5\%, 25\%,
#'     median, 75\%, 95\%).}
#'   \item{\code{density}}{Histogram of terminal log-returns vs normal.}
#'   \item{\code{acf_sq}}{ACF of squared log-returns with 95\% CI.}
#' }
#'
#' @param object A \linkS4class{JDSimResult} object.
#' @return Named list of three \code{ggplot} objects.
#'
#' @examples
#' m    <- MertonModel()
#' sim  <- simulateMerton(m, n = 50, T_ = 1, steps = 100)
#' plts <- diagnosticPlots(sim)
#' print(plts$fan_chart)
#' print(plts$density)
#' print(plts$acf_sq)
#'
#' @importFrom ggplot2 ggplot aes geom_line geom_ribbon geom_histogram
#'   geom_density geom_col geom_hline labs theme_minimal after_stat
#' @importFrom stats acf dnorm sd
#' @importFrom utils globalVariables
#' @export
diagnosticPlots <- function(object) {

  utils::globalVariables(c("t", "r", "lag", "acf",
                           "q05", "q25", "median", "q75", "q95"))

  paths <- object@paths
  times <- object@times
  n     <- nrow(paths)

  # --- Fan chart ---------------------------------------------------
  qs <- apply(paths, 2, quantile,
              probs = c(0.05, 0.25, 0.50, 0.75, 0.95), na.rm = TRUE)
  df_fan <- data.frame(
    t      = times,
    q05    = qs[1, ], q25 = qs[2, ],
    median = qs[3, ],
    q75    = qs[4, ], q95 = qs[5, ]
  )

  p1 <- ggplot2::ggplot(df_fan, ggplot2::aes(x = t)) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = q05, ymax = q95),
                         fill = "steelblue", alpha = 0.15) +
    ggplot2::geom_ribbon(ggplot2::aes(ymin = q25, ymax = q75),
                         fill = "steelblue", alpha = 0.25) +
    ggplot2::geom_line(ggplot2::aes(y = median),
                       colour = "navy", linewidth = 0.8) +
    ggplot2::labs(title = "Simulated Path Fan Chart",
                  subtitle = "Bands: 5/25/75/95th percentiles; line: median",
                  x = "Time (years)", y = "Asset price") +
    ggplot2::theme_minimal()

  # --- Return density vs Normal ------------------------------------
  log_ret <- as.vector(diff(t(log(paths))))
  df_ret  <- data.frame(r = log_ret)

  p2 <- ggplot2::ggplot(df_ret, ggplot2::aes(x = r)) +
    ggplot2::geom_histogram(ggplot2::aes(y = ggplot2::after_stat(density)),
                            bins = 60, fill = "steelblue",
                            colour = "white", alpha = 0.7) +
    ggplot2::geom_line(stat = "function",
                       fun  = dnorm,
                       args = list(mean = mean(log_ret), sd = sd(log_ret)),
                       colour = "firebrick", linewidth = 0.9) +
    ggplot2::labs(title = "Empirical Return Density vs Normal",
                  x = "Log-return", y = "Density") +
    ggplot2::theme_minimal()

  # --- ACF of squared log-returns ----------------------------------
  acf_obj  <- acf(log_ret^2, lag.max = 30, plot = FALSE)
  ci_bound <- qnorm(0.975) / sqrt(length(log_ret))
  df_acf   <- data.frame(
    lag = as.numeric(acf_obj$lag[-1]),
    acf = as.numeric(acf_obj$acf[-1])
  )

  p3 <- ggplot2::ggplot(df_acf, ggplot2::aes(x = lag, y = acf)) +
    ggplot2::geom_col(fill = "#1B5E20", alpha = 0.7, width = 0.6) +
    ggplot2::geom_hline(yintercept = c(-ci_bound, ci_bound),
                        colour = "#B71C1C", linetype = "dashed") +
    ggplot2::labs(title = "ACF of Squared Log-Returns",
                  subtitle = "Bars outside dashed lines = significant autocorrelation",
                  x = "Lag", y = "ACF") +
    ggplot2::theme_minimal()

  list(fan_chart = p1, density = p2, acf_sq = p3)
}


# ── VERIFICATION: Run in R Console tab only ──────────────────
if (FALSE) {
  devtools::load_all()

  # Test simulateMerton dimensions
  m   <- MertonModel()
  sim <- simulateMerton(m, n = 50, T_ = 1, steps = 100, seed = 42)
  cat("Paths dim:", dim(sim@paths), "\n")      # should be 50 x 101

  # Test reproducibility
  sim1 <- simulateMerton(m, n = 20, T_ = 1, steps = 50, seed = 7)
  sim2 <- simulateMerton(m, n = 20, T_ = 1, steps = 50, seed = 7)
  cat("Reproducible:", identical(sim1@paths, sim2@paths), "\n")  # TRUE

  # Test jdSampleData
  ret <- jdSampleData("merton", n = 200, seed = 42)
  cat("Sample data length:", length(ret), "\n")   # 200

  # Test diagnosticPlots
  plts <- diagnosticPlots(sim)
  cat("Plot names:", names(plts), "\n")   # fan_chart density acf_sq
  print(plts$fan_chart)
}
