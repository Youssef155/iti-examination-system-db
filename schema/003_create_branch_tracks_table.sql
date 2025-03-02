-- 3. Create the BRANCH_TRACK junction table (depends on BRANCH and TRACK)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'BRANCH_TRACK')
CREATE TABLE BRANCH_TRACK (
    branch_id INT,
    track_id INT,
    PRIMARY KEY (branch_id, track_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id),
    FOREIGN KEY (track_id) REFERENCES TRACK(track_id)
);