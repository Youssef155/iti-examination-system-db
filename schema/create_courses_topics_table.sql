-- 4. Create the courses_topics table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'courses_topics')
CREATE TABLE courses_topics (
    course_topic_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT NOT NULL,
    topic_name VARCHAR(50) NOT NULL,
    constraint f_key foreign key(course_id) references courses(course_id)
	on delete cascade 
	on update cascade
);
go

create or alter proc sp_select_course_topic @course varchar(50)
as
	select C.course_name, CT.topic_name
	from course C, courses_topics CT
	where C.course_id = CT.course_id and C.course_name = @course
go

create or alter proc sp_insert_course_topic_by_course_name @course varchar(50), @topic varchar(50)
as
	insert into courses_topics
	select C.course_id, @topic
	from courses C
	where C.course_name = @course
go

create or alter proc update_course_topic @course varchar(50), @old_topic varchar(50), @new_topic varchar(50)
as
	update courses_topics
	set topic_name = @new_topic
	from  courses_topics CT, courses C
	where C.course_id = CT.course_id and C.course_name = @course and CT.topic_name = @old_topic
go

create or alter proc delete_course_topic @course varchar(50), @topic varchar(50)
as
	delete from courses_topics
	from courses_topics CT, course C
	where CT.course_id = C.course_id and C.course_name = @course and CT.topic_name = @topic
go

