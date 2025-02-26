-- Intermediate MySQL

use parks_and_recreation;
-- Joins

select * 
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id
inner join parks_departments as pd
	on sal.dept_id = pd.department_id
;

-- left join / right join
-- its means align with left/right table you choose.


-- Unions
use parks_and_recreation;
select employee_id,age
from employee_demographics
union 
select employee_id,salary
from employee_salary;


select employee_id, first_name, last_name, 'senior(male)' as class
from employee_demographics
where age >= 35 and gender = 'Male'
union
select employee_id, first_name, last_name, 'senior(female)' as class
from employee_demographics
where age >= 35 and gender = 'Female'
union
select employee_id, job_title, salary, 'high paid employee' as class
from employee_salary
where salary >= 50000
order by employee_id
;

-- string functions
select length('skyfall');

select first_name, length(first_name)
from employee_demographics
;

select upper('sky');
select lower('SKY');

select trim('          sky          ');
select ltrim('          sky          ');
select rtrim('          sky          ');

select first_name,
 left(first_name, 4),
 right(first_name, 4),
 substring(first_name,3,2)
from employee_demographics;

select first_name, replace(first_name, 'a', 'z')
from employee_demographics;

select locate('x', 'Alexander');

select first_name, last_name, concat(first_name, ' ',last_name) as full_name
from employee_demographics;


-- Case statements

use parks_and_recreation;
select first_name, last_name,age,
case
	when age <=30 then 'young'
    when age between 31 and 50 then 'old'
end as age_bracket
from employee_demographics;

select employee_id, salary,
case
	when salary <= 50000 then '5%'
    when salary > 50000 then '7%'
end as finance_bonus,
case
	when salary <= 50000 then salary*1.05
    when salary > 50000 then salary*1.07
end as new_salary,
case
	when dept_id = 1 then salary*.10
    when dept_id = 4 then salary*.10
end as dept_bonus
from employee_salary;


-- Subqueries

select * 
from parks_and_recreation.employee_demographics
where employee_id in 
	(select employee_id 
	from parks_and_recreation.employee_salary 
    where dept_id > 1 and dept_id < 5)
;

select employee_id, salary, (select avg(salary) from parks_and_recreation.employee_salary)
from parks_and_recreation.employee_salary;

select gender, avg(age), max(age), min(age), count(age) 
from parks_and_recreation.employee_demographics
group by gender
;

select avg(min_age), avg(max_age)
from
	(select gender, avg(age) as avg_age, max(age) as max_age, min(age) as min_age, count(age) 
	from parks_and_recreation.employee_demographics
	group by gender) as agg_table
;


-- Windows functions

use parks_and_recreation;

select gender, avg(salary) as avg_salary
from parks_and_recreation.employee_demographics as dem
join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id
group by gender;

select gender, avg(salary) over()
from parks_and_recreation.employee_demographics as dem
join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id;

select dem.employee_id, dem.first_name, gender, salary,
	sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from parks_and_recreation.employee_demographics as dem
join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id;

select dem.employee_id, dem.first_name, gender, salary,
	row_number() over(partition by gender) as row_num,
	rank() over(partition by gender order by salary desc) as rank_num,
    dense_rank() over(partition by gender order by salary desc) as dense_rank_num
from parks_and_recreation.employee_demographics as dem
join parks_and_recreation.employee_salary as sal
	on dem.employee_id = sal.employee_id;

