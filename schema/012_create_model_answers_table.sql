-- 12. Create the MODEL_ANSWER table (depends on QUESTION)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MODEL_ANSWER')  
CREATE TABLE MODEL_ANSWER (
    model_answer_id INT,
    question_id INT,
    answer_text NVARCHAR(MAX) NOT NULL,
    is_correct BIT NOT NULL,
	PRIMARY KEY (model_answer_id, question_id),
    FOREIGN KEY (question_id) REFERENCES QUESTION(question_id)
);


--insert
create procedure insertmodelanswer @question_id int, @answer_text nvarchar(max), @is_correct bit
as
begin
    insert into model_answer (question_id, answer_text, is_correct)
    values (@question_id, @answer_text, @is_correct);

    print 'model answer inserted successfully.';
end;



--update
create procedure updatemodelanswer @model_answer_id int, @question_id int, @answer_text nvarchar(max), @is_correct bit
as
begin
    -- update the model answer
    update model_answer
    set answer_text = @answer_text,
        is_correct = @is_correct
    where model_answer_id = @model_answer_id and question_id = @question_id;

    print 'model answer updated successfully.';
end;


--delete 
create procedure deletemodelanswer @model_answer_id int, @question_id int
as
begin
    delete from model_answer where model_answer_id = @model_answer_id and question_id = @question_id;

    print 'model answer deleted successfully.';
end;



-- read
create procedure readmodelanswer @model_answer_id int = null, @question_id int = null
as
begin
    select model_answer_id, question_id, answer_text, is_correct
    from 
        model_answer
    where (@model_answer_id is null or model_answer_id = @model_answer_id) and
        (@question_id is null or question_id = @question_id);
end;