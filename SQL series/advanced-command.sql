-- Advanced MySQL 

use parks_and_recreation;
-- CTEs - command table explorations

with CTE_Example as
(
	select gender, 
		avg(salary) as avg_sal,
		min(salary) as min_sal,
		max(salary)as max_sal,
		count(salary)as count_sal
	from parks_and_recreation.employee_demographics as dm
	join parks_and_recreation.employee_salary as sal
		on dm.employee_id = sal.employee_id
	group by gender order by count_sal desc
)
select *
from CTE_Example
;


with CTE_Example(Gender, AVG_sal, MIN_sal, MAX_sal, COUNT_sal) as
(
	select gender, 
		avg(salary) as avg_sal,
		min(salary) as min_sal,
		max(salary)as max_sal,
		count(salary)as count_sal
	from parks_and_recreation.employee_demographics as dm
	join parks_and_recreation.employee_salary as sal
		on dm.employee_id = sal.employee_id
	group by gender order by count_sal desc
)
select *
from CTE_Example
;


with CTE_Example1 as
(
	select employee_id, gender, age
	from parks_and_recreation.employee_demographics as dm
	where dm.age <= 30
),
CTE_Example2 as
(
	select employee_id, salary, dept_id
    from parks_and_recreation.employee_salary as sal
    where sal.salary >= 30000
)
select *
from CTE_Example1 as ex1
join CTE_Example2 as ex2
	on ex1.employee_id = ex2.employee_id
;


-- Temporary Tables

create temporary table temp_table
(
	first_name varchar(50),
    last_name varchar(50),
    favorite_movie varchar(100)
);

select * from temp_table;

insert into temp_table values('Alex', 'Frebreg', 'Lord of the Rings: The Two Towers');

create temporary table salary_over_50k
select * 
from parks_and_recreation.employee_salary
where salary >= 50000;

select * from salary_over_50k;


-- Stored Procedures

create procedure salary_over_50k()
select * 
from parks_and_recreation.employee_salary
where salary >= 50000;

call parks_and_recreation.salary_over_50k();

delimiter $$
create procedure salary_over_50k_2(p_employee_id INT)
begin
	select * 
	from parks_and_recreation.employee_salary
	where employee_id = p_employee_id;
end $$
delimiter ;

call salary_over_50k_2(1002);


-- Triggers

select * from parks_and_recreation.employee_demographics;

select * from parks_and_recreation.employee_salary;

	-- insert values into two tables 
delimiter $$
create trigger employee_insert
	after insert on parks_and_recreation.employee_salary
    for each row 
		begin
			insert into employee_demographics (employee_id)
			values (NEW.employee_id);
		end $$
delimiter ;


insert into employee_salary (employee_id, job_title, salary, dept_id)
values(1013, 'Entertainment CEO', 100000, 9);

select * from parks_and_recreation.employee_demographics;

select * from parks_and_recreation.employee_salary;

DELETE FROM `parks_and_recreation`.`employee_demographics` where (`employee_id` = 1013);


-- Events

select * from employee_demographics;

delimiter $$
create event delete_retirees
on schedule every 30 second
do
	begin
		delete 
		from employee_demographics 
		where age >= 60;
	end $$
delimiter ;

show variables like 'event%';









