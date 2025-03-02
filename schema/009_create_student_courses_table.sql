-- 9. Create the STUDENT_COURSE junction table (depends on STUDENT, COURSE, INSTRUCTOR and BRANCH)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'STUDENT_COURSE')
CREATE TABLE STUDENT_COURSE (
    student_id INT,
    course_id INT,
    instructor_id INT,
    branch_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (instructor_id) REFERENCES INSTRUCTOR(instructor_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id)
);