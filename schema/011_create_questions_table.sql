-- 11. Create the QUESTION table (depends on EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QUESTION')
CREATE TABLE QUESTION (
    question_id INT PRIMARY KEY IDENTITY(1,1),
    exam_id INT,
    question_text NVARCHAR(MAX) NOT NULL,
    marks INT NOT NULL,
    question_type NVARCHAR(10) CHECK (question_type IN ('MCQ', 'TRUE_FALSE')) NOT NULL,
    FOREIGN KEY (exam_id) REFERENCES EXAM(exam_id)
);