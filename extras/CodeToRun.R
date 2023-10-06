# global =======================================================================
library(magrittr)
options(andromedaTempFolder = "G:/andromedaTemp", spipen = 999)
studyFolder <- "G:/motherinfantevaluation2" # changed linked infants cohort start date from mother preg end to infant obs start
# studyFolder <- "G:/motherinfantevaluation" # original implementation

# CCAE =========================================================================

# primary analysis, all pregnancies, 60d =======================================

databaseId <- "truven_ccae"
outputFolder <- file.path(studyFolder, databaseId, "primary")
cdmDatabaseSchema <- "cdm_truven_ccae_v1831"
cohortDatabaseSchema <-"scratch_jweave17"
cohortTable <- "mother_infant_cohorts_v1831"
inferredLinkTable <- "mother_infant_inferred_linkage_v1831"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"),
  server = paste0(Sys.getenv("OHDA_SERVER"), databaseId),
  extraSettings = Sys.getenv("EXTRA_SETTINGS"),
  port = Sys.getenv("port"),
  user = Sys.getenv("OHDA_USER"),
  password = Sys.getenv("OHDA_PASSWORD"))

motherinfantevaluation::execute(connectionDetails = connectionDetails,
                                outputFolder = outputFolder,
                                databaseId = databaseId,
                                cdmDatabaseSchema = cdmDatabaseSchema,
                                cohortDatabaseSchema = cohortDatabaseSchema,
                                cohortTable = cohortTable,
                                inferredLinkTable = inferredLinkTable,
                                constructCohorts = FALSE,
                                firstOutcomeOnly = FALSE,
                                infantDobWindow = 60,
                                constructCovariates = FALSE,
                                createCovariateOutput = FALSE,
                                characterizeCohorts = FALSE)

# sensitivity, first pregnancies, 60d ==========================================

databaseId <- "truven_ccae"
outputFolder <- file.path(studyFolder, databaseId, "first")
if (!file.exists(outputFolder)) {
  dir.create(outputFolder, recursive = TRUE)
}
cdmDatabaseSchema <- "cdm_truven_ccae_v1831"
cohortDatabaseSchema = "scratch_jweave17"
cohortTable = "mother_infant_cohorts_v1831_first"
inferredLinkTable <- "mother_infant_inferred_linkage_first_v1831"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"),
  server = paste0(Sys.getenv("OHDA_SERVER"), databaseId),
  extraSettings = Sys.getenv("EXTRA_SETTINGS"),
  port = Sys.getenv("port"),
  user = Sys.getenv("OHDA_USER"),
  password = Sys.getenv("OHDA_PASSWORD"))

motherinfantevaluation::execute(connectionDetails = connectionDetails,
                                outputFolder = outputFolder,
                                databaseId = databaseId,
                                cdmDatabaseSchema = cdmDatabaseSchema,
                                cohortDatabaseSchema = cohortDatabaseSchema,
                                cohortTable = cohortTable,
                                inferredLinkTable = inferredLinkTable,
                                constructCohorts = FALSE,
                                firstOutcomeOnly = TRUE,
                                infantDobWindow = 60,
                                constructCovariates = FALSE,
                                createCovariateOutput = FALSE,
                                characterizeCohorts = FALSE)

# sensitivity, all pregnancies, 90d ============================================

databaseId <- "truven_ccae"
outputFolder <- file.path(studyFolder, databaseId, "birth90")
if (!file.exists(outputFolder)) {
  dir.create(outputFolder, recursive = TRUE)
}
cdmDatabaseSchema <- "cdm_truven_ccae_v1831"
cohortDatabaseSchema = "scratch_jweave17"
cohortTable = "mother_infant_cohorts_v1831_90"
inferredLinkTable <- "mother_infant_inferred_linkage_90_v1831"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"),
  server = paste0(Sys.getenv("OHDA_SERVER"), databaseId),
  extraSettings = Sys.getenv("EXTRA_SETTINGS"),
  port = Sys.getenv("port"),
  user = Sys.getenv("OHDA_USER"),
  password = Sys.getenv("OHDA_PASSWORD"))

motherinfantevaluation::execute(connectionDetails = connectionDetails,
                                outputFolder = outputFolder,
                                databaseId = databaseId,
                                cdmDatabaseSchema = cdmDatabaseSchema,
                                cohortDatabaseSchema = cohortDatabaseSchema,
                                cohortTable = cohortTable,
                                inferredLinkTable = inferredLinkTable,
                                constructCohorts = FALSE,
                                firstOutcomeOnly = FALSE,
                                infantDobWindow = 90,
                                constructCovariates = FALSE,
                                createCovariateOutput = FALSE,
                                characterizeCohorts = FALSE)


# Optum ========================================================================

# primary analysis, all pregnancies, 60d =======================================

databaseId <- "optum_extended_dod"
outputFolder <- file.path(studyFolder, databaseId, "primary")
cdmDatabaseSchema <- "cdm_optum_extended_dod_v1913"
cohortDatabaseSchema <- "scratch_jweave17"
cohortTable <- "mother_infant_cohorts_v1913"
inferredLinkTable <- "mother_infant_inferred_linkage_v1913"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"),
  server = paste0(Sys.getenv("OHDA_SERVER"), databaseId),
  extraSettings = Sys.getenv("EXTRA_SETTINGS"),
  port = Sys.getenv("port"),
  user = Sys.getenv("OHDA_USER"),
  password = Sys.getenv("OHDA_PASSWORD"))

motherinfantevaluation::execute(connectionDetails = connectionDetails,
                                outputFolder = outputFolder,
                                databaseId = databaseId,
                                cdmDatabaseSchema = cdmDatabaseSchema,
                                cohortDatabaseSchema = cohortDatabaseSchema,
                                cohortTable = cohortTable,
                                inferredLinkTable = inferredLinkTable,
                                constructCohorts = FALSE,
                                firstOutcomeOnly = FALSE,
                                infantDobWindow = 60,
                                constructCovariates = FALSE,
                                createCovariateOutput = FALSE,
                                characterizeCohorts = FALSE)

# sensitivity, first pregnancies, 60d ==========================================

databaseId <- "optum_extended_dod"
outputFolder <- file.path(studyFolder, databaseId, "first")
if (!file.exists(outputFolder)) {
  dir.create(outputFolder, recursive = TRUE)
}
cdmDatabaseSchema <- "cdm_optum_extended_dod_v1913"
cohortDatabaseSchema <- "scratch_jweave17"
cohortTable <- "mother_infant_cohorts_v1913_first"
inferredLinkTable <- "mother_infant_inferred_linkage_first_v1913"


connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"),
  server = paste0(Sys.getenv("OHDA_SERVER"), databaseId),
  extraSettings = Sys.getenv("EXTRA_SETTINGS"),
  port = Sys.getenv("port"),
  user = Sys.getenv("OHDA_USER"),
  password = Sys.getenv("OHDA_PASSWORD"))

motherinfantevaluation::execute(connectionDetails = connectionDetails,
                                outputFolder = outputFolder,
                                databaseId = databaseId,
                                cdmDatabaseSchema = cdmDatabaseSchema,
                                cohortDatabaseSchema = cohortDatabaseSchema,
                                cohortTable = cohortTable,
                                inferredLinkTable = inferredLinkTable,
                                constructCohorts = FALSE,
                                firstOutcomeOnly = TRUE,
                                infantDobWindow = 60,
                                constructCovariates = FALSE,
                                createCovariateOutput = FALSE,
                                characterizeCohorts = FALSE)

# sensitivity, all pregnancies, 90d ============================================

databaseId <- "optum_extended_dod"
outputFolder <- file.path(studyFolder, databaseId, "birth90")
if (!file.exists(outputFolder)) {
  dir.create(outputFolder, recursive = TRUE)
}
cdmDatabaseSchema <- "cdm_optum_extended_dod_v1913"
cohortDatabaseSchema <- "scratch_jweave17"
cohortTable <- "mother_infant_cohorts_v1913_90"
inferredLinkTable <- "mother_infant_inferred_linkage_90_v1913"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = Sys.getenv("DBMS"),
  server = paste0(Sys.getenv("OHDA_SERVER"), databaseId),
  extraSettings = Sys.getenv("EXTRA_SETTINGS"),
  port = Sys.getenv("port"),
  user = Sys.getenv("OHDA_USER"),
  password = Sys.getenv("OHDA_PASSWORD"))

motherinfantevaluation::execute(connectionDetails = connectionDetails,
                                outputFolder = outputFolder,
                                databaseId = databaseId,
                                cdmDatabaseSchema = cdmDatabaseSchema,
                                cohortDatabaseSchema = cohortDatabaseSchema,
                                cohortTable = cohortTable,
                                inferredLinkTable = inferredLinkTable,
                                constructCohorts = FALSE,
                                firstOutcomeOnly = FALSE,
                                infantDobWindow = 90,
                                constructCovariates = FALSE,
                                createCovariateOutput = FALSE,
                                characterizeCohorts = FALSE)

# export =======================================================================
motherinfantevaluation::exportData(studyFolder = studyFolder)
motherinfantevaluation::createTables(studyFolder = studyFolder)
motherinfantevaluation::createScatterPlots(studyFolder = studyFolder)
motherinfantevaluation::createAttritionPlots(studyFolder = studyFolder)









