--혼합 SQL 문제입니다.

/*
문제1.
담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의 
이름, 매니저아이디, 커미션 비율, 월급 을 출력하세요.
(45건)
*/
select  first_name,
        manager_id,
        commission_pct,
        salary
from employees
where salary > 3000 
  and manager_id is not null
  and commission_pct is null;
  

/*
문제2. 
각 부서별로 최고의 급여를 받는 사원의 
직원번호(employee_id), 이름(first_name), 급여(salary), 입사일(hire_date), 
전화번호(phone_number), 부서번호(department_id) 를 조회하세요 
-조건절비교 방법으로 작성하세요
-급여의 내림차순으로 정렬하세요
-입사일은 2001-01-13 토요일 형식으로 출력합니다.
-전화번호는 515-123-4567 형식으로 출력합니다.
(11건)
*/
select  e.employee_id,
        e.first_name,
        e.salary,
        to_char(hire_date, 'YYYY-MM-DD DAY' ) hire_date, 
        replace(phone_number, '.', '-') phone_number, 
        e.department_id
from employees e
where (e.department_id, e.salary) in (select department_id, max(salary)
                                      from employees
                                      group by department_id)
order by salary desc;


/*
문제3
매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-통계대상(직원)은 2005년 이후의 입사자 입니다.
-매니저별 평균급여가 5000이상만 출력합니다.
-매니저별 평균급여의 내림차순으로 출력합니다.
-매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
-출력내용은 매니저아이디, 매니저이름(first_name), 매니저별평균급여, 매니저별최소급여, 매니저별최대급여 입니다.
(9건)
*/
select  t.manager_id,
        e.first_name,
        t.avgSalary,
        t.minSalary,
        t.maxSalary
from employees e, ( select  manager_id, 
                            round(avg(salary),0) avgSalary, 
                            min(salary) minSalary, 
                            max(salary) maxSalary
                    from employees
                    where hire_date > '05/01/01'
                    group by manager_id
                    having avg(salary) >= 5000
                    order by avg(salary) desc ) t
where e.employee_id = t.manager_id
order by avgSalary desc;


/*
문제4.
각 사원(employee)에 대해서 
사번(employee_id), 이름(first_name), 부서명(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
부서가 없는 직원(Kimberely)도 표시합니다.
(106명)
*/
select  emp.employee_id as "사번",
        emp.first_name as "이름",
        dep.department_name as "부서명",
        mag.first_name as "매니저이름"
from employees emp, departments dep, employees mag
where emp.department_id = dep.department_id(+)
and emp.manager_id = mag.employee_id;



/*
문제5.
2005년 이후 입사한 직원중에 입사일이 11번째에서 20번째의 직원의 
사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요
*/
select  rn,
        employee_id,
        first_name,
        salary,
        hire_date
from (select  rownum rn,
              employee_id,
              first_name,
              salary,
              hire_date
      from (select  employee_id,
                    first_name,
                    salary,
                    hire_date
            from employees
            where hire_date > '2005-01-01'
            order by hire_date asc)
      )
where rn>=11
  and rn<=20;



/*
문제6.
가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름(department_name)은?
*/
select  e.first_name || ' ' || e.last_name as "이름",
        e.salary as "연봉",
        d.department_name as "부서이름",
        e.hire_date
from employees e, departments d
where e.department_id = d.department_id 
  and e.hire_date = ( select max(hire_date)
                      from employees ) ;
 
          
/*                      
문제7.
평균연봉(salary)이 가장 높은 부서 직원들의 
직원번호(employee_id), 이름(firt_name), 성(last_name)과  업무(job_title), 연봉(salary)을 조회하시오.
*/
select  e.employee_id as "사번",
        e.first_name as "이름",
        e.last_name as "성",
        e.salary as "급여",
        t.avgSalary,
        j.job_title
from employees e, jobs j, (select department_id, 
                                  avg(salary) as avgSalary
                           from employees
                           group by department_id )t
where e.department_id = t.department_id
  and e.job_id = j.job_id
  and t.avgSalary = (select max(avg(salary)) avgSalary
                     from employees
                     group by department_id );



/*
문제8.
평균 급여(salary)가 가장 높은 부서는? 
*/
--방법1
select  d.department_name, t.avgSalary
from departments d, (select department_id, 
                            avg(salary) as avgSalary
                     from employees
                     group by department_id )t
where d.department_id = t.department_id      
and t.avgSalary = (select max(avg(salary)) maSalary
                   from employees
                   group by department_id);


--방법2
select department_name
from departments
where department_id = ( select department_id
                        from employees
                        group by department_id
                        having avg(salary) = (select max(avg(salary))
                                              from employees
                                              group by department_id));





/*
문제9.
평균 급여(salary)가 가장 높은 지역은? 
*/
select region_name
from regions
where region_id =  (select r.region_id
                    from employees e,
                         departments d,
                         locations l,
                         countries c,
                         regions r
                    where e.department_id = d.department_id
                    and   d.location_id = l.location_id
                    and   l.country_id = c.country_id
                    and   c.region_id = r.region_id
                    group by r.region_id
                    having avg(salary) = (select max(avg(salary))
                                          from employees e,
                                               departments d,
                                               locations l,
                                               countries c,
                                               regions r
                                          where e.department_id = d.department_id
                                          and   d.location_id = l.location_id
                                          and   l.country_id = c.country_id
                                          and   c.region_id = r.region_id
                                          group by r.region_id));


/*
문제10.
평균 급여(salary)가 가장 높은 업무는? 
*/
select job_title
from jobs
where job_id = (select job_id
                from employees
                group by job_id
                having avg(salary) = (select max(avg(salary))
                                      from employees
                                      group by job_id));
