use employees;

---Q3 
select emp_no, count(*) from dept_emp group by emp_no having count(*)>1 limit 100000;

---Q4.
select emp_no, count(*) from dept_emp group by emp_no having count(*) = 1 limit 1000000;


---Q5.
select CONCAT(first_name, ' ', last_name) as full_name, from_date
from dept_emp de 
inner join employees e on de.emp_no = e.emp_no 
inner join departments d on de.dept_no = d.dept_no
where de.emp_no in (select emp_no
					from dept_emp
					group by emp_no
					having count(*) = 1) AND 
		d.dept_name='Production'
order by last_name limit 1000000;


---Q6.
select e.emp_no, group_concat(dept_no) as dept_nos
from employees e inner join dept_emp de on e.emp_no = de.emp_no
group by e.emp_no
having count(*)=2;

---Q7.
create temporary table empDept
select de1.emp_no, de1.dept_no as deptNo1, de2.dept_no as deptNo2
from dept_emp de1, dept_emp de2
where a.emp_no = b.emp_no AND a.from_date < b.from_date AND
a.emp_no in (select emp_no
from dept_emp
group by emp_no
having count(*) = 2);  

select e.first_name, e.last_name, d1.dept_name as dept1, d2.dept_name as dept2 
from employees e join empDept e2 on e.emp_no = e2.emp_no
				join departments d1 on e2.deptNo1 = d1.dept_no
                join departments d2 on e2.deptNo2 = d2.dept_no
order by e.emp_no;

---Q8.

select 
dept_name, min(timestampdiff(YEAR, birth_date, hire_date)), 
max(timestampdiff(YEAR, birth_date, hire_date)), 
avg(timestampdiff(YEAR, birth_date, hire_date)) 
from dept_emp de join employees e on de.emp_no = e.emp_no
				join departments d on de.dept_no = d.dept_no
group by de.dept_no;

---Q9.
select d.dept_name, min(s.salary), max(s.salary), avg(s.salary)
from dept_emp dp1 join salaries s on dp1.emp_no = s.emp_no
				join departments d on dp1.dept_no = d.dept_no
where dp1.from_date >= all (select dp2.from_date from dept_emp dp2 where dp1.emp_no = dp2.emp_no)
group by dp1.dept_no;

---Q10.
select d.dept_name, min(s.salary), max(s.salary), avg(s.salary)
from dept_emp de join salaries s on de.emp_no = s.emp_no
				join departments d on de.dept_no = d.dept_no
where de.to_date = '9999-01-01'
group by de.dept_no;


---Q11.
select concat (e.first_name, ' ', e.last_name), e.gender, t.title, d.dept_name, concat (ma.first_name, ' ', ma.last_name) as department_manager, s.salary, s.from_date, s.to_date
from employees e join salaries s on e.emp_no = s.emp_no
				join titles t on e.emp_no = t.emp_no
                join dept_emp de on e.emp_no = de.emp_no
                join departments d on de.dept_no = d.dept_no
                join dept_manager m on de.dept_no = m.dept_no
                join employees ma on m.emp_no = ma.emp_no
where s.from_date between t.from_date and t.to_date AND
		s.from_date between de.from_date and de.to_date AND
        s.from_date between m.from_date and m.to_date
order by s.salary
limit 10;

---Q11.
select  rnk, last_name, department_id, salary 
from 	(
	select	last_name, department_id, salary,
		RANK () OVER ( PARTITION BY  department_id
			       ORDER BY	     salary	DESC
			     ) AS rnk
	from 	employees
	)
where 	rnk <= 3;
