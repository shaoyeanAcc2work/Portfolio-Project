-- Data Cleaning

use world_layoffs;
select * from layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns or rows


create table layoffs_staging like layoffs;

insert layoffs_staging select * from layoffs;

select *,
 row_number() over(
 partition by 
 company, location, industry, total_laid_off, percentage_laid_off,
    `date` , stage, country, funds_raised_millions
 ) as row_num
from layoffs_staging;

with duplicate_cte as
(
	select *,
	row_number() over(
	partition by 
	company, location, industry, total_laid_off, percentage_laid_off,
    `date` , stage, country, funds_raised_millions
	) as row_num
	from layoffs_staging
)
select * from duplicate_cte where row_num > 1;

-- find null/blank values and delete it.
select * from layoffs_staging where company = 'Casper';

-- ******display cannot delete cte table******
with duplicate_cte as
(
	select *,
	row_number() over(
	partition by 
	company, location, industry, total_laid_off, percentage_laid_off,
    `date` , stage, country, funds_raised_millions
	) as row_num
	from layoffs_staging
)
delete from duplicate_cte where row_num > 1;

-- right click 'layoffs_staging' select 'Copy To Clipboard' -> 'Create Statement'
-- rename 'layoffs_staging' to 'layoffs_staging2'
-- add column named 'row_num' data type integer
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into `layoffs_staging2` 
	select *,
	row_number() over(
	partition by 
	company, location, industry, total_laid_off, percentage_laid_off,
    `date` , stage, country, funds_raised_millions
	) as row_num
	from layoffs_staging;

select * from `layoffs_staging2` where row_num > 1;

delete from `layoffs_staging2` where row_num > 1;



-- Standardizing data
	-- start with `company`
    -- distinct means just show once time the column, not repeatable
select distinct company from `layoffs_staging2`; 
select company, trim(company) from `layoffs_staging2`;
	-- update to triming company name
update `layoffs_staging2`
set `company`=trim(`company`);

	-- checking `industry`
select industry from `layoffs_staging2`;
select distinct industry from `layoffs_staging2`;
select distinct industry from `layoffs_staging2` order by 1;
	-- had find 'CryptoCurrency' and 'Crypto Currency' is a same thing as 'Crypto'
select * from `layoffs_staging2` where industry like 'Crypto%';
	-- update 'Crypto%' to 'Crypto'
update `layoffs_staging2`
set `industry` = 'Crypto' where `industry` like 'Crypto%';

	-- checking `location`	-- looks like no problems with `location`
select location from `layoffs_staging2` ;
select distinct location from `layoffs_staging2`;
select distinct location from `layoffs_staging2` order by 1;

	-- checking `country`
select country from `layoffs_staging2` ;
select distinct country from `layoffs_staging2` ;
select distinct country from `layoffs_staging2` order by 1 ;
	-- had find 'United States.'
select * from `layoffs_staging2` where country like 'United States.';
update `layoffs_staging2`
set `country` = trim(trailing '.' from country) where `country` like 'United States.';

	-- checking `date`
select `date` from `layoffs_staging2`;
	-- change data type text to date format of `date` column
select `date`, str_to_date(`date`, '%m/%d/%Y') from `layoffs_staging2`;
update `layoffs_staging2`
set `date` = str_to_date(`date`, '%m/%d/%Y') ;
	-- `date` data type doesnt change so using alternative table's data command
alter table `layoffs_staging2` modify column `date` date;

	-- checking null values in columns
select * from `layoffs_staging2`;
	-- ***'total_laid_off' and `percentage_laid_off` had found
select * from `layoffs_staging2` 
where `total_laid_off` is null and `percentage_laid_off` is null;
	-- ***`industry` had found
select * from `layoffs_staging2`
where `industry` is null or `industry` = '';
update `layoffs_staging2`
set industry = null where industry = '';
	-- ***many companies has null values in `industry` column, such as one case below:>
select * from `layoffs_staging2` where company = 'Airbnb';
	-- ***combines these null value row in `industry` column  
select t1.industry, t2.industry from `layoffs_staging2` t1
join `layoffs_staging2` t2
	on t1.company = t2.company and t1.location = t2.location
where (t1.industry is null or t1.industry = '') and t2.industry is not null;
update `layoffs_staging2` t1
join `layoffs_staging2` t2
	on t1.company = t2.company and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;
	-- `Bally` company's industry value still blank
    -- thats only one data in form, no idea to do
select * from `layoffs_staging2`
where `industry` is null or `industry` = '';
select * from `layoffs_staging2` where company like 'Bally%';
	-- go back to 'total_laid_off' and `percentage_laid_off`
    -- no more informations to do anymore with this part
    -- we just delete it or need more info to do something
select * from `layoffs_staging2` 
where total_laid_off is null and percentage_laid_off is null;
delete from `layoffs_staging2` 
where total_laid_off is null and percentage_laid_off is null;
	-- drop the `row_num` column
select * from `layoffs_staging2` ;
alter table `layoffs_staging2` drop column `row_num`;















