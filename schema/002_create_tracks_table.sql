-- 2. Create the TRACK table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'track') 
CREATE TABLE track (
    track_id INT PRIMARY KEY IDENTITY(1,1),
    track_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    duration INT NOT NULL
);
go

-- read from track sp
create or alter proc sp_select_track @tid int = -1
as
	if(@tid = -1)
		select * from track

	else 
	begin
		select * from track
		where track_id = @tid
	end
go

-- insert new track sp
create or alter proc sp_insert_track @tName NVARCHAR(100), @tDesc NVARCHAR(MAX), @tDuartion int
as 
	if(@tName is not null and @tDesc is not null and @tDuartion is not null)
	begin
		insert into track
		values(@tName, @tDesc, @tDuartion)
	end

	else
	begin
        declare @ErrorMessage nvarchar(200) = 'All parameters should not be null, please enter valid values.'
        raiserror(@ErrorMessage, 16, 1)
        return
    end
go

-- update track sp
create or alter proc sp_update_track @tid int, @tName NVARCHAR(100), @tDesc NVARCHAR(MAX), @tDuartion int
as
	if @tid is null
	begin
        declare @ErrorMessage nvarchar(200) = 'Track ID cannot be null, please enter valid ID.'
        raiserror(@ErrorMessage, 16, 1)
        return
    end

	if(@tName is null and @tDesc is null and @tDuartion is null)
	begin
        declare @ParamErrorMessage nvarchar(200) = 'At least one update parameter (Name, duartion, or description) must be provided.'
        raiserror(@ParamErrorMessage, 16, 1)
        return
    end

	update track
    set 
        track_name = case when @tName is not null then @tName else track_name end,
        duration = case when @tDuartion is not null then @tDuartion else duration end,
		description = case when @tDesc is not null then @tDesc else description  end
    where track_id = @tid

	-- Check if the update affected any rows
    if @@rowcount = 0
    begin
        declare @NotFoundMessage nvarchar(200) = 'Track with ID ' + cast(@tid as varchar) + ' not found.'
        raiserror(@NotFoundMessage, 16, 1)
        return
    end
    
    print 'Track updated successfully.'
go

-- delete track sp
create or alter proc sp_delete_track @tid int = -1
as
	if(@tid = -1)
	begin
		declare @ErrorMsg nvarchar(200) = 'Track ID cannot be NULL. Please provide a valid Track ID.'
		raiserror(@ErrorMsg, 16, 1)
		return
	end

	delete from track
	where track_id = @tid

	-- Check if the delete affected any rows
    if @@rowcount = 0
    begin
        declare @NotFoundMessage nvarchar(200) = 'Track with ID ' + cast(@tid as varchar) + ' not found.'
        raiserror(@NotFoundMessage, 16, 1)
        return
    end
    
    print 'Track deleted successfully.'
go