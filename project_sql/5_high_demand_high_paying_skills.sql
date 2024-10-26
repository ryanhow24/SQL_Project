/*
Question to answer: What is the most optimal skill as a data analyst?
*/

WITH in_demand_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_dim.skills) AS skill_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
),
top_paying_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
)

-- Finding the highest demand and paying skills for data analysts (ORDERED BY DEMAND then SALARY)
SELECT
    in_demand_skills.skill_id,
    in_demand_skills.skills,
    in_demand_skills.skill_count,
    top_paying_skills.avg_salary
FROM in_demand_skills
INNER JOIN top_paying_skills ON in_demand_skills.skill_id = top_paying_skills.skill_id
ORDER BY
    skill_count DESC, avg_salary DESC
LIMIT 25

-- Finding the highest paying and demand skills for data analysts (ORDERED BY SALARY then DEMAND)
--SELECT
--    in_demand_skills.skill_id,
--    in_demand_skills.skills,
--    in_demand_skills.skill_count,
--    top_paying_skills.avg_salary
--FROM in_demand_skills
--INNER JOIN top_paying_skills ON in_demand_skills.skill_id = top_paying_skills.skill_id
--ORDER BY
--    avg_salary DESC, skill_count DESC
--LIMIT 25