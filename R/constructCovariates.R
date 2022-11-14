#' @export
constructCovariates <- function(connectionDetails,
                                outputFolder,
                                cdmDatabaseSchema,
                                cohortDatabaseSchema,
                                cohortTable,
                                databaseId) {

  covariateFolder <- file.path(outputFolder, "covariateData")
  if (!file.exists(covariateFolder)) {
    dir.create(covariateFolder)
  }

  cohortRefFile <- system.file("csv", "cohortRef.csv", package = "motherinfantevaluation")
  cohortRef <- readr::read_csv(cohortRefFile, show_col_types = FALSE)


  # linked mothers pregnancy start: id1 ========================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 1], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing linked mothers pregnancy start covariate data...")

    linkedMotherPregStartCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = TRUE, # pregnancy episode length since index = pregnancy start date
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = TRUE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = -365,
      endDays = 0,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    linkedMotherPregStartCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 1,
      covariateSettings = linkedMotherPregStartCovariateSettings,
      aggregated = TRUE)

    FeatureExtraction::saveCovariateData(covariateData = linkedMotherPregStartCovariateData, file = fileName)
  } else {
    linkedMotherPregStartCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(linkedMotherPregStartCovariateData)


  # linked mothers pregnancy end: id2 ==========================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 2], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing linked mothers pregnancy end covariate data...")

    linkedMotherPregEndCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = FALSE, # set as end of obs since index = pregnancy end date
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = TRUE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = -365,
      endDays = 0,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    linkedMotherPregEndCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 2,
      covariateSettings = linkedMotherPregEndCovariateSettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = linkedMotherPregEndCovariateData, file = fileName)
  } else {
    linkedMotherPregEndCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(linkedMotherPregEndCovariateData)



  # all mothers pregnancy start: id4 ===========================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 4], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing all mothers pregnancy start covariate data...")

    allMotherPregStartCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = TRUE, # pregnancy episode length since index = pregnancy start date
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = TRUE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = -365,
      endDays = 0,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    allMotherPregStartCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 4,
      covariateSettings = allMotherPregStartCovariateSettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = allMotherPregStartCovariateData, file = fileName)
  } else {
    allMotherPregStartCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(allMotherPregStartCovariateData)




  # all mothers pregnancy end: id5 =============================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 5], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing all mothers pregnancy end covariate data...")

    allMotherPregEndCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = FALSE, # set as end of obs since index = pregnancy end date
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = TRUE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = -365,
      endDays = 0,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    allMotherPregEndCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 5,
      covariateSettings = allMotherPregEndCovariateSettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = allMotherPregEndCovariateData, file = fileName)
  } else {
    allMotherPregEndCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(allMotherPregEndCovariateData)




  # linked infants: id3 ========================================================
  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 3], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("constructing linked infants covariate data...")

    linkedInfantCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = FALSE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = FALSE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = FALSE, # cohort end as obs end
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = FALSE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = 0,
      endDays = 365,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    linkedInfantCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 3,
      covariateSettings = linkedInfantCovariateSettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = linkedInfantCovariateData, file = fileName)
  } else {
    linkedInfantCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(linkedInfantCovariateData)


  # all infants: id6 ===========================================================
  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 6], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing all infants covariate data...")

    allInfantCovariatesettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = FALSE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = FALSE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = FALSE, # cohort end as obs end
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = FALSE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = 0,
      endDays = 365,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    allInfantCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 6,
      covariateSettings = allInfantCovariatesettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = allInfantCovariateData, file = fileName)
  } else {
    allInfantCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(allInfantCovariateData)


  # not linked mothers pregnancy start: id7 ====================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 7], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing not linked mothers pregnancy start covariate data...")

    notLinkedMotherPregStartCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = TRUE, # pregnancy episode length since index = pregnancy start date
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = TRUE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = -365,
      endDays = 0,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    notLinkedMotherPregStartCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 7,
      covariateSettings = notLinkedMotherPregStartCovariateSettings,
      aggregated = TRUE)

    FeatureExtraction::saveCovariateData(covariateData = notLinkedMotherPregStartCovariateData, file = fileName)
  } else {
    notLinkedMotherPregStartCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }

  Andromeda::close(notLinkedMotherPregStartCovariateData)




  # not linked mothers pregnancy end: id8 ======================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 8], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("Constructing not linked mothers pregnancy end covariate data...")

    notLinkedMotherPregEndCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = TRUE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = TRUE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = FALSE, # set as end of obs since index = pregnancy end date
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = TRUE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = -365,
      endDays = 0,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    notLinkedMotherPregEndCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 8,
      covariateSettings = notLinkedMotherPregEndCovariateSettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = notLinkedMotherPregEndCovariateData, file = fileName)
  } else {
    notLinkedMotherPregEndCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }

  Andromeda::close(notLinkedMotherPregEndCovariateData)



  # not linked infants pregnancy end: id9 ======================================

  fileName <- file.path(covariateFolder, paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 9], "CovariateData"))
  if (!file.exists(fileName)) {
    writeLines("constructing not linked infants covariate data...")

    notLinkedInfantCovariateSettings <- FeatureExtraction::createCovariateSettings(
      useDemographicsGender = TRUE,
      useDemographicsAge = FALSE,
      useDemographicsIndexYear = TRUE,
      useDemographicsIndexMonth = TRUE,
      useDemographicsPriorObservationTime = FALSE,
      useDemographicsPostObservationTime = TRUE,
      useDemographicsTimeInCohort = FALSE, # cohort end as obs end
      useConditionOccurrenceLongTerm = TRUE,
      useConditionGroupEraLongTerm = TRUE,
      useDrugExposureLongTerm = TRUE,
      useDrugGroupEraLongTerm = TRUE,
      useProcedureOccurrenceLongTerm = TRUE,
      useMeasurementLongTerm = TRUE,
      useCharlsonIndex = FALSE,
      useDistinctConditionCountLongTerm = TRUE,
      useDistinctIngredientCountLongTerm = TRUE,
      useDistinctProcedureCountLongTerm = TRUE,
      useDistinctMeasurementCountLongTerm = TRUE,
      useDistinctObservationCountLongTerm = TRUE,
      useVisitCountLongTerm = TRUE,
      useVisitConceptCountLongTerm = TRUE,
      longTermStartDays = 0,
      endDays = 365,
      includedCovariateConceptIds = c(),
      addDescendantsToInclude = TRUE,
      excludedCovariateConceptIds = c(),
      addDescendantsToExclude = FALSE,
      includedCovariateIds = c())

    notLinkedInfantCovariateData <- FeatureExtraction::getDbCovariateData(
      connectionDetails = connectionDetails,
      cdmDatabaseSchema = cdmDatabaseSchema,
      cohortDatabaseSchema = cohortDatabaseSchema,
      cohortTable = cohortTable,
      cohortId = 9,
      covariateSettings = notLinkedInfantCovariateSettings,
      aggregated = TRUE)
    FeatureExtraction::saveCovariateData(covariateData = notLinkedInfantCovariateData, file = fileName)
  } else {
    notLinkedInfantCovariateData <- FeatureExtraction::loadCovariateData(fileName)
  }
  Andromeda::close(notLinkedInfantCovariateData)
}
