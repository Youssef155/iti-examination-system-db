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
--select data for specific student and all exams
	if (@exam = -1 and @student != -1)
	begin
		select SE.student_exam_id, S.student_name, E.exam_name, SE.start_time, SE.end_time, SE.obtained_marks, SE.status
		from student_exam SE, exam E, student S
		where SE.student_id = S.student_id and SE.exam_id = E.exam_id and SE.student_id = @student
	end
--select data for all students and specific exam
	else if (@exam != -1 and @student = -1)
	begin
		select SE.student_exam_id, S.student_name, E.exam_name, SE.start_time, SE.end_time, SE.obtained_marks, SE.status
		from student_exam SE, exam E, student S
		where SE.student_id = S.student_id and SE.exam_id = E.exam_id and SE.exam_id = @exam
	end
--select data for specific student and specific exam
	else if (@exam != -1 and @student != -1)
	begin
		select SE.student_exam_id, S.student_name, E.exam_name, SE.start_time, SE.end_time, SE.obtained_marks, SE.status
		from student_exam SE, exam E, student S
		where SE.student_id = S.student_id and SE.exam_id = E.exam_id and SE.student_id = @student and SE.exam_id = @exam
	end
--select data for all students and all exams
	else 
	begin
		select SE.student_exam_id, S.student_name, E.exam_name, SE.start_time, SE.end_time, SE.obtained_marks, SE.status
		from student_exam SE, exam E, student S
		where SE.student_id = S.student_id and SE.exam_id = E.exam_id
	end
go


create or alter proc sp_insert_student_exam @exam int , @student int 
as
	insert into student_exam(student_id, exam_id)
	values (@student, @exam)
go

create or alter proc sp_update_student_exam 
@exam int = -1, 
@current_student int = -1, 
@mark int = -1 , 
@status nvarchar(20) = '', 
@new_student int = -1,
@mark_change int = 0
as
--update all the data for specific student and specific exam
	if(@exam != -1 and @current_student != -1 )
	begin
		update student_exam
		set student_id = (case when @new_student != -1 then @new_student else student_id end),
			end_time = (case when end_time is null then GETDATE() else end_time end),
			obtained_marks = (case when @mark = -1 then @mark else obtained_marks + @mark_change end),
			status = (case when @status != '' then @status else status end)
		where exam_id = @exam and student_id = @current_student
	end
--update obtained marks for specific exam and all students 
	else if(@exam != -1 and @current_student = -1 and (@mark != -1 or @mark_change != 0))
	begin
		update student_exam
		set obtained_marks = (case when @mark != -1 then @mark else obtained_marks + @mark_change  end)
		where exam_id = @exam
	end
--update obtained marks for all exams and specific student
	else if(@exam = -1 and @current_student != -1 and (@mark != -1 or @mark_change != 0))
	begin
		update student_exam
		set obtained_marks = (case when @mark != -1 then @mark else obtained_marks + @mark_change  end)
		where student_id = @current_student
	end
go

create or alter proc sp_delete_student_exam @exam int = -1, @student int = -1
as
--delete data of all exams for specific student
	if (@exam = -1 and @student != -1)
	begin
		delete from student_exam
		where student_id = @student
	end
--delete data of all exams for specific student
	else if (@exam != -1 and @student = -1)
	begin
		delete from student_exam 
		where exam_id = @exam
	end
--delete data of specific exam for specific student
	else if (@exam != -1 and @student != -1)
	begin
		delete from student_exam
		where exam_id = @exam and student_id = @student
	end
--delete data of the whole table
	else
	begin
		delete from student_exam
	end
go

