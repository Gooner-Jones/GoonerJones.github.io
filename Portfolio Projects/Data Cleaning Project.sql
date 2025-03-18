-- Data Cleaning Project
-- ____________________________________________________________________________________________________________________________________
-- Cleaning up data from 'layoffs' database
-- https://www.kaggle.com/datasets/swaptr/layoffs-2022

select *
from layoffs;
-- ____________________________________________________________________________________________________________________________________
-- ______________________________________________________PROJECT OBJECTIVES____________________________________________________________
-- 1. Identify Duplicates
-- 2. Creating a Staging Database to work out from
-- 3. Remove Duplicates
-- 4. Standardize the Data
-- 5. Null Values or Blank Values
-- 6. Remove Any Columns or Rows
-- ____________________________________________________________________________________________________________________________________
-- 1. Identify Duplicates

with duplicate_cte as 
(select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num
from layoffs
)
select *
from duplicate_cte
where row_num > 1;
-- ____________________________________________________________________________________________________________________________________
-- 2. Creating a Staging Database

CREATE TABLE `layoffs_staging` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` int		-- added row_num column
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) as row_num
from layoffs;
-- ____________________________________________________________________________________________________________________________________
-- 3. Remove Duplicates

-- Select all duplicates and then proceed to delete
select *
from layoffs_staging
where row_num > 1;
delete
from layoffs_staging
where row_num > 1;

-- Check and confirm duplicates are deleted
select *
from layoffs_staging
where row_num > 1;
-- ____________________________________________________________________________________________________________________________________
-- 4. Standardizing Data

select *
from layoffs_staging;

select company, trim(company)
from layoffs_staging;
update layoffs_staging
set company = trim(company);

alter table layoffs_staging
modify column `date` date;
-- ____________________________________________________________________________________________________________________________________
-- 5. NULL and BLANK Values

select *
from layoffs_staging;

-- Delete ALL blank values in 'industry'
select *
from layoffs_staging
where industry = ''
order by 1;
delete
from layoffs_staging
where industry = '';

-- Delete ALL blank values in 'total laid off' AND 'percentage laid off'
select *
from layoffs_staging
where total_laid_off = '' AND percentage_laid_off = '';
delete
from layoffs_staging
where total_laid_off = '' and percentage_laid_off = '';
-- ____________________________________________________________________________________________________________________________________
-- 6. Remove any column or Rows

select *
from layoffs_staging;

alter table layoffs_staging
drop column row_num;
select *
from layoffs_staging;
-- ____________________________________________________________________________________________________________________________________













