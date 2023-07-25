drop table if exists #candidate_mothers;
select
  distinct
  ce.person_id,
	ppp.family_source_value,
	p.year_of_birth
into #candidate_mothers
from @cdm_database_schema.condition_era ce
inner join @cdm_database_schema.payer_plan_period ppp
	on ppp.person_id = ce.person_id
	and ce.condition_era_end_date >= ppp.payer_plan_period_start_date
	and ce.condition_era_end_date <= ppp.payer_plan_period_end_date
inner join @cdm_database_schema.person p
	on p.person_id = ce.person_id
	and p.gender_concept_id = 8532
where ce.condition_concept_id = 433260
and ce.condition_occurrence_count = 0
;


drop table if exists #candidate_infants;
select
  person_id,
  family_source_value,
  year_of_birth,
  min(observation_period_start_date) as observation_period_start_date,
  min(to_date(year_of_birth||'-'||month_of_birth||'-'||day_of_birth, ' YYYY- MM- DD')) as date_of_birth
into #candidate_infants
from (
  select
    p.person_id,
    ppp.family_source_value,
    p.year_of_birth as year_of_birth_num,
    op.observation_period_start_date as observation_period_start_date,
    to_char(p.year_of_birth, '0000') as year_of_birth,
    case
      when p.month_of_birth is not null
        and p.month_of_birth >= 1
        and p.month_of_birth <= 12
      then to_char(p.month_of_birth, '00')
      else to_char(date_part(m, op.observation_period_start_date), '00')
      end as month_of_birth,
    case
      when p.day_of_birth is not null
        and p.day_of_birth >= 1
        and p.day_of_birth <= 31
      then to_char(p.day_of_birth , '00')
      else to_char(01, '00') end as day_of_birth
  from @cdm_database_schema.payer_plan_period ppp
  inner join @cdm_database_schema.person p
    on ppp.person_id = p.person_id
  inner join @cdm_database_schema.observation_period op
    on p.person_id = op.person_id
    and op.observation_period_start_date >= ppp.payer_plan_period_start_date
    and op.observation_period_start_date <= ppp.payer_plan_period_end_date
  where date_part(y, observation_period_start_date) - p.year_of_birth = 0
  and p.person_id not in (
    select
      person_id
    from @cdm_database_schema.condition_era
    where condition_concept_id = 433260
    and condition_occurrence_count = 0
  )
) a
where family_source_value in (
  select
    distinct
    family_source_value
  from #candidate_mothers
)
group by
  person_id,
  family_source_value,
  year_of_birth
;


drop table if exists #candidate_mother_infants;
select
  distinct
  cm.person_id as mother_person_id,
  cm.year_of_birth as mother_yob,
  cm.family_source_value as mother_family_source_value,
  ci.person_id as infant_person_id,
  ci.date_of_birth as infant_dob,
  ci.family_source_value as infant_family_source_value,
  row_number() over (partition by ci.person_id order by ci.person_id, cm.person_id) as mothers_per_infant -- drop later if >1 ?
into #candidate_mother_infants
from #candidate_mothers cm
inner join #candidate_infants ci
  on cm.family_source_value = ci.family_source_value
inner join @cdm_database_schema.observation_period op
  on cm.person_id = op.person_id
  and ci.date_of_birth >= op.observation_period_start_date
  and ci.date_of_birth <= op.observation_period_end_date
where cm.person_id <> ci.person_id
;


drop table if exists #probable_mother_infants;
select
  cmi.mother_person_id,
  cmi.mother_yob,
  cmi.infant_person_id,
  cmi.infant_dob as inferred_infant_dob,
  ceb.condition_era_start_date as pregnancy_episode_start_date,
  ceb.condition_era_end_date as pregnancy_episode_end_date,
  cmi.mothers_per_infant
  {@first_outcome_only} ? {
    , row_number() over (partition by cmi.mother_person_id order by cmi.mother_person_id, ceb.condition_era_end_date) as multi
  }
into #probable_mother_infants
from #candidate_mother_infants cmi
inner join (
	select
	  person_id,
	  condition_era_start_date,
	  condition_era_end_date
	from @cdm_database_schema.condition_era
	where condition_concept_id = 433260
	and condition_occurrence_count = 0
) ceb
	on cmi.mother_person_id = ceb.person_id
	and ceb.condition_era_end_date >= dateadd(d, -@infant_dob_window, cmi.infant_dob)
	and ceb.condition_era_end_date <= dateadd(d, @infant_dob_window, cmi.infant_dob)
;


drop table if exists #inferred_mother_infants;
select
  *
into #inferred_mother_infants
from #probable_mother_infants

where mothers_per_infant = 1
  {@first_outcome_only} ? {
   and multi = 1
  }
;


insert into @cohort_database_schema.@inferred_link_table (
  mother_person_id,
  infant_person_id,
  inferred_infant_dob,
  pregnancy_episode_start_date,
  pregnancy_episode_end_date
)
select
  mother_person_id,
  infant_person_id,
  inferred_infant_dob,
  pregnancy_episode_start_date,
  pregnancy_episode_end_date
from #inferred_mother_infants
{@first_outcome_only} ? {
    where multi = 1
}
;


insert into @cohort_database_schema.@cohort_table (
	cohort_definition_id,
	subject_id,
	cohort_start_date,
	cohort_end_date
)

select
  cohort_definition_id,
	subject_id,
	cohort_start_date,
	cohort_end_date
from (
  select
    1 as cohort_definition_id, --linked mothers pregnancy start
    mother_person_id as subject_id,
    pregnancy_episode_start_date as cohort_start_date,
    pregnancy_episode_end_date as cohort_end_date
  from #inferred_mother_infants
  {@first_outcome_only} ? {
    where multi = 1
  }

  union all

  select
    2 as cohort_definition_id, --linked mothers pregnancy end, same start/end date
    imi.mother_person_id as subject_id,
    imi.pregnancy_episode_end_date as cohort_start_date,
    imi.pregnancy_episode_end_date as cohort_end_date
  from #inferred_mother_infants imi
  inner join @cdm_database_schema.observation_period op
    on imi.mother_person_id = op.person_id
    and imi.pregnancy_episode_end_date >= op.observation_period_start_date
	  and imi.pregnancy_episode_end_date <= op.observation_period_end_date
  {@first_outcome_only} ? {
    where imi.multi = 1
  }

  union all

  select
    distinct
    3 as cohort_definition_id, --linked infants, same start/end date
    imi.infant_person_id as subject_id,
    imi.pregnancy_episode_end_date as cohort_start_date, --pregnancy end
    imi.pregnancy_episode_end_date as cohort_end_date
  from #inferred_mother_infants imi
    --inner join @cdm_database_schema.observation_period op
    --on imi.infant_person_id = op.person_id
    --and dateadd(day, 30, imi.inferred_infant_dob) >= op.observation_period_start_date
  	--and dateadd(day, -30, imi.inferred_infant_dob) <= op.observation_period_end_date
  {@first_outcome_only} ? {
    where imi.multi = 1
  }

  union all

  select
    cohort_definition_id,
    subject_id,
    cohort_start_date,
    cohort_end_date
  from (
    select
    distinct
    4 as cohort_definition_id, --all mothers preg start
    ce.person_id as subject_id,
    ce.condition_era_start_date as cohort_start_date,
    ce.condition_era_end_date as cohort_end_date
    {@first_outcome_only} ? {
      , row_number() over (partition by ce.person_id  order by ce.condition_era_start_date) as multi
    }
  from @cdm_database_schema.condition_era ce
  inner join @cdm_database_schema.payer_plan_period ppp
	  on ppp.person_id = ce.person_id
	  and ce.condition_era_end_date >= ppp.payer_plan_period_start_date
	  and ce.condition_era_end_date <= ppp.payer_plan_period_end_date
  where ce.condition_concept_id = 433260
  and ce.condition_occurrence_count = 0

  ) a
  {@first_outcome_only} ? {
    where multi = 1
  }

  union all

   select
    cohort_definition_id,
    subject_id,
    cohort_start_date,
    cohort_end_date
  from (
    select
    distinct
    5 as cohort_definition_id, --all mothers pregnancy end, same start/end date
    ce.person_id as subject_id,
    ce.condition_era_end_date as cohort_start_date,
    ce.condition_era_end_date as cohort_end_date
    {@first_outcome_only} ? {
      , row_number() over (partition by ce.person_id  order by ce.condition_era_end_date) as multi
    }
    from @cdm_database_schema.condition_era ce
    inner join @cdm_database_schema.payer_plan_period ppp
	    on ppp.person_id = ce.person_id
	    and ce.condition_era_end_date >= ppp.payer_plan_period_start_date
	    and ce.condition_era_end_date <= ppp.payer_plan_period_end_date
    where ce.condition_concept_id = 433260
    and ce.condition_occurrence_count = 0
  ) a
  {@first_outcome_only} ? {
    where multi = 1
  }

  union all

  select
    distinct
    6 as cohort_definition_id, --all infants
    p.person_id as subject_id,
    to_date(to_char(p.year_of_birth, '0000')||'-'||
        case
          when p.month_of_birth is not null
          and p.month_of_birth >= 1
          and p.month_of_birth <= 12
        then to_char(p.month_of_birth, '00')
        else to_char(date_part(m, op.observation_period_start_date), '00')
        end||'-'||
        case
          when p.day_of_birth is not null
          and p.day_of_birth >= 1
          and p.day_of_birth <= 31
        then to_char(p.day_of_birth , '00')
        else to_char(01, '00') end,
        ' YYYY- MM- DD') as cohort_start_date,
  	op.observation_period_end_date as cohort_end_date
  from @cdm_database_schema.person p
  inner join @cdm_database_schema.observation_period op
  	on p.person_id = op.person_id
    and to_date(to_char(p.year_of_birth, '0000')||'-'||
      case
        when p.month_of_birth is not null
        and p.month_of_birth >= 1
        and p.month_of_birth <= 12
      then to_char(p.month_of_birth, '00')
      else to_char(date_part(m, op.observation_period_start_date), '00')
      end||'-'||
      case
        when p.day_of_birth is not null
        and p.day_of_birth >= 1
        and p.day_of_birth <= 31
      then to_char(p.day_of_birth , '00')
      else to_char(01, '00') end,
    ' YYYY- MM- DD') >= op.observation_period_start_date
    and to_date(to_char(p.year_of_birth, '0000')||'-'||
      case
        when p.month_of_birth is not null
        and p.month_of_birth >= 1
        and p.month_of_birth <= 12
      then to_char(p.month_of_birth, '00')
      else to_char(date_part(m, op.observation_period_start_date), '00')
      end||'-'||
      case
        when p.day_of_birth is not null
        and p.day_of_birth >= 1
        and p.day_of_birth <= 31
      then to_char(p.day_of_birth , '00')
      else to_char(01, '00') end,
      ' YYYY- MM- DD') <= op.observation_period_end_date
  where date_part(y, observation_period_start_date) - p.year_of_birth = 0
  and p.person_id not in (
    select
      person_id
  	from @cdm_database_schema.condition_era
  	where condition_concept_id = 433260
  	and condition_occurrence_count = 0
  )
)
;


insert into @cohort_database_schema.@cohort_table (
	cohort_definition_id,
	subject_id,
	cohort_start_date,
	cohort_end_date
)
select
  7 as cohort_definition_id, -- not linked mothers pregnancy start
  subject_id,
	cohort_start_date,
	cohort_end_date
from @cohort_database_schema.@cohort_table
where cohort_definition_id = 4
and subject_id not in (
  select subject_id
  from @cohort_database_schema.@cohort_table
  where cohort_definition_id = 1
)
union all
select
  8 as cohort_definition_id, -- not linked mothers pregnancy end
  subject_id,
	cohort_start_date,
	cohort_end_date
from @cohort_database_schema.@cohort_table
where cohort_definition_id = 5
and subject_id not in (
  select subject_id
  from @cohort_database_schema.@cohort_table
  where cohort_definition_id = 2
)
union all
select
  9 as cohort_definition_id, -- not linked infants
  subject_id,
	cohort_start_date,
	cohort_end_date
from @cohort_database_schema.@cohort_table
where cohort_definition_id = 6
and subject_id not in (
  select subject_id
  from @cohort_database_schema.@cohort_table
  where cohort_definition_id = 3
)
union all
  select
    distinct
    10 as cohort_definition_id, --linked infants, same start/end date
    imi.infant_person_id as subject_id,
    min(observation_period_start_date) as cohort_start_date,
    min(observation_period_end_date) as cohort_end_date
  from #inferred_mother_infants imi
  inner join @cdm_database_schema.observation_period op
  on imi.infant_person_id = op.person_id
  {@first_outcome_only} ? {
    where imi.multi = 1
  }
  group by 1,2
  ;





