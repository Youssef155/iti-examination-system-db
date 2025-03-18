-- 10. Create the EXAM table (depends on COURSE)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EXAM') 
create table exam(
	exam_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT,
    exam_name NVARCHAR(100) NOT NULL,
    exam_date DATE NOT NULL,
    duration INT NOT NULL,
    total_marks INT NOT NULL,
    status NVARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);


---- inserting 
create procedure insertexam
    @course_id int,
    @exam_name nvarchar(100),
    @exam_date date,
    @duration int,
    @total_marks int = 100,
    @status nvarchar(20) = 'pending'
as
begin
    if not exists (select 1 from course where course_id = @course_id)
    begin
        print 'error: course does not exist.';
        return;
    end;
    if @exam_date < getdate()  -- check if the date in the future
    begin
        print 'error: exam date must be in the future.';
        return;
    end;
    if @duration <= 0 -- check if duration is positive
    begin
        print 'error: duration must be greater than 0.';
        return;
    end;
    if @total_marks <= 0  -- check if total marks is positive
    begin
        print 'error: total marks must be greater than 0.';
        return;
    end;
    if @status not in ('pending', 'completed', 'cancelled')  -- check if the status is valid
    begin
        print 'error: invalid status. must be pending, completed, or cancelled.';
        return;
    end;
    -- insert the exam
    insert into exam (course_id, exam_name, exam_date, duration, total_marks, status)
    values (@course_id, @exam_name, @exam_date, @duration, @total_marks, @status);

    print 'exam inserted successfully.';
end;

---- reading
create procedure readexam @exam_id int = null, @course_id int = null, @status nvarchar(20) = null
as
begin
    select exam_id, course_id, exam_name, exam_date, duration, total_marks, status
    from exam
    where (@exam_id is null or exam_id = @exam_id) and (@course_id is null or course_id = @course_id) and(@status is null or status = @status);
end;


---- update 
create procedure updateexam
    @exam_id int,
    @course_id int = null,
    @exam_name nvarchar(100) = null,
    @exam_date date = null,
    @duration int = null,
    @total_marks int = null,
    @status nvarchar(20) = null
as
begin
    if not exists (select 1 from exam where exam_id = @exam_id)
    begin
        print 'error: exam does not exist.';
        return;
    end;

    if @course_id is not null and not exists (select 1 from course where course_id = @course_id)
    begin
        print 'error: course does not exist.';
        return;
    end;

    if @exam_date is not null and @exam_date < getdate()
    begin
        print 'error: exam date must be in the future.';
        return;
    end;

    if @duration is not null and @duration <= 0
    begin
        print 'error: duration must be greater than 0.';
        return;
    end;

    if @total_marks is not null and @total_marks <= 0
    begin
        print 'error: total marks must be greater than 0.';
        return;
    end;

    if @status is not null and @status not in ('pending', 'completed', 'cancelled')
    begin
        print 'error: invalid status. must be pending, completed, or cancelled.';
        return;
    end;


    update exam
    set
        course_id = isnull(@course_id, course_id),
        exam_name = isnull(@exam_name, exam_name),
        exam_date = isnull(@exam_date, exam_date),
        duration = isnull(@duration, duration),
        total_marks = isnull(@total_marks, total_marks),
        status = isnull(@status, status)
    where
        exam_id = @exam_id;

    print 'exam updated successfully.';
end;



----delete 
create procedure deleteexam @exam_id int
as
begin
    if not exists (select 1 from exam where exam_id = @exam_id)
    begin
        print 'error: exam does not exist.';
        return;
    end;

    delete from exam_question where exam_id = @exam_id;

    delete from exam where exam_id = @exam_id;

    print 'exam and associated questions deleted successfully.';
end;