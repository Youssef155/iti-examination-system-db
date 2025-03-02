-- 13. Create the STUDENT_EXAM table (depends on STUDENT and EXAM)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'STUDENT_EXAM')  
CREATE TABLE STUDENT_EXAM (
    student_exam_id INT PRIMARY KEY IDENTITY(1,1),
    student_id INT,
    exam_id INT,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    obtained_marks INT DEFAULT 0,
    status NVARCHAR(20) DEFAULT 'ONGOING',
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (exam_id) REFERENCES EXAM(exam_id)
);