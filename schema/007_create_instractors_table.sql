-- 7. Create the INSTRUCTOR table (depends on BRANCH)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INSTRUCTOR')
CREATE TABLE INSTRUCTOR (
    instructor_id INT PRIMARY KEY IDENTITY(1,1),
    instructor_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    specialization NVARCHAR(100),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);

alter procedure Insert_instructor
@instructor_name nvarchar(100),
@email nvarchar(100),
@specialization nvarchar(100),
@branch int
as
	begin
		insert into INSTRUCTOR(instructor_name, email, specialization, branch_id)
		values(@instructor_name, @email, coalesce(@specialization, 'NA'), @branch)
	end;

alter procedure update_instructor
@instructor_id int,
@instructor_name nvarchar(100),
@email nvarchar(100),
@specialization nvarchar(100),
@branch int
as
	begin
		update INSTRUCTOR
		set 
		instructor_name = coalesce(@instructor_name, instructor_name),
		email = coalesce(@email, email),
		specialization = coalesce(@specialization, specialization),
		branch_id = coalesce(@branch, branch_id)
		where instructor_id = @instructor_id
	end;

alter procedure delete_instructor
@instructor_id int
as
	begin
		delete from INSTRUCTOR
		where instructor_id = @instructor_id
	end;

create or alter procedure select_instructor
@instructor_id int = null
as
	begin
		if @instructor_id != null
		begin
			select * from INSTRUCTOR where instructor_id = @instructor_id
		end
		else
		begin
			select * from INSTRUCTOR
		end
	end;