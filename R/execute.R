#' @export
execute <- function(connectionDetails,
                    outputFolder,
                    databaseId,
                    cdmDatabaseSchema,
                    cohortDatabaseSchema,
                    cohortTable,
                    inferredLinkTable,
                    constructCohorts = FALSE,
                    firstOutcomeOnly = FALSE,
                    infantDobWindow = 60,
                    constructCovariates = FALSE,
                    createCovariateOutput = FALSE,
                    characterizeCohorts = FALSE) {

  if (!file.exists(outputFolder)) {
    dir.create(outputFolder, recursive = TRUE)
  }

  if (constructCohorts) {
    start <- Sys.time()
    motherinfantevaluation::constructCohorts(connectionDetails = connectionDetails,
                                             outputFolder = outputFolder,
                                             databaseId = databaseId,
                                             cdmDatabaseSchema = cdmDatabaseSchema,
                                             cohortDatabaseSchema = cohortDatabaseSchema,
                                             cohortTable = cohortTable,
                                             inferredLinkTable = inferredLinkTable,
                                             firstOutcomeOnly = firstOutcomeOnly,
                                             infantDobWindow = infantDobWindow)
    delta <- Sys.time() - start
    writeLines(paste("Constructed",
                     databaseId,
                     "mother and infant cohorts in",
                     signif(delta, 3),
                     attr(delta, "units")))
  }

  if (constructCovariates) {
    start <- Sys.time()
    motherinfantevaluation::constructCovariates(connectionDetails = connectionDetails,
                                                outputFolder = outputFolder,
                                                cdmDatabaseSchema = cdmDatabaseSchema,
                                                cohortDatabaseSchema = cohortDatabaseSchema,
                                                cohortTable = cohortTable,
                                                databaseId = databaseId)
    delta <- Sys.time() - start
    writeLines(paste("Constructed",
                     databaseId,
                     "mother and infant covariates in",
                     signif(delta, 3),
                     attr(delta, "units")))
  }

  if (createCovariateOutput) {
    start <- Sys.time()
    motherinfantevaluation::createCovariateOutput(outputFolder)
    delta <- Sys.time() - start
    writeLines(paste("Constructed",
                     databaseId,
                     "covariate output in",
                     signif(delta, 3),
                     attr(delta, "units")))
  }

  if (characterizeCohorts) {
    start <- Sys.time()
    motherinfantevaluation::characterizeCohorts(outputFolder = outputFolder,
                                                cohortDatabaseSchema = cohortDatabaseSchema,
                                                cohortTable = cohortTable,
                                                databaseId = databaseId)
    delta <- Sys.time() - start
    writeLines(paste("Characterized",
                     databaseId,
                     "mother and infant cohorts in",
                     signif(delta, 3),
                     attr(delta, "units")))
  }
}
