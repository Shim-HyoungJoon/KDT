/*
	정규화(Normalization)
    - 데이터베이스 테이블을 효율적으로 구조화하는 작업
    - 중복 데이터를 줄이고, 데이터가 꼬이지 않게 테이블을 나누는 과정
    - 데이터 무결성 유지, 유지보수 편리성 증가
    
    정규화 단계
    1. 제1정규형(1NF)
		- 하나의 칸에는 하나의 값만 들어가야 함
        예) 수강과목이라는 칸 하나에 MySQL, Python 이라고 입력하면 안됨.
    2. 제2정규형(2NF)
		- 1NF 만족
        - 기본키 전체에 완전 종속되어야 함
    3. 제3정규형(3NF)
		- 2NF 만족
        - 이행적 종속 제거
	* 이행적 종속
		학번 -> 학과번호
        학과번호 -> 학과명
        학번 -> 학과명 : 간접 연결을 이행적 종속이라고 함
*/

student    -- 학생
professor  -- 교수
course     -- 과목
enroll     -- 수강

CREATE TABLE student(
    student_id INT,
    student_name VARCHAR(50)
    professor_id int,
    foreign key (professor_id refer)
);

CREATE TABLE professor(
    idx int not null
    professor_name VARCHAR(50),
    professor_phone VARCHAR(20)
    forign key(idx) references member(idx)                                                                                                                                                                                                                                                                                                   
);

CREATE TABlE course(
	course_id int primary key,
    course_name VARCHAR(50)
    professor_id int,
    foreign key (professor_id) references professor(professor_id)
);

CREATE TABLE enroll(
		student_id int,
        course_id int
        foreign key(student_id) references student(student_id),
        foreign key(course_id) references course(course_id);
		primary key(coudse_id)
);

create table profile(
	idx int not null,
    height double,
    weight double,
    mbti varchar(10),
    foreign key(idx) references member(idx)
);

select * from profile;
insert into profile values(1, 160, 50, 'ISTJ');
insert into profile values(3, 170, 70, 'ESTP');
insert into profile values(4, 175, 80, 'ENFP');
insert into profile values(6, 175, 80, 'ENFJ');
-- insert into profile values (7, 175, 80, 'ENFJ'); 외래키 제약조건 위배

-- idx, userid, name, gender, mbti
select idx, userid, name, gender, mbti from member inner join profile on member.idx = profile.idx;
select m.idx, m.userid, m.name, m.gender, p.mbti from member as m inner join profile as p on m.idx = p.idx;
select m.idx, m.userid, m.name, m.gender, p.mbti from member as m left join profile as p on m.idx = p.idx;
select m.idx, m.userid, m.name, m.gender, p.mbti from member as m right join profile as p on m.idx = p.idx;
select userid, name, gender, mbti from member cross join profile;