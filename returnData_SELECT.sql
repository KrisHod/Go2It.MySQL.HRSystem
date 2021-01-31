-- Get information about all Employees
SELECT *
FROM employees;

-- Get all employees with a name ‘David’
SELECT firstName, lastName, employeeId
FROM employees
WHERE firstName = 'David';

-- Get all employees with job_id equals to ‘IT_PROG’
SELECT *
FROM employees
WHERE jobId = 'IT_PROG';

-- Get all employees from department 50 (department_id) and salary more than 4000
SELECT *
FROM employees
WHERE departmentId = 50
  and salary > 4000;

-- Get all employees from department 20 and 30 (department_id)
SELECT *
FROM employees
WHERE departmentId = 20
   or departmentId = 30;

-- Get all employees whose last letter of the name equals to ‘a’
SELECT *
FROM employees
WHERE firstName LIKE '%a';
-- WHERE first_name REGEXP 'a$';

-- Get all employees from department 50 and 80 (department_id) who has a bonus
--   (commission_pct is not empty)
SELECT *
FROM employees
WHERE (departmentId = 50 or departmentId = 80)
  and commissionPCT IS NOT NULL;

-- Get all employees who has a salary in range of 8000-9000 including
SELECT *
FROM employees
WHERE salary BETWEEN 8000 and 9000
ORDER BY salary;

-- Get all employees who has a name containing ‘%’ character
SELECT *
FROM employees
WHERE firstName LIKE '%\%%';
-- WHERE first_name REGEXP '%'

-- Get all managers (see the manager_id)
SELECT managerId
FROM employees
GROUP BY managerId;

-- Get all the employees with their positions in format: Jessica(sh_clerk).
-- Use concatenation to achieve it
SELECT CONCAT(firstName, '(', jobId, ')') AS position
FROM employees;

-- Get all employees who has a name longer than 10 chars
SELECT firstName
FROM employees
WHERE CHAR_LENGTH(firstName) > 10;

-- Get all employees who was hired on the first day of any month
SELECT *
FROM employees
WHERE hireDate LIKE '%01';

-- Get all employees who was hired in 2000
SELECT *
FROM employees
WHERE hireDate LIKE '2000%';

-- Get all employees who have a salary more than $15000
-- (including bonus % mentioned in commission_pct)
SELECT firstName, salary, commissionPCT
FROM employees
WHERE (salary * commissionPCT + salary) > 15000;

-- Get all employees and information regarding the their bonus (yes/no) using conditional operator
SELECT firstName, IF(commissionPCT IS NOT NULL, 'YES', 'NO') AS bonus
FROM employees;

-- Create report by department_id with minimum and maximum salary, earliest and latest
-- date of hire and number of employees. Sort the result by the number of employees in
-- descending order (ie ‘1, 100000, 20000, 24-May-1990, 1-Jan-2020, 100’)
SELECT departmentId,
       MIN(salary),
       MAX(salary),
       MIN(hireDate) AS 'earliest date of hire',
       MAX(hireDate) AS 'latest date of hire',
       count(*)      AS 'Employees Number'
FROM employees
GROUP BY departmentId
ORDER BY 'Employees Number' DESC;

-- Show how many employees were hired in one year (find how to extract the year from date in MySQL)
SELECT COUNT(*)
FROM employees
WHERE YEAR(hireDate) = 2000;

-- Get department_id with more than 30 employees in it (using having)
SELECT departmentId
FROM employees
GROUP BY departmentId
HAVING COUNT(*) > 30;

-- Get manager_id with more than 5 subordinates whose total salary >50000. Use group by
SELECT managerId
FROM employees
GROUP BY managerId
HAVING COUNT(*) > 5
   and SUM(salary) > 50000;

-- Get max salary of all employees whose jobId ends with ‘CLERK’
SELECT MAX(salary)
FROM employees
WHERE jobId LIKE '%CLERK';

-- For each country show its region (ie ‘Germany, Europe’)
SELECT c.countryName, r.regionName
FROM countries c,
     regions r
WHERE c.regionId = r.regionId;

-- Show all employees that work in department_name=’IT’
SELECT e.firstName, d.departmentName
FROM employees e,
     departments d
WHERE d.departmentId = e.departmentId
  and d.departmentName = 'IT';

-- Get details information about each employee (First_name, Last_name, Department,
-- Job, Street, Country, Region)
SELECT e.firstName,
       e.lastName,
       d.departmentName,
       j.jobTitle,
       l.streetAddress,
       c.countryName,
       r.regionName
FROM employees e,
     departments d,
     jobs j,
     locations l,
     countries c,
     regions r
WHERE e.departmentId = d.departmentId
  and e.jobId = j.jobId
  and d.locationId = l.locationId
  and l.countryId = c.countryId
  and c.regionId = r.regionId;

-- Show manager names with >5 subordinates (use the same table twice)
SELECT e2.firstName, COUNT(*) as 'Employee Number'
FROM employees e
         INNER JOIN employees e2 ON e2.employeeId = e.managerId
GROUP BY e2.employeeId
HAVING COUNT(e2.employeeId) > 5;

-- Show all employees who don’t have manager
SELECT firstName
FROM employees
WHERE managerId IS NULL;

-- Show all employees and their current status (`Currently working`/`Left the company`
-- based on JOB_HISTORY.end_date)
SELECT e.firstName, IF(j.endDate IS NULL, 'Currently working', 'Left the company') AS status
FROM employees e
         LEFT JOIN jobhistory j on e.employeeId = j.employeeId;

-- Get all employees who live in Region (ie in Europe)
SELECT e.firstName, regionName
FROM employees e
         INNER JOIN departments d on e.departmentId = d.departmentId
         INNER JOIN locations l on d.locationId = l.locationId
         INNER JOIN countries c on l.countryId = c.countryId
         INNER JOIN regions r on c.regionId = r.regionId
WHERE regionName = 'Europe';


-- Show all departments with >30 employees (use having count(*))
SELECT departmentName, count(*) AS 'Number of employees'
FROM employees e
         INNER JOIN departments d on d.departmentId = e.departmentId
GROUP BY e.departmentId
HAVING count(*) > 30;

-- Show all departments that don’t have any employees
SELECT departmentName
FROM employees e
         INNER JOIN departments d on d.departmentId = e.departmentId
GROUP BY d.departmentId
HAVING count(employeeId) = 0;

-- Show all employees in format: First_name, Job_title, Department_name
SELECT firstName, jobTitle, departmentName
FROM employees e
         INNER JOIN jobs j on e.jobId = j.jobId
         INNER JOIN departments d on e.departmentId = d.departmentId
ORDER BY employeeId;

-- Get employees that have salary more than average in the company
SELECT firstName, lastName, salary
FROM employees
HAVING salary > (SELECT AVG(salary) FROM employees);

-- Get all employees whose manager gets salary > 15000
SELECT e.firstName AS employee, e2.firstName AS manager, e2.salary
FROM employees e
         INNER JOIN employees e2 ON e2.employeeId = e.managerId
WHERE e2.salary > 15000;

-- Show all employees that are not managers
SELECT firstName
FROM employees
WHERE employeeId NOT IN (SELECT managerId FROM employees WHERE managerId IS NOT NULL );
