#' @export
exportData <- function(studyFolder,
                       databaseIds = c("truven_ccae", "optum_extended_dod"),
                       analysisIds = c("primary", "first", "birth90")) {

  shinyDataFolder <- file.path(studyFolder, "shinyData")
  if (!file.exists(shinyDataFolder)) {
    dir.create(shinyDataFolder)
  }

  covariate data =============================================================
  covariateFolderDummy <- file.path(studyFolder, databaseIds[1], analysisIds[1], "covariateData")
  rawfileNames <- list.files(covariateFolderDummy, pattern = ".*\\.rds")

  for (rawfileName in rawfileNames) {  # rawfileName <- rawfileNames[1]
    fileNames <- c()
    for (databaseId in databaseIds) { # databaseId <- databaseIds[1]

      for (analysisId in analysisIds) { # analysisId <- "primary"

        covariateFolder <- file.path(studyFolder, databaseId, analysisId, "covariateData")
        fileName <- file.path(covariateFolder, rawfileName)

        fileNames <- c(fileNames, fileName)
      }
    }
    fileNamesList <- lapply(fileNames, readRDS)
    dat <- do.call("rbind", fileNamesList)
    dat <- dat[!duplicated(dat), ]
    saveRDS(dat, file.path(shinyDataFolder, rawfileName))
  }

  # counts data ================================================================

  countsList <- list()
  for (databaseId in databaseIds) { # databaseId <- databaseIds[1]

    for (analysisId in analysisIds) { # analysisId <- "primary"

      if (analysisId == "primary") {
        analysisVariant <- "All pregnancies - 60d"
      }
      if (analysisId == "first") {
        analysisVariant <- "First pregnancies - 60d"
      }
      if (analysisId == "birth90") {
        analysisVariant <- "All pregnanices - 90d"
      }

      countsFolder <- file.path(studyFolder, databaseId, analysisId)
      countsFileName <- file.path(countsFolder, "cohortCounts.csv")
      counts <- readr::read_csv(countsFileName, show_col_types = FALSE)
      counts$databaseId <- databaseId
      counts$analysisVariant <- analysisVariant

      countsList[[length(countsList) + 1]] <- counts

    }
  }
  allCounts <- dplyr::bind_rows(countsList)
  saveRDS(allCounts, file.path(shinyDataFolder, "cohortCounts.rds"))
}






