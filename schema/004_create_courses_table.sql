-- 4. Create the COURSE table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'COURSE')
CREATE TABLE COURSE (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    course_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    credit_hours INT NOT NULL
);

alter procedure Update_Course
@course_id int,
@course_name nvarchar(100),
@description nvarchar(max),
@credit_hours int
as
	begin
		update COURSE
			set course_name = coalesce(@course_name, course_name),
			description =coalesce( @description, description),
			credit_hours =coalesce( @credit_hours, credit_hours)
			where 
				course_id = @course_id;
	end;

alter procedure Insert_Course
@course_name nvarchar(100),
@description nvarchar(max),
@credit_hours int
as
	begin
		insert into COURSE(@course_name, @description, @credit_hours)
		values(@course_name,coalesce( @description, 'NA'), @credit_hours)
	end;

create procedure Delete_Course
@course_id int
	as
		begin 
			delete from COURSE
			where course_id = @course_id
	end;