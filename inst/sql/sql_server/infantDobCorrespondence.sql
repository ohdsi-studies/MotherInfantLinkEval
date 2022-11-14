select
  1.0 * sum(case when datediff(day, pregnancy_episode_end_date, inferred_infant_dob) = 0 then 1 else 0 end) / count(mother_person_id) as pct_same_date,
	1.0 * sum(case when abs(datediff(day, pregnancy_episode_end_date, inferred_infant_dob)) <= 7 then 1 else 0 end) / count(mother_person_id) as pct_in_1wk,
	1.0 * sum(case when abs(datediff(day, pregnancy_episode_end_date, inferred_infant_dob)) <= 14 then 1 else 0 end) / count(mother_person_id) as pct_in_2wk,
	1.0 * sum(case when abs(datediff(day, pregnancy_episode_end_date, inferred_infant_dob)) <= 30 then 1 else 0 end) / count(mother_person_id) as pct_in_4wk
from #inferred_mother_infants
;
