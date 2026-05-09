# ============================================================
# merton_price.R
# European option pricing under Merton (1976) jump-diffusion
# Author: Kennedy Kayaki
# ============================================================

# Internal: Black-Scholes call price
.bs_call <- function(S, K, r, sigma, T_) {
  if (T_ <= 0 || sigma <= 0) return(max(S - K * exp(-r * T_), 0))
  d1 <- (log(S / K) + (r + 0.5 * sigma^2) * T_) / (sigma * sqrt(T_))
  d2 <- d1 - sigma * sqrt(T_)
  S * pnorm(d1) - K * exp(-r * T_) * pnorm(d2)
}

# Internal: Black-Scholes put price via put-call parity
.bs_put <- function(S, K, r, sigma, T_) {
  .bs_call(S, K, r, sigma, T_) - S + K * exp(-r * T_)
}


#' Price a European Option under the Merton Jump-Diffusion Model
#'
#' @description
#' Computes the European call or put price under the Merton (1976)
#' jump-diffusion model using the analytic series expansion.
#' The price is expressed as a Poisson-weighted sum of
#' Black-Scholes prices with jump-adjusted drift and volatility.
#'
#' The formula is:
#' \deqn{C = \sum_{n=0}^{N} \frac{e^{-\lambda' T}(\lambda' T)^n}{n!}
#'   \cdot BS(S, K, r_n, \sigma_n, T)}
#' where \eqn{\lambda' = \lambda(1 + \bar\mu_J)},
#' \eqn{r_n = r - \lambda\bar\mu_J + n\log(1+\bar\mu_J)/T},
#' and \eqn{\sigma_n^2 = \sigma^2 + n\sigma_J^2/T}.
#'
#' @param fit       A \linkS4class{JDFitResult} object from
#'   \code{\link{fitMerton}}.
#' @param S         Positive numeric. Current asset price.
#' @param K         Positive numeric. Strike price.
#' @param r         Numeric. Continuously compounded risk-free rate.
#' @param T_        Positive numeric. Time to expiry in years.
#' @param type      Character. Either \code{"call"} or \code{"put"}.
#' @param N_max     Integer. Number of series terms (default 50).
#'
#' @return A named list with elements:
#'   \item{price}{Merton jump-diffusion option price.}
#'   \item{bs_price}{Black-Scholes benchmark price (no jumps).}
#'   \item{jump_premium}{Difference between Merton and BS price.}
#'   \item{params}{List of inputs and fitted parameters used.}
#'
#' @references
#' Merton, R.C. (1976). Option pricing when underlying stock
#' returns are discontinuous.
#' \emph{Journal of Financial Economics}, 3(1-2), 125-144.
#'
#' @examples
#' \dontrun{
#' ret <- jdSampleData("merton", n = 500, seed = 42)
#' fit <- fitMerton(ret)
#' price <- priceEuropean(fit, S = 100, K = 100,
#'                        r = 0.05, T_ = 1, type = "call")
#' print(price)
#' }
#'
#' @importFrom stats pnorm dpois
#' @export
priceEuropean <- function(fit, S = 100, K = 100,
                          r = 0.05, T_ = 1,
                          type = "call", N_max = 50L) {

  # ── Input validation ────────────────────────────────────────
  type <- match.arg(type, c("call", "put"))
  if (!is(fit, "JDFitResult"))
    stop("fit must be a JDFitResult object from fitMerton().")
  if (S  <= 0) stop("S must be positive.")
  if (K  <= 0) stop("K must be positive.")
  if (T_ <= 0) stop("T_ must be positive.")

  # ── Extract fitted parameters ───────────────────────────────
  sigma   <- fit@estimates["sigma"]
  lambda  <- fit@estimates["lambda"]
  mu_j    <- fit@estimates["mu_j"]
  sigma_j <- fit@estimates["sigma_j"]

  # ── Merton (1976) series components ─────────────────────────
  # Expected proportional jump size
  kappa   <- exp(mu_j + 0.5 * sigma_j^2) - 1

  # Jump-adjusted intensity
  lambda_ <- lambda * (1 + kappa)

  # Poisson weights
  ns      <- 0:N_max
  log_w   <- dpois(ns, lambda = lambda_ * T_, log = TRUE)
  w       <- exp(log_w)

  # Jump-adjusted drift and vol for each term
  r_n     <- r - lambda * kappa +
    ns * log(1 + kappa) / T_
  sigma2_n <- sigma^2 + ns * sigma_j^2 / T_
  sigma_n  <- sqrt(pmax(sigma2_n, 1e-10))

  # ── Merton price as weighted sum ────────────────────────────
  bs_fn  <- if (type == "call") .bs_call else .bs_put
  terms  <- mapply(function(r_i, s_i)
    bs_fn(S, K, r_i, s_i, T_),
    r_n, sigma_n)
  price_merton <- sum(w * terms)

  # ── Black-Scholes benchmark (no jumps) ──────────────────────
  price_bs <- bs_fn(S, K, r, sigma, T_)

  # ── Return structured result ─────────────────────────────────
  result <- list(
    price        = round(price_merton, 6),
    bs_price     = round(price_bs,     6),
    jump_premium = round(price_merton - price_bs, 6),
    params       = list(
      S       = S,      K      = K,
      r       = r,      T_     = T_,
      type    = type,
      sigma   = sigma,  lambda = lambda,
      mu_j    = mu_j,   sigma_j = sigma_j,
      kappa   = kappa,  lambda_ = lambda_
    )
  )
  class(result) <- "MertonPrice"
  result
}


#' @export
print.MertonPrice <- function(x, ...) {
  cat("Merton (1976) European Option Price\n")
  cat("------------------------------------\n")
  cat(sprintf("  Type          : %s\n",   toupper(x$params$type)))
  cat(sprintf("  Asset price S : %8.4f\n", x$params$S))
  cat(sprintf("  Strike K      : %8.4f\n", x$params$K))
  cat(sprintf("  Risk-free r   : %8.4f\n", x$params$r))
  cat(sprintf("  Expiry T      : %8.4f years\n", x$params$T_))
  cat("------------------------------------\n")
  cat(sprintf("  Merton price  : %8.6f\n", x$price))
  cat(sprintf("  BS benchmark  : %8.6f\n", x$bs_price))
  cat(sprintf("  Jump premium  : %+8.6f\n", x$jump_premium))
  cat("------------------------------------\n")
  cat(sprintf("  sigma         : %8.4f\n", x$params$sigma))
  cat(sprintf("  lambda        : %8.4f\n", x$params$lambda))
  cat(sprintf("  mu_j          : %8.4f\n", x$params$mu_j))
  cat(sprintf("  sigma_j       : %8.4f\n", x$params$sigma_j))
  invisible(x)
}
