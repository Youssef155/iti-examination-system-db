# Database Team Collaboration Structure

```
e-commerce-database/
├── README.md                        # Project documentation
├── schema/                          # Database schema files
│   ├── 001_create_customers_table.sql  # Team Member 1
│   ├── 002_create_products_table.sql   # Team Member 2
│   ├── 003_create_orders_table.sql     # Team Member 3
│   └── 004_create_order_items_table.sql # Team Member 3
├── migrations/                      # Database migration scripts
│   ├── 001_add_status_column_to_orders.sql
│   ├── 002_add_email_verification_to_customers.sql
│   └── 003_create_product_reviews_table.sql
├── seed-data/                       # Sample data for development
│   ├── customers_seed.sql
│   ├── products_seed.sql
│   └── orders_seed.sql
└── scripts/
    └── setup_database.sh            # Script to apply all schemas
```

## Naming Conventions

Consistent naming conventions are crucial for team collaboration on database projects. Follow these guidelines:

### File Naming

- **Schema files**: `[sequence_number]_create_[table_name]_table.sql`
  - Example: `001_create_customers_table.sql`

- **Migration files**: `[sequence_number]_[action]_[details].sql`
  - Example: `002_add_email_verification_to_customers.sql`

- **Seed files**: `[table_name]_seed.sql`
  - Example: `customers_seed.sql`

### Database Objects

#### Tables
- Use plural nouns (e.g., `customers` not `customer`)
- Use lowercase with underscores (snake_case)
- Be descriptive but concise

#### Columns
- Use singular form for column names
- Primary keys: `[table_name_singular]_id`
  - Example: `customer_id` in the `customers` table
- Foreign keys: Same name as the referenced primary key
  - Example: `customer_id` in the `orders` table
- Boolean fields: Use prefix `is_` or `has_`
  - Example: `is_active`, `has_subscription`
- Date/time fields: Use suffix `_date` or `_at`
  - Example: `created_at`, `order_date`
- Use lowercase with underscores (snake_case)

#### Indexes
- Format: `idx_[table]_[column(s)]`
  - Example: `idx_customers_email`
- For multi-column indexes: `idx_[table]_[column1]_[column2]`
  - Example: `idx_orders_customer_id_order_date`

#### Stored Procedures
- Format: `sp_[verb]_[object]_[modifier]`
  - Example: `sp_get_customer_by_id`
  - Example: `sp_update_product_inventory`
- Use lowercase with underscores (snake_case)
- Begin with an action verb that describes the procedure's purpose:
  - `get_` For retrieving data 
  - `insert_` For adding new records
  - `update_` For modifying existing records
  - `delete_` For removing records
  - `process_` For complex operation
- Include descriptive modifiers when needed:
  - `sp_get_orders_by_date_range`
  - `sp_calculate_order_total`


### SQL Formatting
- Keywords in UPPERCASE: `SELECT`, `INSERT`, `CREATE TABLE`
- Object names in lowercase: `customers`, `customer_id`
- Indent clauses for readability
- Align related items vertically when appropriate
- Include comments for complex logic

## Schema Examples

Initial database schema files that create your tables:

```sql
-- Team Member 1: Working on Customers table
-- File: 001_create_customers_table.sql

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Team Member 2: Working on Products table
-- File: 002_create_products_table.sql

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    inventory_count INT NOT NULL DEFAULT 0,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Team Member 3: Working on Orders table
-- File: 003_create_orders_table.sql

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'canceled') DEFAULT 'pending',
    total DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Team Member 3: Also working on Order_Items table
-- File: 004_create_order_items_table.sql

CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

## Migrations Examples

The migrations folder contains scripts that track incremental changes to your database after the initial setup:

```sql
-- Migration: 001_add_status_column_to_orders.sql
-- Description: Add a status column to track order processing stages in more detail
-- Author: Team Member 3
-- Date: 2025-02-15

-- Up (Apply the change)
ALTER TABLE orders 
ADD COLUMN status_details VARCHAR(100);

-- Add comments for clarity
EXEC sp_addextendedproperty
@name = N'MS_Description',
@value = 'Detailed status information about the order',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table', @level1name = 'orders',
@level2type = N'Column', @level2name = 'status_details';

-- Down (Rollback the change)
-- ALTER TABLE orders DROP COLUMN status_details;
```

```sql
-- Migration: 002_add_email_verification_to_customers.sql
-- Description: Add email verification tracking to customers table
-- Author: Team Member 1
-- Date: 2025-02-18

-- Up (Apply the change)
ALTER TABLE customers
ADD email_verified BIT NOT NULL DEFAULT 0,
    verification_token VARCHAR(100) NULL,
    verification_sent_at DATETIME NULL;

-- Down (Rollback the change)
-- ALTER TABLE customers
-- DROP COLUMN email_verified,
--     verification_token,
--     verification_sent_at;
```

```sql
-- Migration: 003_create_product_reviews_table.sql
-- Description: Add a new table to store product reviews
-- Author: Team Member 2
-- Date: 2025-02-20

-- Up (Apply the change)
CREATE TABLE product_reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text NVARCHAR(1000) NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ProductReviews_Products FOREIGN KEY (product_id) 
        REFERENCES products(product_id),
    CONSTRAINT FK_ProductReviews_Customers FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Down (Rollback the change)
-- DROP TABLE product_reviews;
```

## Collaboration Workflow

1. **Initial setup**:
   - Create the repository structure
   - Define table relationships and dependencies in a README or diagram
   - Assign tables to team members

2. **Development**:
   - Each member works on their assigned table files
   - Regular commits to GitHub with clear messages
   - Pull requests when tables are ready for review

3. **Integration**:
   - Run a script that applies all schema files in sequence
   - Test relationships between tables

4. **Evolution**:
   - Make modifications through new migration files
   - Number migrations sequentially
   - Include both apply (up) and rollback (down) operations

5. **Team Guidelines**:
   - Always include descriptive comments
   - Follow naming conventions consistently
   - Coordinate on foreign key relationships
   - Test migrations before committing


---

## **Understanding `schema` vs `migrations` in Your File Structure**

Your project has two important folders related to database setup:

### **1. `schema/` (Schema Files)**
- Contains SQL files that define the **initial database structure**.
- Each file creates tables and sets up relationships.
- **Example files:**  
  - `001_create_customers_table.sql` → Defines the `Customers` table.  
  - `002_create_products_table.sql` → Defines the `Products` table.  
  - `003_create_orders_table.sql` → Defines the `Orders` table.

### **2. `migrations/` (Migration Scripts)**
- Contains SQL scripts used for **updating** or **modifying** the database over time.
- These scripts ensure that changes (like adding columns, modifying indexes) are applied **incrementally** without breaking existing data.
- **Example use cases:**  
  - Adding a new column:  
    ```sql
    ALTER TABLE Customers ADD PhoneNumber NVARCHAR(20);
    ```
  - Changing data types:  
    ```sql
    ALTER TABLE Orders ALTER COLUMN OrderDate DATETIME;
    ```
  - Creating new indexes:  
    ```sql
    CREATE INDEX IX_Orders_CustomerID ON Orders(CustomerID);
    ```

---

## **Key Differences**
| Feature      | Schema Files | Migration Scripts |
|-------------|-------------|------------------|
| **Purpose** | Defines initial structure | Modifies or updates the schema |
| **When Used?** | At first-time setup | Whenever the structure needs changes |
| **Effect** | Creates new tables, keys, and constraints | Alters, updates, or migrates existing tables |
| **Examples** | `CREATE TABLE` statements | `ALTER TABLE`, `ADD COLUMN`, `DROP COLUMN` |

---

## **How They Work Together?**
1. When setting up a **new** database, schema files create the initial tables.
2. As the project evolves, migration scripts apply **incremental** changes without resetting everything.

---

## **How to Run the Database Setup Script**

Follow these steps to set up your database using the `setup_database.ps1` PowerShell script.

---

### **Prerequisites**

Before running the script, ensure the following:

- You have **Microsoft SQL Server** installed.
- You have **SQL Server Management Studio (SSMS)** or `sqlcmd` available.
- PowerShell is installed on your system.

---

### **Steps to Run the Setup Script**

#### **1️⃣ Open PowerShell**

- Press `Win + R`, type `powershell`, and press `Enter`.
- Alternatively, search for **PowerShell** in the Start menu.

#### **2️⃣ Navigate to the Project Directory**

Use the `cd` command to move to the folder containing the `setup_database.ps1` script:

```powershell
cd path\to\your\project
```

*(Replace **`path\to\your\project`** with the actual location of your script.)*

#### **3️⃣ Allow Execution of Scripts (If Required)**

If you haven't run PowerShell scripts before, you may need to enable script execution:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
```

*(Select **`Y`** when prompted.)*

#### **4️⃣ Run the Setup Script**

Execute the PowerShell script by running:

```powershell
.\setup_database.ps1
```

#### **5️⃣ Verify the Database Creation**

After the script completes:

- Open **SQL Server Management Studio (SSMS)**.
- Connect to your server (`.` for local, or `localhost`).
- Check if the database (e.g., `EcommerceDB`) is created.
- Run:
  ```sql
  SELECT name FROM sys.databases;
  ```
  To confirm the database exists.

#### **6️⃣ Verify Tables and Seed Data**

Check if tables are created:

```sql
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
```

Check if data is inserted:

```sql
SELECT * FROM Customers;
```

---

### **Troubleshooting**

| Issue                             | Solution                                                                |
| --------------------------------- | ----------------------------------------------------------------------- |
| **PowerShell script not running** | Run `Set-ExecutionPolicy RemoteSigned -Scope Process` before execution. |
| **Database not appearing**        | Ensure SQL Server is running (`services.msc`) and try again.            |
| **Permission Denied Errors**      | Run PowerShell as Administrator.                                        |
| **Tables missing**                | Check the `schema/` folder and rerun the script.                        |

---

### **Final Notes**

- If the database already exists, the script **updates it instead of recreating it**.
- Make sure `sqlcmd` is installed and available in the system PATH.
- If any step fails, check the **error messages** and refer to the **Troubleshooting** section.

---

Your database should now be set up and ready to use! 🚀

