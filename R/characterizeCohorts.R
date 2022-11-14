#' @export
characterizeCohorts <- function(outputFolder,
                                cohortDatabaseSchema,
                                cohortTable,
                                databaseId) {

  # characterization ===========================================================

  loadCovariates <- function(fileName) {
    file <- file.path(outputFolder, "covariateData", fileName)
    covariateData <- FeatureExtraction::loadCovariateData(file)
    return(covariateData)
  }

  dropRows <- c("  age in years",
                "  observation time (days) prior to index",
                "  observation time (days) after index",
                "  time (days) between cohort start and end",
                "  condition_era distinct concept count during day -365 through 0 concept_count relative to index",
                "  drug_era distinct concept count during day -365 through 0 concept_count relative to index",
                "  procedure_occurrence distinct concept count during day -365 through 0 concept_count relative to index",
                "  measurement distinct concept count during day -365 through 0 concept_count relative to index",
                "  visit_occurrence concept count during day -365 through 0 concept_count relative to index",
                "  condition_era distinct concept count during day 0 through 365 concept_count relative to index",
                "  drug_era distinct concept count during day 0 through 365 concept_count relative to index",
                "  procedure_occurrence distinct concept count during day 0 through 365 concept_count relative to index",
                "  measurement distinct concept count during day 0 through 365 concept_count relative to index",
                "  visit_occurrence concept count during day 0 through 365 concept_count relative to index",
                "  time (days) between cohort start and end",
                "Characteristic",
                "    Minimum",
                "    25th percentile",
                "    75th percentile",
                "    Maximum",
                "")

  motherCovarSpecFile <- system.file("csv", "motherTable1Spec.csv", package = "motherinfantevaluation")
  motherCovarSpec <- readr::read_csv(motherCovarSpecFile, show_col_types = FALSE)
  infantCovarSpecFile <- system.file("csv", "infantTable1Spec.csv", package = "motherinfantevaluation")
  infantCovarSpec <- readr::read_csv(infantCovarSpecFile, show_col_types = FALSE)

  getTable1 <- function(covariateData1,
                        covariateData2,
                        covariateSpec,
                        fileName) {
    table1 <- FeatureExtraction::createTable1(
      covariateData1 = covariateData1,
      covariateData2 = covariateData2,
      specifications = covariateSpec,
      output = "one column",
      showCounts = FALSE,
      showPercent = TRUE,
      percentDigits = 2,
      valueDigits = 2,
      stdDiffDigits = 3)
    table1 <- table1[!(table1$Characteristic %in% dropRows), ]
    readr::write_csv(table1,
                     file.path(outputFolder, fileName),
                     col_names = TRUE)
  }

  # mother preg start tables ===================================================


  linkedMothersPregStartCovariateData <- loadCovariates("linkedMothersPregStartCovariateData")
  notlinkedMothersPregStartCovariateData <- loadCovariates("notLinkedMothersPregStartCovariateData")
  allMothersPregStartCovariateData <- loadCovariates("allMothersPregStartCovariateData")

  getTable1(covariateData1 = linkedMothersPregStartCovariateData,
            covariateData2 = notlinkedMothersPregStartCovariateData,
            covariateSpec = motherCovarSpec,
            fileName = "motherlinkedNotLinkedPregStartTable1.csv")

  getTable1(covariateData1 = linkedMothersPregStartCovariateData,
            covariateData2 = allMothersPregStartCovariateData,
            covariateSpec = motherCovarSpec,
            fileName = "motherlinkedAllPregStartTable1.csv")

  # mother preg end tables =====================================================

  linkedMothersPregEndCovariateData <- loadCovariates("linkedMothersPregEndCovariateData")
  notLinkedMothersPregEndCovariateData <- loadCovariates("notLinkedMothersPregEndCovariateData")
  allMothersPregEndCovariateData <- loadCovariates("allMothersPregEndCovariateData")

  getTable1(covariateData1 = linkedMothersPregEndCovariateData,
            covariateData2 = notLinkedMothersPregEndCovariateData,
            covariateSpec = motherCovarSpec,
            fileName = "motherlinkedNotLinkedPregEndTable1.csv")

  getTable1(covariateData1 = linkedMothersPregEndCovariateData,
            covariateData2 = allMothersPregEndCovariateData,
            covariateSpec = motherCovarSpec,
            fileName = "motherlinkedAllPregEndTable1.csv")

   # infant tables =============================================================

  linkedInfantsCovariateData <- loadCovariates("linkedInfantsCovariateData")
  notLinkedInfantsCovariateData <- loadCovariates("notLinkedInfantsCovariateData")
  allInfantsCovariateData <- loadCovariates("allInfantsCovariateData")

  getTable1(covariateData1 = linkedInfantsCovariateData,
            covariateData2 = notLinkedInfantsCovariateData,
            covariateSpec = infantCovarSpec,
            fileName = "infantlinkedNotLinkedTable1.csv")

  getTable1(covariateData1 = linkedInfantsCovariateData,
            covariateData2 = allInfantsCovariateData,
            covariateSpec = infantCovarSpec,
            fileName = "infantlinkedAllTable1.csv")
}




