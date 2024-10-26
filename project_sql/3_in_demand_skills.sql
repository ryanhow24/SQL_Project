/*
Question to answer: What are the most in demand skills for data analysts?
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        company_dim.name AS company_name,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
),
top_paying_skills AS (
    SELECT
        top_paying_jobs.*,
        skills_dim.skills
    FROM 
        top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    ORDER BY
        salary_year_avg DESC
)

-- Finding the top skills for the top paying data analyst jobs using our previous queries
SELECT
    skills,
    COUNT(skills) AS skill_count
FROM
    top_paying_skills
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT 5

-- Finding the top skills for ALL remote data analyst jobs
SELECT
    skills_dim.skills,
    COUNT(skills_dim.skills) AS skill_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY 
    skills_dim.skills
ORDER BY 
    skill_count DESC
LIMIT 5