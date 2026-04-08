# Scaffolds

This folder contains ready-to-use code files for each team member.
They exist to avoid copy-paste errors from the PDF tutorial.

## How to use your scaffold file

1. Find your file in the table below
2. Open it in RStudio (click it in the Files tab)
3. Copy the relevant section into the destination file shown
4. Run `devtools::load_all()` or `devtools::test()` to confirm it works
5. Commit and push to your feature branch

## File map

| File | Member | Role | Copy content into |
|------|--------|------|-------------------|
| `A_kennedy_estimation.R` | Kennedy Kayaki | Package Lead + Estimation | `R/merton_fit.R` and `R/utils.R` |
| `B_dohyun_s4_classes.R` | Oh Dohyun | S4 Architect | `R/generics.R` and `R/merton_model.R` |
| `C_juseong_simulation.R` | Ju Seong Nyeon | Simulation Engine | `R/merton_sim.R` |
| `D_seeun_tests.R` | Lee Se Eun | Unit Testing (T1-T9) | `tests/testthat/test-merton_model.R` and `tests/testthat/test-merton_fit.R` |
| `E_jiwoo_vignette.Rmd` | Choi Jiwoo | Vignette and README | `vignettes/JumpDiffSim-intro.Rmd` |
| `F_yuri_coverage.R` | Yuri Shin | Simulation Tests + Coverage (T10-T12) | `tests/testthat/test-merton_sim.R` and `tests/testthat/test-utils.R` |

## Important rules

- Only copy **your own file** — do not touch other members' destination files
- Each scaffold file has clear section headers telling you exactly what to copy and where
- After copying, always run `devtools::load_all()` to confirm no errors
- Test files go into `tests/testthat/` — do **not** paste test code into `R/` files
- The vignette file (`E_jiwoo_vignette.Rmd`) is copied as a whole file, not section by section

## After copying your code

```r
# Confirm the package loads cleanly
devtools::load_all()

# Run all tests
devtools::test()

# Check for errors
devtools::check()
```

Then commit and push:

```bash
git add .
git commit -m "feat: add your module description here"
git push
```

Open a Draft Pull Request on GitHub: `feature/your-branch` → `dev`
