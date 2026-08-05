/*
	사용자 계정
	- 데이터베이스에 접속할 수 있는 로그인 계정
    - root 계정은 모든 권한을 가진 계정이기 때문에 실제 사용 시 위험할 수 있음
    - 프로젝트별로 계정을 따로 만들고, 필요한 권한만 부여하는 것이 일반적임
*/

-- create user '계정명'@'접속위치' identified by '비밀번호';
-- localhost : 같은 컴퓨터(내 컴퓨터)에서만 접속 > 외부에서 접근할 수 없음.
-- 'apple'@'%' : 어디서든 접속 가능.
-- 'apple'@'192.168.0.%' : 198.168.0.으로 시작하는 내부망에서만 접속이 가능
-- 'apple'@'192.168.0.10' : 특정 ip에서만 접속 가능 (해킹을 막기 위해)

create user 'apple'@'localhost' identified by '1111';


-- grant 권한종류 on 데이터베이스명/테이블명 to '계정명'@'접속위치';
-- all : 모든 일반 권한, select, insert, update, delete, create, drop, alger, index
-- ai.* : ai 데이터베이스 안의 모든 테이블 (특정 테이블만 원한 다면 * 대신 테이블 명으로 기입)
grant all on ai.* to 'apple'@'localhost';

show grants for 'apple'@'localhost';

create user 'banana'@'localhost' identified by '2222';
grant select on ai.* to 'banana'@'localhost';

create user 'orange'@'localhost' identified by '3333';
grant select, insert, update, delete on ai.* to 'orange'@'localhost';

-- 권한 회수
revoke delete on ai.* from 'orange'@'localhost';

-- 사용자 비밀번호 변경
alter user 'banana'@'localhost' identified by '1004';

-- 사용자 삭제
drop user 'banana'@'localhost';