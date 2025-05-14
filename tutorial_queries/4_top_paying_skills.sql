
/*
Answer: What are the top skills basend on salary?
-look at the avarage salary associated with each skills for data analyst postings
- focus on roles with specified salaries, regardless of location
- why? it reveals how different skills impact salary levels for data analyst and 
helps identify the most financially rewarding skills or improve
*/

select 
    skills,
  Round(avg(salary_year_avg),0) as avg_salary
from  job_postings_fact
 inner JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
 INNER JOIN skills_dim on skills_job_dim.skill_id= skills_dim.skill_id
 where
 job_title_short= 'Data Analyst' and 
 salary_year_avg is NOT NULL
 GROUP BY skills
 ORDER BY avg_salary DESC
 LIMIT 10;