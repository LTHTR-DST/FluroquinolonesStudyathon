library(DBI)
library(CDMConnector)
library(CodelistGenerator)
library(dplyr)
library(here)
library(dotenv)

# Load environment variabales from root directory
dotenv::load_dot_env(here("../../.env"))

dsn <- Sys.getenv("ODBC_DSN")
database_name <-  Sys.getenv("DATABASE_NAME")
cdm_schema <- Sys.getenv("CDM_SCHEMA")
cdm_version <- Sys.getenv("CDM_VERSION")
cdm_name <- Sys.getenv("CDM_NAME")


# database connection ----
# see https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html
# for examples on how to connect and create your cdm reference

db <- dbConnect(odbc::odbc(), dsn, Database = database_name,  timeout = 10)

cdm <- CDMConnector::cdm_from_con(db,
                                  cdm_schema=cdm_schema,
                                  cdm_name=cdm_name,
                                  cdm_version=cdm_version)



drug_names <- data.frame(concept_name = c("ciprofloxacin",
                "delafloxacin",
                "moxifloxacin",
                "ofloxacin",
                "levofloxacin",
                "norfloxacin"))

drug_concepts <- cdm$concept %>%
  mutate(concept_name = tolower(concept_name)) %>%
  filter(concept_name %in% local(drug_names$concept_name)) %>%
  filter(concept_class_id=="Ingredient")    %>%
  filter(standard_concept =="S") %>%
  collect()


drug_concepts <- drug_names %>%
  left_join(drug_concepts,
            by = "concept_name") %>%
  select("concept_name", "concept_id")

write.csv(drug_concepts,
          file = here("drug_concepts", "drug_concepts.csv"),
          row.names = FALSE)
