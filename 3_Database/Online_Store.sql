CREATE DATABASE online_store;
USE online_store;

CREATE TABLE member(
	id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    regdate DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_header(
	id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    total_price INT NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL DEFAULT 'ready',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_order_header_member
    FOREIGN KEY (member_id) REFERENCES member(id)
    ON DELETE CASCADE
);

CREATE TABLE order_item(
	id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price INT NOT NULL,
    
    CONSTRAINT fk_order_item_order_header
    FOREIGN KEY (order_id) REFERENCES order_header(id)
    ON DELETE CASCADE,
    
    CONSTRAINT fk_order_item_product
    FOREIGN KEY (product_id) REFERENCES product(id)
    ON DELETE CASCADE
);

CREATE TABLE payment(
	id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    method VARCHAR(20) NOT NULL,
    paid_amount INT NOT NULL,
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_payment_order_header
    FOREIGN KEY (order_id) REFERENCES order_header(id)
    ON DELETE CASCADE
);

DESC member;
DESC product;
DESC order_header;
DESC order_item;
DESC payment;

select * from member;
insert into member (username, password, name, email) values ('apple', '1111', '김사과', 'apple@apple.com');
insert into member (username, password, name, email) values ('banana', '2222', '반하나', 'banana@banana.com');
insert into member (username, password, name, email) values ('orange', '3333', '오렌지', 'orange@orange.com');
insert into member (username, password, name, email) values ('melon', '4444', '이메론', 'melon@melon.com');

insert into product(name, price, stock)
values
('키보드', 50000, 10),
('마우스', 30000, 30),
('모니터', 250000, 20),
('노트북 거치대', 40000, 50),
('USB', 15000, 100),
('노트북', 1200000, 5),
('헤드셋', 90000, 15);
select * from product;
select * from order_header;
select * from order_item;
select * from payment;

