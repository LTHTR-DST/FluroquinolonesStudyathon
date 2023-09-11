#install.packages("renv") # if not already installed, install renv from CRAN
renv::activate()
renv::restore() # this should prompt you to install the various packages required for the study

library(DBI)
library(CDMConnector)
library(DrugExposureDiagnostics)
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

cdm <- CDMConnector::cdm_from_con(db, cdm_schema=cdm_schema, cdm_name = cdm_name, cdm_version = cdm_version)

source(here("RunAnalysis.R"))
