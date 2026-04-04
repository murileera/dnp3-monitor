# DNP3 Monitor

![CI Pipeline](https://github.com/murileera/dnp3-monitor/actions/workflows/ci.yml/badge.svg)

A DNP3 device monitoring system built with Python, FastAPI, SQLite, Docker, and Grafana.

## Overview

This project simulates a DNP3 master station that continuously polls outstations, collects measurements, and displays them on a real-time dashboard. It demonstrates the integration of industrial automation protocols with modern software development practices.

## Architecture
```
DNP3 Outstation (simulated)
        ↓
Collector (Python)     ← polls devices every 10 seconds
        ↓
SQLite Database        ← stores measurements
        ↓
FastAPI REST API       ← exposes data via HTTP
        ↓
Grafana Dashboard      ← visualizes live data
```

## Features

- REST API with full device and measurement management
- Automatic polling of DNP3 devices every 10 seconds
- Support for Analog Inputs, Binary Inputs and Double-bit Inputs
- Persistent SQLite database with Docker volumes
- Real-time Grafana dashboard with organized tables per point type
- Multi-container setup with Docker Compose
- Simulated DNP3 outstation for testing without real hardware

## Tech Stack

- **Python 3.10** — collector and API
- **FastAPI** — REST API framework
- **SQLAlchemy** — ORM for database operations
- **SQLite** — lightweight database
- **Docker + Docker Compose** — containerization
- **Grafana** — real-time dashboard
- **dnp3-python** — DNP3 protocol binding (simulation mode)

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Run the project
```bash
git clone https://github.com/YOUR_USERNAME/dnp3-monitor.git
cd dnp3-monitor
docker compose up -d
```

### Register a device
```bash
curl -X POST http://localhost:8000/devices \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Subestacao Norte",
    "host": "192.168.1.10",
    "port": 20000,
    "dnp3_address": 1,
    "active": true,
    "analog_input_count": 10,
    "binary_input_count": 8,
    "double_point_count": 4
  }'
```

### Access the services

| Service | URL |
|---------|-----|
| API | http://localhost:8000 |
| API Docs | http://localhost:8000/docs |
| Grafana | http://localhost:3000 |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | Health check |
| GET | /info | Project info |
| POST | /devices | Register a device |
| GET | /devices | List all devices |
| GET | /devices/{id} | Get a device |
| POST | /devices/{id}/points | Register a point |
| GET | /devices/{id}/points | List device points |
| GET | /devices/{id}/measurements | Get measurements |
| GET | /measurements | Get all measurements |

## Project Structure
```
dnp3-monitor/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── app/
    ├── main.py        # FastAPI routes
    ├── collector.py   # DNP3 polling engine
    ├── database.py    # Database connection
    ├── models.py      # SQLAlchemy models
    └── schemas.py     # Pydantic schemas
```

## Roadmap

- [ ] Real DNP3 communication via dnp3-python
- [ ] CROB commands (Direct Operate and Select Before Operate)
- [ ] Single Point Commands (SPC) and Double Point Commands (DPC)
- [ ] Grafana alerting for abnormal values
- [ ] Cloud deployment (AWS/Azure)
- [ ] GitHub Actions CI/CD pipeline

## Background

This project was built to bridge industrial automation expertise with modern DevOps practices. The author has hands-on experience with DNP3, IEC 104, Modbus, RTAC, Elipse, and SAGE systems in electrical substations.

