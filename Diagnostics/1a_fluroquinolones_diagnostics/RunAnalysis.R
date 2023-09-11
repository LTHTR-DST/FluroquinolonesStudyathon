
# load drug concepts ----
# note, these were identified in drug_concepts/concept_search.R
library(logger)

logger::log_info("Loading drug concepts...")
drug_concepts <- read.csv(here("drug_concepts", "drug_concepts.csv"))

# run diagnostics ----
logger::log_info("Running drug exposure diagnostics...this could take a while.")
drug_diagnostics <- suppressWarnings(suppressMessages(
  # uninformative warnings because we're not running all checks
  DrugExposureDiagnostics::executeChecks(
  cdm = cdm,
  ingredients = drug_concepts$concept_id,
  checks = c(
    "missing",
    "exposureDuration",
    "sourceConcept"
  ))
))

# export diagnostics ----
logger::log_info("Writing results to results folder...")
writeResultToDisk(drug_diagnostics,
                  databaseId = database_name,
                  outputFolder = here("results"))
