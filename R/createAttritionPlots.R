#' @export
createAttritionPlots <- function(studyFolder,
                                 linksLabel = "Links",
                                 mothersLabel = "Mothers",
                                 infantsLabel = "Infants") {

  outputFolder <- file.path(studyFolder, "output")
  if (!file.exists(outputFolder)) {
    dir.create(outputFolder)
  }

  analysisVariants <- c("All pregnancies - 60d", "First pregnancies - 60d", "All pregnanices - 90d")
  databaseIds <- c("truven_ccae", "optum_extended_dod")

  for (analysisVariant in analysisVariants) { # analysisVariant <- analysisVariants[1]

    if (analysisVariant == "All pregnancies - 60d") {
      analysisId <- "primary"
    }
    if (analysisVariant == "First pregnancies - 60d") {
      analysisId <- "first"
    }
    if (analysisVariant == "All pregnanices - 90d") {
      analysisId <- "birth90"
    }

    attritionPlots <- list()
    for (databaseId in databaseIds) { # databaseId <- databaseIds[2]

      attrition <- read.csv(file.path(studyFolder, databaseId, analysisId, "attritionCounts.csv"))
      attrition$pairDrops <- NA
      attrition$motherDrops <- NA
      attrition$infantDrops <- NA

      for (i in 1:nrow(attrition)) { # i=1
        attrition$pairDrops[i] <- attrition$pairs[i] - attrition$pairs[i + 1]
        attrition$motherDrops[i] <- attrition$mothers[i] - attrition$mothers[i + 1]
        attrition$infantDrops[i] <- attrition$infants[i] - attrition$infants[i + 1]
      }

      data <- list(leftBoxText = c(),
                   rightBoxText = c())

      for (i in 1:nrow(attrition)) { # i=1

        if (i == 1) {

          leftBoxText <- paste0(attrition$stepName[i], "\n",
                                mothersLabel, ": n = ",
                                formatC(attrition$mothers[i], big.mark = ",", format = "d"),
                                "\n",
                                infantsLabel, ": n = ",
                                formatC(attrition$infants[i], big.mark = ",", format = "d"))

          motherPercentDrop <- attrition$motherDrops[i] / attrition$mothers[i] * 100
          motherPercentDrop <- ifelse(motherPercentDrop < 0.01, 0.01, round(motherPercentDrop, 2))

          infantPercentDrop <- attrition$infantDrops[i] / attrition$infants[i] * 100
          infantPercentDrop <- ifelse(infantPercentDrop < 0.01, 0.01, round(infantPercentDrop, 2))

          rightBoxText <- paste0("\n",
                                 mothersLabel, ": n = ",
                                 formatC(attrition$motherDrops[i], big.mark = ",", format = "d"),
                                 paste0(" (", motherPercentDrop, "%)"),
                                 "\n",
                                 infantsLabel, ": n = ",
                                 formatC(attrition$infantDrops[i], big.mark = ",", format = "d"),
                                 paste0(" (", infantPercentDrop, "%)"))


        } else {

          leftBoxText <- paste0(attrition$stepName[i], "\n",
                                linksLabel, ": n = ",
                                formatC(attrition$pairs[i], big.mark = ",", format = "d"),
                                "\n",
                                mothersLabel, ": n = ",
                                formatC(attrition$mothers[i], big.mark = ",", format = "d"),
                                "\n",
                                infantsLabel, ": n = ",
                                formatC(attrition$infants[i], big.mark = ",", format = "d"))

          pairPercentDrop <- attrition$pairDrops[i] / attrition$pairs[i] * 100
          pairPercentDrop <- ifelse(pairPercentDrop < 0.01, 0.01, round(pairPercentDrop, 2))

          motherPercentDrop <- attrition$motherDrops[i] / attrition$mothers[i] * 100
          motherPercentDrop <- ifelse(motherPercentDrop < 0.01, 0.01, round(motherPercentDrop, 2))

          infantPercentDrop <- attrition$infantDrops[i] / attrition$infants[i] * 100
          infantPercentDrop <- ifelse(infantPercentDrop < 0.01, 0.01, round(infantPercentDrop, 2))

          rightBoxText <- paste0("\n",
                                 linksLabel, ": n = ",
                                 formatC(attrition$pairDrops[i], big.mark = ",", format = "d"),
                                 paste0(" (", pairPercentDrop, "%)"),
                                 "\n",
                                 mothersLabel, ": n = ",
                                 formatC(attrition$motherDrops[i], big.mark = ",", format = "d"),
                                 paste0(" (", motherPercentDrop, "%)"),
                                 "\n",
                                 infantsLabel, ": n = ",
                                 formatC(attrition$infantDrops[i], big.mark = ",", format = "d"),
                                 paste0(" (", infantPercentDrop, "%)"))

        }

        data$leftBoxText[i] <- leftBoxText
        data$rightBoxText[i] <- rightBoxText

      }

      leftBoxText <- data$leftBoxText
      rightBoxText <- data$rightBoxText
      nSteps <- length(leftBoxText)

      # plot params and functions ==============================================
      boxHeight <- (1/nSteps) - 0.03
      boxWidth <- 0.45
      shadowOffset <- 0.01
      arrowLength <- 0.01

      x <- function(x) {
        return(0.25 + ((x - 1)/2))
      }

      y <- function(y) {
        return(1 - (y - 0.5) * (1/nSteps))
      }

      downArrow <- function(p, x1, y1, x2, y2) {
        p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x1, y = y1, xend = x2, yend = y2))
        p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                           y = y2,
                                                           xend = x2 + arrowLength,
                                                           yend = y2 + arrowLength))
        p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                           y = y2,
                                                           xend = x2 - arrowLength,
                                                           yend = y2 + arrowLength))
        return(p)
      }

      rightArrow <- function(p, x1, y1, x2, y2) {
        p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x1, y = y1, xend = x2, yend = y2))
        p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                           y = y2,
                                                           xend = x2 - arrowLength,
                                                           yend = y2 + arrowLength))
        p <- p + ggplot2::geom_segment(ggplot2::aes_string(x = x2,
                                                           y = y2,
                                                           xend = x2 - arrowLength,
                                                           yend = y2 - arrowLength))
        return(p)
      }

      box <- function(p, x, y) {
        p <- p + ggplot2::geom_rect(ggplot2::aes_string(xmin = x - (boxWidth/2) + shadowOffset,
                                                        ymin = y - (boxHeight/2) - shadowOffset,
                                                        xmax = x + (boxWidth/2) + shadowOffset,
                                                        ymax = y + (boxHeight/2) - shadowOffset), fill = rgb(0,
                                                                                                             0,
                                                                                                             0,
                                                                                                             alpha = 0.2))
        p <- p + ggplot2::geom_rect(ggplot2::aes_string(xmin = x - (boxWidth/2),
                                                        ymin = y - (boxHeight/2),
                                                        xmax = x + (boxWidth/2),
                                                        ymax = y + (boxHeight/2)), fill = rgb(0.94,
                                                                                              0.94,
                                                                                              0.94), color = "black")
        return(p)
      }

      label <- function(p, x, y, text, hjust = 0) {
        p <- p + ggplot2::geom_text(ggplot2::aes_string(x = x, y = y, label = paste("\"", text, "\"",
                                                                                    sep = "")),
                                    hjust = hjust,
                                    size = 3.7)
        return(p)
      }


      # draw plot  =================================================================
      p <- ggplot2::ggplot()
      for (i in 1:(nSteps-1)) {
        p <- downArrow(p, x(1), y(i) - (boxHeight/2), x(1), y(i + 1) + (boxHeight/2))
        p <- label(p, x(1) + 0.02, y(i + 0.5), "Y")
      }

      for (i in 1:(nSteps-1)) {
        p <- rightArrow(p, x(1) + boxWidth/2, y(i), x(2) - boxWidth/2, y(i))
        p <- label(p, x(1.5), y(i) - 0.02, "N", 0.5)
      }

      for (i in 1:nSteps) {
        p <- box(p, x(1), y(i))
      }

      for (i in 1:(nSteps-1)) {
        p <- box(p, x(2), y(i))
      }

      for (i in 1:nSteps) {
        p <- label(p, x(1) - boxWidth/2 + 0.02, y(i), text = leftBoxText[i])
      }

      for (i in 1:(nSteps - 1)) {
        p <- label(p, x(2) - boxWidth/2 + 0.02, y(i), text = rightBoxText[i])
      }

      p <- p + ggplot2::theme(legend.position = "none",
                              plot.background = ggplot2::element_blank(),
                              panel.grid.major = ggplot2::element_blank(),
                              panel.grid.minor = ggplot2::element_blank(),
                              panel.border = ggplot2::element_blank(),
                              panel.background = ggplot2::element_blank(),
                              axis.text = ggplot2::element_blank(),
                              axis.title = ggplot2::element_blank(),
                              axis.ticks = ggplot2::element_blank())

      attritionPlots[[length(attritionPlots) + 1]] <- p
    }

    # save analysis, 2-db plot here

    col1 <- grid::textGrob("CCAE", gp = grid::gpar(fontsize = 14))
    col2 <- grid::textGrob("Clinformatics®", gp = grid::gpar(fontsize = 14))

    plotGrob <- gridExtra::arrangeGrob(col1, col2,
                                       attritionPlots[[1]], attritionPlots[[2]],
                                       heights = c(0.5, 8),
                                       widths = c(8, 8),
                                       nrow = 2)

    plotName <- paste0(analysisId, "_attritionPlot.png")
    ggplot2::ggsave(file.path(outputFolder, plotName),
                    plotGrob,
                    height = 8,
                    width = 12)
  }
}



