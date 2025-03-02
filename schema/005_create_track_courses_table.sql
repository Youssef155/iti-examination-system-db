-- 5. Create the TRACK_COURSE junction table (depends on TRACK and COURSE)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TRACK_COURSE')
CREATE TABLE TRACK_COURSE (
    track_id INT,
    course_id INT,
    PRIMARY KEY (track_id, course_id),
    FOREIGN KEY (track_id) REFERENCES TRACK(track_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);