-- 10. Create the EXAM table (depends on COURSE)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'EXAM') 
CREATE TABLE EXAM (
    exam_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT,
    exam_name NVARCHAR(100) NOT NULL,
    exam_date DATE NOT NULL,
    duration INT NOT NULL,
    total_marks INT NOT NULL,
    status NVARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);