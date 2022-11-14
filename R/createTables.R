#' @export
createTables <- function(studyFolder) {

  dataFolder <- file.path(studyFolder, "shinyData")
  outputFolder <- file.path(studyFolder, "output")
  if (!file.exists(outputFolder)) {
    dir.create(outputFolder)
  }

  # counts table ===============================================================

  counts <- readRDS(file.path(dataFolder, "cohortCounts.rds")) %>%
    dplyr::relocate(databaseId,
                    analysisVariant,
                    cohortName,
                    records,
                    persons)

  dbOrder <- c("truven_ccae", "optum_extended_dod")
  analysisOrder <- c("All pregnancies - 60d", "First pregnancies - 60d", "All pregnanices - 90d")
  cohortOrder <- c("Linked mothers (pregnancy episode start)",
                   "Linked mothers (pregnancy episode end)",
                   "Linked infants",
                   "Not linked mothers (pregnancy episode start)",
                   "Not linked mothers (pregnancy episode end)",
                   "Not linked infants",
                   "All mothers (pregnancy episode start)",
                   "All mothers (pregnancy episode end)",
                   "All infants")


  counts$dbOrder <- match(counts$databaseId, dbOrder)
  counts$analysisOrder <- match(counts$analysisVariant, analysisOrder)
  counts$cohortOrder <- match(counts$cohortName, cohortOrder)

  counts <- counts[order(counts$dbOrder, counts$analysisOrder, counts$cohortOrder), ]
  counts$dbOrder <- NULL
  counts$analysisOrder <- NULL
  counts$cohortOrder <- NULL
  counts$cohortDefinitionId <- NULL
  counts$records <-  formatC(counts$records, format = "d", big.mark = ",")
  counts$persons <-  formatC(counts$persons, format = "d", big.mark = ",")

  readr::write_csv(counts, file.path(outputFolder, "counts.csv"))

  # characteristics tables =====================================================

  for (analysisId in c("primary",
                       "first",
                       "birth90")) { # analysisId <- "primary"
    for (table1Name in c("motherlinkedNotLinkedPregStartTable1.csv",
                         "motherlinkedNotLinkedPregEndTable1.csv",
                         "infantlinkedNotLinkedTable1.csv",
                         "motherlinkedAllPregStartTable1.csv",
                         "motherlinkedAllPregEndTable1.csv",
                         "infantlinkedAllTable1.csv")) { # table1Name <- "motherlinkedNotLinkedPregStartTable1.csv"

      dbTables <- list()
      for (databaseId in c("truven_ccae",
                           "optum_extended_dod")) { # databaseId <- "optum_extended_dod"
        tableFile <- file.path(studyFolder, databaseId, analysisId, table1Name)
        table1 <- readr::read_csv(tableFile, show_col_types = FALSE)
        dbTables[[length(dbTables) + 1]] <- table1
      }
      dbTable <- dplyr::bind_cols(dbTables)
      dbTable$Characteristic...5 <- NULL
      names(dbTable)[1] <- "Characteristic"
      names(dbTable)[4] <- "Std.Diff"
      names(dbTable)[7] <- "Std.Diff"
      readr::write_csv(dbTable, file.path(outputFolder, sprintf("%s_%s", analysisId, table1Name)), na = "")
    }
  }
}


