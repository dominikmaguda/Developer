SELECT * FROM job_postings_fact
LIMIT 10;

SELECT * FROM skills_job_dim
LIMIT 10;

SELECT * FROM skills_dim
LIMIT 10;

WITH number_of_postings AS(
SELECT
    company_id,
    COUNT(*) AS number_of_jobs
FROM
    job_postings_fact
GROUP BY company_id
)


SELECT

    company_dim.name,
    CASE
        WHEN number_of_postings.number_of_jobs < 10 THEN 'SMALL'
        WHEN number_of_postings.number_of_jobs > 50 THEN 'LARGE'
        ELSE 'MEDIUM'
    END AS company_size
FROM company_dim
LEFT JOIN 
number_of_postings ON number_of_postings.company_id = company_dim.company_id


SELECT
    skills_dim.skill_id,
    skills_dim.skills,
COUNT
    (job_postings_fact.job_location = 'Anywhere' AND job_postings_fact.job_work_from_home = 'TRUE')
    AS number_of_offers
FROM job_postings_fact

LEFT JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE skills_dim.skill_id IS NOT NULL
GROUP BY skills_dim.skill_id
ORDER BY number_of_offers DESC

LIMIT 5
;


WITH remote_job_skills AS (
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = 'TRUE'
GROUP BY
    skill_id
)

SELECT 
skills.skill_id,
skills AS skill_name,
skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC   
LIMIT 5