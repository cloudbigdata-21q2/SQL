--------------------
-- DB OBJECTS
--------------------

-- SYSTEM 계정 CREATE VIEW 권한 부여
GRANT CREATE VIEW TO c##namsk;
-- 사용자 계정으로 복귀

-- SimpleView
-- 단일 테이블, 함수나 연산식을 포함한 컬럼이 없는 단순 뷰
DROP TABLE emp123;
CREATE TABLE emp123
    AS SELECT * FROM hr.employees
        WHERE department_id IN (10, 20, 30);
SELECT * FROM emp123;

-- emp123 테이블을 기반으로 30 번 부서 사람들만 보여주는 View 생성
CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp123
        WHERE department_id = 10;

DESC emp10;

-- View는 테이블처럼 SELECT 할 수 있다
-- 다만 실제 데이터는 원본 테이블 내에 있는 데이터 활용
SELECT * FROM emp10;
SELECT first_name || ' ' || last_name, salary FROM emp10;

-- Simple View는 제약 사항에 위배되지 않는다면 내용을 갱신할 수 있다
-- salary를 2배로 올려봅시다
SELECT first_name, salary FROM emp10;

UPDATE emp10 SET salary = salary * 2;
SELECT first_name, salary FROM emp10;
SELECT first_name, salary FROM emp123;
ROLLBACK;

-- VIEW는 가급적 조회용으로만 사용하도록 하자
-- READ ONLY 옵션 부여 View 생성
CREATE OR REPLACE VIEW emp10
    AS SELECT employee_id, first_name, last_name, salary
        FROM emp123
        WHERE department_id=10
    WITH READ ONLY;
    
SELECT * FROM emp10;

UPDATE emp10 SET salary=salary * 2; -- 읽기 전용 뷰에서는 DML 수행 불가

-- 복합 뷰
DESC author;
DESC book;
-- author와 book을 join 정보를 출력하는 복합 뷰
CREATE OR REPLACE VIEW book_detail
    (bood_id, title, author_name, pub_date)
    AS SELECT book_id,
                title,
                author_name,
                pub_date
        FROM book b, author a
        WHERE b.author_id = a.author_id;
        
DESC book_detail;

SELECT * FROM book_detail;

UPDATE book_detail SET author_name='Unknown';
-- 복합 뷰에서는 기본적으로 DML 수행할 수 없다

-- VIEW 확인을 위한 DICTIONARY
SELECT * FROM USER_VIEWS;
-- 특정 View의 정보 확인을 위해 WHERE 절에 VIEW_NAME을 지정하면 된다
SELECT view_name, text FROM USER_VIEWS
WHERE view_name='BOOK_DETAIL';

-- USER_OBJECTS 테이블을 이용한 확인
SELECT * FROM USER_OBJECTS
WHERE object_type='VIEW';

-- VIEW의 삭제
DROP VIEW book_detail;
SELECT * FROM USER_VIEWS;

-- INDEX : 검색 속도 개선을 위한 데이터베이스 객체
-- hr.employees의 테이블을 기반으로 s_emp 생성
CREATE TABLE s_emp
    AS SELECT * FROM hr.employees;
    
-- s_emp 테이블의 employee_id 컬럼에 UNIQUE INDEX를 생성
SELECT * FROM s_emp;
CREATE UNIQUE INDEX s_emp_id_pk
    ON s_emp (employee_id); --  s_emp 테이블의 employee_id 컬럼에 UNIQUE INDEX를 부여
    
-- 사용자가 가지고 있는 인덱스를 확인
SELECT * FROM USER_INDEXES;
-- 어느 컬럼에 인덱스가 걸려 있는지 확인
SELECT * FROM USER_IND_COLUMNS;
-- 두 테이블 조인, 어느 인덱스가 어느 컬럼에 걸려 있는지 확인
SELECT t.index_name, 
    t.table_name, 
    c.column_name, 
    c.column_position
FROM USER_INDEXES t, USER_IND_COLUMNS c
WHERE t.index_name = c.index_name AND
    t.table_name = 'S_EMP';
    
-- INDEX는
-- WHERE절, JOIN 절에서 빈번하게 사용되는 컬럼
-- 자주 업데이트 되는 테이블의 경우, 인덱스 계속 갱신해야 함
--  -> 인덱스가 DB 성능을 저하시킬 수도 있다
-- 꼭 필요한 컬럼에만 인덱스 부여 권장

-- 인덱스의 제거
DROP INDEX s_emp_id_pk;
SELECT * FROM USER_INDEXES;

-- SEQUENCE
-- author 테이블에 새 레코드 삽입
DESC author;
SELECT * FROM author;

-- author.author_id max 확인
SELECT MAX(author_id) FROM author;

-- 새로운 author 추가
INSERT INTO author(author_id, author_name)
    VALUES( (SELECT MAX(author_id) + 1 FROM author), 'Unknown');
SELECT * FROM author;

-- 유일한 PK를 확보해야 할 경우, 위 방법은 안전하지 않을 수 있다
-- SEQUENCE를 이용, 유일한 정수 값을 확보

ROLLBACK;

-- 시퀀스 생성
SELECT MAX(author_id) + 1 FROM author;

CREATE SEQUENCE seq_author_id
    START WITH 3
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 100000000
    NOCACHE;
    
-- 시퀀스 이용한 PK의 부여
INSERT INTO author (author_id, author_name)
VALUES (seq_author_id.NEXTVAL, 'Steven King');

SELECT * FROM author;
COMMIT;

-- 새 시퀀스 하나 생성
CREATE SEQUENCE my_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10
    NOCACHE;
    
--  새 시퀀스 생성
SELECT my_seq.NEXTVAL FROM dual;    --  시퀀스 증가시키고 반환
SELECT my_seq.CURRVAL FROM dual;    --  시퀀스의 현재 값

--  시퀀스 수정
ALTER SEQUENCE my_seq
    INCREMENT BY 2
    MAXVALUE 1000000;
    
SELECT my_seq.CURRVAL FROM dual;
SELECT my_seq.NEXTVAL FROM dual;

-- 시퀀스를 위한 딕셔너리
SELECT * FROM USER_SEQUENCES;

SELECT * FROM USER_OBJECTS WHERE object_type='SEQUENCE';

-- book_id를 위한 시퀀스도 추가해 봅시다
SELECT MAX(book_id) FROM book;

CREATE SEQUENCE seq_book_id
    START WITH 3
    MINVALUE 1
    INCREMENT BY 1
    MAXVALUE 1000000;
    
SELECT * FROM USER_SEQUENCES;