create database edms;
\c edms

create table department(
	dep_id integer not null primary key,
	dep_name varchar(20) not null,
	dep_location varchar(15) not null
);

create table employees(
	emp_id integer not null primary key,
	emp_name  varchar(15) not null,
	job_name varchar(10) not null,
	manager_id integer,
	hire_date date not null,
	salary  decimal(10,2) not null,
	commission decimal(7,2),
	dep_id integer not null,
	foreign key(dep_id) references department(dep_id) on delete cascade on update cascade
);

create table salary_grade(
	grade integer not null primary key,
	min_sal integer not null,
	max_sal integer not null
);

insert into department values (1001, 'FINANCE', 'SYDNEY');
insert into department values (2001, 'AUDIT', 'MELBOURNE');
insert into department values (3001, 'MARKETING', 'PERTH');
insert into department values (4001, 'PRODUCTION', 'BRISBANE');

insert into employees (emp_id, emp_name, job_name, manager_id, hire_date, salary, commission, dep_id)
values
(68319, 'KAYLING', 'PRESIDENT', NULL, '1991-11-18', 6000.00, NULL, 1001),
(66928, 'BLAZE', 'MANAGER', 68319, '1991-05-01', 2750.00, NULL, 3001),
(67832, 'CLARE', 'MANAGER', 68319, '1991-06-09', 2550.00, NULL, 1001),
(65646, 'JONAS', 'MANAGER', 68319, '1991-04-02', 2957.00, NULL, 2001),
(67858, 'SCARLET', 'ANALYST', 65646, '1997-04-19', 3100.00, NULL, 2001),
(69062, 'FRANK', 'ANALYST', 65646, '1991-12-03', 3100.00, NULL, 2001),
(63679, 'SANDRINE', 'CLERK', 69062, '1990-12-18', 900.00, NULL, 2001),
(64989, 'ADELYN', 'SALESMAN', 66928, '1991-02-20', 1700.00, 400.00, 3001),
(65271, 'WADE', 'SALESMAN', 66928, '1991-02-22', 1350.00, 600.00, 3001),
(66564, 'MADDEN', 'SALESMAN', 66928, '1991-09-28', 1350.00, 1500.00, 3001),
(68454, 'TUCKER', 'SALESMAN', 66928, '1991-09-08', 1600.00, 0.00, 3001),
(68736, 'ADNRES', 'CLERK', 67858, '1997-05-23', 1200.00, NULL, 2001),
(69000, 'JULIUS', 'CLERK', 66928, '1991-12-03', 1050.00, NULL, 3001),
(69324, 'MARKER', 'CLERK', 67832, '1992-01-23', 1400.00, NULL, 1001);

insert into salary_grade values (1, 800, 1300);
insert into salary_grade values (2, 1301, 1500);
insert into salary_grade values (3, 1501, 2100);
insert into salary_grade values (4, 2101, 3100);
insert into salary_grade values (5, 3101, 9999);

table salary_grade;
table department;
table employees;

--2. What are the names of managers that have a salary between 1500 and 2500?
select emp_name, job_name, salary
from employees where job_name='MANAGER' and salary between 1500 and 2500;

--3. What are the names of the salesmen who have an income (= salary plus commission) above 2000?
select emp_name, job_name, salary + commission as income from employees
where job_name='SALESMAN' and ((salary + coalesce(commission, 0.0))) > 2000;

--4. What are the names of the employees that work in Sydney?
select b.emp_name, a.dep_name, a.dep_location
from department a join employees b on a.dep_id = b.dep_id
where dep_location = 'SYDNEY';

--5. Who are the employees that earn more than their manager?
select e1.emp_name as employee, e1.salary as employee_salary, e2.emp_name as manager, e2.salary as manager_salary
from employees e1 join employees e2 on e1.manager_id = e2.emp_id
where e1.dep_id = e2.dep_id and e1.salary > e2.salary;

--6. Which salesmen earn a salary of grade 2?
select emp_name, job_name, salary
from employees e join salary_grade s on e.salary between s.min_sal and s.max_sal
where e.job_name = 'SALESMAN' and s.grade = 2;

--7. What is the salary grade of each employee? (Sort the output according to the salary grades.)
select emp_name, salary, s.grade
from employees e join salary_grade s on e.salary between s.min_sal and s.max_sal
order by s.grade;

--8. What are the names of the employees who are managers of at least one salesman?
select distinct e1.emp_name as manager
from employees e1 join employees e2 on e1.emp_id = e2.manager_id
where e2.job_name = 'SALESMAN';

--9. Which are the departments that are located in Melbourne?
select dep_name
from department
where dep_location = 'MELBOURNE';

--10. What are the names of the employees who are managers of at least three people?
select e1.emp_name as manager
from employees e1
where (
    select count(*)
    from employees e2
    where e2.manager_id = e1.emp_id
) >= 3;

--11. Write a query in SQL to list the emp_name and salary is increased by 15% and expressed the amount in US Dollars.
select emp_name, to_char((salary * 1.15),'FM$999G999D000') as salary_usd
from employees;

--12. Write a query in SQL to produce the output of employees name and job name in a format: "Employee & Job"
select emp_name || ' & ' || job_name as "Employee & Job"
from employees;

--13. Write a query in SQL to list the employees with Hire date in the format like February 22, 1991.
select emp_name, to_char(hire_date, 'Month DD, YYYY') as hire_date
from employees;

--14. Write a query in SQL to list the employees who joined in the month January.
select emp_name, hire_date
from employees
where trim(to_char(hire_date, 'Month')) = 'January';

--15. Write a query in SQL to list the hired date, job, and employee name who joined the company before 1992-12-31
select hire_date, job_name, emp_name
from employees
where hire_date < '1992-12-31';

--16. Write a query in SQL to list the id, name, and salary with an experience over 10 years
select emp_id, emp_name, salary
from employees
where date_part('year', age(now(), hire_date)) > 10;

--17. Write a query in SQL to list the employees whose names containing the character set 'AR' together
select emp_name
from employees
where emp_name like '%AR%';

--18. Write a query that will print all salary grade plus an additional column that will show the nature of task for each grade. 
--	  The fourth column will show ‘Supervisory’ if the salary is between 2000 and 10000, ‘Team Leader’ if the
--	  salary is between 1000 and 1999, and ‘Administrative’ if salary is between 999 and 700.
with salary_grade_cte as ( select grade, min_sal, max_sal from salary_grade )
select grade, min_sal, max_sal,
    case
    	when max_sal between 2000 and 10000 then 'Supervisory'
    	when max_sal between 1000 and 1999 then 'Team Leader'
    	when max_sal between 700 and 999 then 'Administrative'
    else 'Other position'
end as task_nature from salary_grade_cte;

--19. Write a query that will show on screen the employee name, id, salary, and commission where all NULL
--		commission is set to 0.0.
select emp_name, emp_id, salary, coalesce(commission, 0.0) as commission
from employees;

--20. Write a query that will show on screen the employee information of all the employees that has commission.
select *
from employees
where commission is not null;