-- Data Cleaning

SELECT *
FROM Layoffs;

-- Create a new table that a copy from layosffs table
CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT layoffs_copy
SELECT * 
FROM layoffs;

SELECT *
FROM layoffs_copy;

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

-- 1. check for duplicates and remove any

# First let's check for duplicates

SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_copy;

-- checking how many duplicate
WITH duplicate_cte AS
(
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_copy
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- checking how many duplicate
SELECT *
FROM layoffs_copy
WHERE company = 'Oda';

-- change the CTE since Oda is not duplicate after checking
WITH duplicate_cte AS
(
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_copy
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

-- checking how many duplicate again
SELECT *
FROM layoffs_copy
WHERE company = 'Casper';

-- deleting the duplicate
CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_copy2
WHERE row_num > 1;

INSERT INTO layoffs_copy2
SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_copy;

DELETE 
FROM layoffs_copy2
WHERE row_num > 1;

SELECT *
FROM layoffs_copy2;

-- 2. standardize data and fix errors

-- take off the white space from company column
SELECT company, TRIM(company)
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET company = TRIM(company);

-- checking unstandarize word from industry column

SELECT DISTINCT industry
FROM layoffs_copy2
ORDER BY 1;

SELECT *
FROM layoffs_copy2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_copy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- checking the standarize result of industry column 
SELECT DISTINCT industry
FROM layoffs_copy2;

-- standarize the country column
SELECT DISTINCT country
FROM layoffs_copy2
ORDER BY 1;
 
SELECT DISTINCT country
FROM layoffs_copy2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_copy2
ORDER BY 1;

UPDATE layoffs_copy2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- change data type date column to date

ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE;

-- 3. Look at null & blank values and fill in the null & blank values

SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

UPDATE layoffs_copy2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_copy2
WHERE industry IS NULL;

SELECT t1.company, t1.industry AS blank_industry, t2.industry AS filled_industry
FROM layoffs_copy2 AS t1
JOIN layoffs_copy2 AS t2
  ON t1.company = t2.company
 AND t1.location = t2.location
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;
  
UPDATE layoffs_copy2 AS t1
JOIN layoffs_copy2 AS t2
  ON t1.company = t2.company
 AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL;

UPDATE layoffs_copy2
SET industry = company
WHERE industry IS NULL;

SELECT company, industry
FROM layoffs_copy2
WHERE company = 'Airbnb';

-- 4. remove any columns and rows we need to

ALTER TABLE layoffs_copy2
DROP COLUMN row_num;

-- 5. replace null values with 0

UPDATE layoffs_copy2
SET total_laid_off = 0
WHERE total_laid_off IS NULL;

UPDATE layoffs_copy2
SET percetage_laid_off = 0
WHERE percetage_laid_off IS NULL;

UPDATE layoffs_copy2
SET funds_raised_millions = 0
WHERE funds_raised_millions IS NULL;

SELECT *
FROM layoffs_copy2;


