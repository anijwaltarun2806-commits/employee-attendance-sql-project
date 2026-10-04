CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    designation VARCHAR(100),
    joining_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    employee_id INT,
    attendance_date DATE,
    check_in TIME,
    check_out TIME,
    status VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO departments (department_id, department_name)
VALUES
(1, 'Operations'),
(2, 'Finance'),
(3, 'HR'),
(4, 'IT'),
(5, 'Sales');

SELECT * FROM departments;

INSERT INTO employees 
(employee_id, employee_name, department_id, designation, joining_date)
VALUES
(101, 'Rahul Sharma', 1, 'Associate', '2024-01-15'),
(102, 'Priya Singh', 2, 'Analyst', '2023-06-20'),
(103, 'Amit Verma', 1, 'Senior Associate', '2022-11-10'),
(104, 'Neha Gupta', 3, 'HR Executive', '2024-03-05'),
(105, 'Rohit Meena', 4, 'IT Analyst', '2023-09-18'),
(106, 'Pooja Jain', 5, 'Sales Executive', '2024-02-12'),
(107, 'Vikas Kumar', 1, 'Associate', '2025-01-08'),
(108, 'Anjali Sharma', 2, 'Finance Analyst', '2024-07-22'),
(109, 'Karan Singh', 4, 'Developer', '2022-08-30'),
(110, 'Sneha Joshi', 5, 'Sales Associate', '2025-03-14');

SELECT * FROM employees;

INSERT INTO attendance
(attendance_id, employee_id, attendance_date, check_in, check_out, status)
VALUES
(1, 101, '2026-09-01', '09:02', '18:05', 'Present'),
(2, 102, '2026-09-01', '08:55', '17:50', 'Present'),
(3, 103, '2026-09-01', '09:15', '18:10', 'Late'),
(4, 104, '2026-09-01', '09:00', '18:00', 'Present'),
(5, 105, '2026-09-01', NULL, NULL, 'Absent'),
(6, 106, '2026-09-01', '09:05', '18:02', 'Present'),
(7, 107, '2026-09-01', '09:10', '18:00', 'Late'),
(8, 108, '2026-09-01', '09:00', '17:55', 'Present'),
(9, 109, '2026-09-01', '08:50', '18:15', 'Present'),
(10, 110, '2026-09-01', NULL, NULL, 'Absent'),

(11, 101, '2026-09-02', '08:58', '18:00', 'Present'),
(12, 102, '2026-09-02', '09:05', '18:10', 'Late'),
(13, 103, '2026-09-02', '09:00', '18:00', 'Present'),
(14, 104, '2026-09-02', '09:12', '18:05', 'Late'),
(15, 105, '2026-09-02', '09:00', '17:55', 'Present'),
(16, 106, '2026-09-02', '09:01', '18:00', 'Present'),
(17, 107, '2026-09-02', NULL, NULL, 'Absent'),
(18, 108, '2026-09-02', '08:57', '18:02', 'Present'),
(19, 109, '2026-09-02', '09:20', '18:10', 'Late'),
(20, 110, '2026-09-02', '09:00', '18:00', 'Present');

SELECT * FROM attendance;

--Total Employees

SELECT COUNT(*) AS total_employees
FROM employees;

--Department-wise employees

Select d.department_name, COUNT(e.employee_id) AS employee_count
From departments d
Left Join employees e on d.department_id=e.department_id
group by d.department_name;

--Employee-wise attendance status
SELECT employee_id, status
FROM attendance
ORDER BY employee_id, attendance_date;

SELECT employee_id,
    SUM(Case When status = 'Present' Then 1 ELSE 0 END) AS present_days,
    SUM(Case When status = 'Absent' Then 1 ELSE 0 END) AS absent_days,
    SUM(Case When status = 'Late' Then 1 ELSE 0 END) AS late_days
FROM attendance
GROUP BY employee_id
ORDER BY employee_id;

SELECT
    e.employee_id,
    e.employee_name,
    SUM(Case When a.status = 'Present' Then 1 ELSE 0 END) AS present_days,
    SUM(Case When a.status = 'Absent' Then 1 ELSE 0 END) AS absent_days,
    SUM(Case When a.status = 'Late' Then 1 ELSE 0 END) AS late_days
From employees e
Join attendance a
    ON e.employee_id = a.employee_id
GROUP BY
    e.employee_id,
    e.employee_name
ORDER BY e.employee_id;

--Employee Attendance %

Select e.employee_id, e.employee_name,
Count(a.attendance_id) As Total_days,
Sum(Case When a.status IN('Present','Late')Then 1 Else 0 END) As Attended_Days,
ROUND(
        SUM(CASE WHEN a.status IN ('Present', 'Late') THEN 1 ELSE 0 END) * 100.0
        / COUNT(a.attendance_id),
        2
    ) AS attendance_percentage
FROM employees e
JOIN attendance a
    ON e.employee_id = a.employee_id
GROUP BY
    e.employee_id,
    e.employee_name
ORDER BY attendance_percentage DESC;

--Employee who have attendance less then>80%--

SELECT e.employee_id, e.employee_name,
COUNT(a.attendance_id) AS total_days,
SUM(CASE WHEN a.status IN ('Present','Late') THEN 1 ELSE 0 END) AS attended_days,
ROUND((SUM(CASE WHEN a.status IN ('Present','Late') THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id))::numeric, 2) AS attendance_percentage
FROM employees e
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, e.employee_name
HAVING (SUM(CASE WHEN a.status IN ('Present','Late') THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id)) < 80
ORDER BY attendance_percentage;

--Most Absent Employees

Select e.employee_id, e.employee_name,
Sum(Case When a.status='Absent' Then 1 Else 0 END) As absent_days
from employees e
join attendance a on e.employee_id=a.employee_id
group By e.employee_id, e.employee_name
Order By absent_days DESC;

--Department-wise Attendance Percentage

SELECT d.department_name,
COUNT(a.attendance_id) AS total_days,
SUM(CASE WHEN a.status IN ('Present','Late') THEN 1 ELSE 0 END) AS attended_days,
ROUND((SUM(CASE WHEN a.status IN ('Present','Late') THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id))::numeric, 2) AS attendance_percentage
FROM departments d
JOIN employees e ON d.department_id = e.department_id
JOIN attendance a ON e.employee_id = a.employee_id
GROUP BY d.department_name
ORDER BY attendance_percentage DESC;

--Daily Attendance Summary

Select attendance_date,
Sum(Case When status = 'Present' Then 1 Else 0 End) As present,
Sum(Case When status = 'Absent' Then 1 Else 0 End) As absent,
Sum(Case When status = 'Late' Then 1 Else 0 End) As late
From attendance
Group By attendance_date
Order By attendance_date;

--Attendance Ranking
Select e.employee_id, e.employee_name,
Round((Sum(Case When a.status In ('Present','Late') Then 1 Else 0 End) * 100.0 / Count(a.attendance_id))::numeric, 2) As attendance_percentage,
Rank() Over (Order By(Sum(Case When a.status In ('Present','Late') Then 1 Else 0 End) * 100.0 / Count(a.attendance_id)) Desc) As attendance_rank
From employees e
Join attendance a
On e.employee_id = a.employee_id
Group By e.employee_id, e.employee_name
Order By attendance_rank;

-- Final management report

Select  e.employee_id, e.employee_name, d.department_name,
Count(a.attendance_id) As total_days,
Sum(Case When a.status In ('Present','Late') Then 1 Else 0 End) As attended_days,
Sum(Case When a.status = 'Absent' Then 1 Else 0 End) As absent_days,
Sum(Case When a.status = 'Late' Then 1 Else 0 End) As late_days,
Round((Sum(Case When a.status In ('Present','Late') Then 1 Else 0 End) * 100.0 / Count(a.attendance_id))::numeric, 2) As attendance_percentage
From employees e
Join departments d
On e.department_id = d.department_id
Join attendance a
On e.employee_id = a.employee_id
Group By e.employee_id, e.employee_name, d.department_name
Order By attendance_percentage Desc;

---employee of the month

Select e.employee_id, e.employee_name, d.department_name,
Sum(Case When a.status In ('Present','Late') Then 1 Else 0 End) As attended_days,
Sum(Case When a.status = 'Absent' Then 1 Else 0 End) As absent_days,
Sum(Case When a.status = 'Late' Then 1 Else 0 End) As late_days,
Round((Sum(Case When a.status In ('Present','Late') Then 1 Else 0 End) * 100.0 / Count(a.attendance_id))::numeric, 2) As attendance_percentage
From employees e
Join departments d
On e.department_id = d.department_id
Join attendance a
On e.employee_id = a.employee_id
Group By e.employee_id, e.employee_name, d.department_name
Order By attendance_percentage Desc, late_days Asc, absent_days Asc
Limit 1;
