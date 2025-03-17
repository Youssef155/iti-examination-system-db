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
