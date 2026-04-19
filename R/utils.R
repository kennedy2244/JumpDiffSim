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
