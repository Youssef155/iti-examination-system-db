-- 8. Create the INSTRUCTOR_COURSE junction table (depends on INSTRUCTOR, COURSE and BRANCH)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'INSTRUCTOR_COURSE') 
CREATE TABLE INSTRUCTOR_COURSE (
    instructor_id INT,
    course_id INT,
    branch_id INT,
    PRIMARY KEY (instructor_id, course_id),
    FOREIGN KEY (instructor_id) REFERENCES INSTRUCTOR(instructor_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);