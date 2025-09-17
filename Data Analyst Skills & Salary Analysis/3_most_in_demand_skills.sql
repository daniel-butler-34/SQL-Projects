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