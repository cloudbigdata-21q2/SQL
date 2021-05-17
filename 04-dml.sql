--------------------
-- CUD (Create, Update, Delete)
--------------------

DESC author;

-- INSERT: 테이블에 새 데이터 추가
-- 데이터를 넣을 컬럼을 지정하지 않으면 전체 데이터를 제공
-- 테이블 정의시 지정한 순서대로 INSERT
INSERT INTO author
VALUES(1, '박경리', '토지 작가');

-- 특정 컬럼의 내용만 입력할 때는 컬럼의 목록 지정
INSERT INTO author (author_id, author_name)
VALUES(2, '김영하');

SELECT * FROM author;

COMMIT; --  변경 사항 커밋

INSERT INTO author (author_id, author_name)
VALUES(3, '스티븐 킹');

SAVEPOINT a;
SELECT * FROM author;

INSERT INTO author (author_id, author_name)
VALUES(4, '톨스토이');

SELECT * FROM author;
ROLLBACK TO a;  --   Savepoint a로 복구
SELECT * FROM author;

ROLLBACK;   --  트랜잭션 시작 위치로 복구
SELECT * FROM author;

DESC book;
INSERT INTO book 
VALUES(1, '토지', sysdate, 1);

INSERT INTO book (book_id, title, author_id)
VALUES(2, '살인자의 기억법', 2);

--  무결성 제약 조건을 위반한 레코드는 삽입되지 않는다.
INSERT INTO book (book_id, title, author_id)
VALUES(3, '쇼생크 탈출', 3);

SELECT * FROM book;