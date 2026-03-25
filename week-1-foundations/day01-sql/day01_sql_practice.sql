-- ============================================
-- Day 01 — SQL Practice | Data Analyst Roadmap
-- Author: Arnav Gurung
-- Date: [today's date]
-- Topics: GROUP BY, HAVING, Subqueries,
-- CTEs, JOINs, Window Functions
-- ============================================

-- Create and populate these tables first
Create Database Claude_practice
use Claude_practice
CREATE TABLE employees (
  emp_id INT, name TEXT, department TEXT,
  salary INT, hire_date DATE, manager_id INT
);
INSERT INTO employees VALUES
(1,'Arnav','Engineering',90000,'2022-01-15',NULL),
(2,'Priya','Engineering',85000,'2021-06-01',1),
(3,'Rahul','Engineering',85000,'2020-03-10',1),
(4,'Sneha','Marketing',70000,'2023-02-20',NULL),
(5,'Karan','Marketing',75000,'2022-08-05',4),
(6,'Meera','Marketing',72000,'2021-11-30',4),
(7,'Vivek','HR',60000,'2023-05-15',NULL),
(8,'Aditi','HR',58000,'2022-09-01',7),
(9,'Rohan','Finance',95000,'2019-04-22',NULL),
(10,'Nisha','Finance',88000,'2020-07-18',9),
(11,'Amit','Finance',91000,'2021-01-05',9),
(12,'Deepa','HR',55000,'2023-08-10',7);

CREATE TABLE departments (
  dept_name TEXT, budget INT, location TEXT
);
INSERT INTO departments VALUES
('Engineering',5000000,'Pune'),
('Marketing',2000000,'Mumbai'),
('HR',1000000,'Delhi'),
('Finance',3000000,'Bengaluru');


Select * from employees
select * from departments

-- Find the total salary paid per department. Show department name and total salary, sorted highest to lowest.
select department,SUM(salary) as total_salary
from employees 
group by department;

-- Find departments where the average salary is greater than 75,000. Show department and average salary.
select department, AVG(salary) as avg_salary
from employees
group by department
having AVG(salary)>75000

-- Find all employees who earn more than the overall average salary across the company.
select name,salary
from employees
where salary>(select AVG(salary) from employees)

-- Using a CTE, find the department with the highest total salary bill.

with highest_salary as (
select department, sum(salary) as total_salary
from employees
group by department)
select * from highest_salary
order by total_salary desc
limit 1;

-- Join the employees table with the departments table. Show each employee's name, department, salary, and the department's location.
select e.name, e.department, e.salary,d.location
from employees e
Inner join departments d
on d.dept_name=e.department;

-- Rank employees within each department by salary (highest = rank 1). Show name, department, salary, and rank.
SELECT name, salary, department,
RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
FROM employees;

-- Find the 2nd highest earner in each department. (Hint: use DENSE_RANK in a subquery or CTE, then filter where rank = 2.)
with second_highest as(
select department, salary, dense_rank()
over (partition by  department order by salary desc)  as rnk
from employees
)
select * from second_highest 
where rnk=2;

-- Show each employee's name, salary, and a running total of salary ordered by hire_date (oldest first).
select name,salary, sum(salary) over 
(order by hire_date ASC) as running_total
from employees;

-- For the Finance department only, show each employee's name, salary, the previous employee's salary (ordered by salary desc), and the difference between them.
SELECT name, salary,
  LAG(salary) OVER (ORDER BY salary DESC) AS prev_salary,
  salary - LAG(salary) OVER (ORDER BY salary DESC) AS salary_diff
FROM employees
WHERE department = 'Finance';

-- Find departments where the highest-paid employee earns more than twice the lowest-paid employee in that same department. Show department name, max salary, and min salary.
select department, max(salary) as max_Salary, min(salary) as min_salary
from employees
group by department 
having max(salary)>2*min(salary);
