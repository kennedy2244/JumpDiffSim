# ============================================================
# JumpDiffTrial -- Student Scaffold
# Member  : Kennedy Kayaki (A)
# Role    : Package Lead + Estimation Module
# Files   : R/merton_fit.R  |  R/utils.R
# Branch  : feature/kennedy-estimation
# Week    : Week 2, Days 2-5
# ============================================================
# INSTRUCTIONS:
#   1. Open R/merton_fit.R in RStudio
#   2. Copy SECTION 1 and SECTION 2 into that file
#   3. Open R/utils.R and copy SECTION 3 into that file
#   4. Run devtools::load_all() after each section
#   5. Run the verification block at the bottom when done
# ============================================================


# ── SECTION 1: Internal log-density helper ──────────────────
# Copy this into R/merton_fit.R  (MUST come first in the file)

# Internal: log-likelihood contribution for one observation
# Not exported -- for use by mertonLogLik() only
.merton_logdens <- function(r, dt, mu, sigma, lambda,
                            mu_j, sigma_j, N_max = 50L) {
  lambda_dt <- lambda * dt
  ns        <- 0:N_max
  log_w     <- dpois(ns, lambda = lambda_dt, log = TRUE)
  mu_n      <- (mu - 0.5 * sigma^2 - lambda * mu_j) * dt + ns * mu_j
  sigma2_n  <- sigma^2 * dt + ns * sigma_j^2
  log_terms <- log_w + dnorm(r, mean = mu_n,
                             sd = sqrt(sigma2_n), log = TRUE)
  m <- max(log_terms)
  m + log(sum(exp(log_terms - m)))   # log-sum-exp for stability
}


# ── SECTION 2: Exported estimation functions ─────────────────
# Copy this into R/merton_fit.R  (paste below Section 1)

#' Negative Log-Likelihood for the Merton Jump-Diffusion Model
#'
#' @description
#' Evaluates the negative log-likelihood of observing \code{log_returns}
#' under the Merton (1976) model. The density is approximated by a
#' Gaussian mixture truncated at \code{N_max = 50} terms.
#'
#' @param params      Named numeric vector:
#'   \code{c(mu, sigma, lambda, mu_j, sigma_j)}.
#' @param log_returns Numeric vector of observed log asset returns.
#' @param dt          Numeric. Length of each time step (default 1/252).
#' @param N_max       Integer. Number of mixture terms (default 50).
#'
#' @return Scalar. Negative log-likelihood. Returns \code{Inf} for
#'   invalid parameter values.
#'
#' @examples
#' ret <- jdSampleData("merton", n = 200, seed = 42)
#' p   <- c(mu = 0.05, sigma = 0.2, lambda = 1, mu_j = -0.1, sigma_j = 0.15)
#' mertonLogLik(p, ret)
#'
#' @export
mertonLogLik <- function(params, log_returns, dt = 1/252, N_max = 50L) {
  mu      <- params["mu"]
  sigma   <- params["sigma"]
  lambda  <- params["lambda"]
  mu_j    <- params["mu_j"]
  sigma_j <- params["sigma_j"]

  # Parameter guard: return Inf for invalid values
  if (!is.finite(sigma)   || sigma   <= 0) return(Inf)
  if (!is.finite(lambda)  || lambda  <  0) return(Inf)
  if (!is.finite(sigma_j) || sigma_j <= 0) return(Inf)

  ll <- sum(vapply(log_returns,
                   function(r) .merton_logdens(r, dt, mu, sigma, lambda,
                                               mu_j, sigma_j, N_max),
                   numeric(1)))
  -ll  # return NEGATIVE log-likelihood for minimisation
}


#' Fit Merton Jump-Diffusion Model via MLE
#'
#' @description
#' Maximises the log-likelihood of the Merton (1976) model using
#' L-BFGS-B optimisation. Returns a \linkS4class{JDFitResult} object
#' containing parameter estimates, standard errors, and convergence info.
#'
#' @param log_returns Numeric vector of observed log asset returns.
#' @param start       Named numeric vector of starting values.
#'   Defaults to \code{c(mu=0.05, sigma=0.20, lambda=1,
#'   mu_j=-0.10, sigma_j=0.15)}.
#' @param dt          Numeric. Time step length (default 1/252).
#' @param N_max       Integer. Mixture truncation (default 50).
#' @param verbose     Logical. Print progress? (default FALSE).
#'
#' @return A \linkS4class{JDFitResult} object.
#'
#' @examples
#' ret <- jdSampleData("merton", n = 500, seed = 42)
#' fit <- fitMerton(ret, verbose = TRUE)
#' print(fit)
#' confint(fit)
#'
#' @importFrom stats optim
#' @importFrom numDeriv hessian
#' @export
fitMerton <- function(log_returns,
                      start   = c(mu = 0.05, sigma = 0.20, lambda = 1,
                                  mu_j = -0.10, sigma_j = 0.15),
                      dt      = 1/252,
                      N_max   = 50L,
                      verbose = FALSE) {

  obj <- function(p) mertonLogLik(p, log_returns, dt, N_max)

  opt <- tryCatch(
    optim(
      par     = start,
      fn      = obj,
      method  = "L-BFGS-B",
      lower   = c(mu = -Inf, sigma = 1e-6, lambda = 0,
                  mu_j = -Inf, sigma_j = 1e-6),
      control = list(maxit = 5000L, factr = 1e7)
    ),
    error = function(e) list(convergence = 99, par = start, value = Inf)
  )

  converged <- (opt$convergence == 0)
  if (verbose) {
    cat(if (converged) "Converged.\n" else "WARNING: did not converge.\n")
  }

  # Hessian-based standard errors
  H  <- tryCatch(
    numDeriv::hessian(obj, opt$par),
    error = function(e) matrix(NA, 5, 5)
  )
  se <- tryCatch(
    sqrt(diag(solve(H + 1e-6 * diag(nrow(H))))),
    error = function(e) rep(NA_real_, 5)
  )
  names(se) <- names(opt$par)

  new("JDFitResult",
      estimates  = opt$par,
      se         = se,
      loglik     = -opt$value,
      converged  = converged,
      model_type = "Merton")
}


#' @describeIn JDFitResult Wald-type 95\% confidence intervals.
#' @param object A \linkS4class{JDFitResult} object.
#' @param parm   Ignored (all parameters returned).
#' @param level  Confidence level (default 0.95).
#' @param ...    Unused.
#' @export
setMethod("confint", "JDFitResult",
          function(object, parm, level = 0.95, ...) {
            z   <- qnorm(1 - (1 - level) / 2)
            lo  <- object@estimates - z * object@se
            hi  <- object@estimates + z * object@se
            out <- cbind(lo, hi)
            colnames(out) <- c(
              paste0(round((1 - level) / 2 * 100, 1), " %"),
              paste0(round((1 + level) / 2 * 100, 1), " %")
            )
            out
          }
)


# ── SECTION 3: Utility functions ─────────────────────────────
# Copy this into R/utils.R

#' Theoretical Moments of the Merton Jump-Diffusion Log-Return
#'
#' @description
#' Returns the theoretical mean, variance, skewness, and excess kurtosis
#' of the log-return distribution under the Merton (1976) model.
#'
#' @param object A \linkS4class{MertonModel} object.
#' @return Named numeric vector with elements
#'   \code{mean}, \code{variance}, \code{skewness}, \code{kurtosis}.
#'
#' @examples
#' m <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 1,
#'                  mu_j = -0.10, sigma_j = 0.15)
#' jumpMoments(m)
#'
#' @export
setMethod("jumpMoments", "MertonModel", function(object) {
  mu      <- object@mu
  sigma   <- object@sigma
  lambda  <- object@lambda
  mu_j    <- object@mu_j
  sigma_j <- object@sigma_j

  # Per unit time (dt = 1)
  mean_r   <- mu - 0.5 * sigma^2 - lambda * mu_j + lambda * mu_j
  var_r    <- sigma^2 + lambda * (mu_j^2 + sigma_j^2)
  skew_r   <- lambda * (mu_j^3 + 3 * mu_j * sigma_j^2) / var_r^1.5
  kurt_r   <- lambda * (mu_j^4 + 6 * mu_j^2 * sigma_j^2 +
                          3 * sigma_j^4) / var_r^2

  c(mean     = mean_r,
    variance = var_r,
    skewness = skew_r,
    kurtosis = kurt_r)   # excess kurtosis from jump component
})


# ── VERIFICATION: Run this after devtools::load_all() ────────
# Copy these lines into the R Console tab (not into any R/ file)

if (FALSE) {
  devtools::load_all()

  # Test mertonLogLik
  ret <- jdSampleData("merton", n = 200, seed = 42)
  p   <- c(mu = 0.05, sigma = 0.20, lambda = 1,
           mu_j = -0.1, sigma_j = 0.15)
  ll  <- mertonLogLik(p, ret)
  cat("mertonLogLik:", ll, "\n")           # should be a finite positive number

  # Test fitMerton
  ret2 <- jdSampleData("merton", n = 500, seed = 42)
  fit  <- fitMerton(ret2, verbose = TRUE)
  print(fit)
  print(confint(fit))

  # Test jumpMoments
  m <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 1,
                   mu_j = -0.10, sigma_j = 0.15)
  print(jumpMoments(m))
}
