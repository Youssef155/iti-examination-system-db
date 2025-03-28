-- 5. Create the TRACK_COURSE junction table (depends on TRACK and COURSE)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TRACK_COURSE')
CREATE TABLE TRACK_COURSE (
    track_id INT,
    course_id INT,
    PRIMARY KEY (track_id, course_id),
    FOREIGN KEY (track_id) REFERENCES TRACK(track_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

create procedure insert_trackCourse
@track_id int,
@course_id int
as
	begin
		insert into TRACK_COURSE
		values (@track_id, @course_id)
	end;

create procedure update_trackCourse
@old_track_id int,
@old_course_id int,
@track_id int,
@course_id int
as
	begin
		update TRACK_COURSE
		set track_id =coalesce( @track_id, track_id),
		course_id =coalesce( @course_id, course_id)
		where track_id = @old_track_id and course_id = @old_course_id
	end;

create procedure delete_Track_Course
@old_track_id int,
@old_course_id int
as
	begin
		delete from TRACK_COURSE
		where track_id = @old_track_id and course_id = @old_course_id
	end;