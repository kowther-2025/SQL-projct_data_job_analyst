select *
from job_postings_fact
WHERE extract (month from job_posted_date) = 1
;

SELECT job_posted_date, TO_CHAR(job_posted_date, 'Month') AS month_name
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

create table january_jobs as 

 select * 
 from job_postings_fact
 where extract(month from job_posted_date) = 1;

CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

 SELECT job_posted_date
 from january_jobs 
 where extract(month from job_posted_date) = 1;

/*
The query mentioned below explains that when you need to label some columns, you can use CASE expressions.  
*/

 select 
 job_title_short,
 job_location,
    case 
    when job_location = 'Anywhere' then 'Remote'
    when job_location = 'New York, NY' then 'local'
    else 'Onsite'
    end as location_category
 from  job_postings_fact;

/*
Also, if you want to know how many jobs to apply for specifically romote one ,local,and onsite 
*/

 select 
 count(job_id) as number_of_jobs,
    case 
    when job_location = 'Anywhere' then 'Remote'
    when job_location = 'New York, NY' then 'local'
    else 'Onsite'
    end as location_category
 from  job_postings_fact
where job_title_short = 'Data Analyst'
 GROUP BY
 location_category;

 -- subquey and CTE

  select *
  from (
   select * from job_postings_fact
   where EXTRACT(Month from job_posted_date) = 1
  ) as january_jobs;

 with january_jobs  as (
   select * 
   from job_postings_fact
   where EXTRACT(Month from job_posted_date) = 1
   )

   select *
   from january_jobs;

 --- subquery

   select 
   company_id,
   name as company_name
   from 
   company_dim
   where 
   company_id IN(
      select 
      company_id 
      from job_postings_fact
      where job_no_degree_mention= true
      order by
       company_id
   );

   --CTE

   with company_job_count as (
          select company_id,
          count(*)
          from job_postings_fact
          GROUP BY 
          company_id
   )
    select * 
    from  company_job_count;



 with company_job_count as (
          select company_id,
          count(*) as total_jobs
          from job_postings_fact
          GROUP BY 
          company_id
   )
    select 
       company_dim. name as company_name,
        company_job_count.total_jobs
    from 
    company_dim
    left join company_job_count on company_job_count.company_id = company_dim.company_id
    ORDER BY 
    total_jobs DESC;



with remote_job_skills as (
   select 
      skill_id,
   count(*) as skill_count
      from 
      skills_job_dim as skills_to_job
      inner join job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
      where 
      job_postings.job_work_from_home = true and 
      job_postings.job_title_short = 'Data Analyst'
      GROUP BY  skill_id 
) 
select 
skills.skill_id,
skills as skill_name,
skill_count 
from remote_job_skills
inner join skills_dim as skills on skills.skill_id = remote_job_skills.skill_id 
ORDER BY 
skill_count DESC
limit 6;


---- union


select 
job_title_short,
company_id,
job_location
from 
january_jobs
union 
select
job_title_short,
company_id,
job_location
from  february_jobs;


--- problem 
select 
job_location,
job_via,
job_posted_date::date,
salary_year_avg
from(
   select * 
   from january_jobs 
   UNION all
   select *
   from february_jobs

) as quater1_job_postings
where  
salary_year_avg >70000 and
job_title_short ='Data Analyst'
ORDER BY salary_year_avg DESC
 ;


