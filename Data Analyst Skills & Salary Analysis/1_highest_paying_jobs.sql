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