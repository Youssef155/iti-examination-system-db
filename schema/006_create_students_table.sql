-- 6. Create the STUDENT table (depends on TRACK)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'STUDENT')
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY IDENTITY(1,1),
    student_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL UNIQUE,
    phone NVARCHAR(20),
    track_id INT,
    FOREIGN KEY (track_id) REFERENCES TRACK(track_id)
);