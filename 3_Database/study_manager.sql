create database study_manager;
use study_manager;

create table subjects(
	subject_id int auto_increment primary key,
    subject_name varchar(50) unique not null,
    description varchar(200),
    created_at datetime default now()
);

create table tasks(
	task_id int auto_increment primary key,
    subject_id int not null,
    title varchar(100) not null,
    content text,
    priority varchar(10) default '보통',
    status varchar(10) default '대기',
    due_date date,
    created_at datetime,
    
    constraint fk_tasks_sub
    foreign key (subject_id) references subjects(subject_id)
    on delete cascade
);

CREATE TABLE study_plans(
	plan_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    plan_title VARCHAR(100) NOT NULL,
    plan_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    memo VARCHAR(200),
    created_at DATETIME,
    
    CONSTRAINT fk_plans_sub
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE CASCADE
);

CREATE TABLE study_logs(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    study_date DATE NOT NULL,
    study_time INT,
    content VARCHAR(300) NOT NULL,
    created_at DATETIME,
    
    CONSTRAINT fk_logs_sub
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
    ON DELETE CASCADE
);

CREATE TABLE task_memos(
	memo_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    memo VARCHAR(300) NOT NULL,
    created_at DATETIME,
    
    CONSTRAINT fk_memos_tasks
    FOREIGN KEY (task_id) REFERENCES tasks(task_id)
    ON DELETE CASCADE
);

DESC subjects;
DESC tasks;
DESC study_plans;
DESC study_logs;
DESC task_memos;

select * from subjects;