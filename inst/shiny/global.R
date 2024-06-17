source("plotsTables.R")
source("dataPulls.R")
dataFolder <- "G:/motherinfantevaluation2/shinyData"
load(file.path(dataFolder, "PreMergedShinyData.RData"))

databaseRef <- c("truven_ccae", "optum_extended_dod")
domainRef <- unique(infant$domainId)
analysisRef <- c("All pregnancies - 60d", "First pregnancies - 60d" ,"All pregnanices - 90d")

motherPregStart <- dplyr::arrange(motherPregStart, desc(abs(stdDiff)))
motherPregEnd <- dplyr::arrange(motherPregEnd, desc(abs(stdDiff)))
infant <- dplyr::arrange(infant, desc(abs(stdDiff)))
