if object_id('@cohort_database_schema.@inferred_link_table', 'U') is not null
	drop table @cohort_database_schema.@inferred_link_table;

create table @cohort_database_schema.@inferred_link_table (
  mother_person_id bigint,
  infant_person_id bigint,
  inferred_infant_dob date,
  pregnancy_episode_start_date date,
  pregnancy_episode_end_date date
);

if object_id('@cohort_database_schema.@cohort_table', 'U') is not null
	drop table @cohort_database_schema.@cohort_table;

create table @cohort_database_schema.@cohort_table (
	cohort_definition_id int,
	subject_id bigint,
	cohort_start_date date,
	cohort_end_date date
);





