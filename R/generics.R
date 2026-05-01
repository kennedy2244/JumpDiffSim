#' @import methods
#' @importFrom stats dnorm dpois optim qnorm quantile median density lag
#' @importFrom stats simulate dnorm dpois optim qnorm quantile median density lag
#' @importFrom numDeriv hessian
#' @importFrom ggplot2 ggplot aes geom_line geom_ribbon geom_histogram
#'   geom_density geom_col geom_hline labs theme_minimal after_stat
NULL

setGeneric("simulate",
           function(object, n, T_, steps, seed = NULL, ...)
             standardGeneric("simulate"))

setGeneric("loglik",
           function(object, log_returns, ...)
             standardGeneric("loglik"))

setGeneric("fit",
           function(object, log_returns, ...)
             standardGeneric("fit"))

setGeneric("jumpMoments",
           function(object) standardGeneric("jumpMoments"))

# -- Generic: simulate ------------------------------------------
#' Simulate Asset Price Paths
#'
#' @param object A \linkS4class{JumpDiffModel} object.
#' @param n      Integer. Number of simulated paths.
#' @param T_     Positive numeric. Time horizon in years.
#' @param steps  Positive integer. Number of time steps.
#' @param seed   Optional integer seed for reproducibility.
#' @param ...    Additional arguments passed to methods.
#' @return A \linkS4class{JDSimResult} object.
#' @export
setGeneric("simulate",
           function(object, n, T_, steps, seed = NULL, ...)
             standardGeneric("simulate"))

# -- Generic: loglik --------------------------------------------
#' Compute Negative Log-Likelihood
#'
#' @param object      A \linkS4class{JumpDiffModel} object.
#' @param log_returns Numeric vector of log asset returns.
#' @param ...         Passed to methods.
#' @return Scalar negative log-likelihood value.
#' @export
setGeneric("loglik",
           function(object, log_returns, ...)
             standardGeneric("loglik"))

# -- Generic: fit -----------------------------------------------
#' Fit Model to Log-Returns via MLE
#'
#' @param object      A \linkS4class{JumpDiffModel} object.
#' @param log_returns Numeric vector of observed log returns.
#' @param ...         Passed to \code{\link[stats]{optim}}.
#' @return A \linkS4class{JDFitResult} object.
#' @export
setGeneric("fit",
           function(object, log_returns, ...)
             standardGeneric("fit"))

# -- Generic: jumpMoments ---------------------------------------
#' Theoretical Moments of the Log-Return Distribution
#'
#' @param object A \linkS4class{JumpDiffModel} object.
#' @return Named numeric vector: mean, variance, skewness, kurtosis.
#' @export
setGeneric("jumpMoments",
           function(object) standardGeneric("jumpMoments"))
