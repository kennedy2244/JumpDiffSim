# Package index

## Model Classes

S4 class definitions for jump-diffusion models

- [`MertonModel()`](https://kennedy2244.github.io/JumpDiffSim/reference/MertonModel.md)
  : Create a MertonModel Object
- [`show(`*`<MertonModel>`*`)`](https://kennedy2244.github.io/JumpDiffSim/reference/MertonModel-class.md)
  : MertonModel: Merton (1976) Jump-Diffusion Model
- [`JumpDiffModel-class`](https://kennedy2244.github.io/JumpDiffSim/reference/JumpDiffModel-class.md)
  : JumpDiffModel: Virtual Base Class for Jump-Diffusion Models
- [`JDSimResult-class`](https://kennedy2244.github.io/JumpDiffSim/reference/JDSimResult-class.md)
  : JDSimResult: Simulation Output Class
- [`show(`*`<JDFitResult>`*`)`](https://kennedy2244.github.io/JumpDiffSim/reference/JDFitResult-class.md)
  [`confint(`*`<JDFitResult>`*`)`](https://kennedy2244.github.io/JumpDiffSim/reference/JDFitResult-class.md)
  : JDFitResult: MLE Estimation Output Class

## Generic Functions

S4 generic function definitions

- [`simulate()`](https://kennedy2244.github.io/JumpDiffSim/reference/simulate.md)
  : Simulate Asset Price Paths
- [`fit()`](https://kennedy2244.github.io/JumpDiffSim/reference/fit.md)
  : Fit Model to Log-Returns via MLE
- [`loglik()`](https://kennedy2244.github.io/JumpDiffSim/reference/loglik.md)
  : Compute Negative Log-Likelihood
- [`jumpMoments()`](https://kennedy2244.github.io/JumpDiffSim/reference/jumpMoments.md)
  : Theoretical Moments of the Log-Return Distribution

## Simulation

Simulate asset price paths

- [`simulateMerton()`](https://kennedy2244.github.io/JumpDiffSim/reference/simulateMerton.md)
  : Simulate Merton Jump-Diffusion Asset Paths
- [`jdSampleData()`](https://kennedy2244.github.io/JumpDiffSim/reference/jdSampleData.md)
  : Generate Synthetic Log-Returns from a Jump-Diffusion Model
- [`diagnosticPlots()`](https://kennedy2244.github.io/JumpDiffSim/reference/diagnosticPlots.md)
  : Diagnostic Plots for a JDSimResult Object

## Estimation

Fit models via maximum likelihood

- [`mertonLogLik()`](https://kennedy2244.github.io/JumpDiffSim/reference/mertonLogLik.md)
  : Negative Log-Likelihood for the Merton Jump-Diffusion Model
- [`fitMerton()`](https://kennedy2244.github.io/JumpDiffSim/reference/fitMerton.md)
  : Fit Merton Jump-Diffusion Model via MLE

## Option Pricing

European option pricing under jump-diffusion models

- [`priceEuropean()`](https://kennedy2244.github.io/JumpDiffSim/reference/priceEuropean.md)
  : Price a European Option under the Merton Jump-Diffusion Model

## Methods

S4 method implementations

- [`jumpMoments(`*`<MertonModel>`*`)`](https://kennedy2244.github.io/JumpDiffSim/reference/jumpMoments-MertonModel-method.md)
  : Theoretical Moments of the Merton Jump-Diffusion Log-Return
