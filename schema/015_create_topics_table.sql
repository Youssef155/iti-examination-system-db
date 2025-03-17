IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Topics')
CREATE TABLE Topics(
  Topic_Id int primary key identity(1,1),
  TopicName varchar(50),
  Course_Id Int,
  Foreign Key (Course_Id) references COURSE(COURSE_ID)
)
