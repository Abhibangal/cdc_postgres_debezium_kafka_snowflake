alter system set wal_level = logical;
alter system set max_replication_slots = 10;
alter system set max_wal_senders = 10;

-- Restart the post gres server after the above changes so it will reflect
CREATE PUBLICATION my_publication FOR ALL TABLES;

select * from pg_publication;
--check all tables are part of this publication. This hhelp me to check that my schema used was public during creation and i was using ecomm_sch and was not etting data
SELECT * FROM pg_publication_tables WHERE pubname = 'my_publication';
