-- Exploratory Data Analysis
SELECT *
FROM layoffs_staging2;

-- The maximum people laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Where the company laid off all employees
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- sum of total people laid off by each company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

SELECT Year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY Year(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH rolling_total AS
(SELECT SUBSTRING(`date`, 1,7) AS `MONTH`, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,sum_total_laid_off, SUM(sum_total_laid_off) OVER (ORDER BY `MONTH`) AS Rolling_Totals
FROM rolling_total;


SELECT company, Year(`date`) AS years, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY company, Year(`date`)
ORDER BY 3 DESC;

WITH company_year AS
(SELECT company, Year(`date`) AS years, SUM(total_laid_off) AS sum_total_laid_off
FROM layoffs_staging2
GROUP BY company, Year(`date`)
ORDER BY 3 DESC
), company_year_ranking AS
(SELECT *, DENSE_RANK () OVER (PARTITION BY years ORDER BY sum_total_laid_off DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM  company_year_ranking
WHERE Ranking<=5;






