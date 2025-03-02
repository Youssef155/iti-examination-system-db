-- 1. Create the BRANCH table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BRANCH') 
CREATE TABLE BRANCH (
    branch_id INT PRIMARY KEY IDENTITY(1,1),
    branch_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(255) NOT NULL
);