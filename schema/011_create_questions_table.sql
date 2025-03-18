-- 11. Create the QUESTION table (depends on EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QUESTION')
CREATE TABLE QUESTION (
    question_id INT PRIMARY KEY IDENTITY(1,1),
    question_text NVARCHAR(MAX) NOT NULL,
	course_ID int,
    question_type NVARCHAR(10) CHECK (question_type IN ('MCQ', 'TRUE_FALSE')) NOT NULL,
	FOREIGN KEY (course_ID) REFERENCES Course(course_id)
);

-- insert
create procedure insertquestionwithanswers
    @question_text nvarchar(max),
    @course_id int,
    @question_type nvarchar(10),
    @answers as dbo.answertype readonly -- user defined type 
as
begin
    if not exists (select 1 from course where course_id = @course_id)
    begin
        print 'error: course does not exist.';
        return;
    end;

    if @question_type not in ('mcq', 'true_false')
    begin
        print 'error: invalid question type. must be mcq or true_false.';
        return;
    end;

    declare @question_id int;
    insert into question (question_text, course_id, question_type)
    values (@question_text, @course_id, @question_type);

    set @question_id = scope_identity(); -- get the value of the created question

	-- now the data in the @answer is tranferign to the model_ansewr table.
    insert into model_answer (question_id, answer_text, is_correct)
    select @question_id, answer_text, is_correct
    from @answers;

    print 'question and answers inserted succesfully.';
end;

--create type dbo.answertype as table
--(
--    answer_text nvarchar(max),
--    is_correct bit
--); way to insert the answer type


-- read (without checks)
create procedure readquestion@question_id int = null, @course_id int = null, @question_type nvarchar(10) = null
as
begin
    select question_id,question_text,course_id,question_type
    from 
        question
    where (@question_id is null or question_id = @question_id) and(@course_id is null or course_id = @course_id) and(@question_type is null or question_type = @question_type);
end;


--update 
create procedure updatequestion
    @question_id int,
    @question_text nvarchar(max) = null,
    @course_id int = null,
    @question_type nvarchar(10) = null
as
begin
    update question
    set
        question_text = isnull(@question_text, question_text),
        course_id = isnull(@course_id, course_id),
        question_type = isnull(@question_type, question_type)
    where
        question_id = @question_id;

    print 'question updated successfully.';
end;

--delete
create procedure deletequestion
    @question_id int
as
begin
    -- delete the question
    delete from question
    where question_id = @question_id;

    print 'question deleted successfully.';
end;
