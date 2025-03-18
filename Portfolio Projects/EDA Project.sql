-- Exploratory Data Analysis
-- ____________________________________________________________________________________________________________________________________
select *
from layoffs_staging;

select max(total_laid_off) as 'max laid off',
	   max(percentage_laid_off) as 'max percentage laid off'
from layoffs_staging;

-- ____________________________________________________________________________________________________________________________________
-- List of companies which had 100% lay offs
select *
from layoffs_staging
where percentage_laid_off = 1
order by total_laid_off desc;

-- ____________________________________________________________________________________________________________________________________
-- Total number of lay offs by respective companies
select company, sum(total_laid_off) as 'total laid off'
from layoffs_staging 
group by company
order by 2 desc;

-- ____________________________________________________________________________________________________________________________________
-- Total number of lay offs by respective industries
select industry, sum(total_laid_off) as 'total laid off'
from layoffs_staging 
group by 1
order by 2 desc;

-- ____________________________________________________________________________________________________________________________________
-- Total number of lay offs by respective Country
select country, sum(total_laid_off) as 'total laid off'
from layoffs_staging 
group by 1
order by 2 desc;

-- ____________________________________________________________________________________________________________________________________
-- Total number of lay offs by year
select year(`date`) as 'Year',
		   sum(total_laid_off) as 'total laid off'
from layoffs_staging
group by 1
order by 2 desc;

-- ____________________________________________________________________________________________________________________________________
-- Progression off lay offs (Rolling total layoffs)
select substring(`date`,1,7) as 'Month',
	   sum(total_laid_off) as 'Total laid off'
from layoffs_staging
where substring(`date`,1,7) is not null
group by 1
order by 1;

with Rolling_Total as 
(
select substring(`date`,1,7) as `Month`,
	   sum(total_laid_off) as total_off
from layoffs_staging
where substring(`date`,1,7) is not null
group by `Month`
order by 1
)
select `Month`, 
		total_off, 
        sum(total_off) over(order by `Month`) as rollling_total
from Rolling_Total;

-- ____________________________________________________________________________________________________________________________________
select company, sum(total_laid_off)
from layoffs_staging
group by company
order by 2 desc; 

-- Total number of lay offs by respective companies per year
select company, year(`date`), sum(total_laid_off)
from layoffs_staging
group by company, year(`date`)
order by 3 desc;


with Company_Year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging
group by company, year(`date`)
), 
Company_Year_Rank as
(select *, 
dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null)
select *
from Company_Year_Rank
where Ranking <= 5;
-- ____________________________________________________________________________________________________________________________________





