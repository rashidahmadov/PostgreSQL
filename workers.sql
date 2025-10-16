 --Show the salary for each employee and their name
--SELECT first_name, last_name, salary FROM public.employees AS e 
--Inner JOIN public.salaries AS s 
--ON e.emp_no = s.emp_no;  

-- select first_name, salary from employees
-- inner join salaries using(emp_no) 

-- SELECT first_name, last_name, salary FROM public.employees AS e 
-- Inner JOIN public.salaries AS s 
-- USING(emp_no); 
  


  

--Lesson 4
--Group By 
--select e.emp_no, round(avg(salary), 2) from employees as e
--inner join salaries as s on e.emp_no = s.emp_no
--group by e.emp_no 

--select title, avg(salary) from employees as e 
--inner join salaries as s on e.emp_no = s.emp_no
--inner join titles as t on t.emp_no = e.emp_no
--GROUP by title 

-- select dept_name, title, avg(salary) from employees as e 
-- inner join salaries as s on e.emp_no = s.emp_no
-- inner join titles as t on e.emp_no = t.emp_no
-- inner join dept_emp as de on de.emp_no = e.emp_no
-- inner join departments as d on d.dept_no = de.dept_no
-- group by 
--     GROUPING sets(
--     (dept_name),
--     (title),
--     ()
--     )  
-- 
-- select emp_no, avg(salary) from employees
-- inner join salaries using(emp_no)
-- group by emp_no
-- having avg(salary) > 70000 


--How many people were hired on any given hire date?
-- SELECT hire_date, COUNT(*) FROM public.employees
-- GROUP BY hire_date; 

--Show me  employees (emp_no) who were hired after 1991 and count the number of positions they've had
-- SELECT e.emp_no, COUNT(t.title) FROM public.employees AS e 
-- INNER JOIN public.titles AS t ON e.emp_no = t.emp_no
-- WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
-- GROUP BY e.emp_no; 

--How many employees were hired in each year?
-- SELECT COUNT(*), EXTRACT(year FROM hire_date) AS hire_year
-- FROM public.employees
-- GROUP BY EXTRACT(year FROM hire_date);

--Find the employee numbers and names of employees who work in the 'Sales' department.
-- SELECT e.emp_no, e.first_name, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- WHERE d.dept_name = 'Sales'
-- GROUP BY e.emp_no, d.dept_name; 

--Count the number of employees who were hired each month.
-- SELECT count( * ), EXTRACT(month from hire_date) as hire_month 
-- from public.employees
-- group by EXTRACT(month from hire_date);


--Having
--Show me employees(emp_no) who  hired after 1991, that have had more than 2 titles
-- SELECT e.emp_no, t.title FROM public.employees AS e 
-- INNER JOIN public.titles AS t ON e.emp_no = t.emp_no
-- WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
-- GROUP BY e.emp_no, t.title
-- HAVING COUNT(t.title) > 2; 

--Show me  employees (emp_no) that have had more than 15 salary changes that work in the department development
-- SELECT e.emp_no, count( * ) FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no
-- WHERE d.dept_name = 'Development'
-- GROUP BY e.emp_no
-- HAVING COUNT(s.salary) > 15;

--Show me employees who have worked for multiple departments
-- SELECT e.emp_no FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- GROUP by e.emp_no
-- HAVING COUNT(DISTINCT d.dept_name) > 1;


--Calculate the total average salary per department and the total using grouping sets
--Grouping Sets
-- SELECT AVG(s.salary) AS avg_salary, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no
-- GROUP BY 
--     GROUPING SETS(
--     (d.dept_name),
--     ()
--     );

Lesson 5 AND 6
WINDOW FUNCTIONS
SELECT *, avg(emp_no) OVER() AS average_emp_no FROM employees 

SELECT *, avg(salary) OVER(PARTITION BY emp_no) FROM salaries 

SELECT * FROM(
SELECT *, row_number() OVER(PARTITION BY dept_name ORDER BY hire_date) AS ordered_emp FROM employees
INNER JOIN dept_emp USING(emp_no)
INNER JOIN departments USING(dept_no)
)
WHERE ordered_emp <=3 

SELECT *, lag(hire_date) OVER() FROM employees 

SELECT *, lag(salary) OVER(ORDER BY from_date), salary - lag(salary) FROM salaries

-- SELECT *, lag(hire_date, 2) over() from employees
-- SELECT *, lead(hire_date, 2) over() from employees  

-- select *, first_value( salary ) over(PARTITION by emp_no order by from_date) from employees
-- inner join salaries USING(emp_no)

-- select *, last_value( salary ) over(PARTITION by emp_no order by from_date range BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) from employees
-- inner join salaries USING(emp_no)

-- select *, ntile( 5 ) over() from(
-- select * from employees
-- limit 17
-- )

--Find the average income for each position
-- SELECT DISTINCT(t.title), AVG(s.salary) OVER(PARTITION BY t.title) AS avg_income FROM public.employees as e 
-- INNER JOIN public.salaries AS s on e.emp_no = s.emp_no 
-- INNER JOIN public.titles AS t ON s.emp_no = t.emp_no;

--row_number()
--Find the first three hired employees for each department
-- SELECT emp_no, dept_name, row_number 
-- FROM (
--     SELECT e.emp_no, d.dept_name, ROW_NUMBER() OVER(PARTITION BY d.dept_name order by e.hire_date) AS row_number FROM public.employees AS e 
--     INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
--     INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- ) as ranked_employees
-- where row_number <= 3; 

--Find the 3 highest salaries for each position
-- select * from( SELECT e.*, d.dept_name, row_number() over(PARTITION by dept_name ORDER BY hire_date) as ordered from public.employees as e
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no)
-- WHERE ordered >= 3;

--hər departamnetdə ilk 3 işçini tap
-- SELECT *
-- FROM (
--     SELECT *, dense_rank() OVER(PARTITION BY d.dept_name order by e.hire_date) AS ordered FROM public.employees AS e 
--     INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
--     INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- )
-- where ordered <= 3;

--Find the 3 highest salaries for each position
-- SELECT salary, title, highest_salaries
-- FROM (
-- SELECT s.emp_no, s.salary, t.title, ROW_NUMBER() OVER(PARTITION BY t.title ORDER BY s.salary DESC) AS highest_salaries FROM public.salaries    AS s 
-- INNER JOIN public.titles AS t ON s.emp_no = t.emp_no
-- ) AS ranked_employees
-- WHERE highest_salaries <= 3;
-- hər vəzifə üzrə ən yüksək maaş alan 3 nəfəri tap

--  SELECT *
--  FROM (
--      SELECT *, ROW_NUMBER() OVER(PARTITION BY t.title ORDER BY s.salary DESC) AS row_number FROM public.salaries    AS s 
--      INNER JOIN public.titles AS t ON s.emp_no = t.emp_no
--  )
--  WHERE row_number <= 3;
.
--select *, lead( title ) over(PARTITION by emp_no order by from_date) as next_title from employees

-- SELECT *, LAG(salary, 2) OVER(PARTITION BY emp_no ORDER BY from_date) - salary FROM public.employees
--  INNER JOIN public.salaries USING(emp_no); 

--  SELECT *, FIRST_VALUE(salary) OVER(PARTITION BY emp_no ORDER BY from_date) FROM public.employees
--  INNER JOIN public.salaries USING(emp_no);

--  SELECT *, LAST_VALUE(salary) OVER(PARTITION BY emp_no ORDER BY 
--  from_date range BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED 
--  CURRENT ROW) FROM public.employees
--  INNER JOIN public.salaries USING(emp_no);

--  SELECT *, nth_value(salary, 1) OVER(PARTITION BY emp_no ORDER BY 
--  from_date range BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED 
--  CURRENT ROW) FROM public.employees
--  INNER JOIN public.salaries USING(emp_no);

--  SELECT *, entail(5) OVER(ORDER BY hire_date) FROM employees;

--new tasks
--How many employees were hired in each year?
-- SELECT COUNT(*) AS employees_count, extract(YEAR FROM hire_date) AS years FROM public.employees
-- group by extract(YEAR FROM hire_date);

--Count the number of employees who were hired each month
-- SELECT COUNT(*) AS employees_count, EXTRACT(MONTH FROM hire_date) AS months FROM public.employees
-- GROUP BY EXTRACT(MONTH FROM hire_date);

--Show me employees (emp_no) that have had more than 15 salary changes that work in the department development
--  SELECT emp_no, dept_name 
--  FROM (
--      SELECT e.emp_no, d.dept_name, s.salary, LAG(s.salary) OVER(PARTITION BY e.emp_no ORDER BY s.from_date) AS prev_salary,
--      CASE
--          WHEN LAG(s.salary) OVER(PARTITION BY e.emp_no ORDER BY s.from_date) IS DISTINCT from s.salary THEN 1
--          ELSE 0 
--          END
--      from public.employees AS e 
--      INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
--      INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
--      INNER JOIN public.salaries as s ON s.emp_no = e.emp_no
--      WHERE d.dept_name = 'Development'
--  ) AS salary_changes
--  GROUP BY emp_no, dept_name 
--  HAVING COUNT(salary_changes) > 15;

--For each employee's title record, show the current title and the next title. If there is no next title, show NULL.
--  SELECT e.emp_no, t.title AS current_title, LEAD(t.title) OVER(PARTITION BY e.emp_no ORDER BY t.from_date) FROM public.employees AS e 
--  INNER JOIN public.titles AS t ON e.emp_no = t.emp_no; 
 
--  SELECT *, LEAD(t.title) OVER(PARTITION BY e.emp_no ORDER BY t.from_date) FROM public.employees AS e 
--  INNER JOIN public.titles AS t ON e.emp_no = t.emp_no;

-- For each employee's department record, show the current department, the previous department, the next department, and the last recorded department for that employee
--  SELECT d.dept_name AS current_dept, 
--         LAG(d.dept_name) OVER(PARTITION BY e.emp_no ORDER BY de.from_date) AS prev_dept,
--         LEAD(d.dept_name) OVER(PARTITION BY e.emp_no ORDER BY de.from_date) AS next_dept,
--         LAST_VALUE(d.dept_name) OVER(PARTITION BY e.emp_no ORDER BY de.from_date) AS last_recorded_dept
--  FROM public.employees AS e 
--  INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
--  INNER JOIN public.departments AS d ON de.dept_no = de.dept_no;       

--For each employee, calculate the number of days between their hire date and the hire date of the previous employee based on the emp_no order. If there is no previous employee, show NULL
--  SELECT *, (hire_date - LAG(hire_date) OVER(ORDER BY emp_no)) AS day_counts FROM public.employees; 

--Assign a dense rank to each employee's title based on the from_date within each employee. Additionally, mark the first title each employee received
--  SELECT e.emp_no, e.first_name, t.title, t.from_date, 
--         DENSE_RANK() Over(PARTITION BY e.emp_no ORDER BY t.from_date) AS employee_title,
--         FIRST_VALUE(t.title) OVER(PARTITION BY e.emp_no ORDER BY t.from_date) AS first_title
--  FROM public.employees AS e 
--  INNER JOIN public.titles AS t ON e.emp_no = t.emp_no; 


--Lesson 7 UNION, conditionals
SELECT *, 
    CASE WHEN salary > 65000 THEN 'high_salary'
    ELSE 'low_salary'
    END
FROM salaries 

--Calculate the total average salary per department and the total
SELECT AVG(s.salary) AS avg_salary, d.dept_name FROM public.employees AS e 
INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
INNER JOIN public.departments AS d ON de.dept_no = d.dept_no 
INNER JOIN public.salaries AS s ON s.emp_no = e.emp_no
GROUP BY d.dept_name  

UNION 
SELECT avg( salary ) AS avg_salary, 'Total' AS dept_name 
FROM public.salaries AS s 


 SELECT *,
 CASE 
     WHEN salary > 70000 THEN 'Rich'
     WHEN salary BETWEEN 60000 AND 70000 THEN 'Medium'
     ELSE 'Poor'
     END 
 FROM employees
 INNER JOIN salaries USING(emp_no);

--UNION ALL
SELECT AVG(s.salary) AS avg_salary, NULL FROM public.employees AS e 
INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
INNER JOIN public.departments AS d ON de.dept_no = d.dept_no 
INNER JOIN public.salaries AS s ON s.emp_no = e.emp_no;





-- CREATE TEMPORARY VIEW "bigbucks" AS
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary
FROM public.employees AS e 
INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no 
WHERE s.salary > 80000;

SELECT * FROM "bigbucks";

--Assign a sequential number to each employee based on their hire date within each gender. Additionally, mark whether the employee is in the --top half or bottom half of their gender group based on their hire date

COUNT(*) / 2 calculates the midpoint based ON gender
 SELECT *, RANK() OVER(PARTITION BY gender ORDER BY hire_date) AS employee_rank, 
         CASE 
             WHEN RANK() OVER(PARTITION BY gender ORDER BY hire_date) < (SELECT COUNT(*) / 2 FROM public.employees) THEN 'top half'
             ELSE 'bottom half'
         END AS half_type
 FROM public.employees; 

--views
-- CREATE VIEW avg_emp AS 
-- (SELECT e.emp_no, AVG(s.salary) FROM public.employees AS e 
-- INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no
-- GROUP BY e.emp_no);

-- SELECT * FROM public.avg_emp;
-- SELECT * FROM employees AS e 
-- WHERE e.emp_no IN(SELECT emp_no FROM salaries);

--common table expressions
-- WITH averages as(
-- SELECT distinct d.dept_name, t.title, AVG(s.salary) FROM employees AS e 
-- INNER JOIN salaries AS e ON s.emp_no = e.emp_no 
-- INNER JOIN titles AS t ON t.emp_no = s.emp_no 
-- INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no 
-- INNER JOIN departments AS d ON d.dept_no = e.emp_no
-- GROUP BY
--     GROUPING sets (
--         (d.dept_name),
--         (t.title),
--         ()
--     )
-- )

-- SELECT * FROM averages;
-- 
-- SELECT concat(first_name, ' ', last_name) AS full_name, salary FROM 
-- (SELECT *, ROW_NUMBER() OVER(PARTITION BY e.emp_no ORDER BY s.from_date) AS gulnara FROM employees AS e
-- INNER JOIN salaries AS s ON s.emp_no = e.emp_no) 
-- WHERE gulnara = 1;







--Lesson 4
--GROUP BY
-- SELECT hire_date, COUNT(*) FROM public.employees
-- GROUP BY hire_date;
-- 
-- SELECT e.emp_no, COUNT(t.title) FROM public.employees AS e 
-- INNER JOIN public.titles AS t ON e.emp_no = t.emp_no
-- WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
-- GROUP BY e.emp_no;
-- 
-- SELECT e.emp_no, e.first_name, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- WHERE d.dept_name = 'Sales'
-- GROUP BY e.emp_no, d.dept_name; 
-- 
-- 
-- SELECT * FROM public.employees
-- ORDER BY first_name ASC, last_name DESC;
-- 
-- SELECT * FROM public.employees  
-- ORDER BY birth_date;
-- 
-- SELECT * FROM public.employees  
-- where first_name LIKE 'K%'
-- ORDER BY hire_date;
-- 
-- SELECT count(*) FROM public.employees
-- WHERE first_name LIKE 'A%_r';
-- 
-- SELECT * FROM public.employees;
-- 
-- SELECT *
-- FROM employees
-- WHERE birth_date <= CURRENT_DATE - INTERVAL '60 years';
-- 
-- SELECT count(*) 
-- from public.employees
-- WHERE EXTRACT(MONTH FROM hire_date) = 2;
-- 
-- SELECT hire_date FROM public.employees  
-- GROUP BY hire_date 
-- HAVING count( * ) >=10 
-- 
-- SELECT hire_date, count(*) FROM public.employees    
-- GROUP BY hire_date
-- 
-- SELECT e.emp_no, count(t.title) FROM public.employees AS e  
-- inner JOIN public.titles AS t ON e.emp_no = t.emp_no
-- WHERE EXTRACT (YEAR FROM e.hire_date) > 1991
-- GROUP BY e.emp_no 
-- 
-- SELECT * FROM public.departments;
-- 
-- SELECT e.emp_no, e.first_name, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- WHERE d.dept_name = 'Sales'
-- GROUP BY e.emp_no, d.dept_name;
-- 
-- SELECT * from public.departments; 
-- 
--Having
-- SELECT e.emp_no, t.title FROM public.employees AS e 
-- INNER JOIN public.titles AS t ON e.emp_no = t.emp_no
-- WHERE EXTRACT(YEAR FROM e.hire_date) > 1991
-- GROUP BY e.emp_no, t.title
-- HAVING COUNT(t.title) > 2; 
-- 
-- SELECT e.emp_no, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no
-- WHERE d.dept_name = 'Development'
-- GROUP BY e.emp_no, d.dept_name
-- HAVING COUNT(s.salary) > 15; 
-- 
-- SELECT e.emp_no FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- GROUP by e.emp_no
-- HAVING COUNT(DISTINCT d.dept_name) > 1; 
--Grouping sets
-- SELECT COUNT(e.emp_no) AS total_employees, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- GROUP BY
--     GROUPING SETS(
--         (d.dept_name),
--         ()
--     );
--     
-- 
-- SELECT AVG(s.salary) AS avg_salary, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no
-- GROUP BY 
--     GROUPING SETS(
--         (d.dept_name),
--         ()
--     );
-- 
-- Windows Functions
-- SELECT * from employees
-- INNER JOIN salaries AS s ON s.emp_no = e.emp_no 
-- inner join titles as t on t.emp_no = e.emp_no 
-- 
-- select * from (SELECT * from employees)
-- 
-- select * FROM(
-- select *, row_number() over(PARTITION by dept_name order by hire_date desc) from employees as e
-- inner join dept_emp as de on e.emp_no = de.emp_no
-- INNER join departments as d on d.dept_no = de.dept_no)
-- where row_number<=3 
-- 
-- select * from salaries as s 
-- inner join public.titles AS t on t.emp_no = s.emp_no
-- where row_number()
-- 
-- select *, lead(salary) over(PARTITION by emp_no order by from_date) - salary from employees
-- inner join salaries using (mp_no)
-- 
-- select *, 
-- CASE
--     when salary > 70000 then 'rich'
--     when salary between 60000 and 70000 then 'medium'
--     else 'poor'
--     end
-- from employees
-- inner join salaries using(emp_no)
-- 
-- For each employee's title record, show the current title and the next title. If there is no next title, show NULL.
-- 
-- select 
--     emp_no,
--     title as current_title,
--     LEAD (title) over (partition by emp_no ORDER by from_date) as 
-- next_title
-- FROM
--     public.titles;
--     
-- 
-- 
-- 
-- select *, nth_value(salary,3) over(partition by emp_no order by from_date range between UNBOUNDED PRECEDING and unbounded FOLLOWING) from employees
-- INNER join salaries using(emp_no) .
-- 
--For each employee's department record, show the current department, the previous department, the next department, and the last recorded department for that employee.
-- 
-- SELECT *,
-- lag(dept_name) OVER (PARTITION BY dept_name ORDER BY hire_date),
-- lead( dept_name ) over (PARTITION by dept_name ORDER by hire_date), 
-- last_value( dept_name ) over (PARTITION by dept_name order by hire_date)
--  from employees as e
-- inner join dept_emp as de on e.emp_no = de.emp_no
-- INNER join departments as d on d.dept_no = de.dept_no 
-- 
--For each employee, calculate the number of days between their hire date and the hire date of the previous employee based on the emp_no order. If there is no previous employee, show NULL.
-- 
-- select
-- hire_date - lag(hire_date) OVER (ORDER BY emp_no)
-- from employees 
-- 
--new tasks
--How many employees were hired in each year?
-- SELECT COUNT(*) AS employees_count, extract(YEAR FROM hire_date) AS years FROM public.employees
-- group by extract(YEAR FROM hire_date); 
-- 
--Count the number of employees who were hired each month
-- SELECT COUNT(*) AS employees_count, EXTRACT(MONTH FROM hire_date) AS months FROM public.employees
-- GROUP BY EXTRACT(MONTH FROM hire_date);
-- 
--For each employee's title record, show the current title and the next title. If there is no next title, show NULL.
-- SELECT e.emp_no, t.title AS current_title, LEAD(t.title) OVER(PARTITION BY e.emp_no ORDER BY t.from_date) FROM public.employees AS e 
-- INNER JOIN public.titles AS t ON e.emp_no = t.emp_no;
-- 
-- For each employee's department record, show the current department, the previous department, the next department, and the last recorded department for that employee
-- SELECT d.dept_name AS current_dept,
--        LAG(d.dept_name) OVER(PARTITION BY e.emp_no ORDER BY de.from_date) AS prev_dept,
--        LEAD(d.dept_name) OVER(PARTITION BY e.emp_no ORDER BY de.from_date) AS next_dept,
--        LAST_VALUE(d.dept_name) OVER(PARTITION BY e.emp_no ORDER BY de.from_date) AS last_recorded_dept
-- FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = de.dept_no;
-- 
--For each employee, calculate the number of days between their hire date and the hire date of the previous employee based on the emp_no order. If there is no previous employee, show NULL
-- SELECT *, (hire_date - LAG(hire_date) OVER(ORDER BY emp_no)) AS day_counts FROM public.employees;
-- 
--Assign a dense rank to each employee's title based on the from_date within each employee. Additionally, mark the first title each employee received
-- SELECT e.emp_no, t.title, t.from_date,  
--        DENSE_RANK() Over(PARTITION BY t.from_date ORDER BY e.emp_no) AS employee_title,
--        FIRST_VALUE(t.title) OVER(PARTITION BY t.from_date ORDER BY e.emp_no) AS first_title
-- FROM public.employees AS e 
-- INNER JOIN public.titles AS t ON e.emp_no = t.emp_no;
-- 
--UNION
-- SELECT AVG(s.salary) AS avg_salary, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no 
-- INNER JOIN public.salaries AS s ON s.emp_no = e.emp_no
-- GROUP BY d.dept_name
-- 
--UNION ALL
-- 
-- SELECT AVG(s.salary) AS avg_salary, NULL FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no 
-- INNER JOIN public.salaries AS s ON s.emp_no = e.emp_no;
-- 
--conditionals
-- SELECT prod_id, 
-- (CASE
--     WHEN price > 20 THEN 'expensive'
--     WHEN price BETWEEN 10 AND 20 THEN 'average'
--     else 'cheap'
--     END) AS price_class
-- FROM public.products;
-- 
--conditionals
-- SELECT 
-- SUM(case
--     WHEN population > 50000000 THEN surfacearea
--     ELSE surfacearea
--     END)
-- from public.country;
-- 
-- 
-- select e.emp_no avg(salary) from public.employees as e 
-- inner join public.salaries  as s on e.emp_no = s.emp_no
-- 
-- select * from employees as e
-- (select emp_no from salaries) 
-- 
-- select concat(first_name,' ', last_name) salary from 
-- (select *, row_number() over(PARTITION by e.emp_no order by from_date) from public.employees as e
-- inner join public.salaries as s on s.emp_no = e.emp_no)
-- where row_number() 
-- 
-- 
-- SELECT d.dept_name, AVG(s.salary) AS avg_manager_salary
-- FROM dept_manager AS dm
-- INNER JOIN employees AS e ON dm.emp_no = e.emp_no
-- INNER JOIN salaries AS s ON e.emp_no = s.emp_no
-- INNER JOIN departments AS d ON dm.dept_no = d.dept_no
-- GROUP BY d.dept_name
-- ORDER BY avg_manager_salary DESC; 
-- 
-- SELECT SUM(transaction_amount) AS total_transactions
-- FROM orders
-- WHERE customer_id IN (
--     SELECT DISTINCT customer_id
--     FROM orders
--     ORDER BY customer_id
--     LIMIT 100
-- );
-- 
-- SELECT 
--     d.dept_name,
--     e.emp_no,
--     e.first_name,
--     e.last_name,
--     e.salary
-- FROM 
--     employees e
-- JOIN 
--     dept_emp de ON e.emp_no = de.emp_no
-- JOIN 
--     departments d ON de.dept_no = d.dept_no
-- WHERE 
--     (e.salary) = (
--         SELECT MAX(e2.salary)
--         FROM employees e2
--         JOIN dept_emp de2 ON e2.emp_no = de2.emp_no
--         WHERE de2.dept_no = de.dept_no
--     )
-- ORDER BY 
--     d.dept_name;    
-- 
-- 
-- SELECT dept_no, dept_name, first_name, last_name, salary
-- FROM (
--     SELECT d.dept_no, d.dept_name, e.first_name, e.last_name, s.salary, 
--         RANK() OVER (PARTITION BY d.dept_no ORDER BY s.salary DESC) AS rank
--     FROM employees AS e
--     INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
--     INNER JOIN departments AS d ON d.dept_no = de.dept_no
--     INNER JOIN salaries AS s ON e.emp_no = s.emp_no
-- ) ranked_employees
-- WHERE rank = 1;
-- 
-- 
-- SELECT emp_no, first_name, hire_date, top_employees_rank
-- FROM (
--     SELECT emp_no, first_name, hire_date, RANK() OVER (ORDER BY hire_date ASC) AS top_employees_rank
--     FROM employees
-- ) ranked_employees
-- WHERE top_employees_rank <= 10;  
-- 
-- 
-- SELECT t.title, d.dept_name, AVG(s.salary) OVER (PARTITION BY d.dept_name, t.title) AS avg_salary
-- FROM employees AS e
-- INNER JOIN titles AS t ON e.emp_no = t.emp_no
-- INNER JOIN salaries AS s ON e.emp_no = s.emp_no
-- INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN departments AS d ON de.dept_no = d.dept_no; 
-- 
-- 
-- SELECT COUNT(e.emp_no) AS total_employees, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- GROUP BY
--     GROUPING SETS(
--         (d.dept_name),
--         ()
--     );
-- 
-- SELECT AVG(s.salary) AS avg_salary, d.dept_name FROM public.employees AS e 
-- INNER JOIN public.dept_emp AS de ON e.emp_no = de.emp_no
-- INNER JOIN public.departments AS d ON de.dept_no = d.dept_no
-- INNER JOIN public.salaries AS s ON e.emp_no = s.emp_no
-- GROUP BY 
--     GROUPING SETS(
--         (d.dept_name),
--         ()
--     );

--2) Find the average salary of each departments managers
SELECT dept_name, avg(salary) FROM employees e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no7) Who are the highest-paid employees IN EACH department?

SELECT concat(first_name, ' ', last_name), dept_name, salary FROM(
SELECT *, row_number() OVER(PARTITION BY dept_name ORDER BY salary DESC) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no)
WHERE row_number <=1


--7) Who are the highest-paid employees in each department?
SELECT concat(first_name, ' ', last_name), dept_name, salary FROM(
SELECT *, row_number() OVER(PARTITION BY dept_name ORDER BY salary DESC) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no)
WHERE row_number <=1


--8) Who are the top 10 longest-serving employees?
SELECT *, to_date - from_date AS servtime FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
ORDER BY servtime DESC
LIMIT 10

--9) What is the average salary for each job title and each department?
SELECT dept_name, avg(salary) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no 
INNER JOIN departments AS d ON d.dept_no = de.dept_no
GROUP BY dept_name

UNION

SELECT title, avg(salary) FROM employees AS e 
INNER JOIN salaries AS s ON s.emp_no = e.emp_no 
INNER JOIN titles AS t ON t.emp_no = e.emp_no
GROUP BY title

SELECT *, EXTRACT(MONTH FROM age(birth_date)), 
EXTRACT(DAY FROM age(birth_date) FROM employees

SELECT EXTRACT(YEAR FROM age(birth_date)) FROM employees
WHERE EXTRACT(YEAR FROM birth_date) > 60  

SELECT count(EXTRACT(MONTH FROM age(hire_date))) FROM employees
WHERE EXTRACT(MONTH FROM hire_date) = 2

SELECT count(*) FROM employees
WHERE EXTRACT(MONTH FROM birth_date) = 11 

SELECT * FROM employees
ORDER BY first_name ASC, last_name DESC
WHERE emp_no IN (SELECT emp_no FROM salaries)
#2 ORDER BY birth_date

#3 WHERE first_name LIKE 'K%'
ORDER BY hire_date

SELECT * FROM employees
WHERE first_name LIKE 'A%r'

SELECT * FROM employees
WHERE CAST(first_name AS TEXT) LIKE 'A%r'


SELECT * FROM employees
SELECT * FROM dept_emp
SELECT * FROM departments
SELECT * FROM salaries


SELECT first_name, last_name, dept_name FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
WHERE dept_name = 'Development'

SELECT first_name, salary FROM employees AS e 
INNER JOIN salaries AS s ON e.emp_no = s.emp_no

SELECT first_name, salary FROM employees AS e 
INNER JOIN salaries USING(emp_no)

SELECT hire_date, count(*) FROM employees
GROUP BY hire_date

SELECT hire_date, count(*) AS hire_year FROM employees
GROUP BY hire_date
HAVING count( * ) > 10

SELECT 'total', avg(salary) FROM employees AS e 
INNER JOIN salaries AS s ON e.emp_no = s.emp_no

UNION


 
SELECT dept_name, avg(salary) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no 
INNER JOIN departments AS d ON d.dept_no = de.dept_no
GROUP BY 
    GROUPING SETS(
    (dept_name),
    ()
    )


--select *, avg(emp_no) over() from employees

-- SELECT *, avg(salary) over(PARTITION by emp_no) from salaries

SELECT *, row_number() OVER(ORDER BY hire_date) FROM employees


-- select * from 
-- (select *, row_number() over( PARTITION by dept_name order by hire_date) as ordered
-- from employees as e
-- inner join dept_emp as de on de.emp_no = e.emp_no
-- inner JOIN departments as d on d.dept_no = de.dept_no)
-- WHERE ordered <=3



SELECT *, dense_rank() OVER( PARTITION BY dept_name ORDER BY hire_date) AS ordered
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no

-- row_number()    rank   dense_rank


--tasklar
-- group by
--1  How many people were hired on any given hire date?
 
SELECT hire_date, count(*) FROM employees
GROUP BY hire_date
ORDER BY hire_date


--2Show me  employees (emp_no) who were hired after 1991 and count the number of positions they've had

SELECT e.emp_no, count(title) AS position_sayi, hire_date FROM employees AS e
INNER JOIN titles AS t ON e.emp_no = t.emp_no
GROUP BY e.emp_no
HAVING EXTRACT(YEAR FROM hire_date) > 1991
ORDER BY emp_no


--3How many employees were hired in each year?
SELECT * FROM employees

SELECT EXTRACT(YEAR FROM hire_date), count(first_name) FROM public.employees
GROUP BY hire_date
ORDER BY hire_date


--4Find the employee numbers and names of employees who work in the 'Sales' department.
SELECT e.emp_no, first_name, last_name, dept_name FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
WHERE dept_name = 'Sales'


ORDER BY e.emp_no


--5Count the number of employees who were hired each month.
SELECT EXTRACT(MONTH FROM hire_date), count(*) FROM employees
GROUP BY EXTRACT(MONTH FROM hire_date)
ORDER BY EXTRACT

--6 Show me employees(emp_no) who hired after 1991, that have had more than 2 titles

SELECT e.emp_no, count(title) AS position_sayi, hire_date FROM employees AS e
INNER JOIN titles AS t ON e.emp_no = t.emp_no
GROUP BY e.emp_no
HAVING EXTRACT(YEAR FROM hire_date) > 1991 AND count(title) >= 2
ORDER BY emp_no

--7 Show me employees (emp_no) that have had more than 15 salary changes 
--  that work in the department development



SELECT s.emp_no, count(salary) FROM salaries AS s
INNER JOIN employees AS e ON s.emp_no = e.emp_no
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
WHERE de.dept_no = 'd005' 
GROUP BY s.emp_no
HAVING count(salary) >= 15
ORDER BY count(salary)

--8 show me employees who have worked for multiple departments
SELECT * FROM departments
SELECT * FROM employees
SELECT * FROM dept_emp

SELECT first_name, count(dept_name) FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
GROUP BY first_name
HAVING count(dept_name)> 2

SELECT first_name, de.dept_no FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no

SELECT first_name, count(DISTINCT de.dept_no) FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
GROUP BY first_name


SELECT first_name, count(DISTINCT de.dept_no) FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
GROUP BY first_name

SELECT DISTINCT dept_name, first_name FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no 
INNER JOIN departments AS d ON d.dept_no =  de.dept_no
-- group by first_name
WHERE first_name = 'Aamer'


--9  Calculate the total amount of employees per department and the total using grouping sets

SELECT de.dept_no, count(emp_no) AS ishci_sayi FROM dept_emp AS de
INNER JOIN departments AS d ON d.dept_no = de.dept_no
GROUP BY 
    GROUPING SETS(
    (de.dept_no),
    ()    
    )
    
    
--10 Calculate the total average salary per department and the total using grouping sets

SELECT dept_name, avg(salary) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no 
INNER JOIN departments AS d ON d.dept_no = de.dept_no
GROUP BY 
    GROUPING SETS(
    (dept_name),
    ()
    )


--lesson 5,6 Window functions
--1 Find the average income for each position

SELECT DISTINCT title FROM public.titles

SELECT t.title, avg(s.salary) FROM titles AS t 
INNER JOIN salaries AS s ON t.emp_no = s.emp_no
GROUP BY t.title

SELECT DISTINCT title, avg(salary) OVER(PARTITION BY title) FROM employees AS e 
INNER JOIN salaries AS s ON s.emp_no = e.emp_no 
INNER JOIN titles AS t ON t.emp_no = e.emp_no


--Find the first three hired employees for each department

SELECT * FROM 
(SELECT *, row_number() OVER( PARTITION BY dept_name ORDER BY hire_date) AS ordered
FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no)
WHERE ordered <=3

SELECT * FROM(
SELECT *, dense_rank() OVER(PARTITION BY dept_name ORDER BY hire_date) AS ordered 
FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no)
WHERE ordered <= 3

--Find the 3 highest salaries for each position
SELECT * FROM(
SELECT *, row_number()OVER( PARTITION BY title ORDER BY salary DESC) FROM salaries AS s 
INNER JOIN titles AS t ON t.emp_no = s.emp_no)
WHERE row_number <=3

SELECT * FROM 
(SELECT *, row_number() OVER(PARTITION BY title ORDER BY salary) AS ordered
FROM titles AS s 
INNER JOIN employees AS e ON e.emp_no = s.emp_no)
WHERE ordered <=3


SELECT * FROM
(SELECT *, row_number() OVER(PARTITION BY title ORDER BY t.emp_no) AS ordered
FROM titles AS t
INNER JOIN salaries AS s ON t.emp_no = s.emp_no)
WHERE ordered <=3


SELECT title, salary FROM titles AS t 
INNER JOIN salaries AS s ON t.emp_no = s.emp_no 
ORDER BY title, salary DESC

--lead      lag

SELECT *, lag(salary) OVER(PARTITION BY emp_no ORDER BY from_date) - salary FROM employees
INNER JOIN salaries USING(emp_no)


--first_value, last_value          range BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING

SELECT *, last_value(salary) OVER(PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING) FROM employees
INNER JOIN salaries USING(emp_no)


-- nth_value

SELECT *, nth_value(salary, 2) OVER(PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING) FROM employees
INNER JOIN salaries USING(emp_no)


SELECT *, nth_value(salary, 3) OVER(PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING) FROM employees
INNER JOIN salaries USING(emp_no)

--
SELECT *, ntile(5) OVER (ORDER BY hire_date) FROM employees


--Conditional statements 

--70k boyuk,rich       60-70k arasi, medium        60k kicik, poor
SELECT *,
CASE 
    WHEN salary > 70000 THEN 'Rich'
    WHEN salary BETWEEN 60000 AND 70000 THEN 'Medium'
    ELSE 'Poor'
    END
FROM employees
INNER JOIN salaries USING(emp_no)


SELECT *,
CASE 
    WHEN salary > 70000 THEN 1
    ELSE 0
    END
FROM employees
INNER JOIN salaries USING(emp_no)


--For each employee's title record, show the current title and the next title. If there is no next title, show NULL.
SELECT emp_no, first_name, last_name, lead(title) OVER(PARTITION BY emp_no ORDER BY from_date) AS title FROM employees
INNER JOIN titles USING(emp_no)


--For each employee's department record, show the current department, the previous department, 
--the next department, and the last recorded department for that employee.


SELECT emp_no, first_name, last_name, 


lead(dept_name) OVER(PARTITION BY emp_no ORDER BY from_date) AS sonraki,
lag(dept_name) OVER(PARTITION BY emp_no ORDER BY from_date) AS evvelki, 
last_value(dept_name) OVER (PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING )
AS last_department FROM employees
INNER JOIN dept_emp USING(emp_no)


INNER JOIN departments USING(dept_no)



--For each employee, calculate the number of days between their hire date 
--and the hire date of the previous employee based on the emp_no order. 


--If there is no previous employee, show NULL.

SELECT * FROM employees
INNER JOIN salaries USING(emp_no)

SELECT *, lead(hire_date) OVER(PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) FROM employees
INNER JOIN salaries USING(emp_no)


--Assign a dense rank to each employee's title based on the from_date within each employee. 


--Additionally, mark the first title each employee received.


SELECT emp_no, first_name, last_name, title, 
first_value(title) OVER (PARTITION BY emp_no ORDER BY from_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) 


AS first_position, 
dense_rank() OVER(PARTITION BY title ORDER BY from_date) FROM employees
INNER JOIN titles USING(emp_no)






































    
    
    









































-- 

row_number() OVER (PARTITION BY gender ORDER BY hire_date),
ntile(2) OVER (PARTITION BY gender ORDER BY hire_date),

CASE
    WHEN ntile(2) OVER (PARTITION BY gender ORDER BY hire_date) = 1 THEN 'top'
    ELSE 'bottom'
    END
    
FROM employees


--*Calculate the total average salary per department and the total

-- select * from salaries
-- select * from employees
-- select * from dept_emp
-- select * from departments
SELECT avg(average_salary) FROM(
SELECT d.dept_name, AVG(salary) AS average_salary
FROM employees
INNER JOIN dept_emp USING (emp_no)
INNER JOIN departments AS d USING (dept_no)
INNER JOIN salaries USING (emp_no)
GROUP BY dept_name)


SELECT d.dept_name, AVG(salary) AS average_salary
FROM employees
INNER JOIN dept_emp USING (emp_no)
INNER JOIN departments AS d USING (dept_no)
INNER JOIN salaries USING (emp_no)
GROUP BY dept_name

UNION 

SELECT 'ttotal' , AVG(salary) AS average_salary
FROM employees
INNER JOIN dept_emp USING (emp_no)
INNER JOIN departments AS d USING (dept_no)
INNER JOIN salaries USING (emp_no)





SELECT 'total' AS dept_no, AVG(salary) AS average_salary FROM employees
INNER JOIN dept_emp USING (emp_no)
INNER JOIN departments AS d USING (dept_no)
INNER JOIN salaries USING (emp_no)



CREATE VIEW avg_emp AS
(SELECT e.emp_no, avg(salary) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
GROUP BY e.emp_no)

SELECT * FROM avg_emp



WITH averages AS(
SELECT DISTINCT dept_name, title, avg(salary) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN titles AS t ON t.emp_no = e.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no
GROUP BY 
    GROUPING SETS(
    (dept_name),
    (title),
    ()
    )
    )
SELECT * FROM averages


-- select * from employees as e
-- where e.emp_no in
--     (select emp_no from salaries as s)


SELECT concat(first_name, ' ', last_name), salary FROM 
(SELECT *, row_number() OVER(PARTITION BY e.emp_no ORDER BY from_date) FROM employees AS e 
INNER JOIN salaries AS s ON e.emp_no = s.emp_no)
WHERE row_number = 1
ORDER BY salary


--2) Find the average salary of each departments managers
SELECT * FROM dept_manager
SELECT emp_no FROM dept_manager

SELECT * FROM employees e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
-- inner join titles as t on t.emp_no = e.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no
INNER JOIN dept_manager AS dm ON dm.emp_no = e.emp_no


SELECT dept_name, avg(salary) FROM employees e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no
INNER JOIN dept_manager AS dm ON dm.emp_no = e.emp_no
WHERE e.emp_no IN (SELECT emp_no FROM dept_manager)
GROUP BY dept_name

SELECT * FROM employees





SELECT concat(first_name, ' ', last_name), dept_name, salary FROM(
SELECT *, row_number() OVER(PARTITION BY dept_name ORDER BY salary DESC) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON d.dept_no = de.dept_no)
WHERE row_number <=1



SELECT dept_name, avg(salary) FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no 
INNER JOIN departments AS d ON d.dept_no = de.dept_no
GROUP BY dept_name

UNION

SELECT title, avg(salary) FROM employees AS e 
INNER JOIN salaries AS s ON s.emp_no = e.emp_no 
INNER JOIN titles AS t ON t.emp_no = e.emp_no
GROUP BY title



SELECT *, to_date - from_date AS servtime FROM employees AS e
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
ORDER BY servtime DESC
LIMIT 10




















