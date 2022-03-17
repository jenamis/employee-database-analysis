-- Create table of retiring employees with title
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees AS e
	INNER JOIN titles AS t
		ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON(emp_no) emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC, to_date DESC;

-- Create table with number of retiring employees by most recent title
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY(title)
ORDER BY count DESC;

-- Create mentorship eligibility table
SELECT DISTINCT ON(emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON e.emp_no = de.emp_no
	INNER JOIN titles AS t
		ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC, t.to_date DESC;

-- ADDITIONAL QUERIES AND TABLES
-- Create table of current employees with department and title
SELECT DISTINCT ON(emp_no) de.emp_no,
	d.dept_name,
	de.from_date,
	de.to_date,
	t.title
INTO current_dept_emp
FROM dept_emp AS de
	INNER JOIN titles AS t
		ON de.emp_no = t.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
ORDER BY de.emp_no ASC, de.to_date DESC, t.to_date DESC;

-- Get count of current employees
SELECT COUNT(emp_no) FROM current_dept_emp;

-- Get number of current employees by current title
SELECT COUNT(emp_no), title
INTO current_titles
FROM current_dept_emp
GROUP BY(title)
ORDER BY count DESC;

-- Get number of current employees by current department
SELECT COUNT(emp_no), dept_name
INTO current_dept
FROM current_dept_emp
GROUP BY(dept_name)
ORDER BY count DESC;

-- Create table of current employees eligible for retirement by department
SELECT cde.emp_no,
	e.birth_date,
	cde.dept_name,
	cde.from_date,
	cde.to_date
INTO retirement_dept
FROM current_dept_emp AS cde
	INNER JOIN employees AS e
		ON cde.emp_no = e.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'

-- Create table with number of retiring employees by department
SELECT COUNT(emp_no), dept_name
INTO retirement_dept_count
FROM retirement_dept
GROUP BY(dept_name)
ORDER BY count DESC;

-- Create table with number of mentorship-eligible employees by title
SELECT COUNT(emp_no), title
INTO mentorship_title_count
FROM mentorship_eligibility
GROUP BY(title)
ORDER BY count DESC;

-- Create table of mentorship-eligible employees with department
SELECT me.emp_no,
	me.first_name,
	me.last_name,
	me.birth_date,
	me.from_date,
	me.to_date,
	me.title,
	cde.dept_name
INTO mentorship_eligibility_dept
FROM mentorship_eligibility AS me
	INNER JOIN current_dept_emp AS cde
		ON me.emp_no = cde.emp_no
ORDER BY me.emp_no ASC;

-- Create table with number of mentorship-eligible employees by department
SELECT COUNT(emp_no), dept_name
INTO mentorship_dept_count
FROM mentorship_eligibility_dept
GROUP BY(dept_name)
ORDER BY count DESC;

-- Create table of mentorship-eligible employees with new birthdate and title criteria
SELECT cde.emp_no,
	e.birth_date,
	cde.dept_name,
	cde.from_date,
	cde.to_date,
	cde.title
INTO mentorship_eligibility_new
FROM current_dept_emp AS cde
	INNER JOIN employees AS e
		ON cde.emp_no = e.emp_no
WHERE (e.birth_date BETWEEN '1960-01-01' AND '1965-12-31')
AND (cde.title IN ('Engineer', 'Assistant Engineer', 'Staff'));

-- Create table with number of mentorship-eligible employees by department based on new criteria
SELECT COUNT(emp_no), dept_name
INTO mentorship_dept_count_new
FROM mentorship_eligibility_new
GROUP BY(dept_name)
ORDER BY count DESC;