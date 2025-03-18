--  Create the STUDENT_ANSWER table (depends on STUDENT and EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'student_answer')  
CREATE TABLE student_answer (
    student_answer_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT not null,	
    exam_id INT not null,
    question_id INT not null,
    answer_id INT,
    is_true BIT DEFAULT 0,
    FOREIGN KEY (student_id, exam_id) REFERENCES student_exam(student_id, exam_id)
	on delete cascade
	on update cascade,
	FOREIGN KEY (question_id, answer_id) REFERENCES exam_question(question_id, answer_id)
	on delete cascade
	on update cascade,
);
go

create or alter proc sp_select_student_answer @exam int, @student int = -1
as
--select data for specific exam for specific student
	if (@student != -1)
	begin
		select S.student_name, E.exam_name, Q.question_text, MA.answer_text , (case when is_true = 1 then 'correct' else 'wrong' end)
		from student_answer SA inner join student_exam SE on SA.student_id = SE.student_id and SA.exam_id = SE.exam_id
		inner join student S on SE.student_id = S.student_id
		inner join exam E on SE.exam_id = E.exam_id
		inner join exam_question EQ on SA.question_id = EQ.question_id and SA.answer_id = EQ.answer_id
		inner join question Q on EQ.question_id = Q.question_id
		inner join model_answer MA on Q.question_id = MA.question_id and EQ.answer_id = MA.answer_id
		where SA.exam_id = @exam and SA.student_id = @student
	end
-- select data for specific exam for all students
	else if (@student = -1)
	begin
		select S.student_name, E.exam_name, Q.question_text, MA.answer_text , (case when is_true = 1 then 'correct' else 'wrong' end)
		from student_answer SA inner join student_exam SE on SA.student_id = SE.student_id and SA.exam_id = SE.exam_id
		inner join student S on SE.student_id = S.student_id
		inner join exam E on SE.exam_id = E.exam_id
		inner join exam_question EQ on SA.question_id = EQ.question_id and SA.answer_id = EQ.answer_id
		inner join question Q on EQ.question_id = Q.question_id
		inner join model_answer MA on Q.question_id = MA.question_id and EQ.answer_id = MA.answer_id
		where SA.exam_id = @exam
	end
go



create or alter proc sp_insert_student_answer @exam int , @student int, @question_id int, @answer_id int = null
as
	insert into student_answer(student_id, exam_id, question_id, answer_id)
	values (@student, @exam, @question_id, @answer_id)
go


create or alter proc sp_update_student_answer @student int,  @exam int, @question int = -1, @answer int = -1
as
-- update answer for specific question and specific student in specific exam
	if(@question != -1 and @answer != -1)
	begin
		update student_answer
		set answer_id = @answer
	end
--update student id in specific exam
	else
	begin
		update student_answer
		set student_id = @student
	end
go
 
create or alter proc sp_delete_student_answer @exam int = -1, @student int = -1, @question int = -1
as
--delete data for all exams and specific student
	if (@exam = -1 and @student != -1)
	begin
		delete from student_answer
		where student_id = @student
	end
--delete data for specific exam and all students
	else if (@exam != -1 and @student = -1)
	begin
		delete from student_answer 
		where exam_id = @exam
	end
--delete data for specific exam and specific student
	else if (@exam != -1 and @student != -1 and @question = -1)
	begin
		delete from student_answer
		where exam_id = @exam and student_id = @student
	end
-- delete data for specific question and specific exam for specific student
	else if (@exam != -1 and @student != -1 and @question != -1)
	begin
		delete from student_answer
		where exam_id = @exam and student_id = @student and question_id = @question
	end
-- delete data for specific question and specific exam for all students
	else if (@exam != -1 and @student = -1 and @question != -1)
	begin
		delete from student_answer
		where exam_id = @exam and question_id = @question
	end
go

