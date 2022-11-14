#' @export
constructCohorts <- function(connectionDetails,
                             outputFolder,
                             databaseId,
                             cdmDatabaseSchema,
                             cohortDatabaseSchema,
                             cohortTable,
                             inferredLinkTable,
                             firstOutcomeOnly = FALSE,
                             infantDobWindow = 60) {

  connection <- DatabaseConnector::connect(connectionDetails)

  # create cohort table ========================================================
  writeLines("Creating linkage and cohort tables...")
  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "createTables.sql",
                                           packageName = "motherinfantevaluation",
                                           dbms = connectionDetails$dbms,
                                           cohort_database_schema = cohortDatabaseSchema,
                                           cohort_table = cohortTable,
                                           inferred_link_table = inferredLinkTable)
  DatabaseConnector::executeSql(connection, sql)


  # construct cohorts ==========================================================
  writeLines("Applying mothing-infant linkage algorithm and constructing cohorts...")
  sql <- SqlRender::loadRenderTranslateSql(sqlFilename = "constructCohorts.sql",
                                           packageName = "motherinfantevaluation",
                                           dbms = connectionDetails$dbms,
                                           cdm_database_schema = cdmDatabaseSchema,
                                           first_outcome_only = firstOutcomeOnly,
                                           cohort_database_schema = cohortDatabaseSchema,
                                           cohort_table = cohortTable,
                                           inferred_link_table = inferredLinkTable,
                                           infant_dob_window = infantDobWindow)
  SqlRender::writeSql(sql, file.path(outputFolder, "cohortConstruction.sql"))
  DatabaseConnector::executeSql(connection, sql)

  # simple characterizations ===================================================

  cohortRefFile <- system.file("csv", "cohortRef.csv", package = "motherinfantevaluation")
  cohortRef <- readr::read_csv(cohortRefFile, show_col_types = FALSE)

  sql <- "select
          cohort_definition_id,
          count(*) records,
          count(distinct subject_id) persons
          from @cohort_database_schema.@cohort_table
          group by cohort_definition_id
          order by cohort_definition_id;"
  sql <- SqlRender::render(sql = sql,
                           cohort_database_schema = cohortDatabaseSchema,
                           cohort_table = cohortTable)
  sql <- SqlRender::translate(sql = sql,
                              targetDialect = connection@dbms)
  counts <- DatabaseConnector::querySql(connection, sql, snakeCaseToCamelCase = TRUE)
  counts <- dplyr::inner_join(cohortRef[, c("cohortDefinitionId", "cohortName")],
                              counts)
  readr::write_csv(counts, file.path(outputFolder, "cohortCounts.csv"))


  path <- file.path("inst/sql/sql_server/infantDobCorrespondence.sql")
  sql <- SqlRender::readSql(path)
  sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
  infantDobCorrespondence <- DatabaseConnector::querySql(connection, sql, snakeCaseToCamelCase = TRUE)
  readr::write_csv(infantDobCorrespondence, file.path(outputFolder, "infantDobCorrespondence.csv"))

  path <- file.path("inst/sql/sql_server/infantDobCorrespondenceDist.sql")
  sql <- SqlRender::readSql(path)
  sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
  infantDobCorrespondenceDist <- DatabaseConnector::querySql(connection, sql, snakeCaseToCamelCase = TRUE)
  readr::write_csv(infantDobCorrespondenceDist, file.path(outputFolder, "infantDobCorrespondenceDist.csv"))


  path <- file.path("inst/sql/sql_server/getAttritionCounts.sql")
  sql <- SqlRender::readSql(path)
  sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
  attritionCounts <- DatabaseConnector::querySql(connection, sql, snakeCaseToCamelCase = TRUE)
  readr::write_csv(attritionCounts, file.path(outputFolder, "attritionCounts.csv"))

  # path <- file.path("inst/sql/sql_server/cleanUp.sql")
  # sql <- SqlRender::readSql(path)
  # sql <- SqlRender::translate(sql, targetDialect = connectionDetails$dbms)
  # DatabaseConnector::executeSql(connection, sql)

}
