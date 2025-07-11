
-- Question 1:What are the top 10 most in-demand skills for Data Analysts, based on current job market trends?
SELECT 
    skills_dim.skills,
    COUNT(*) AS skill_demand
FROM job_postings_fact
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst'
  AND job_postings_fact.salary_year_avg IS NOT NULL
  AND job_postings_fact.salary_year_avg > 0
GROUP BY skills_dim.skills
ORDER BY skill_demand DESC
LIMIT 10
;

-- Question 2: Which skills are most commonly required for Data Analyst jobs by work location (Remote vs Onsite)?

SELECT *
FROM (
    SELECT 
        skills_dim.skills AS skill_name,
        CASE 
            WHEN job_postings_fact.job_location = 'Anywhere' THEN 'Remote'
            ELSE 'Onsite'
        END AS location_type,
        COUNT(*) AS skill_demand,
        ROW_NUMBER() OVER (
            PARTITION BY 
                CASE 
                    WHEN job_postings_fact.job_location = 'Anywhere' THEN 'Remote'
                    ELSE 'Onsite'
                END
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM job_postings_fact
    JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst'
      AND job_postings_fact.salary_year_avg IS NOT NULL
      AND job_postings_fact.salary_year_avg > 0
    GROUP BY 
        skills_dim.skills,
        CASE 
            WHEN job_postings_fact.job_location = 'Anywhere' THEN 'Remote'
            ELSE 'Onsite'
        END
) ranked
WHERE rank <= 5
ORDER BY location_type, skill_demand DESC;




-- Question 3: What are the top 10 highest-paying Data Analyst roles by average annual salary?

SELECT 
    job_title,
    name AS company_name,
    MAX(salary_year_avg) AS salary_year_avg
FROM job_postings_fact
JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title ILIKE '%data analyst%'
    AND salary_year_avg IS NOT NULL
GROUP BY job_title, name
ORDER BY salary_year_avg DESC
LIMIT 10;


-- Question 4:How do companies differ in their degree requirements when hiring Data Analysts, and what is the distribution of these roles?

SELECT 
    company_dim.name AS company_name,
    CASE 
        WHEN job_no_degree_mention = TRUE THEN 'No Degree Required'
        WHEN job_no_degree_mention = FALSE THEN 'Degree Required'
        ELSE 'Not Mentioned'
    END AS degree_requirement,
    COUNT(*) AS job_postings_count
FROM job_postings_fact
JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst'
GROUP BY company_dim.name, 
         CASE 
            WHEN job_no_degree_mention = TRUE THEN 'No Degree Required'
            WHEN job_no_degree_mention = FALSE THEN 'Degree Required'
            ELSE 'Not Mentioned'
         END
HAVING COUNT(*) >= 3
ORDER BY job_postings_count DESC
LIMIT 10;


-- Question 5: Which companies are hiring the most Data Analysts globally, and how are their job postings distributed between remote and onsite roles?

   SELECT 
    company_name,
    SUM(CASE WHEN location_type = 'Remote' THEN job_count ELSE 0 END) AS remote_jobs,
    SUM(CASE WHEN location_type = 'Onsite' THEN job_count ELSE 0 END) AS onsite_jobs,
    SUM(job_count) AS total_jobs
FROM (
    SELECT 
        company_dim.name AS company_name,
        CASE 
            WHEN job_postings_fact.job_location ILIKE '%remote%' 
                 OR job_postings_fact.job_location ILIKE '%work from home%' 
                 OR job_postings_fact.job_location ILIKE '%anywhere%' 
            THEN 'Remote'
            ELSE 'Onsite'
        END AS location_type,
        COUNT(*) AS job_count
    FROM job_postings_fact
    JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst'
    GROUP BY company_dim.name, location_type
) AS sub
GROUP BY company_name
ORDER BY total_jobs DESC
LIMIT 10;


-- Question 6: What are the top 5 skills demanded in the highest-paying (top 20%) Data Analyst roles, comparing remote and city-based positions?.


WITH high_salary_jobs AS (
    SELECT *
    FROM (
        SELECT *,   
               NTILE(5) OVER (ORDER BY salary_year_avg DESC) AS salary_rank
        FROM job_postings_fact
        WHERE job_title_short = 'Data Analyst'
          AND salary_year_avg IS NOT NULL
          AND salary_year_avg > 0
    ) ranked_jobs
    WHERE salary_rank = 1  -- top 20% highest-paying jobs
),
job_with_location AS (
    SELECT 
        job_id,
        CASE 
            WHEN job_location ILIKE '%remote%' 
                 OR job_location ILIKE '%work from home%' 
                 OR job_location ILIKE '%anywhere%' 
            THEN 'Remote'
            ELSE 'City-based'
        END AS location_type
    FROM high_salary_jobs
),
skills_count AS (
    SELECT
        skills_dim.skills AS skill_name,
        job_with_location.location_type,
        COUNT(*) AS skill_demand,
        ROW_NUMBER() OVER (
            PARTITION BY job_with_location.location_type
            ORDER BY COUNT(*) DESC
        ) AS rank
    FROM job_with_location
    JOIN skills_job_dim ON job_with_location.job_id = skills_job_dim.job_id
    JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY skills_dim.skills, job_with_location.location_type
)
SELECT skill_name, location_type, skill_demand
FROM skills_count
WHERE rank <= 5
ORDER BY location_type, skill_demand DESC;

