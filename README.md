
# Introduction
 📊 Project Introduction: Job Postings 2023
This project analyzes job postings data from 2023 to uncover key trends in hiring, skills demand, work formats, and employment types. Using structured SQL methods—such as joins, subqueries, and aggregations—it transforms raw data into clear, actionable insights, offering a sharp view of the evolving job market.
 
- SQL queries. check them out here; [first_practice_by_my_own](/first_practice_by_my_own/questions.sql).

# Background
The world of work is evolving—fast. With the rise of remote roles, tech-driven hiring, and shifting skill demands, 2023 marked a pivotal year in the job market. This project dives into real job postings to decode what employers truly value today. By analyzing thousands of listings with SQL, we uncover the trends shaping modern careers—from the hottest roles to the skills that open doors.
### The questions I aim to answer through my SQL queries;
1. What are the top 10 most in-demand skills for Data Analysts, based on current job market trends?

2. Which skills are most commonly required for Data Analyst jobs by work location (Remote vs Onsite)?

3. What are the top 10 highest-paying Data Analyst roles by average annual salary?

4. How do companies differ in their degree requirements when hiring Data Analysts, and what is the distribution of these roles?

5. Which companies are hiring the most Data Analysts globally, and how are their job postings distributed between remote and onsite roles?

6. Which skills are most commonly required for the highest-paying Data Analyst roles in both remote and city-based jobs?

# Tools & Technologies Used
- **SQL:** Core tool for data exploration, quality checks, and generating insights.
- **postgreSQL:** I used PostgreSQL for managing and storing the 2023 job postings dataset, enabling efficient querying and analysis throughout the project.
- **visual studio code** I used VS Code over pgAdmin for advanced SQL development and project management, thanks to its flexibility, extensions, and Git integration.
- **Git&github** Used for version control and project sharing, allowing collaboration and tracking of changes throughout development.
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


![Top 10 Skills](images/Top10skills.png)
Here is the bar chart showing the Top 10 Most In-Demand Skills for Data Analysts, based on job postings with salary data.

- Key Insight:
SQL is the top skill demanded, followed by Excel, Python, and Tableau. BI and database tools like Power BI, SAS, and SQL Server remain important, along with communication tools such as Word and PowerPoint.



# what I Learned

# Conculsions



 
