#!/bin/sh
echo "Waiting for Kafka Connect..."
until curl -s http://connect:8083/; do
  echo "Kafka Connect not ready, waiting 5s..."
  sleep 5
done

echo "Kafka Connect is up, registering connectors..."


echo "current folder"
pwd

# Register PostgreSQL Debezium Connector
curl -X POST http://connect:8083/connectors \
-H "Content-Type: application/json" \
-d @postgres-connector.json

echo "current folder"
pwd
# Register Snowflake Kafka Connector
curl -X POST http://connect:8083/connectors \
-H "Content-Type: application/json" \
-d @snowflake-connector.json