# -- Virtual base class -----------------------------------------
#' JumpDiffModel: Virtual Base Class for Jump-Diffusion Models
#'
#' @description
#' Abstract base class. Do not instantiate directly.
#' Concrete subclasses: \linkS4class{MertonModel}.
#'
#' @slot mu     Numeric. Drift parameter (annualised).
#' @slot sigma  Positive numeric. Diffusion volatility.
#' @slot lambda Non-negative numeric. Jump intensity (jumps per year).
#'
#' @exportClass JumpDiffModel
setClass("JumpDiffModel",
         contains  = "VIRTUAL",
         slots     = list(
           mu     = "numeric",
           sigma  = "numeric",
           lambda = "numeric"
         )
)

# -- MertonModel -----------------------------------------------
#' MertonModel: Merton (1976) Jump-Diffusion Model
#'
#' @description
#' Extends \linkS4class{JumpDiffModel} with log-normal jump parameters.
#'
#' @slot mu_j    Numeric. Mean log-jump size.
#' @slot sigma_j Positive numeric. Std dev of log-jump sizes.
#'
#' @references
#' Merton, R.C. (1976). Option pricing when underlying stock returns are
#' discontinuous. \emph{Journal of Financial Economics}, 3(1-2), 125-144.
#'
#' @exportClass MertonModel
setClass("MertonModel",
         contains = "JumpDiffModel",
         slots    = list(
           mu_j    = "numeric",
           sigma_j = "numeric"
         ),
         validity = function(object) {
           errs <- character(0)
           if (length(object@sigma) != 1 || object@sigma <= 0)
             errs <- c(errs, "sigma must be a single positive number.")
           if (length(object@lambda) != 1 || object@lambda < 0)
             errs <- c(errs, "lambda must be a single non-negative number.")
           if (length(object@sigma_j) != 1 || object@sigma_j <= 0)
             errs <- c(errs, "sigma_j must be a single positive number.")
           if (length(errs)) errs else TRUE
         }
)

# -- MertonModel constructor -----------------------------------
#' Create a MertonModel Object
#'
#' @param mu      Numeric. Drift (default 0.05).
#' @param sigma   Positive numeric. Diffusion volatility (default 0.20).
#' @param lambda  Non-negative numeric. Jump intensity (default 1).
#' @param mu_j    Numeric. Mean log-jump size (default -0.10).
#' @param sigma_j Positive numeric. Std dev of log-jumps (default 0.15).
#' @return A validated \linkS4class{MertonModel} object.
#'
#' @examples
#' m <- MertonModel()
#' m <- MertonModel(mu = 0.05, sigma = 0.20, lambda = 1,
#'                  mu_j = -0.10, sigma_j = 0.15)
#'
#' @export
MertonModel <- function(mu      =  0.05,
                        sigma   =  0.20,
                        lambda  =  1.00,
                        mu_j    = -0.10,
                        sigma_j =  0.15) {
  obj <- new("MertonModel",
             mu = mu, sigma = sigma, lambda = lambda,
             mu_j = mu_j, sigma_j = sigma_j)
  validObject(obj)
  obj
}

# -- show() method for MertonModel -----------------------------
#' @rdname MertonModel-class
#' @export
setMethod("show", "MertonModel", function(object) {
  cat("Merton Jump-Diffusion Model\n")
  cat("---------------------------\n")
  cat(sprintf("  mu      : %6.4f\n", object@mu))
  cat(sprintf("  sigma   : %6.4f\n", object@sigma))
  cat(sprintf("  lambda  : %6.4f\n", object@lambda))
  cat(sprintf("  mu_j    : %6.4f\n", object@mu_j))
  cat(sprintf("  sigma_j : %6.4f\n", object@sigma_j))
  cat(sprintf("  Persist : %6.4f  [alpha+beta not applicable to raw model]\n",
              object@mu + object@sigma))
  invisible(object)
})

# -- Result classes --------------------------------------------
#' JDSimResult: Simulation Output Class
#'
#' @slot paths      Matrix. Simulated price paths (n x steps+1).
#' @slot times      Numeric vector. Time grid.
#' @slot params     List. Model parameters used in simulation.
#' @slot model_type Character. Model name.
#'
#' @exportClass JDSimResult
setClass("JDSimResult",
         slots = list(
           paths      = "matrix",
           times      = "numeric",
           params     = "list",
           model_type = "character"
         )
)

#' JDFitResult: MLE Estimation Output Class
#'
#' @slot estimates  Named numeric. Parameter estimates.
#' @slot se         Named numeric. Standard errors.
#' @slot loglik     Numeric. Log-likelihood at optimum.
#' @slot converged  Logical. Did optimisation converge?
#' @slot model_type Character. Model name.
#'
#' @exportClass JDFitResult
setClass("JDFitResult",
         slots = list(
           estimates  = "numeric",
           se         = "numeric",
           loglik     = "numeric",
           converged  = "logical",
           model_type = "character"
         )
)

# -- show() method for JDFitResult ----------------------------
#' @rdname JDFitResult-class
#' @export
setMethod("show", "JDFitResult", function(object) {
  cat("Merton MLE Fit Result\n")
  cat("---------------------\n")
  cat(sprintf("  Converged : %s\n", object@converged))
  cat(sprintf("  Log-lik   : %.4f\n", object@loglik))
  cat("  Estimates (SE):\n")
  for (nm in names(object@estimates)) {
    cat(sprintf("    %-8s : %8.4f  (%8.4f)\n",
                nm, object@estimates[nm], object@se[nm]))
  }
  invisible(object)
})
