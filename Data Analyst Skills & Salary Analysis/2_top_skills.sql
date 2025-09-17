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
