-- 11. Create the QUESTION table (depends on EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QUESTION')
CREATE TABLE QUESTION (
    question_id INT PRIMARY KEY IDENTITY(1,1),
    question_text NVARCHAR(MAX) NOT NULL,
    marks INT NOT NULL,
	course_ID int,
    question_type NVARCHAR(10) CHECK (question_type IN ('MCQ', 'TRUE_FALSE')) NOT NULL,
	FOREIGN KEY (course_ID) REFERENCES Course(course_id)
);


create table exam(
	exam_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT,
    exam_name NVARCHAR(100) NOT NULL,
    exam_date DATE NOT NULL,
    duration INT NOT NULL,
    total_marks INT NOT NULL,
    status NVARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);


create table Exam_Question(
	question_id int,
	Exam_id int,
	Mark int,
	primary key (question_id, Exam_id),
	foreign key (question_id) references Question(question_id),
	foreign key (Exam_id) references Exam(exam_id)
);

create table MCQ(
	MCQ_id int,
	Question_id int,
	MCQ_Question_Text Nvarchar(max) not null,
	IS_MCQ_Correct boolean 
);