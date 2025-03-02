-- 4. Create the COURSE table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'COURSE')
CREATE TABLE COURSE (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    course_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    credit_hours INT NOT NULL
);