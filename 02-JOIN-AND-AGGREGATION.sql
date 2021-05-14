-----------------
-- JOIN
-----------------

-- employees와 departments 테이블 확인
DESC employees;
DESC departments;

SELECT * FROM employees;  -- 107
SELECT * FROM departments;  -- 27

SELECT first_name, department_name
FROM employees, departments;
-- 두 테이블의 조합 가능한 모든 쌍이 출력
-- 카티전 프로덕트, Cross Join
-- 일반적으로는 이런 결과를 원하지는 않을 것

-- 두 테이블의 연결 조건을 WHERE에 부여 -> Simple Join
SELECT *
FROM employees, departments
WHERE employees.department_id = departments.department_id; -- 106

-- 필드의 모호성을 해소하기 위해 테이블명 혹은 alias를 부여한다
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id;

-- INNER JOIN
SELECT emp.first_name,
    dept.department_name
FROM employees emp JOIN departments dept
                    USING (department_id);
                    
SELECT first_name,
    department_name
FROM employees emp JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    -- ON은 JOIN의 조건을 명시할 때 사용
                    
SELECT first_name, department_name
FROM employees NATURAL JOIN departments;    -- Natural JOIN
--  같은 이름을 가진 컬럼을 기준으로 JOIN

-- Thera JOIN
-- 특정 조건을 기준으로 JOIN을 하되
-- 조건이 = 이 아닌 경우
-- Non-Equi Join이라고 한다
SELECT * FROM jobs WHERE job_id='FI_MGR';

SELECT first_name, salary FROM employees emp, jobs j
WHERE j.job_id='FI_MGR' AND salary BETWEEN j.min_salary AND j.max_salary;

--------------------
-- Outer JOIN
--------------------
-- 조건이 만족하는 짝이 없는 레코드도 null을 포함하여 결과를 출력
-- 모든 레코드를 출력할 테이블이 어느 위치에 있는가에 따라서 LEFT, RIGHT, FULL
-- ORACLE SQL의 경우, NULL이 출력될 수 있는 쪽 조건에 (+)를 붙인다

-- INNER JOIN
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id; -- 106

-- 전체 사원 수
SELECT COUNT(*) FROM employees; --  107명의 사원

-- 부서 id가 null 인 직원
SELECT first_name, department_id 
FROM employees
WHERE department_id IS NULL;

-- LEFT OUTER JOIN: 짝이 없어도 왼쪽의 테이블 전체를 출력에 참여
-- ORACLE SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id = dept.department_id (+);

-- ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp LEFT OUTER JOIN departments dept
                        ON emp.department_id = dept.department_id;
                        
-- RIGHT OUTER JOIN
-- 오른쪽 테이블의 모든 레코드를 출력 참여 -> 왼쪽 테이블에 매칭되는 짝이 없는 경우
-- 왼쪽 테이블 컬럼이 null 표기된다
SELECT
    first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp, departments dept
WHERE emp.department_id (+) = dept.department_id;

-- ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp RIGHT OUTER JOIN departments dept
                    ON emp.department_id = dept.department_id;
                    
-- FULL OUTER JOIN
-- 양쪽 테이블 모두 짝이 없어도 출력에 참여
-- ERROR
--SELECT first_name,
--    emp.department_id,
--    dept.department_id,
--    department_name
--FROM employees emp, departments dept
--WHERE emp.department_id (+) = dept.department_id (+);

-- ANSI SQL
SELECT first_name,
    emp.department_id,
    dept.department_id,
    department_name
FROM employees emp FULL OUTER JOIN departments dept
                        ON emp.department_id = dept.department_id;
                        
-- JOIN 연습
-- 부서 ID, 부서명, 속한 도시명, 국가명을 출력
SELECT department_id,
    department_name,
    city,
    country_name
FROM departments dept, locations loc JOIN countries co
                                ON loc.country_id = co.country_id
WHERE dept.location_id = loc.location_id
ORDER BY dept.department_id asc;

-- OR

SELECT department_id,
    department_name,
    city,
    country_name
FROM departments dept,
    locations loc,
    countries co
WHERE dept.location_id = loc.location_id AND
    loc.country_id = co.country_id
ORDER BY department_id ASC;

----------
-- SELF JOIN
----------
-- 자기 자신과 JOIN
-- 한개 테이블을 두 번 이상 사용해야 하므로 반드시 alias 사용

SELECT * FROM employees;  -- 107명

-- 사원의 아이디, 사원 이름, 매니저 아이디, 매니저 이름
SELECT emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp JOIN employees man
                    ON emp.manager_id = man.employee_id; -- 106명

-- OR

SELECT emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id;

-- manager가 없는 사람?
SELECT * FROM employees
WHERE manager_id IS NULL;

-- manager가 없는 사람도 출력
SELECT emp.employee_id,
    emp.first_name,
    emp.manager_id,
    man.first_name
FROM employees emp, employees man
WHERE emp.manager_id = man.employee_id (+);

--------------------
-- AGGREGATION
--------------------
-- 여러 행을 입력으로 데이터를 집계하여 하나의 행으로 반환

-- COUNT : 갯수 세기
-- employees 테이블에 몇 개의 레코드가 있나?
SELECT COUNT(*) FROM employees; --  107

-- * 로 카운트 -> 모든 레코드의 수
-- 컬럼 명시 -> null값은 집계에서 제외
SELECT COUNT(commission_pct) FROM employees;

--  아래 쿼리와 동일
SELECT COUNT(*) FROM employees
WHERE commission_pct IS NOT NULL;

-- 합계: SUM
-- 사원들 급여 총합
SELECT SUM(salary) FROM employees;

-- 평균: AVG
-- 사원들 급여 평균
SELECT AVG(salary) FROM employees;

-- 집계 함수는 null을 집계에서 제외
-- 사원들이이 받는 커미션 비율의 평균치?
SELECT AVG(commission_pct) FROM employees;  --  22%

-- null을 0으로 치환하고 통계 다시 잡아 봅시다.
SELECT AVG(NVL(commission_pct, 0)) FROM employees;  --  7%
-- 집계함수 수행시 null(결측치) 값을 처리할 방식을 정책으로 결정하고 수행

-- 사원들이 받는 급여의 최솟값, 최댓값, 평균, 중앙값
SELECT MIN(salary), MAX(salary), AVG(salary), MEDIAN(salary)
FROM employees;

-- 흔히 범하는 오류
-- 부서별 평균 급여 산정
SELECT department_id, AVG(salary)
FROM employees; --  department_id는 단일 레코드로 집계되지 않으므로 오류

SELECT department_id, salary
FROM employees 
ORDER BY department_id;

-- 수정
--  그룹별 집계를 위해서는 GROUP BY 절을 이용
SELECT department_id, ROUND(AVG(salary), 2) "Average Salary"
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 집계 함수를 사용한 쿼리문의 SELECT 컬럼 목록에는
-- 그룹핑에 참여한 필드 or 집계 함수만 올 수 있다

-- HAVING 절
-- 평균 급여가 7000 이상인 부서만
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) >= 7000   -- WHERE 절은 GROUP BY 집계가 일어나기 이전에 조건 체크
GROUP BY department_id;

-- 집계 함수 실행 이전에 WHERE 절의 조건을 검사
-- 집계 함수 컬럼은 WHERE 절에서 사용할 수 없다
-- 집계 이후에 조건 검사는 HAVING 절으로 수행

-- 수정된 쿼리
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
    HAVING AVG(salary) >= 7000  --  집계 이후에 조건을 검사
ORDER BY department_id;

----------
-- 분석 함수

-- ROLLUP
-- GROUP BY 절과 함께 사용
-- 그룹핑된 결과에 대한 좀더 상세한 요약을 제공
-- 일종의 ITEM Total 기능 수행
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

-- ROLLUP으로 ITEM TOTAL도 출력
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id;

-- CUBE 
-- Cross Tab에 의한 Summary 함께 추출
-- ROLLUP 함수에 의해 제공되는 ITEM Total과 함께
-- Column Total 값을 함께 제공
SELECT department_id, job_id, SUM(salary)
FROM employees
GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;

-------------------
-- SUBQUERY
-------------------
-- 하나의 SQL 내부에서 다른 SQL를 포함하는 형태
-- 임시로 테이블 구성, 임시결과를 바탕으로 최종 쿼리를 수행

-- 사원들의 급여 중앙값보다 많은 급여를 받은 직원들
--  급여의 중간값?
--  중앙값보다 많이 받는 직원 추출 쿼리

-- 급여의 중간 값?
SELECT MEDIAN(salary) FROM employees;   -- 6200

-- 이 결과보다 많은 급여를 받는 직원 추출 쿼리
SELECT first_name, salary
FROM employees
WHERE salary > 6200
ORDER BY salary DESC;

-- 두 쿼리 합쳐 봅니다.
SELECT first_name, salary
FROM employees
WHERE salary > ( SELECT MEDIAN(salary) FROM employees )
ORDER BY salary DESC;

SELECT first_name, hire_date FROM employees;
-- 사원 중, Susan 보다 늦게 입사한 사원의 명단
-- 쿼리 1. 이름이 Susan인 사원의 입사일을 추출하는 쿼리
SELECT hire_date FROM employees
WHERE first_name = 'Susan'; -- 02/06/07

-- 쿼리 2. 입사일이 특정 일자보다 나중일 사원을 뽑는 쿼리
SELECT first_name, hire_date
FROM employees
WHERE hire_date > '02/06/07';

-- 두 쿼리 합치기
SELECT first_name, hire_date
FROM employees
WHERE hire_date > ( SELECT hire_date FROM employees WHERE first_name='Susan' );

-- 단일행 서브쿼리
-- 서브 쿼리의 결과 단일 행인 경우
-- 단일행 연산자 : =, >, >=, <, <=, <>

-- 급여를 가장 적게 받는 사원의 이름, 급여, 사원 번호
SELECT first_name, salary, employee_id
FROM employees
WHERE salary = ( SELECT MIN(salary) FROM employees );

-- 평균 급여보다 적게 받은 사원의 이름, 급여
SELECT first_name, salary
FROM employees
WHERE salary < ( SELECT AVG(salary) FROM employees );

-- 다중행 서브쿼리
-- 서브쿼리의 결과 레코드가 둘 이상인 것 -> 단순 비교 연산자 수행 불가
-- 집합 연산에 관련된 IN, ANY, ALL, EXSIST 등을 이용

-- 서브 쿼리로 사용할 쿼리
SELECT salary FROM employees WHERE department_id = 110;

SELECT first_name, salary
FROM employees
WHERE salary IN ( SELECT salary FROM employees
                    WHERE department_id = 110 );
-- IN ( 12008, 8300 ) -> salary = 12008 OR salary = 8300

SELECT first_name, salary
FROM employees
WHERE salary > ALL ( SELECT salary FROM employees
                    WHERE department_id = 110 );
-- > ALL(12008, 8300) -> salary > 12008 AND salary > 8300

SELECT first_name, salary
FROM employees
WHERE salary > ANY ( SELECT salary FROM employees
                    WHERE department_id = 110 );
-- > ANY(12008, 8300) -> salary > 12008 OR salary > 8300

-- Correlated Query 
-- 바깥쪽 쿼리(주쿼리)와 안쪽 쿼리(서브 쿼리)가 서로 연관된 쿼리
SELECT first_name, salary, department_id
FROM employees outer 
WHERE salary  > ( SELECT AVG(salary) FROM employees
                    WHERE department_id = outer.department_id );
-- 의미
-- 사원 목록을 뽑아 오는데
-- 자신이 속한 부서의 평균 급여보다 많이 받는 직원을 뽑아오자

-- 서브 쿼리 연습문제
-- 각 부서별로 최고 급여를 받는 사원의 목록 출력 (조건절 이용)
-- 쿼리 1번: 각 부서의 최고 급여 테이블을 뽑아 봅시다
SELECT department_id, MAX(salary)
FROM employees
GROUP BY department_id;

-- 쿼리 2번: 위 쿼리에서 나온 department_id, salary max 값을 비교
SELECT department_id, employee_id, first_name, salary
FROM employees
WHERE (department_id, salary) IN 
    (SELECT department_id, MAX(salary)
        FROM employees
        GROUP BY department_id)
ORDER BY department_id;

-- 각 부서별로 최고 급여를 받는 사원의 목록 출력 (테이블 조인)
SELECT emp.department_id, 
    emp.employee_id, 
    first_name,
    emp.salary
FROM employees emp, ( SELECT department_id, MAX(salary) salary
                        FROM employees
                        GROUP BY department_id ) sal
WHERE emp.department_id = sal.department_id AND
    emp.salary = sal.salary
ORDER BY emp.department_id;

----------
-- TOP-K Query
----------
-- rownum : 쿼리 질의 수행결과에 의한 가상의 컬럼 -> 쿼리 결과의 순서 반환

-- 2007년 입사자 중, 연봉 순위 5위까지 추출
SELECT rownum, first_name, salary
FROM (SELECT * FROM employees
        WHERE hire_date LIKE '07%'
        ORDER BY salary DESC)
WHERE rownum <= 5;

---------
-- 집합 연산
---------

SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date < '05/01/01'; -- 2005년 1월 1일 이전 입사자 (24)
SELECT first_name, salary, hire_date
FROM employees
WHERE salary > 12000; -- 12000 초과한 급여 받는 사원 (8)

-- 입사일이 '05/01/01'이전이고 급여 > 12000 -> 교집합
SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date < '05/01/01'  -- 2005년 1월 1일 이전 입사자 (24)
INTERSECT   --  교집합 연산
SELECT first_name, salary, hire_date
FROM employees
WHERE salary > 12000; -- 12000 초과한 급여 받는 사원 (8)

-- 입사일이 '05/01/01'이전 이거나 (OR) 급여 > 12000 -> 합집합
SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date < '05/01/01'  -- 2005년 1월 1일 이전 입사자 (24)
-- UNION   --  합집합 연산 (중복은 제거)
UNION ALL   -- 합집합 연산 (중복은 제거 안함)
SELECT first_name, salary, hire_date
FROM employees
WHERE salary > 12000 -- 12000 초과한 급여 받는 사원 (8)
ORDER BY first_name;

-- 입사일 '05/01/01'이전인 사원 중
-- 급여 > 12000 사원은 제거 -> 차집합
SELECT first_name, salary, hire_date
FROM employees
WHERE hire_date < '05/01/01'  -- 2005년 1월 1일 이전 입사자 (24)
MINUS -- 차집합
SELECT first_name, salary, hire_date
FROM employees
WHERE salary > 12000 -- 12000 초과한 급여 받는 사원 (8)
ORDER BY salary DESC;

----------
-- Rank 관련
----------
SELECT first_name, salary,
    RANK() OVER (ORDER BY salary DESC) as RANK, --  중복 순위는 건너 뛰고 출력
    DENSE_RANK() OVER (ORDER BY salary DESC) as "DENSE RANK",  --  중복 순위 관계 없이 바로 다음 순위 부여
    ROW_NUMBER() OVER (ORDER BY salary DESC) as "ROW NUMBER" -- RANK가 출력된 레코드 순서
FROM employees;

----------
-- 계층형 쿼리
----------
-- Oracle
-- 질의 결과를 Tree 형태의 구조로 출력
-- 현재 employeees 테이블을 이용, 조직도를 뽑아봅시다.
SELECT employee_id, first_name, manager_id
FROM employees;

SELECT level, employee_id, first_name, manager_id
FROM employees
START WITH manager_id IS NULL   --  ROOT 노드의 조건
CONNECT BY PRIOR employee_id = manager_id
ORDER BY level;

-- JOIN을 이용해서 manager 이름까지 확인
SELECT level, emp.employee_id, emp.first_name || ' ' || emp.last_name,
    emp.manager_id, man.employee_id, man.first_name || ' ' || man.last_name
FROM employees emp LEFT OUTER JOIN employees man
                        ON emp.manager_id = man.employee_id
START WITH emp.manager_id IS NULL
CONNECT BY PRIOR emp.employee_id = emp.manager_id
ORDER BY level;