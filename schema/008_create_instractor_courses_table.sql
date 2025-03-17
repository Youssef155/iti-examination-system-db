-- 8. Create the INSTRUCTOR_COURSE junction table (depends on INSTRUCTOR, COURSE and BRANCH)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INSTRUCTOR_COURSE') 
CREATE TABLE INSTRUCTOR_COURSE (
    instructor_id INT,
    course_id INT,
    branch_id INT,
    PRIMARY KEY (instructor_id, course_id),
    FOREIGN KEY (instructor_id) REFERENCES INSTRUCTOR(instructor_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);

create procedure insert_instructorCourse
@instructor_id int,
@course_id int,
@branch_id int
as
	begin
		insert into INSTRUCTOR_COURSE
		values (@instructor_id, @course_id, @branch_id)
	end;

create procedure update_instructorCourse
@old_instructor_id int,
@old_course_id int,
@old_branch_id int,
@instructor_id int,
@course_id int,
@branch_id int
as
	begin
		update INSTRUCTOR_COURSE
		set instructor_id = coalesce(@instructor_id, instructor_id),
		course_id = coalesce(@course_id,course_id),
		branch_id = coalesce (@branch_id,branch_id)
		where instructor_id = @old_instructor_id and course_id = @old_course_id and branch_id = @old_branch_id
	end;

create procedure delete_instructorCourse
@instructor_id int,
@course_id int,
@branch_id int
as
	begin
		delete from INSTRUCTOR_COURSE
		where instructor_id = @instructor_id and course_id = @course_id and branch_id = @branch_id
		end;

create or alter procedure select_instructorCourse
@instructor_id int = null,
@course_id int= null,
@branch_id int= null
as
	begin
		if(@instructor_id != null or @course_id != null or @branch_id!= null)
		begin
		select * from INSTRUCTOR_COURSE
		where instructor_id = @instructor_id and course_id = @course_id and branch_id = @branch_id
		end
		else 
		select * from INSTRUCTOR_COURSE
	end;