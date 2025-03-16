-- 13. Create the STUDENT_EXAM table (depends on STUDENT and EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'student_exam')  
CREATE TABLE student_exam (
    student_exam_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT,
    exam_id INT,
    start_time DATETIME default getdate(),
    end_time DATETIME,
    obtained_marks INT DEFAULT 0,
    status NVARCHAR(20) DEFAULT 'ONGOING',
    FOREIGN KEY (student_id) REFERENCES student(student_id)
	on delete cascade
	on update cascade,
    FOREIGN KEY (exam_id) REFERENCES exam(exam_id)
	on delete cascade
	on update cascade
);
go

create or alter proc sp_select_student_exam @exam int = -1, @student int = -1
as
	if (@exam = -1 and @student != -1)
	begin
		select *
		from student_exam
		where student_id = @student
	end
	else if (@exam != -1 and @student = -1)
	begin
		select *
		from student_exam 
		where exam_id = @exam
	end
	else if (@exam != -1 and @student != -1)
	begin
		select *
		from student_exam
		where exam_id = @exam and student_id = @student
	end
go

create or alter proc sp_insert_student_exam @exam int , @student int 
as
	insert into student_exam
	values (@student, @exam)
go

/*
update sp
*/

create or alter proc sp_delete_student_exam @exam int = -1, @student int = -1
as
	if (@exam = -1 and @student != -1)
	begin
		delete from student_exam
		where student_id = @student
	end
	else if (@exam != -1 and @student = -1)
	begin
		delete from student_exam 
		where exam_id = @exam
	end
	else if (@exam != -1 and @student != -1)
	begin
		delete from student_exam
		where exam_id = @exam and student_id = @student
	end
go

