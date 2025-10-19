# 🧩 Containerized CDC Ingestion Pipeline (Postgres → Debezium → Kafka → Snowflake)

This repository contains a **containerized Change Data Capture (CDC) pipeline** built using **Docker**, **Debezium**, **Kafka**, and **Snowflake**.  
It captures **log-based changes from PostgreSQL’s Write-Ahead Logs (WAL)**, streams them through Kafka, and ingests them into Snowflake — where a **dynamic SCD Type 2 table** is maintained.

---

## 📁 Project Overview

### Components:
- **Postgres** – Source database for CDC (configured with WAL-based replication)
- **Debezium** – Reads WAL logs to capture insert, update, and delete events
- **Kafka & Kafka Connect** – Streams CDC events and manages connectors
- **Snowflake Connector** – Ingests data from Kafka topics into Snowflake tables
- **Docker Compose** – Manages and orchestrates all containerized services

---

## ⚙️ Folder Structure

```
├── connectors/
│   └── snowflake-kafka-connector.jar      # Downloaded Snowflake Kafka connector
│
├── kafka/
│   └── connect/
│       ├── jar/                           # Contains Snowflake connector JAR
│       └── ...                            # Debezium connectors run here
│
├── postgres-connector.json                # Debezium connector config for Postgres (WAL-based)
├── snowflake-connector.json               # Kafka connector config for Snowflake
├── docker-compose.yaml                    # Docker setup for all services
├── RUN_GUIDE.txt                          # Instructions to run the pipeline
├── debugging_command.txt                  # Commands used for debugging
└── README.md                              # You are here
```

---

## 🚀 Setup Instructions

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd <your-repo-name>
```

### 2. Start the Docker Containers
Spin up all containers using:
```bash
docker compose up -d
```

This starts Postgres, Kafka, Zookeeper, Debezium Connect, and other required services.

---

## 🔗 Connector Setup

### 3. Verify Connector Registration
After startup, check the **`register-connector`** service logs to confirm both connectors are registered:
- **Postgres connector** → Captures CDC events from WAL logs  
- **Snowflake connector** → Pushes the captured events into Snowflake

You can verify connector status via:
```bash
docker logs connect
```

---

## ❄️ Snowflake Configuration

In Snowflake:
- Created a **dynamic table** to implement **Slowly Changing Dimension (SCD) Type 2** logic.  
- Data flows from the **`raw_use_log`** table (populated from Postgres WAL events) into the **SCD2-managed table**.  
- Transformation and merge logic are defined using Snowflake SQL dynamic table queries included in this repository.

---

## 🧠 Debugging

If you face issues during setup or runtime, refer to:
```
debugging_command.txt
```

This file contains commonly used commands for inspecting Kafka topics, connector logs, and Docker container health.

---

## 🧾 Reference Files

- **`RUN_GUIDE.txt`** – Step-by-step guide to run and validate the pipeline  
- **`debugging_command.txt`** – Useful CLI commands for troubleshooting  
- **`docker-compose.yaml`** – Orchestration of Postgres, Kafka, Debezium, and Snowflake  
- **`postgres-connector.json`** – Debezium configuration for WAL-based CDC  
- **`snowflake-connector.json`** – Kafka connector configuration for Snowflake ingestion  

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

## 📜 Author & Notes

This setup demonstrates an **end-to-end, log-based CDC pipeline** using PostgreSQL’s **Write-Ahead Logs (WAL)** for data capture.  
It provides a reliable and scalable approach to synchronize source data changes into Snowflake with **SCD Type 2** logic for historical tracking.  

Refer to the included guide files for **running instructions**, **connector setup**, and **debugging commands**.
