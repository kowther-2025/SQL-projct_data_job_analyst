select * FROM job_postings_fact
limit 50;

SELECT '2023-02-19':: date;


select 
job_title_short as title,
job_location as location,
job_posted_date as date
from 
job_postings_fact
LIMIT 5;


select 
job_title_short as title,
job_location as location,
job_posted_date at time zone 'utc'At time zone  'est' ,
EXTRACT(MONTH from job_posted_date) as date_month
from 
job_postings_fact
limit 5;

select  
count(job_id) as job_posted_count,
EXTRACT(month from job_posted_date) as month
from job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY MONTH
ORDER BY 
job_posted_count DESC
;


select *
from job_postings_fact
WHERE extract (month from job_posted)