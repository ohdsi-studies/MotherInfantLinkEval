#' @export
createScatterPlots <- function(studyFolder) {

  dataFolder <- file.path(studyFolder, "shinyData")
  outputFolder <- file.path(studyFolder, "output")
  if (!file.exists(outputFolder)) {
    dir.create(outputFolder)
  }
  load(file.path(dataFolder, "PreMergedShinyData.RData"))

  analysisVariants <- c("All pregnancies - 60d", "First pregnancies - 60d", "All pregnanices - 90d")
  databaseIds <- c("truven_ccae", "optum_extended_dod")

  for (analysisVariant in analysisVariants) { # analysisVariant <- analysisVariants[1]

    scatterPlots <- list()
    for (databaseId in databaseIds) { # databaseId <- databaseIds[2]

      # pregnancy start
      pregStartData <- motherPregStart[motherPregStart$analysisVariant == analysisVariant &
                                         motherPregStart$databaseId == databaseId &
                                         motherPregStart$isBinary == "Y", ]
      xCount <- counts$records[counts$cohortDefinitionId == 1 &
                                 counts$databaseId == databaseId &
                                 counts$analysisVariant == analysisVariant]
      yCount <- counts$records[counts$cohortDefinitionId == 7 &
                                 counts$databaseId == databaseId &
                                 counts$analysisVariant == analysisVariant]

      scatterPlots[[length(scatterPlots) + 1]] <- plotScatter(compareData = pregStartData,
                                                               xCount = xCount,
                                                               yCount = yCount,
                                                               xLabel = "Linked",
                                                               yLabel = "Not linked")

      # pregnancy end
      pregEndData <- motherPregEnd[motherPregEnd$analysisVariant == analysisVariant &
                                     motherPregEnd$databaseId == databaseId &
                                     motherPregEnd$isBinary == "Y", ]
      xCount <- counts$records[counts$cohortDefinitionId == 2 &
                                 counts$databaseId == databaseId &
                                 counts$analysisVariant == analysisVariant]
      yCount <- counts$records[counts$cohortDefinitionId == 8 &
                                 counts$databaseId == databaseId &
                                 counts$analysisVariant == analysisVariant]
      scatterPlots[[length(scatterPlots) + 1]] <-  plotScatter(compareData = pregEndData,
                                                               xCount = xCount,
                                                               yCount = yCount,
                                                               xLabel = "Linked",
                                                               yLabel = "Not linked")

      # infants
      infantData <- infant[infant$analysisVariant == analysisVariant &
                             infant$databaseId == databaseId & infant$isBinary == "Y", ]
      xCount <- counts$records[counts$cohortDefinitionId == 3 &
                                 counts$databaseId == databaseId &
                                 counts$analysisVariant == analysisVariant]
      yCount <- counts$records[counts$cohortDefinitionId == 9 &
                                 counts$databaseId == databaseId &
                                 counts$analysisVariant == analysisVariant]
      scatterPlots[[length(scatterPlots) + 1]] <-  plotScatter(compareData = infantData,
                                                               xCount = xCount,
                                                               yCount = yCount,
                                                               xLabel = "Linked",
                                                               yLabel = "Not linked")
    }

    row1 <- grid::textGrob("Mothers: pregnancy episode start", rot = 90, gp = grid::gpar(fontsize = 14))
    row2 <- grid::textGrob("Mothers: pregnancy episode end", rot = 90, gp = grid::gpar(fontsize = 14))
    row3 <- grid::textGrob("Infants", rot = 90, gp = grid::gpar(fontsize = 14))
    col0 <- grid::textGrob("")
    col1 <- grid::textGrob("CCAE", gp = grid::gpar(fontsize = 14))
    col2 <- grid::textGrob("Clinformatics®", gp = grid::gpar(fontsize = 14))

    plotGrob <- gridExtra::arrangeGrob(col0, col1, col2,
                                       row1, scatterPlots[[1]], scatterPlots[[4]],
                                       row2, scatterPlots[[2]], scatterPlots[[5]],
                                       row3, scatterPlots[[3]], scatterPlots[[6]],
                                       heights = c(0.5, 5, 5, 5),
                                       widths = c(0.5, 5, 5),
                                       nrow = 4)

    dummyPlot <- plotScatter(compareData = pregStartData,
                             xCount = xCount,
                             yCount = yCount,
                             xLabel = "Linked",
                             yLabel = "Not linked",
                             legend = "bottom") +
      ggplot2::guides(col = ggplot2::guide_legend("Domain"))

      extractLegend <- function(plot) {
        step1 <- ggplot2::ggplot_gtable(ggplot2::ggplot_build(plot))
        step2 <- which(sapply(step1$grobs, function(x) x$name) == "guide-box")
        step3 <- step1$grobs[[step2]]
        return(step3)
      }
      sharedLegend <- extractLegend(dummyPlot)

      trellis <- gridExtra::grid.arrange(plotGrob,
                                         sharedLegend,
                                         nrow = 2,
                                         heights=c(12, 0.5))

      if (analysisVariant == "All pregnancies - 60d") {
        analysisId <- "primary"
      }
      if (analysisVariant == "First pregnancies - 60d") {
        analysisId <- "first"
      }
      if (analysisVariant == "All pregnanices - 90d") {
        analysisId <- "birth90"
      }
      plotName <- paste0(analysisId, "_scatterPlot.png")
      ggplot2::ggsave(file.path(outputFolder, plotName),
                      trellis,
                      height = 12,
                      width = 9)

  }
}

plotScatter <- function(compareData,
                        xCount,
                        yCount,
                        xLabel = "Linked",
                        yLabel = "Not linked",
                        legend = "none") {

  cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00")
  limits <- c(0, 1)

  xCount <- formatC(xCount, format = "d", big.mark = ",")
  yCount <- formatC(yCount, format = "d", big.mark = ",")
  xLabel <- sprintf("%s \n (n = %s)", xLabel, xCount)
  yLabel <- sprintf("%s \n (n = %s)", yLabel, yCount)

  theme <- ggplot2::element_text(colour = "#000000", size = 12)
  plot <- ggplot2::ggplot(compareData, ggplot2::aes(x = mean1, y = mean2)) +
    ggplot2::geom_point(ggplot2::aes(colour = domainId), shape = 16, size = 2) +
    ggplot2::scale_fill_manual(values = cbPalette) +
    ggplot2::geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    ggplot2::geom_hline(yintercept = 0) +
    ggplot2::geom_vline(xintercept = 0) +
    ggplot2::scale_x_continuous(xLabel, limits = limits) +
    ggplot2::scale_y_continuous(yLabel, limits = limits) +
    ggplot2::theme(text = theme, legend.position = legend) +
    ggplot2::labs(col = "Domain")
  return(plot)
}
