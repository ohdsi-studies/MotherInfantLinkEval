with raw_data as (
	select
	  0 as concept_id,
	  imi.infant_person_id,
		datediff(day, imi.pregnancy_episode_end_date, imi.inferred_infant_dob) as stat_value
	from #inferred_mother_infants imi
),
overall_stats as (
  select
    concept_id,
    avg(1.0 * stat_value) as avg_value,
    stdev(stat_value) as stdev_value,
    min(stat_value) as min_value,
    max(stat_value) as max_value,
    count(*) as total
  from raw_data
  group by
    concept_id
),
stats as (
  select
    concept_id,
    stat_value,
    count(*) as total,
    row_number() over (order by stat_value) as rn
  from raw_data
  group by
    concept_id,
    stat_value
),
stats_prior as (
  select
    s.concept_id,
    s.stat_value,
    s.total,
    sum(p.total) as accumulated
  from stats s
  join stats p
    on s.concept_id = p.concept_id
    and p.rn <= s.rn
  group by
    s.concept_id,
    s.stat_value,
    s.total,
    s.rn
),
time_diff as (
  select
    o.concept_id,
	  'Inferred DOB-pregnancy episode end date difference' as covariate_id,
    o.total as count_value,
	  o.min_value,
	  o.max_value,
	  o.avg_value,
	  o.stdev_value,
	  min(case when p.accumulated >= .10 * o.total then stat_value end) as p10_value,
	  min(case when p.accumulated >= .25 * o.total then stat_value end) as p25_value,
	  min(case when p.accumulated >= .50 * o.total then stat_value end) as median_value,
	  min(case when p.accumulated >= .75 * o.total then stat_value end) as p75_value,
	  min(case when p.accumulated >= .90 * o.total then stat_value end) as p90_value
from stats_prior p
join overall_stats o
  on p.concept_id = o.concept_id
group by
  o.concept_id,
  o.total,
  o.min_value,
  o.max_value,
  o.avg_value,
  o.stdev_value
)
select * from time_diff
;
