IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Exam_Question') 
create table Exam_Question(
	question_id int,
	Exam_id int,
	Mark int,
	primary key (question_id, Exam_id),
	foreign key (question_id) references Question(question_id),
	foreign key (Exam_id) references Exam(exam_id)
);
