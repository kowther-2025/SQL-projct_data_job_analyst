
# Introduction
 Project Introduction: Job Postings 2023
This project analyzes job postings data from 2023 to uncover key trends in hiring, skills demand, work formats, and employment types. Using structured SQL methods, such as joins, subqueries, and aggregations it transforms raw data into clear, actionable insights, offering a sharp view of the evolving job market.

This project was inspired by a SQL analysis tutorial by Luke Barousse and uses a 2023 job postings dataset. While the initial setup followed the tutorial, I expanded the analysis by crafting original questions and deriving unique insights. I used ChatGPT to validate my thinking, explore alternative approaches, and assist with visual storytelling. Visualizations were created using both ChatGPT and Julius.ai. The project was developed in SQL and supported by tools such as VS Code and GitHub.
 
- SQL queries. check them out here; [project_files](/project_files/first_practice_by_my_own/questions.sql)


# Background
The world of work is evolving—fast. With the rise of remote roles, tech-driven hiring, and shifting skill demands, 2023 marked a pivotal year in the job market. This project dives into real job postings to decode what employers truly value today. By analyzing thousands of listings with SQL, we uncover the trends shaping modern careers—from the hottest roles to the skills that open doors.
### The questions I aim to answer through my SQL queries;
1. What are the top 10 most in-demand skills for Data Analysts, based on current job market trends?

2. Which skills are most commonly required for Data Analyst jobs by work location (Remote vs Onsite)?

3. What are the top 10 highest-paying Data Analyst roles by average annual salary?

4. How do companies differ in their degree requirements when hiring Data Analysts, and what is the distribution of these roles?

5. Which companies are hiring the most Data Analysts globally, and how are their job postings distributed between remote and onsite roles?

6. What are the top 5 skills demanded in the highest-paying (top 20%) Data Analyst roles, comparing remote and city-based positions?.

# Tools & Technologies Used
- **SQL:** Core tool for data exploration, quality checks, and generating insights.
- **postgreSQL:** I used PostgreSQL for managing and storing the 2023 job postings dataset, enabling efficient querying and analysis throughout the project.
- **visual studio code** I used VS Code over pgAdmin for advanced SQL development and project management, thanks to its flexibility, extensions, and Git integration.
- **Git&github** Used for version control and project sharing, allowing collaboration and tracking of changes throughout development.
- **Julius.ai** used for generating professional data visualizations that enhance the clarity and impact of analysis results.
# The analysis
 Each SQL query in this project is designed to investigate a specific aspect of the dataset, with clear logic and purpose behind every analysis step.

 Here’s the approach I took to tackle the analysis effectively.
 ### Q1:What are the top 10 most in-demand skills for Data Analysts, based on current job market trends?. 

 This reveals the most valued technical skills for data analysts, helping job seekers and educators prioritize what matters in today’s job market.
  ```sql 
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
LIMIT 10;
 ```
 ### Result Table: Top 10 In-Demand Skills for Data Analysts.

| Skill        | Job Postings Count |
|--------------|--------------------|
| SQL          | 3083               |
| Excel        | 2143               |
| Python       | 1840               |
| Tableau      | 1659               |
| R            | 1073               |
| Power BI     | 1044               |
| SAS          | 1000               |
| Word         | 527                |
| PowerPoint   | 524                |
| SQL Server   | 336                |


![Top 10 Skills](project_files/images/Top10skills.png)
Here is the bar chart showing the Top 10 Most In-Demand Skills for Data Analysts, based on job postings with salary data.

# Key Findings & Insights

SQL is the top skill demanded, followed by Excel, Python, and Tableau. BI and database tools like Power BI, SAS, and SQL Server remain important, along with communication tools such as Word and PowerPoint.

# Q2:Which skills are most commonly required for Data Analyst jobs by work location (Remote vs Onsite)?.

Based on globally sourced job postings, this analysis compares the most in-demand technical skills for Onsite and Remote Data Analyst roles. The findings highlight how skill priorities differ by work setting, offering actionable insights for career growth and hiring.

``` sql
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
```
![remote vs onsite](project_files/images/onsite_vs_remote.png)

Side-by-side comparison of top skills for Onsite vs Remote Data Analyst roles, highlighting demand differences by location type.

# Key Findings & Insights

- SQL is the most in-demand skill for both Onsite and Remote roles, with Onsite demand (2685) far exceeding Remote (398).

- Excel, Python, and Tableau consistently rank in the top 5 for both categories, highlighting their universal value in data analysis roles.

- Power BI appears exclusively in Onsite roles, while R is specific to Remote roles — indicating differing tool preferences by work environment.

In general, Onsite roles show higher demand across all top skills, which may reflect a greater volume of Onsite postings or broader skill expectations.

# Q3: What are the top 10 highest-paying Data Analyst roles by average annual salary?.
In the competitive job market of 2023, compensation for Data Analyst roles varied significantly by company and seniority level. By analyzing job postings from that year containing “Data Analyst” in the title and including reported average annual salaries, we identified the highest-paying positions and the organizations offering them.
```sql 
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
```
# Result table of highest-paying Data Analyst roles (2023)
To keep this section concise, I’ve included only the top 5 roles in the table below. However, the full list of 10 highest-paying roles is visualized in the accompanying bar chart for complete context.
| Rank | Job Title                | Company                      | Salary (USD) |
| ---- | ------------------------ | ---------------------------- | ------------ |
| 1    | Data Analyst             | Mantys                       | \$650,000    |
| 2    | Senior Data Analyst SME  | Modern Tech Solutions        | \$375,000    |
| 3    | Sr Data Analyst          | Illuminate Mission Solutions | \$375,000    |
| 4    | Data Analyst             | Anthropic                    | \$350,000    |
| 5    | Quant Analyst (Contract) | Eden Smith Group             | \$340,000    |

Other high-paying roles from GradBay, TikTok, Walmart, and Pinterest (salaries $230K–$240K) are reflected in the chart above.

![remote vs onsite](project_files/images/highest_salary.png)
 
Here is the bar chart visualizing the Top 10 Highest-Paying Data Analyst Roles by average annual salary. 
# Key Findings & Insights
- Outlier Salary: Mantys offers $650K for a Data Analyst role — far above market, likely due to unique responsibilities or equity.
- Defense Sector Premiums: Modern Technology Solutions and Illuminate Mission Solutions pay $375K+, reflecting high compensation in secure/government-aligned roles.

- AI-Driven Demand: Anthropic offers $350K, highlighting strong pay for analysts in advanced tech and AI sectors.

- Title ≠ Salary: High-paying roles at Mantys and Anthropic show that “Senior” isn’t always tied to compensation.

- Tech Giants Compete:TikTok, Pinterest, and Walmart offer $230K+, underscoring strong demand for analytics in top tech firms.
# Q4: How do companies differ in their degree requirements when hiring Data Analysts, and what is the distribution of these roles?.
 
Demand for Data Analysts is soaring, but degree expectations differ. Some firms now hire on skills alone, while others still insist on a formal degree.
```sql
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
```
# Result Table
Here’s the enhanced table including percentages of each company’s postings by degree requirement, for better insight:
| Company             | Degree Requirement | Job Postings Count | % of Total Postings per Company\* |
| ------------------- | ------------------ | ------------------ | --------------------------------- |
| Citi                | Degree Required    | 804                | 100%                              |
| Robert Half         | No Degree Required | 667                | 100%                              |
| Emprego             | Degree Required    | 571                | 51.8%                             |
| Emprego             | No Degree Required | 550                | 48.2%                             |
| UnitedHealth Group  | Degree Required    | 515                | 100%                              |
| Insight Global      | No Degree Required | 457                | 51.4%                             |
| Insight Global      | Degree Required    | 435                | 48.6%                             |
| Get It Recruit - IT | Degree Required    | 448                | 100%                              |
| Corporate           | Degree Required    | 415                | 100%                              |
| SynergisticIT       | Degree Required    | 399                | 100%                              |

Percentages calculated based on total postings per company (sum of degree + no degree postings).
# Key Findings & Insights
- Citi dominates degree-required roles with 804 postings, emphasizing traditional hiring.

- Robert Half flips the script with 667 no-degree roles, championing skills over credentials.

- Emprego and Insight Global blur the lines, nearly split between degree and no-degree opportunities—offering real flexibility.

- Other top players mostly stick to degree requirements but still show a healthy volume of openings.

**Insight:** The hiring landscape for Data Analysts is shifting. While some giants hold fast to degrees, many companies are boldly opening doors to skilled candidates without formal education, signaling a fresh, inclusive approach to talent.
  # Q5:  Which companies are hiring the most Data Analysts globally, and how are their job postings distributed between remote and onsite roles?.

In 2023, Emprego led the market with the highest number of job openings, but every single one was onsite—no remote options at all. Dice, on the other hand, was the champion of remote work, offering the most remote positions even though its total job count was lower. Companies like Robert Half and Insight Global offered a mix, but still leaned heavily toward onsite roles. Citi had almost no remote jobs, focusing almost entirely on onsite positions.

```sql
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
```
![remote vs onsite](project_files/images/company%20name.png)This chart visually reinforces these findings, making it easy to compare each company’s approach to remote and onsite work. 
# Key Findings & Insights
- Emprego has the highest total number of jobs, all onsite—no remote positions.

- Get It Recruit – IT leads in remote roles, with nearly all positions remote.

- Dice offers a significant number of remote jobs, though still fewer than onsite.

- Robert Half and Insight Global include remote roles, but onsite jobs dominate.

- Citi offers almost exclusively onsite roles.

This suggests that while some companies are embracing remote work, the majority of job opportunities—especially from the largest employers—are still onsite.

# Q6: What are the top 5 skills demanded in the highest-paying (top 20%) Data Analyst roles, comparing remote and city-based positions?.
In the top 20% highest-paying Data Analyst roles, SQL and Python are the most in-demand skills in both city-based and remote jobs. City-based roles also prioritize Tableau, Excel, and R, while remote roles show higher demand for SAS and R. This indicates consistent core skill requirements, with slight variation in tool preferences based on job location.
```sql 
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
```
# Result Table
| Rank | Onsite Skill | Demand | Remote Skill | Demand |
| ---- | ------------ | ------ | ------------ | ------ |
| 1    | SQL          | 584    | SQL          | 86     |
| 2    | Python       | 409    | Python       | 58     |
| 3    | Tableau      | 323    | Tableau      | 46     |
| 4    | Excel        | 233    | SAS          | 34     |
| 5    | R            | 205    | R            | 33     |

**Note:**
“Onsite” refers to roles based in a physical city or office location, while “Remote” refers to roles that allow working from home or any location. This table shows the top skills demanded in the highest-paying jobs by work setting.


![remote vs onsite](project_files/images/Q6.png)
This visualization makes it easy to quickly identify which skills are most valued in the dataset.

# Key findings

SQL and Python are the most in-demand skills by a significant margin.
Tableau, R, and Excel also show notable demand, but much less than SQL and Python.
SAS has the lowest demand among the listed skills.
This visualization makes it easy to quickly identify which skills are most valued in the dataset.

**Skills Demand Analysis Clarification**

This analysis explores Data Analyst skills demand from two perspectives to provide a fuller picture. Question 2 examines all Data Analyst job postings by location (remote vs. onsite), revealing that SQL and Python are the most in-demand skills overall. Question 6 focuses on the top 20% highest-paying roles, showing that SQL and Excel gain prominence in these higher-paying positions. The differences highlight that employers of higher-paying jobs may prioritize certain skills differently, reflecting varied role requirements and market needs. This distinction helps to better understand the nuances in skills demand across the job market.

# what I Learned
Throughout this project, I gained valuable experience in recognizing patterns, analyzing trends, and solving complex problems to extract meaningful insights from data. This process strengthened my perseverance and deepened my passion for data analysis. It challenged me to stay patient and disciplined, which ultimately enhanced my practical skills and confidence. Since beginning this journey, I have remained dedicated and motivated to grow as a data analyst, inspired by the power and impact of data-driven decision making.
# Conculsions
This project analyzed Data Analyst job postings from 2023 to identify the most important skills, salary patterns, and work location differences. The analysis revealed that SQL and Python are the most demanded skills across both remote and city-based roles, with variations in other skills depending on location and pay level. Through this work, I strengthened my SQL and data analysis skills and learned how to extract meaningful insights from complex datasets. The findings provide valuable guidance for job seekers and employers alike, highlighting current market demands in the data analytics field. This experience has motivated me to continue growing as a data analyst and to apply data-driven approaches to real-world challenges. Moving forward, I am committed to leveraging data to drive impactful decisions and contribute effectively to the evolving analytics landscape.



