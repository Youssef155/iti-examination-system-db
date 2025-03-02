# Set database connection variables
$server = "." # Local SQL Server instance
$database = "ITIExaminationDB"

# Step 1: Check if the database exists
$query = "SELECT COUNT(*) FROM sys.databases WHERE name = '$database'"
$result = Invoke-SqlCmd -ServerInstance $server -Query $query -ErrorAction SilentlyContinue

if ($result.Column1 -eq 0) {
    # Database does not exist, so create it
    Write-Host "Database '$database' does not exist. Creating database..."
    Invoke-SqlCmd -ServerInstance $server -Query "CREATE DATABASE $database"
} else {
    Write-Host "Database '$database' already exists. Proceeding with updates..."
}

# Step 2: Apply schema files (creating or updating tables)
Write-Host "Applying schema..."
$schemaFiles = Get-ChildItem -Path "schema" -Filter "*.sql"
foreach ($file in $schemaFiles) {
    Write-Host "Applying schema file: $($file.Name)"
    Invoke-SqlCmd -ServerInstance $server -Database $database -InputFile $file.FullName
}

# Step 3: Apply migration scripts (if any)
Write-Host "Applying migrations..."
$migrationFiles = Get-ChildItem -Path "migrations" -Filter "*.sql"
foreach ($file in $migrationFiles) {
    Write-Host "Applying migration: $($file.Name)"
    Invoke-SqlCmd -ServerInstance $server -Database $database -InputFile $file.FullName
}

# Step 4: Seed the database with sample data
Write-Host "Seeding data..."
$seedFiles = Get-ChildItem -Path "seed-data" -Filter "*.sql"
foreach ($file in $seedFiles) {
    Write-Host "Applying seed file: $($file.Name)"
    Invoke-SqlCmd -ServerInstance $server -Database $database -InputFile $file.FullName
}

Write-Host "Database setup complete!"