
select
   1 as step,
   'Candidate persons' as step_name,
   0 as pairs,
   (select count(distinct person_id) from #candidate_mothers) as mothers,
   (select count(distinct person_id) from #candidate_infants) as infants

union all

select
  2 as step,
  'Candidate links' as step_name,
  (select count(*) from #candidate_mother_infants) as pairs,
  (select count(distinct mother_person_id) from #candidate_mother_infants) as mothers,
  (select count(distinct infant_person_id) from #candidate_mother_infants) as infants

union all

select
  3 as step,
  'Probable links' as step_name,
  (select count(*) from #probable_mother_infants) as pairs,
  (select count(distinct mother_person_id) from #probable_mother_infants) as mothers,
  (select count(distinct infant_person_id) from #probable_mother_infants) as infants

union all

select
  4 as step,
  'Inferred links' as step_name,
  (select count(*) from #inferred_mother_infants) as pairs,
  (select count(distinct mother_person_id) from #inferred_mother_infants) as mothers,
  (select count(distinct infant_person_id) from #inferred_mother_infants) as infants

order by step
;
