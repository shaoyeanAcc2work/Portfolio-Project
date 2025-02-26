create database Parks_and_Recreation;
use Parks_and_Recreation;

create table Employee_Demographics(
	employee_id int,
    first_name varchar(50),
    last_name varchar(50),
    age int,
    gender varchar(10),
    primary key (employee_id)
    );
    
create table Employee_Salary(
	employee_id int,
    job_title varchar(50),
    salary int
    );
    
drop table parks_and_recreation.employee_demographics;

insert into employee_demographics(employee_id, first_name, last_name, age, gender)
values
	(1001, 'Jim', 'Halpert', 30, 'Male'),
	(1002, 'Pam', 'Beasley', 30, 'Female'),
	(1003, 'Dwight', 'Schrute', 29, 'Male'),
	(1004, 'Angela', 'Martin', 31, 'Female'),
	(1005, 'Toby', 'Flenderson', 32, 'Male'),
	(1006, 'Michael', 'Scott', 35, 'Male'),
	(1007, 'Meredith', 'Palmer', 32, 'Female'),
	(1008, 'Stanley', 'Hudson', 38, 'Male'),
	(1009, 'Kevin', 'Malone', 31, 'Male');

insert into employee_salary(employee_id, job_title, salary) 
VALUES
	(1001, 'Salesman', 45000),
	(1002, 'Receptionist', 36000),
	(1003, 'Salesman', 63000),
	(1004, 'Accountant', 47000),
	(1005, 'HR', 50000),
	(1006, 'Regional Manager', 65000),
	(1007, 'Supplier Relations', 41000),
	(1008, 'Salesman', 48000),
	(1009, 'Accountant', 42000);
    
-- group by
select gender, avg(age),max(age), min(age), count(age)
from parks_and_recreation.employee_demographics
group by gender;

select employee_id, first_name, last_name, age, age+10
from parks_and_recreation.employee_demographics
where age>=30 and gender='Male'and last_name like '%t';

-- desc & limit
select *
from parks_and_recreation.employee_demographics
order by age desc, gender 
limit 3;

-- having vs. group by
select job_title, avg(salary)
from parks_and_recreation.employee_salary
group by job_title
having avg(salary)>= 40000;


-- aliasing (as)
select gender, avg(age) as avg_age
from parks_and_recreation.employee_demographics
group by gender
having avg_age >= 32;





