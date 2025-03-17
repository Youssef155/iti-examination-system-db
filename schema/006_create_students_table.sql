-- 6. Create the STUDENT table (depends on TRACK)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'STUDENT')
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY IDENTITY(1,1),
    student_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    track_id INT,
    FOREIGN KEY (track_id) REFERENCES TRACK(track_id)
);

alter procedure insert_student
@name nvarchar(100),
@email  nvarchar(100),
@phone  nvarchar(20),
@track_id int
as
	begin 
		insert into STUDENT(student_name, email, phone, track_id)
		values(@name, coalesce(@email, 'NA'), @phone, @track_id)
	end;

alter procedure update_Student
@id int,
@name nvarchar(100),
@email  nvarchar(100),
@phone  nvarchar(20),
@track_id int
as
	begin
		update STUDENT
		set 
		student_name =coalesce( @name, student_name),
		email =coalesce( @email, email),
		phone =coalesce( @phone, phone),
		track_id =coalesce( @track_id, track_id)
		where student_id = @id
	end;

create procedure delete_student
@id int

as
	begin
		delete STUDENT
		where student_id = @id
	end;

create or alter procedure select_student
@student_id int = null
as
	begin
		if @student_id != null
		begin
			select * from STUDENT where student_id = @student_id
		end
		else
		begin
			select * from STUDENT
		end
	end;