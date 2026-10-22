# A personal emissions budget to reduce academic air travel: investigating policy acceptability and fairness

<!-- Add the Zenodo DOI badge here after the first release -->

This repository contains the R code for the quantitative survey analyses of the article:

> Lichtin, S., Slawinski, N., Joon, K., Hanger-Kopp, S., & Wenger, A. *A personal emissions budget to reduce academic air travel: investigating policy acceptability and fairness.* (in review)

The study examines the feasibility of a personal emissions budget for academic air travel at ETH Zurich by assessing policy acceptability and perceived fairness among university staff. It combines an online survey (N = 1,734 staff members) with 15 semistructured interviews. This repository covers the survey analyses: a conjoint experiment with a framing experiment (policy effectiveness), and respondents' agreement with six budget allocation strategies. The interview analysis is not part of this repository.

## Data

The anonymised survey data are available on Zenodo: [doi.org/10.5281/zenodo.23512557](https://doi.org/10.5281/zenodo.23512557)

The data consist of two files:

- `data_anonymised.csv`: the survey responses (one row per response, one column per survey item, exported from Qualtrics)
- `codebook.csv`: the question text for each column of `data_anonymised.csv`

The code expects `data_anonymised.csv` in a folder `data/`, which you must create in the main folder of the repository before running the code (see [How to run](#how-to-run)). A folder `plots/` is created automatically when the code runs. All figures and tables are saved there.

## Repository structure

```
├── personal-emissions-budget-AAT.Rproj              # RStudio project
├── scripts/
│   ├── run_all.R                                    # runs all scripts below in the correct order
│   ├── functions.R                                  # helper functions (marginal means, bias correction, tables)
│   ├── preprocessing/
│   │   └── data_recoding.R                          # recoding, data cleaning, restriction to staff
│   ├── data_analysis_budget_allocation_strategies/
│   │   ├── budget_allocation_analysis.R             # agreement with allocation strategies (Figure 2, Table S6)
│   │   └── budget_allocation_subgroup_analysis.R    # comparison of the two framing groups (Figure S3)
│   └── data_analysis_conjoint/
│       ├── conjoint_analysis.R                      # conjoint models and marginal means (Figure 1, Figure S1)
│       ├── supplementary_material.R                 # robustness checks (Table S2, Figure S4)
│       └── conjoint_subgroup_analysis.R             # subgroup analysis by flying frequency (Figure S2)
├── sessionInfo.txt                                  # R and package versions used to reproduce the results
├── LICENSE                                          # MIT License
├── README.md
```

## Requirements

- R (the analyses were run with R 4.5.1)
- RStudio (recommended)
- R packages: `tidyverse`, `data.table`, `scales`, `lmerTest`, `emmeans`, `patchwork`, `officer`, `broom.mixed`

## How to run

1. Download or clone this repository.
2. Create a folder `data/` in the main folder of the repository and place `data_anonymised.csv` from Zenodo in it.
3. Open `personal-emissions-budget-AAT.Rproj` in RStudio.
4. In the console, run:

   ```r
   source("scripts/run_all.R")
   ```

`run_all.R` checks that the packages and the dataset are available, creates the output folders and runs all scripts in the correct order. All file paths are relative to the main folder of the repository, so the scripts must be run from within the RStudio project (or with the main folder as working directory).

The scripts can also be run individually in the order below. Note that `supplementary_material.R` uses objects created by `conjoint_analysis.R` and must be run directly after it, in the same R session.

| Order | Script | Output |
|---:|---|---|
| 1 | `preprocessing/data_recoding.R` | `data/Recoded_Budget_Data.csv`, `data/Recoded_Conjoint_Data.csv` |
| 2 | `data_analysis_budget_allocation_strategies/budget_allocation_analysis.R` | Figure 2; Supplementary Table S6 (mean and median ratings, printed to the console) |
| 3 | `data_analysis_budget_allocation_strategies/budget_allocation_subgroup_analysis.R` | Supplementary Figure S3 |
| 4 | `data_analysis_conjoint/conjoint_analysis.R` | Figure 1, Supplementary Figure S1 |
| 5 | `data_analysis_conjoint/supplementary_material.R` | Supplementary Table S2, Supplementary Figure S4 |
| 6 | `data_analysis_conjoint/conjoint_subgroup_analysis.R` | Supplementary Figure S2 |

Figures are saved in `plots/` (main figures), `plots/supplementary_figures/` and `plots/supplementary_tables/`.

## Methods in brief

The conjoint experiment was analysed with linear mixed-effects regressions (`lmerTest`) with a random intercept per respondent, separately for the two framing groups and for choice and rating data. Marginal means were computed with `emmeans`. Marginal means of the choice data were corrected for measurement-error bias based on the intrarespondent reliability (IRR), estimated from the fifth conjoint round, which repeated the first round (functions `calculate_tau()` and `correct_bias_mm()` in `functions.R`). Subgroup analyses add the variable of interest as an interaction term. Agreement with the budget allocation strategies was analysed with descriptive statistics. See the article for details.

## Reproducibility

The analyses for the article were run with R 4.5.1 in December 2025. On 20 October 2026, the complete pipeline was re-run with R 4.5.1 and the package versions listed in `sessionInfo.txt`, reproducing the results reported in the article.

## Citation

If you use this code, please cite the article and the archived version of this repository on Zenodo.

## License

The code in this repository is licensed under the [MIT License](LICENSE).
