#!/bin/bash
PROJECT_DIR="$HOME/YCloud_AI_Global"
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR
mkdir -p rag/data/HR rag/data/Finance rag/data/Engineering

cat > docker-compose.yml <<EOL
version: '3.8'
services:
  orchestrator:
    build: ./orchestrator
    container_name: ai_orchestrator
    restart: always
    volumes:
      - ./rag/data:/app/rag/data
      - ./orchestrator:/app
    ports:
      - "8000:8000"
  web_ui:
    build: ./web_ui
    container_name: ai_web_ui
    restart: always
    depends_on:
      - orchestrator
    ports:
      - "8080:8080"
  dashboard:
    build: ./dashboard
    container_name: ai_dashboard
    restart: always
    ports:
      - "9090:9090"
EOL

echo "تم تشغيل كل الخدمات..."
docker-compose up -d --build
