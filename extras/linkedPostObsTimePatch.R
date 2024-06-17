# Global =======================================================================

library(magrittr)
studyFolder <- "G:/motherinfantevaluation2"

rawSql <- "select
  infant_person_id,
  pregnancy_episode_end_date,
  first_obs_end_date,
  datediff(day, pregnancy_episode_end_date, first_obs_end_date) as days_preg_end_obs_end
from (
  select
  mother_person_id,
  infant_person_id,
  inferred_infant_dob,
  pregnancy_episode_start_date,
  pregnancy_episode_end_date,
  min(observation_period_start_date) as first_obs_start_date,
  min(observation_period_end_Date) as first_obs_end_date
from @cohort_database_schema.@inferred_link_table il
  join @cdm_database_schema.observation_period op
  on il.infant_person_id = op.person_id
group by
  mother_person_id,
  infant_person_id,
  inferred_infant_dob,
  pregnancy_episode_start_date,
  pregnancy_episode_end_date
)"

# CCAE =========================================================================

databaseId <- "truven_ccae"
cdmDatabaseSchema <- "cdm_truven_ccae_v1831"
cohortDatabaseSchema <-"scratch_jweave17"
inferredLinkTable <- "mother_infant_inferred_linkage_v1831"
inferredLinkTableFirst <- "mother_infant_inferred_linkage_first_v1831"
inferredLinkTable90 <- "mother_infant_inferred_linkage_90_v1831"

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = keyring::key_get("DBMS"),
  server = paste0(keyring::key_get("OHDA_SERVER"), databaseId),
  extraSettings = keyring::key_get("EXTRA_SETTINGS"),
  port = keyring::key_get("port"),
  user = keyring::key_get("OHDA_USER"),
  password = keyring::key_get("OHDA_PASSWORD"))

connection <- DatabaseConnector::connect(connectionDetails)

# primary
sql <- SqlRender::render(sql = rawSql,
                         cohort_database_schema = cohortDatabaseSchema,
                         inferred_link_table = inferredLinkTable,
                         cdm_database_schema = cdmDatabaseSchema)

diffDays <- DatabaseConnector::querySql(connection = connection,
                                        sql = sql,
                                        snakeCaseToCamelCase = TRUE) # 2528482

aPrimary <- tibble::tibble(db = "CCAE",
                           analysis = "primary",
                           n = nrow(diffDays),
                           mean = mean(diffDays$daysPregEndObsEnd),
                           sd = sd(diffDays$daysPregEndObsEnd),
                           median = median(diffDays$daysPregEndObsEnd))
rm(diffDays)

# first
sql <- SqlRender::render(sql = rawSql,
                         cohort_database_schema = cohortDatabaseSchema,
                         inferred_link_table = inferredLinkTableFirst,
                         cdm_database_schema = cdmDatabaseSchema)

diffDays <- DatabaseConnector::querySql(connection = connection,
                                        sql = sql,
                                        snakeCaseToCamelCase = TRUE)

aFirst <- tibble::tibble(db = "CCAE",
                         analysis = "first",
                         n = nrow(diffDays),
                         mean = mean(diffDays$daysPregEndObsEnd),
                         sd = sd(diffDays$daysPregEndObsEnd),
                         median = median(diffDays$daysPregEndObsEnd))
rm(diffDays)

# 90d
sql <- SqlRender::render(sql = rawSql,
                         cohort_database_schema = cohortDatabaseSchema,
                         inferred_link_table = inferredLinkTable90,
                         cdm_database_schema = cdmDatabaseSchema)

diffDays <- DatabaseConnector::querySql(connection = connection,
                                        sql = sql,
                                        snakeCaseToCamelCase = TRUE)

a90 <- tibble::tibble(db = "CCAE",
                      analysis = "90d",
                      n = nrow(diffDays),
                      mean = mean(diffDays$daysPregEndObsEnd),
                      sd = sd(diffDays$daysPregEndObsEnd),
                      median = median(diffDays$daysPregEndObsEnd))
rm(diffDays)

ccaeOutput <- dplyr::bind_rows(aPrimary,
                               aFirst,
                               a90)
readr::write_csv(ccaeOutput, file.path(studyFolder, "ccaeLinkedPostObsTimePatch.csv"))


DatabaseConnector::disconnect(connection)


# Otpum ========================================================================

databaseId <- "optum_extended_dod"
cdmDatabaseSchema <- "cdm_optum_extended_dod_v1913"
cohortDatabaseSchema <- "scratch_jweave17"
inferredLinkTable <- "mother_infant_inferred_linkage_v1913"
inferredLinkTableFirst <- "mother_infant_inferred_linkage_first_v1913"
inferredLinkTable90 <- "mother_infant_inferred_linkage_90_v1913"


connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = keyring::key_get("DBMS"),
  server = paste0(keyring::key_get("OHDA_SERVER"), databaseId),
  extraSettings = keyring::key_get("EXTRA_SETTINGS"),
  port = keyring::key_get("port"),
  user = keyring::key_get("OHDA_USER"),
  password = keyring::key_get("OHDA_PASSWORD"))

connection <- DatabaseConnector::connect(connectionDetails)

# primary
sql <- SqlRender::render(sql = rawSql,
                         cohort_database_schema = cohortDatabaseSchema,
                         inferred_link_table = inferredLinkTable,
                         cdm_database_schema = cdmDatabaseSchema)

diffDays <- DatabaseConnector::querySql(connection = connection,
                                        sql = sql,
                                        snakeCaseToCamelCase = TRUE)

aPrimary <- tibble::tibble(db = "Optum",
                           analysis = "primary",
                           n = nrow(diffDays),
                           mean = mean(diffDays$daysPregEndObsEnd),
                           sd = sd(diffDays$daysPregEndObsEnd),
                           median = median(diffDays$daysPregEndObsEnd))
rm(diffDays)

# first
sql <- SqlRender::render(sql = rawSql,
                         cohort_database_schema = cohortDatabaseSchema,
                         inferred_link_table = inferredLinkTableFirst,
                         cdm_database_schema = cdmDatabaseSchema)

diffDays <- DatabaseConnector::querySql(connection = connection,
                                        sql = sql,
                                        snakeCaseToCamelCase = TRUE)

aFirst <- tibble::tibble(db = "Optum",
                         analysis = "first",
                         n = nrow(diffDays),
                         mean = mean(diffDays$daysPregEndObsEnd),
                         sd = sd(diffDays$daysPregEndObsEnd),
                         median = median(diffDays$daysPregEndObsEnd))
rm(diffDays)

# 90d
sql <- SqlRender::render(sql = rawSql,
                         cohort_database_schema = cohortDatabaseSchema,
                         inferred_link_table = inferredLinkTable90,
                         cdm_database_schema = cdmDatabaseSchema)

diffDays <- DatabaseConnector::querySql(connection = connection,
                                        sql = sql,
                                        snakeCaseToCamelCase = TRUE)

a90 <- tibble::tibble(db = "Optum",
                      analysis = "90d",
                      n = nrow(diffDays),
                      mean = mean(diffDays$daysPregEndObsEnd),
                      sd = sd(diffDays$daysPregEndObsEnd),
                      median = median(diffDays$daysPregEndObsEnd))
rm(diffDays)

# compile ======================================================================
optumOutput <- dplyr::bind_rows(aPrimary,
                                aFirst,
                                a90)
readr::write_csv(optumOutput, file.path(studyFolder, "optumLinkedPostObsTimePatch.csv"))

DatabaseConnector::disconnect(connection)

# add to shiny =================================================================
