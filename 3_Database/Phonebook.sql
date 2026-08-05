create database pb;
use pb;

create table member(
	idx int auto_increment primary key,
    name varchar(20) not null,
    phone varchar(20) not null,
    address varchar(300)
    );

select * from member;
    