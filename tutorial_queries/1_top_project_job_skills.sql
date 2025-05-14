
--delete this later

/*  Question : what are the top_paying data analyst jobs?
- identify the top 10 highest-paying data analyst roles that are available remotely.
-focuses on job posting with specified slaries (remove nulls).
-why? highlight the top-paying opportunities, offering insights into employee
*/

select 
job_id,
job_title,
job_location,
job_schedule_type,
salary_year_avg,
job_posted_date,
name as company_name
FROM  
job_postings_fact
LEFT JOIN company_dim on job_postings_fact.company_id= company_dim.company_id
where job_title_short = 'Data Analyst' and 
job_location = 'Anywhere' and 
salary_year_avg is NOT  null

ORDER BY 
salary_year_avg DESC
limit 10
;