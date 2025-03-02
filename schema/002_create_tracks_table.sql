-- 2. Create the TRACK table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TRACK') 
CREATE TABLE TRACK (
    track_id INT PRIMARY KEY IDENTITY(1,1),
    track_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    duration INT NOT NULL
);