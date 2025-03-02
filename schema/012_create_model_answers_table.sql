-- 12. Create the MODEL_ANSWER table (depends on QUESTION)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'MODEL_ANSWER')  
CREATE TABLE MODEL_ANSWER (
    model_answer_id INT PRIMARY KEY IDENTITY(1,1),
    question_id INT,
    answer_text NVARCHAR(MAX) NOT NULL,
    is_correct BIT NOT NULL,
    FOREIGN KEY (question_id) REFERENCES QUESTION(question_id)
);