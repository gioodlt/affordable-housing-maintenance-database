# Affordable Housing Work_Order Database
A PostgreSQL database designed to help affordable housing staff manage maintenance requests,
work orders, technician assignments, priorities, statuses, and completion history.

# Project Features
- Relational database with eight entities
- Primary and foreign key relationships
- Check constraints for valid priorities and statuses
- Prevention of duplicate unit numbers within the same property
- Technician workload reporting
- Overdue high-priority work-order queries
- Unit and property maintenance analysis
- Verification test for database rules

# Files
- '01_schema.sql' - Creates the database tables and constraints
- '02_data.sql' - Inserts synthetic seed data
- '03_queries.sql' - Contains five business-reporting queries
- '04_queries.sql' - Tests constraints and database behavior
- 'Deliverables 1-3.pdf' - Client scope, requirements, ERD, and relational design
- 'Deliverable_6.pdf' - README and demonstration guide

# Execution Order
Run the SQL files in this order:
'01_schema.sql'
'02_data.sql'
'03_queries.sql'
'04_verification.sql'

# Tools
- PostgreSQL
- SQL
- Visual Studio Code
- DBeaver

# Project Outcome
The database provides a structures way for affordable housing staff to record maintenance
requests, monitor overdue work, review technician workloads, and identify recurring maintenance
issues.
