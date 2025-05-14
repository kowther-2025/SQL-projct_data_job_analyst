
/*
Question : What are the most in_demand skills for data analyst?
- join job postings to inner join table similar to query 2
- identify the top 5 in_demand  skills for the data analyst .
focus on all jobs postings.
- why? retrieves the  top 5 skills with the highest  demand in the job market,
providing insights into the most valuable skills for the job seekers.
*/

select 
    skills,
    count(skills_job_dim.job_id) as demand_count
from  job_postings_fact
 inner JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
 INNER JOIN skills_dim on skills_job_dim.skill_id= skills_dim.skill_id
 where
 job_title_short= 'Data Analyst'
 GROUP BY skills
 ORDER BY demand_count DESC
 LIMIT 5;