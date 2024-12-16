-- Exploratory Data Analysis of World Layoff

SELECT *
FROM layoffs_copy2;

-- 1. Industry-wise Analysis
-- Goal: Find the total number of layoffs and the average percentage of layoffs by industry.

SELECT industry, 
       SUM(total_laid_off) AS total_laid_off, 
       AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_copy2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- 2. Country-based Analysis
-- Goal: Analyze layoffs by country and identify the country with the most layoffs.

SELECT country, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY country
ORDER BY total_laid_off DESC
LIMIT 10;

-- 3. Funding vs. Layoffs
-- Goal: Examine if companies with higher funds raised tend to have more layoffs.

SELECT funds_raised_millions, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
WHERE funds_raised_millions IS NOT NULL
GROUP BY funds_raised_millions
ORDER BY funds_raised_millions DESC;

-- 4. Stage-wise Analysis
-- Goal: Compare the average percentage of layoffs across different funding stages.

SELECT stage, 
       AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_copy2
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY avg_percentage_laid_off DESC;

-- 5. Timeline Analysis
-- Goal: Trend analysis of layoffs over time

SELECT date AS layoff_date, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
WHERE date IS NOT NULL
GROUP BY date
ORDER BY date;

-- 6. Top Companies with Layoffs
-- Goal: Identify the top 10 companies with the highest number of layoffs.

SELECT company, 
       SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;



