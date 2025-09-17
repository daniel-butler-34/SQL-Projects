# Introduction
In this project, we aim to understand what the most in-demand and highest-paying skills are in the data science industry, focusing on data analyst roles in the UK. We explore the highest-paying jobs, the most in-demand and high-paying skills, and which skills are both in-demand and high-paying. The data for this project comes from the same source as the Salary Analysis Microsoft Excel projects.

### The questions I sought to answer are:

1. What are the top-paying data analyst jobs in the UK?
2. Which skills are required for these top-paying jobs?
3. Which skills are most in-demand for data analysts in the UK?
4. Which skills are associated with higher salaries?
5. Which skills are 'optimal' to learn?

# Tools Used
To complete this project, I made use of a number of tools:

- **SQL:** The foundation of the analysis, allowing me to query and manipulate the data.
- **PostgreSQL:** The chosen database management system, allowing easy access and querying of the data.
- **Visual Studio Code:** The main IDE used for writing all SQL queries.

# The Analysis

### What are the top-paying data analyst jobs in the UK?
To identify the highest-paying data analyst roles in the UK, I filtered the data analyst positions by average yearly salary. This was achieved in SQL via the following query, which displays the 10 highest-paying data analyst jobs in the UK which were posted in 2023:

```sql
SELECT
    jobs.job_id,
    jobs.job_title,
    companies.name AS company_name,
    jobs.job_location AS job_city,
    jobs.job_schedule_type,
    jobs.salary_year_avg AS average_yearly_salary,
    jobs.job_posted_date
FROM job_postings_fact AS jobs
LEFT JOIN company_dim AS companies ON jobs.company_id = companies.company_id
WHERE 
    jobs.job_title_short = 'Data Analyst'
    AND jobs.job_location LIKE '%UK%'
    AND jobs.salary_year_avg IS NOT NULL
ORDER BY jobs.salary_year_avg DESC
LIMIT 10
```

Upon running this query, I obtained the following output:

<img width="1090" height="332" alt="Query1_Result" src="https://github.com/user-attachments/assets/72411571-209f-4264-bf20-9d291bb23d43" />

The breakdown of the top data analyst positions in the UK in 2023 is as follows:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $111,000 to $177,000, indicating strong potential for salary growth in the field.
- **Diverse Employers:** Companies like Google DeepMind, Darktrace and Accor are among those offering the highest salaries.
- **Job Title Variety:** There is a wide variety of job titles, from Research Engineer to Finance Data Analytics Manager, representing the wide range of roles available in the field.

### 2. Which skills are required for these top-paying jobs?
To understand which skills are most in-demand for the top-paying jobs, I joined the job postings data with the skills data, making use of CTEs and inner joins:

```sql
WITH top_jobs AS (
    SELECT
    jobs.job_id,
    jobs.job_title,
    companies.name AS company_name,
    jobs.job_location AS job_city,
    jobs.job_schedule_type,
    jobs.salary_year_avg AS average_yearly_salary,
    jobs.job_posted_date
    FROM job_postings_fact AS jobs
    LEFT JOIN company_dim AS companies ON jobs.company_id = companies.company_id
    WHERE 
        jobs.job_title_short = 'Data Analyst'
        AND jobs.job_location LIKE '%UK%'
        AND jobs.salary_year_avg IS NOT NULL
    ORDER BY jobs.salary_year_avg DESC
    LIMIT 10)

SELECT 
    skills.skills, 
    COUNT(skills.skills) AS skill_count
FROM top_jobs
LEFT JOIN skills_job_dim AS job_skills ON job_skills.job_id = top_jobs.job_id
LEFT JOIN skills_dim AS skills ON skills.skill_id = job_skills.skill_id
GROUP BY skills.skills
HAVING skills.skills IS NOT NULL
ORDER BY skill_count DESC
```

Using Microsoft Excel to plot the skill breakdown for the 10 highest paying jobs, we have the following:

<img width="1330" height="645" alt="image" src="https://github.com/user-attachments/assets/bd836d20-ab60-4cd1-ab0d-254ae913efab" />

From this we see that the 3 most in-demand skills are:
- **SQL:** Leading with 8.
- **Python:** Following closely on 7.
- **Tableau:** Also highly sought-after with a count of 6.
Other skills like **R**, **Excel**, **Pandas**, and **Snowflake** show varying degrees of demand.

### 3. Which skills are most in-demand for data analysts in the UK?

This query helped to identify the skills most frequently requested in job postings from the UK:

```sql
SELECT 
    skills, 
    COUNT(job_skills.job_id) AS demand_count
FROM job_postings_fact AS job_postings
INNER JOIN skills_job_dim AS job_skills ON job_postings.job_id = job_skills.job_id
INNER JOIN skills_dim ON job_skills.skill_id = skills_dim.skill_id
WHERE 
    job_postings.job_title_short = 'Data Analyst'
    AND job_postings.job_location LIKE '%UK%'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5
```
The results of this query are shown in the following Excel chart:

<img width="1221" height="642" alt="image" src="https://github.com/user-attachments/assets/eb1904f3-ba8d-4128-a508-744be4cc1780" />

We see that SQL and Excel remain highly in-demand, emphasising the need for strong skills in data processing and spreadsheet manipulation. Programming and visualisation tools like Python and Power BI are also in-demand, suggesting an increasing importance on technical skills in data storytelling.

### Which skills are associated with higher salaries?
We now aim to understand which skills are associated to higher average salaries. The following SQL query returns a list of the highest-paying skills:

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 10
```

The output of this SQL query is as follows:

<img width="301" height="292" alt="image" src="https://github.com/user-attachments/assets/bb00dc3d-0859-44ff-b356-e7e0cbd25d24" />

From these results we see that AI and Machine Learning platforms such as datarobot and mxnet are commanding higher salaries, reflecting the industry's increasing use of AI to streamline workflows. Similarly, familiarity with cloud computing tools such as vmware appears to command higher salaries, underscoring the growing importance of cloud-based analytics environments.

### 5. Which skills are 'optimal' to learn?
We now aim to combine the insights obtained from the demand and salary data. This query aims to pinpoint skills that are both in-demand and have high average salaries:

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS job_count,
    ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    job_count DESC
LIMIT 10
```

This query resulted in the following output:

<img width="601" height="330" alt="image" src="https://github.com/user-attachments/assets/021162e2-6124-46aa-a516-aa2ddebc4a0e" />

From these results we see a similar trend to that seen in the previous result, with cloud tools and technologies being both higher-paying and more in-demand. However, familiarity with Python tools such as PyTorch is also valued, reflecting a nonetheless enduring emphasis on 'legacy' technologies.


# Conclusions

From the analysis, several conclusions emerge:

1. **Top-Paying Data Analyst Jobs in the UK**: The highest-paying jobs for data analysts in the UK offer a wide range of salaries, between $111,000 and $175,000.
2. **Skills for Top-Paying Jobs**: The highest-paying data analyst jobs advertised in the UK require proficiency with SQL, suggesting that mastery of SQL is a critical skill for earning a higher salary.
3. **Most In-Demand Skills**: SQL and Microsoft Excel are the most in-demand skill in the UK data analyst job market, reflecting their foundational importance in Data Analytics.
4. **Skills with Higher Salaries**: Highly specialised skills such as SVN and Solidity are associated with the highest average salaries overall, indicating high value for expertise with niche tools.

### Closing Thoughts

This project furthered my SQL skills and provided extremely valuable insights into the data analyst job market. The findings from this analysis show that I may better position myself in a competitive job market by focusing on the skills which are most in-demand. Nonetheless, expertise in more 'niche' software products is also highly valued.

(Credit to Luke Barousse for the data set and the course)
