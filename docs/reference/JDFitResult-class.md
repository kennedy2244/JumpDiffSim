# JDFitResult: MLE Estimation Output Class

JDFitResult: MLE Estimation Output Class

## Usage

``` r
# S4 method for class 'JDFitResult'
show(object)

# S4 method for class 'JDFitResult'
confint(object, parm, level = 0.95, ...)
```

## Arguments

- object:

  A JDFitResult object.

- parm:

  Ignored (all parameters returned).

- level:

  Confidence level (default 0.95).

- ...:

  Unused.

## Methods (by generic)

- `confint(JDFitResult)`: Wald-type 95\\

## Slots

- `estimates`:

  Named numeric. Parameter estimates.

- `se`:

  Named numeric. Standard errors.

- `loglik`:

  Numeric. Log-likelihood at optimum.

- `converged`:

  Logical. Did optimisation converge?

- `model_type`:

  Character. Model name.
