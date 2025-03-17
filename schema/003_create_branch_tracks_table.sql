-- 3. Create the BRANCH_TRACK junction table (depends on BRANCH and TRACK)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'branch_track')
CREATE TABLE branch_track (
    branch_id INT,
    track_id INT,
    PRIMARY KEY (branch_id, track_id),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (track_id) REFERENCES track(track_id)
);
go

-- retrive all branches and it's tracks
create or alter proc sp_select_all_branch_track
as
	select b.branch_name, t.track_name
	from branch_track bt
	join branch b on bt.branch_id = b.branch_id
	join track t on bt.track_id = t.track_id
go

-- retrive all tracks that in a specific branch
create or alter proc sp_select_tracks_in_specific_branch @bid int
as
	select t.* from track t
	join branch_track bt on bt.branch_id = @bid
	where t.track_id = bt.track_id 
go

-- insert branch_track record sp
create or alter proc sp_insert_branch_track @bid int, @tid int
as
	insert into branch_track 
	values(@bid, @tid)
go

-- upadte branch_track record sp
create or alter proc sp_update_branch_track @bid int, @tid int
as
	if not exists (select 1 from branch_track where branch_id = @bid)
    begin
        declare @ErrorMessage nvarchar(200) = 'Branch ID ' + cast(@bid as nvarchar) + ' does not exist in branch_track table.'
        raiserror(@ErrorMessage, 16, 1)
        return
    end

	update branch_track
	set track_id = @tid
	where branch_id = @bid

	print 'Branch track updated successfully.'
go

-- delete branch_track record sp
create or alter proc sp_delete_track_from_branch @bid int, @tid int
as
	if not exists (select 1 from branch_track where branch_id = @bid and track_id = @tid)
    begin
        declare @ErrorMessage nvarchar(200) = 'track ID ' + cast(@tid as nvarchar) + ' does not exist in branch ID ' + cast(@bid as nvarchar)  + ' table.'
        raiserror(@ErrorMessage, 16, 1)
        return
    end
go