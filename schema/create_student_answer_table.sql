-- 13. Create the STUDENT_EXAM table (depends on STUDENT and EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'student_answer')  
CREATE TABLE student_answer (
    student_answer_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT,
    exam_id INT,
    question_id INT,
    answer_id INT,
    is_true BIT DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES student(student_id)
	on delete cascade
	on update cascade,
    FOREIGN KEY (exam_id) REFERENCES exam(exam_id)
	on delete cascade
	on update cascade,
	FOREIGN KEY (question_id, answer_id) REFERENCES exam_question(question_id, answer_id)
	on delete cascade
	on update cascade,
);
go

create or alter proc sp_select_student_answer @exam int = -1, @student int = -1
as
	if (@exam = -1 and @student != -1)
	begin
		select *
		from student_answer
		where student_id = @student
	end
	else if (@exam != -1 and @student = -1)
	begin
		select *
		from student_answer 
		where exam_id = @exam
	end
	else if (@exam != -1 and @student != -1)
	begin
		select *
		from student_answer
		where exam_id = @exam and student_id = @student
	end
go

create or alter proc sp_insert_student_answer @exam int , @student int, @question_id int, @answer_id int = null
as
	insert into student_answer
	values (@student, @exam, @question_id, @answer_id)
go

/*
update sp
*/

--not finished
create or alter proc sp_delete_student_answer @exam int = -1, @student int = -1
as
	if (@exam = -1 and @student != -1)
	begin
		delete from student_answer
		where student_id = @student
	end
	else if (@exam != -1 and @student = -1)
	begin
		delete from student_answer 
		where exam_id = @exam
	end
	else if (@exam != -1 and @student != -1)
	begin
		delete from student_answer
		where exam_id = @exam and student_id = @student
	end
go

