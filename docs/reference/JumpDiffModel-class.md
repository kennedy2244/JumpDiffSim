# JumpDiffModel: Virtual Base Class for Jump-Diffusion Models

Abstract base class. Do not instantiate directly. Concrete subclasses:
[MertonModel](https://kennedy2244.github.io/JumpDiffSim/reference/MertonModel-class.md).

## Slots

- `mu`:

  Numeric. Drift parameter (annualised).

- `sigma`:

  Positive numeric. Diffusion volatility.

- `lambda`:

  Non-negative numeric. Jump intensity (jumps per year).
