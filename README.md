# 🧩 Containerized CDC Ingestion Pipeline (Postgres → Debezium → Kafka → Snowflake)

This repository contains a **containerized Change Data Capture (CDC) pipeline** built using **Docker**, **Debezium**, **Kafka**, and **Snowflake**.  
It captures **log-based changes from PostgreSQL’s Write-Ahead Logs (WAL)**, streams them through Kafka, and ingests them into Snowflake — where a **dynamic SCD Type 2 table** is maintained.

---

## 📁 Project Overview

### Components:
- **Postgres** – Source database configured with WAL-based CDC (Write-Ahead Logs)
- **Debezium** – Captures database change events from Postgres WAL logs
- **Kafka & Kafka Connect** – Handles message streaming and connector management
- **Snowflake Connector** – Consumes Kafka topics and writes to Snowflake
- **Docker Compose** – Orchestrates and runs all containerized services

---

## ⚙️ Folder Structure

```
├── connectors/
│   └── snowflake/                         # Contains all Snowflake Kafka connector JARs and related files
│
├── init_connectors/
│   ├── postgres-connector.json            # Debezium connector configuration for Postgres (WAL-based CDC)
│   ├── snowflake-connector.json           # Kafka connector configuration for Snowflake
│   └── register-connectors.sh             # Script to register both connectors
│
├── postgres/
│   ├── 01_table_creation.sql              # Postgres DDL scripts for table setup
│   ├── 02_admin_queries.sql               # Admin-level Postgres queries
│   └── 03_insert_into_user_query.sql      # Sample insert statements for CDC testing
│
├── snowflake/
│   ├── 01_admin_queries_snowflake.sql     # Snowflake admin and setup queries
│   └── 02_SCD_2_Dynamic_table_queries.sql # Dynamic table and SCD Type 2 logic queries
│
├── docker-compose.yaml                    # Docker setup for Postgres, Kafka, Debezium, and connectors
├── RUN_GUIDE.txt                          # Step-by-step guide to run and validate the pipeline
├── debugging_command.txt                  # Commands for troubleshooting and debugging
└── README.md                              # Project documentation (this file)
```

---

## 🚀 Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

### 2. Start the Docker Containers
Spin up all services using Docker Compose:
```bash
docker compose up -d
```
This will start Postgres, Kafka, Zookeeper, and Debezium Connect containers.

---

## 🔗 Connector Setup

After the containers are running, register the connectors by executing the script inside the **init_connectors** folder:

```bash
bash init_connectors/register-connectors.sh
```

This registers:
- **Postgres connector** → Reads WAL logs for CDC
- **Snowflake connector** → Writes CDC data into Snowflake

You can verify connector registration and status via:
```bash
docker logs connect
```

---

## ❄️ Snowflake Configuration

In Snowflake:
- Create the necessary database, schema, and stage using **`01_admin_queries_snowflake.sql`**  
- Use **`02_SCD_2_Dynamic_table_queries.sql`** to set up the **dynamic table** for implementing **Slowly Changing Dimension (SCD) Type 2**
- The data flows from the **raw_use_log** table (ingested via Kafka) to the **SCD2 dynamic table**

---

## 🧠 Debugging

If you face issues during setup or runtime, refer to:
```
debugging_command.txt
```
This file contains helpful Docker, Kafka, and connector debugging commands.

---

## 🧾 Reference Files

- **`RUN_GUIDE.txt`** – Quick guide for running and validating the pipeline  
- **`debugging_command.txt`** – Useful commands for troubleshooting  
- **`docker-compose.yaml`** – Service orchestration for all CDC components  
- **`postgres`** folder – All Postgres SQL setup scripts  
- **`snowflake`** folder – All Snowflake setup and SCD2 logic scripts  
- **`init_connectors`** – JSON configs and registration scripts for connectors

---

## ✅ Data Flow Summary

```
Postgres (WAL Logs)
     │
     ▼
 Debezium (Log-based CDC Capture)
     │
     ▼
 Kafka Topics
     │
     ▼
 Snowflake (Ingestion via Connector)
     │
     ▼
 Dynamic SCD2 Table
```

---

## 🧰 Tools & Technologies

- **Docker / Docker Compose**
- **PostgreSQL (WAL-based CDC)**
- **Kafka / Zookeeper**
- **Debezium**
- **Snowflake**
- **Snowflake Kafka Connector**

---

## 📜 Notes

This setup demonstrates an **end-to-end, log-based CDC pipeline** using PostgreSQL’s **Write-Ahead Logs (WAL)** for data capture.  
It ensures near real-time synchronization from Postgres to Snowflake with **SCD Type 2** handling for historical data tracking.  

Refer to the included guide files for detailed setup, execution, and debugging steps.
