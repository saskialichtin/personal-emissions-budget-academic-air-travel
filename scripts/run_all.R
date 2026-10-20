############
## file name: scripts/run_all.R
## context: Runs the complete analysis pipeline in the correct order
##          (data recoding -> budget allocation analyses -> conjoint analyses).
## usage:   Open personal-emissions-budget-AAT.Rproj in RStudio and run: source("scripts/run_all.R")
##          or, from the project folder in a terminal: Rscript scripts/run_all.R
## requires: data/data_anonymised.csv (available on Zenodo, not included in this repository)
############

# 1. Checks -------------------------------------------------------------------

# Must be run from the project folder, because all scripts use relative paths
if (!file.exists("personal-emissions-budget-AAT.Rproj")) {
  stop("Please run this script from the project folder (open personal-emissions-budget-AAT.Rproj first).")
}

# Required packages
required_packages <- c("tidyverse", "data.table", "scales", "lmerTest",
                       "emmeans", "patchwork", "officer", "broom.mixed")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace,
                                              logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop("Please install the missing packages first:\n  install.packages(c(",
       paste0('"', missing_packages, '"', collapse = ", "), "))")
}

# Survey data
if (!file.exists("data/data_anonymised.csv")) {
  stop("Data not found. Please download 'data_anonymised.csv' from Zenodo and place it in the folder 'data/'.")
}

# 2. Output folders -----------------------------------------------------------

dir.create("plots/supplementary_figures", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/supplementary_tables",  recursive = TRUE, showWarnings = FALSE)

# 3. Helper -------------------------------------------------------------------

# Runs a script in the global environment (as when running it by hand in RStudio)
# and reports how long it took. The global environment is needed because
# supplementary_material.R uses objects created by conjoint_analysis.R.
run_script <- function(path) {
  message("\n>>> Running ", path, " ...")
  start <- Sys.time()
  source(path, local = globalenv())
  message(">>> Finished ", path, " (", round(difftime(Sys.time(), start, units = "mins"), 1), " min)")
}

# 4. Pipeline -----------------------------------------------------------------

# Preprocessing: creates data/Recoded_Budget_Data.csv and data/Recoded_Conjoint_Data.csv
run_script("scripts/preprocessing/data_recoding.R")

# Budget allocation strategies: Figure 2, Figure S3
run_script("scripts/data_analysis_budget_allocation_strategies/budget_allocation_analysis.R")
run_script("scripts/data_analysis_budget_allocation_strategies/budget_allocation_subgroup_analysis.R")

# Conjoint experiment: Figure 1, Figure S1
run_script("scripts/data_analysis_conjoint/conjoint_analysis.R")

# Supplementary material (Table S2, Figure S4) builds on the objects created in
# conjoint_analysis.R, so it must run directly afterwards
run_script("scripts/data_analysis_conjoint/supplementary_material.R")

# Conjoint subgroup analysis: Figure S2
run_script("scripts/data_analysis_conjoint/conjoint_subgroup_analysis.R")

# 5. Record the software environment -----------------------------------------

writeLines(capture.output(sessionInfo()), "sessionInfo.txt")
message("\nAll scripts finished. Figures and tables are in 'plots/'; ",
        "R and package versions are recorded in 'sessionInfo.txt'.")
