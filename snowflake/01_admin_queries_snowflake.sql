--cReate scehma and databaseabhi.hot9@gmail.com
create database dwh_prod;
create schema dwh_prod.ecomm_sch;

--create user with  rsa public key 
create or replace user svc_kafka_snowflake
type = service
default_role = 'ACCOUNTADMIN'
default_Warehouse = 'compute_wh'
rsa_public_key = '<public key generated from openssl>';

-- I have assigned the accountadmin role to service user for now , but if you want to create a custom role specific below privileges to that role.
-- give usage on database and schema where you want to ingest the logs
-- create table, pipe and stage access to that role and assign that role to service user
-- or if you have existing internal stage you may use that and providde read write access to that stage to the role.
grant role accountadmin to user svc_kafka_snowflake;
-- check user is created or not
show users;
desc user svc_kafka_snowflake;

-- Create authentication policy as keypair for all service user
CREATE AUTHENTICATION POLICY keypair_authentication
  AUTHENTICATION_METHODS = ('KEYPAIR');

--assigning the keypair authentication to service user
alter user svc_kafka_snowflake set authentication policy  keypair_authentication;

-- create a table to capture postgres logs for users tables (WAL logs)
create or replace table user_logs
(
record_metadata variant,
record_content variant
);
