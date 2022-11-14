#' @export
createCovariateOutput <- function(outputFolder) {

  # load covariate data ========================================================
  cohortRefFile <- system.file("csv", "cohortRef.csv", package = "motherinfantevaluation")
  cohortRef <- readr::read_csv(cohortRefFile, show_col_types = FALSE)

  loadCovariates <- function(fileName) {
    file <- file.path(outputFolder, "covariateData", fileName)
    covariateData <- FeatureExtraction::loadCovariateData(file)
    return(covariateData)
  }

  if (basename(outputFolder) == "primary") {
    analysisVariant <- "All pregnancies - 60d"
  }
  if (basename(outputFolder) == "first") {
    analysisVariant <- "First pregnancies - 60d"
  }
  if (basename(outputFolder) == "birth90") {
    analysisVariant <- "All pregnanices - 90d"
  }

  linkedMothersPregStartCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 1], "CovariateData"))
  linkedMothersPregEndCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 2], "CovariateData"))
  linkedInfantsCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 3], "CovariateData"))
  allMothersPregStartCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 4], "CovariateData"))
  allMothersPregEndCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 5], "CovariateData"))
  allInfantsCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 6], "CovariateData"))
  notLinkedMothersPregStartCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 7], "CovariateData"))
  notLinkedMothersPregEndCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 8], "CovariateData"))
  notLinkedInfantsCovariateData <- loadCovariates(paste0(cohortRef$cohortLabel[cohortRef$cohortDefinitionId == 9], "CovariateData"))

  # create covariate output ====================================================
  covariateFolder <- file.path(outputFolder, "covariateData")

  # infant linked vs all
  infantLinkedAll <- FeatureExtraction::computeStandardizedDifference(linkedInfantsCovariateData,
                                                                      allInfantsCovariateData)
  infantLinkedAll$databaseId <- databaseId
  infantLinkedAll$analysisVariant <- analysisVariant
  saveRDS(infantLinkedAll, file.path(covariateFolder, "infantLinkedAll.rds"))
  linkedInfantCovariateRef <- tibble::as_tibble(linkedInfantsCovariateData$covariateRef)
  allInfantCovariateRef <- tibble::as_tibble(allInfantsCovariateData$covariateRef)
  linkedInfantAnalysisRef <- tibble::as_tibble(linkedInfantsCovariateData$analysisRef)
  allInfantAnalysisRef <- tibble::as_tibble(allInfantsCovariateData$analysisRef)

  # infant linked vs not linked
  infantLinkedNotLinked <- FeatureExtraction::computeStandardizedDifference(linkedInfantsCovariateData,
                                                                            notLinkedInfantsCovariateData)
  infantLinkedNotLinked$databaseId <- databaseId
  infantLinkedNotLinked$analysisVariant <- analysisVariant
  saveRDS(infantLinkedNotLinked, file.path(covariateFolder, "infantLinkedNotLinked.rds"))
  notLinkedInfantCovariateRef <- tibble::as_tibble(notLinkedInfantsCovariateData$covariateRef)
  notLinkedInantAnalysisRef <- tibble::as_tibble(notLinkedInfantsCovariateData$analysisRef)

  # mother preg start linked vs all
  motherLinkedAllPregStart <- FeatureExtraction::computeStandardizedDifference(linkedMothersPregStartCovariateData,
                                                                               allMothersPregStartCovariateData)
  motherLinkedAllPregStart$databaseId <- databaseId
  motherLinkedAllPregStart$analysisVariant <- analysisVariant
  saveRDS(motherLinkedAllPregStart, file.path(covariateFolder, "motherLinkedAllPregStart.rds"))
  linkedMotherPregStartCovariateRef <- tibble::as_tibble(linkedMothersPregStartCovariateData$covariateRef)
  allMotherPregStartCovariateRef <- tibble::as_tibble(allMothersPregStartCovariateData$covariateRef)
  linkedMotherPregStartAnalysisRef <- tibble::as_tibble(linkedMothersPregStartCovariateData$analysisRef)
  allMotherPregStartAnalysisRef <- tibble::as_tibble(allMothersPregStartCovariateData$analysisRef)

  # mother preg start linked vs not linked
  motherLinkedNotLinkedPregStart <- FeatureExtraction::computeStandardizedDifference(linkedMothersPregStartCovariateData,
                                                                                     notLinkedMothersPregStartCovariateData)
  motherLinkedNotLinkedPregStart$databaseId <- databaseId
  motherLinkedNotLinkedPregStart$analysisVariant <- analysisVariant
  saveRDS(motherLinkedNotLinkedPregStart, file.path(covariateFolder, "motherLinkedNotLinkedPregStart.rds"))
  notLinkedMotherPregStartCovariateRef <- tibble::as_tibble(notLinkedMothersPregStartCovariateData$covariateRef)
  notLinkedMotherPregStartAnalysisRef <- tibble::as_tibble(notLinkedMothersPregStartCovariateData$analysisRef)

  # mother preg end linked vs all
  motherLinkedAllPregEnd <- FeatureExtraction::computeStandardizedDifference(linkedMothersPregEndCovariateData,
                                                                             allMothersPregEndCovariateData)
  motherLinkedAllPregEnd$databaseId <- databaseId
  motherLinkedAllPregEnd$analysisVariant <- analysisVariant
  saveRDS(motherLinkedAllPregEnd, file.path(covariateFolder, "motherLinkedAllPregEnd.rds"))
  linkedMotherPregEndCovariateRef <- tibble::as_tibble(linkedMothersPregEndCovariateData$covariateRef)
  allMotherPregEndCovariateRef <- tibble::as_tibble(allMothersPregEndCovariateData$covariateRef)
  linkedMotherPregEndAnalysisRef <- tibble::as_tibble(linkedMothersPregEndCovariateData$analysisRef)
  allMotherPregEndAnalysisRef <- tibble::as_tibble(allMothersPregEndCovariateData$analysisRef)

  # mother preg end linked vs not linked
  motherLinkedNotLinkedPregEnd <- FeatureExtraction::computeStandardizedDifference(linkedMothersPregEndCovariateData,
                                                                                   notLinkedMothersPregEndCovariateData)
  motherLinkedNotLinkedPregEnd$databaseId <- databaseId
  motherLinkedNotLinkedPregEnd$analysisVariant <- analysisVariant
  saveRDS(motherLinkedNotLinkedPregEnd, file.path(covariateFolder, "motherLinkedNotLinkedPregEnd.rds"))
  notLinkedMotherPregEndCovariateRef <- tibble::as_tibble(notLinkedMothersPregEndCovariateData$covariateRef)
  notLinkedMotherPregEndAnalysisRef <- tibble::as_tibble(notLinkedMothersPregEndCovariateData$analysisRef)

  # ref objects
  covariateRef <- dplyr::bind_rows(linkedInfantCovariateRef,
                                   notLinkedInfantCovariateRef,
                                   allInfantCovariateRef,
                                   linkedMotherPregStartCovariateRef,
                                   notLinkedMotherPregStartCovariateRef,
                                   allMotherPregStartCovariateRef,
                                   linkedMotherPregEndCovariateRef,
                                   notLinkedMotherPregEndCovariateRef,
                                   allMotherPregEndCovariateRef)
  covariateRef <- covariateRef[!duplicated(covariateRef), ]
  saveRDS(covariateRef, file.path(covariateFolder, "covariateRef.rds"))

  analysisRef <- rbind(linkedInfantAnalysisRef,
                       notLinkedInantAnalysisRef,
                       allInfantAnalysisRef,
                       linkedMotherPregStartAnalysisRef,
                       notLinkedMotherPregStartAnalysisRef,
                       allMotherPregStartAnalysisRef,
                       linkedMotherPregEndAnalysisRef,
                       notLinkedMotherPregEndAnalysisRef,
                       allMotherPregEndAnalysisRef)
  analysisRef <- analysisRef[!duplicated(analysisRef), ]
  saveRDS(analysisRef, file.path(covariateFolder, "analysisRef.rds"))
}
