WITH cte AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY column1, column2, column3 ORDER BY some_column) AS rn
    FROM e
)
DELETE FROM e
WHERE id IN (
    SELECT id FROM cte WHERE rn > 1
);
ostgres=# WITH cte AS (
postgres(#     SELECT ctid, ROW_NUMBER() OVER (
postgres(#         PARTITION BY emp_id, first_name, last_name, dept_id, manager_id, office_id
postgres(#         ORDER BY ctid
postgres(#     ) AS rn
postgres(#     FROM employee
postgres(# )
postgres-# DELETE FROM employee
postgres-# WHERE ctid IN (
postgres(#     SELECT ctid FROM cte WHERE rn > 1
postgres(# );

WITH cte AS (
    SELECT ctid, ROW_NUMBER() OVER (
        PARTITION BY emp_id, first_name, last_name, dept_id, manager_id, office_id
        ORDER BY ctid
    ) AS rn
    FROM employee
)
DELETE FROM employee
WHERE ctid IN (
    SELECT ctid FROM cte WHERE rn > 1
);
-- TO DELETE ALL DUPLICATE VLAUE FORM GIVEN TABLE 
WITH cte as (
select ctid, ROW_NUMBER() over (
PARTITION by emp_id, first_name, last_name, dept_id, manager_id, office_id 
   ORDER by ctid) 
   as rn 
   from employee 
   delete from employee 
   where ctid in (
   select ctid FROM cte where rn > 1
 ); 

 
--- TO IDENTIFIED AN DUPLICATE VALUE FORM GIVEN TABLE-----
SELECT first_name,last_name from employee  group by first_name,last_name having count(*)>1;		
	
emp_id | first_name | last_name | dept_id | manager_id | office_id
--------+------------+-----------+---------+------------+-----------
      2 | Mark       | Smith     |       2 |          4 |         3
      4 | Michelle   | Johnson   |       2 |            |         5
      5 | Brian      | Grand     |       2 |          2 |         3
      4 | Michelle   | Johnson   |       2 |            |         5
      5 | Brian      | Grand     |       2 |          2 |         3
      3 | jon        | Dae       |       3 |          5 |         6
      3 | jon        | Dae       |       3 |          5 |         6
	  
DELETE FROM employee
WHERE id NOT IN (
    SELECT MIN(id)
    FROM employee
    GROUP BY emp_id, first_name, last_name, dept_id, manager_id, office_id
);

delete from employee 
where id not in(
select min(id) 
from employee 
group by emp_id, first_name, last_name, dept_id, manager_id, office_id );

--Second highest salary from given table 
SELECT COALESCE((
  SELECT DISTINCT salary
  FROM customers
  ORDER BY salary DESC
  OFFSET 1 LIMIT 1
), NULL) AS second_highest_salary;

-- second hightest salary from 3 department 
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    salary INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);
INSERT INTO Employees (emp_id, emp_name, salary, dept_id) VALUES
(101, 'Alice', 50000, 1),
(102, 'Bob', 60000, 2),
(103, 'Charlie', 80000, 2),
(104, 'David', 55000, 3),
(105, 'Eva', 75000, 3),
(106, 'Frank', 70000, 1),
(107, 'Grace', 90000, 2),
(108, 'Hannah', 65000, 3),
(109, 'Ian', 85000, 1);
	
SELECT salary,department
FROM emp
WHERE salary = (
    SELECT DISTINCT salary
    FROM emp
    ORDER BY salary DESC
    OFFSET 1 LIMIT 1
);

