-- Enable logical replication mode in PostgreSQL to support WAL-based CDC
ALTER SYSTEM SET wal_level = logical;

-- Set the maximum number of replication slots
-- Each Debezium connector instance uses one replication slot to track changes
ALTER SYSTEM SET max_replication_slots = 10;

-- Set the maximum number of WAL sender processes
-- WAL senders are background processes that stream the write-ahead logs to subscribers (like Debezium)
ALTER SYSTEM SET max_wal_senders = 10;

-- ⚠️ After applying the above changes, restart the PostgreSQL server
-- These parameters are system-level settings and only take effect after a restart
-- Example: sudo systemctl restart postgresql
-- or inside Docker: docker restart <postgres-container-name>

-- Create a publication for all tables in the current database
-- A publication defines which changes (INSERT, UPDATE, DELETE) should be streamed out
CREATE PUBLICATION my_publication FOR ALL TABLES;

-- Verify that the publication was successfully created
SELECT * FROM pg_publication;

-- Check which tables are included in the created publication
-- This helps confirm whether your schema (e.g., "public" or "ecomm_sch") is part of the publication
-- If your tables are in a different schema (not "public"), they must be explicitly added to the publication
SELECT * FROM pg_publication_tables WHERE pubname = 'my_publication';
