-- Exploratory Data Analysis

use world_layoffs;
select * from world_layoffs.layoffs_staging2;

select max(`total_laid_off`), max(`percentage_laid_off`)
from world_layoffs.layoffs_staging2;

select * 
from `world_layoffs`.`layoffs_staging2` 
where `percentage_laid_off` = 1
order by `funds_raised_millions` desc;

select `company`, sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
group by `company` order by 2 desc; 

select min(`date`), max(`date`) from `world_layoffs`.`layoffs_staging2`;

select `industry`, sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
group by `industry` order by 2 desc; 

select `country`, sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
group by `country` order by 2 desc; 

select year(`date`), sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
where year(`date`) is not null
group by year(`date`) order by 1 desc; 

select `stage`, sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
group by `stage` order by 2 desc; 

select `company`, avg(`percentage_laid_off`)
from `world_layoffs`.`layoffs_staging2`
group by `company` order by 2 desc; 

select year(`date`), month(`date`), sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
where `date` is not null
group by year(`date`), month(`date`) order by 1 desc,3 desc; 
	-- *** order by `column name` or [column index] ***
    -- *** [column index] start from 1 ***

with rolling_total as
(
select substring(`date`, 1, 7) as `year-month`, sum(`total_laid_off`) as `total_off`
	-- *** substring(`column name`, [start_position], [length]) ***
    -- *** [start_position] start from 1 ***
    -- *** [length] including the [start_position] ***
from `world_layoffs`.`layoffs_staging2`
where `date` is not null
group by `year-month`
)
select `year-month`, `total_off`, 
sum(`total_off`) over(order by `year-month`) as Rolling_total
from rolling_total;

select substring(`date`, 1, 4) as `yyyy`, `company`, sum(`total_laid_off`)
from `world_layoffs`.`layoffs_staging2`
where substring(`date`, 1, 4) is not null
group by `yyyy`, `company` order by 1, 3 desc ; 

with 
Company_year(years, company, total_laid_off) as
(
	select substring(`date`, 1, 4) as `yyyy`, `company`, sum(`total_laid_off`)
	from `world_layoffs`.`layoffs_staging2`
	where substring(`date`, 1, 4) is not null
	group by `yyyy`, `company`
), 
Company_year_rank as 
(
	select *, 
    dense_rank() over(partition by years order by total_laid_off desc) as year_Rank
	-- *** dense_rank()分类每年的数据并进行排名
	from Company_year
    where years is not null
)
select * from Company_year_rank where year_rank <= 5;

