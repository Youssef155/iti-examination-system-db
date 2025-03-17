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

create procedure Insert_instructor
@instructor_name nvarchar(100),
@email nvarchar(100),
@specialization nvarchar(100),
@branch int
as
	begin
		insert into INSTRUCTOR(instructor_name, email, specialization, branch_id)
		values(@instructor_name, @email, @specialization, @branch)
	end;