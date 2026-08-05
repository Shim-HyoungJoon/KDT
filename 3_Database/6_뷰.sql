/*
	뷰(view)
    - select 문을 저장해둔 가상의 테이블
		create view 뷰이름 as select문
    - view를 사용하는 이유
		1. 복잡한 SQL을 단순화 *
        2. 재사용(자주 쓰는 조회 저장)
        3. 가독성(SQL을 보기 쉽게 구성)
        4. 보안(특정 컬럼만 공개) * -> view로 전달하게되면 개발자는 전체 테이블에대한 정보를 알 수 없다.
	- 데이터를 직접 저장하지 않음(원본 테이블의 select 결과를 보여주는 가상 테이블)
    - member 테이블 데이터 변경 -> view 결과도 같이 변경
*/

create view vip_member as select userid, name, point from member where point >= 100;
select * from vip_member;

-- view는 select처럼 사용 가능
select * from vip_member where point >= 150;

-- 회원 주소 view(member_address) userid, name, address1 + address2 + address3 as addresss
select concat(address1, ' ' , address2, ' ', address3) as address from member;
create view member_address as select userid, name, concat(address1, ' ' , address2, ' ', address3) as address from member;
select * from member_address;

-- view 수정 (덮어쓰기)
create or replace view vip_member as
select userid, name, point, email from member where point >= 100;
select * from vip_member;

-- view 삭제
drop view vip_member;

-- view 구조 확인
show create view vip_member;

-- view 목록 확인
show full tables where table_type='VIEW';

select * from orders;
select m.userid, m.name, o.product_name, o.price, o.order_date from member m
join orders o on m.idx = o.member_idx;

create view member_order as
select m.userid, m.name, o.product_name, o.price, o.order_date from member m
join orders o on m.idx = o.member_idx;

select * from member_order;