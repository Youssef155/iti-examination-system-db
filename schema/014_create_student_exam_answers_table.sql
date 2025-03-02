-- 14. Create the STUDENT_EXAM_ANSWER table (depends on STUDENT_EXAM and QUESTION)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'STUDENT_EXAM_ANSWER')
CREATE TABLE STUDENT_EXAM_ANSWER (
    student_exam_answer_id INT PRIMARY KEY IDENTITY(1,1),
    student_exam_id INT,
    question_id INT,
    answer_text NVARCHAR(MAX),
    is_correct BIT DEFAULT 0,
    marks_obtained INT DEFAULT 0,
    FOREIGN KEY (student_exam_id) REFERENCES STUDENT_EXAM(student_exam_id),
    FOREIGN KEY (question_id) REFERENCES QUESTION(question_id)
);
