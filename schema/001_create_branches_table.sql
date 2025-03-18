-- 1. Create the BRANCH table (independent entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'branch') 
CREATE TABLE branch (
    branch_id INT PRIMARY KEY IDENTITY(1,1),
    branch_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(255) NOT NULL
);
go

-- read branch sp 
create or alter proc sp_select_branch @bid int = -1
as 
	if(@bid = -1)
	begin
		select * from branch
	end

	else
	begin 
		select * from branch
		where branch_id = @bid
	end
go

-- insert branch sp
create or alter proc sp_insert_branch @bName nvarchar(100), @bLocation nvarchar(100)
as
	if(@bName = ''  and @bLocation = '')
	begin
		declare @ErrorMessage nvarchar(200) = 'All parameters should not be null, please enter valid values.'
        raiserror(@ErrorMessage, 16, 1)
        return
	end

	insert into branch
	values(@bName, @bLocation)
go

-- update branch sp
create or alter proc sp_update_branch @bName nvarchar(100), @bLocation nvarchar(100), @bid int = -1
as 
	if @bid = -1
    begin
        declare @ErrorMessage nvarchar(200) = 'Branch ID should be entered. Please provide a valid Branch ID.'
        raiserror(@ErrorMessage, 16, 1)
        return
    end

	if (@bName = '' and @bLocation = '')
    begin
        declare @ParamErrorMessage nvarchar(200) = 'At least one update parameter (Name or Location) must be provided.'
        raiserror(@ParamErrorMessage, 16, 1)
        return
    end

	update branch
    set 
        branch_name = case when @bName != '' then @bName else branch_name end,
        location = case when @bLocation != '' then @bLocation else location end
    where branch_id = @bid
    
    -- Check if the update affected any rows
    if @@rowcount = 0
    begin
        declare @NotFoundMessage nvarchar(200) = 'Branch with ID ' + cast(@bid as varchar) + ' not found.'
        raiserror(@NotFoundMessage, 16, 1)
        return
    end
    
    print 'Branch updated successfully.'

go

-- delete branch sp
create or alter proc sp_delete_branch @bid int = -1
as
	if(@bid = -1)
	begin
		declare @ErrorMsg nvarchar(200) = 'Branch ID cannot be NULL. Please provide a valid Branch ID.'
		raiserror(@ErrorMsg, 16, 1)
		return
	end

	delete from branch
	where branch_id = @bid

	-- Check if the delete affected any rows
    if @@rowcount = 0
    begin
        declare @NotFoundMessage nvarchar(200) = 'Branch with ID ' + cast(@bid as varchar) + ' not found.'
        raiserror(@NotFoundMessage, 16, 1)
        return
    end
    
    print 'Branch deleted successfully.'
go
