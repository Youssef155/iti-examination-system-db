IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Exam_Question') 
create table Exam_Question(
	question_id int,
	Exam_id int,
	Mark int,
	primary key (question_id, Exam_id),
	foreign key (question_id) references Question(question_id),
	foreign key (Exam_id) references Exam(exam_id)
);

-- insert
create procedure insertExamQuestion
    @exam_id int,
    @question_id int,
    @mark int
as
begin
    -- insert into exam_question
    insert into exam_question (exam_id, question_id, mark)
    values (@exam_id, @question_id, @mark);

    print 'exam-question inserted successfully.';
end;

--update
create procedure updateexamquestion
    @exam_id int,
    @question_id int,
    @mark int
as
begin
    -- update the mark
    update exam_question
    set mark = @mark
    where exam_id = @exam_id and question_id = @question_id;

    print 'exam-question updated successfully.';
end;


--delete
create procedure deleteexamquestion
    @exam_id int,
    @question_id int
as
begin
    -- delete the exam-question link
    delete from exam_question
    where exam_id = @exam_id and question_id = @question_id;

    print 'exam-question deleted successfully.';
end;


--read
create procedure readexamquestion @exam_id int = null, @question_id int = null
as
begin
    select exam_id, question_id, mark
    from exam_question
    where (@exam_id is null or exam_id = @exam_id) and
        (@question_id is null or question_id = @question_id);
end;