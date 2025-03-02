-- 7. Create the INSTRUCTOR table (depends on BRANCH)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INSTRUCTOR')
CREATE TABLE INSTRUCTOR (
    instructor_id INT PRIMARY KEY IDENTITY(1,1),
    instructor_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    specialization NVARCHAR(100),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);