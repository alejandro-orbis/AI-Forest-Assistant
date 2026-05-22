# AI-Forest-Assistant
🌲 AI Forest Assistant - Omnichannel forest monitoring, alerting, and management system built with n8n, Gemini AI, WhatsApp API, PostgreSQL &amp; PostGIS. Automates fire alerts, pest tracking, permit requests, legal RAG, and weekly dashboards.

[![n8n](https://img.shields.io/badge/n8n-Workflow-orange?style=flat-square)](https://n8n.io/)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI-4285F4?style=flat-square&logo=google)](https://ai.google.dev)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-Business_API-25D366?style=flat-square&logo=whatsapp)](https://developers.facebook.com/docs/whatsapp)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat-square&logo=postgresql)](https://www.postgresql.org/)
[![PostGIS](https://img.shields.io/badge/PostGIS-3.4-4169E1?style=flat-square)](https://postgis.net/)
[![Google Maps](https://img.shields.io/badge/Google_Maps-API-4285F4?style=flat-square&logo=googlemaps)](https://mapsplatform.google.com/)
[![OpenWeatherMap](https://img.shields.io/badge/OpenWeatherMap-API-FC4C02?style=flat-square)](https://openweathermap.org/api)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production-22c55e?style=flat-square)](https://github.com/alejandro-orbis)

---

## 📚 Documentation

| Language | File |
|----------|------|
| English | [README.md](README.md) |
| Spanish | [README.ES.md](README.ES.md) |

---

## 🎯 What does it do?

Omnichannel forest monitoring, alerting, and management system. Forestry workers can interact via **WhatsApp** to:

| Function | Description |
|----------|-------------|
| **Report Fire** | User reports smoke/fire, AI classifies and validates coordinates |
| **Report Pest** | Detects pests (pine processionary, red weevil, etc.) and creates case |
| **Request Permit** | Processes felling/pruning/clearing permit requests |
| **Legal Query** | Answers forestry regulations (Law 43/2003, pruning seasons, distances) |
| **Work Report** | Logs daily work hours, tasks, and location |
| **Emergency Alert** | Every 4 hours, calculates fire risk and alerts brigade members |
| **Escalate to Supervisor** | Critical incidents trigger immediate supervisor notification |
| **Reset Conversation** | User can type `reset` to clear context |

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| **Omnichannel** | WhatsApp Business API (primary), email (reports), webhook (optional dashboard) |
| **AI Classification** | Gemini classifies: FIRE, PEST, PERMIT, INCIDENT, LEGAL_QUERY, WORK_REPORT |
| **Geolocation** | Captures coordinates, validates with PostGIS, reverse geocoding with Google Maps API |
| **State Machine** | Associates coordinates with pending cases automatically |
| **Legal RAG** | Answers regulations with layered legal context (fire, drones, AI, business, permits) |
| **Smart Escalation** | Notifies supervisor via WhatsApp for HIGH priority cases |
| **Weather Alerts** | Every 4 hours, calculates risk using temperature, humidity, wind speed |
| **Dashboard** | Weekly metrics via email, WhatsApp, and Google Sheets |
| **Rate Limiting** | 15 messages per minute per user (prevents spam in emergencies) |
| **PostGIS** | Spatial queries, distance calculations, location triggers |

---

## 🏗️ Architecture

Webhook WhatsApp
│
└── Parse WhatsApp (normalizes text, location, images, documents)
│
└── Rate Limiter (15 msg/minuto)
│
└── IF Legal Query? (regex detection)
│ ├── YES → Legal RAG Branch (Gemini with legal context)
│ └── NO → Gemini Classifier (classifies intent)
│
└── Process Classification
│
└── Validate Coordinates
│
└── Reverse Geocoding (Google Maps API)
│
└── IF Missing Coordinates?
│ ├── YES → Save State → Ask for location
│ └── NO → Prepare Registration
│
└── Switch (routes to appropriate table)
│ ├── FIRE → forest_incidents
│ ├── PEST → pest_cases
│ ├── PERMIT → permits
│ ├── WORK_REPORT → work_reports
│ └── INCIDENT → forest_incidents
│
└── Save to PostgreSQL + PostGIS
│
└── Prepare Response (with case_id + readable location)
│
└── IF Notify Supervisor? (HIGH priority)
│ ├── YES → Send WhatsApp to Supervisor
│ └── NO → (skip)
│
└── Send WhatsApp to User
│
└── Update Dashboard Metrics (daily at 8am)
│ ├── Google Sheets (historical)
│ ├── Email to Supervisor
│ └── WhatsApp to Supervisor


---

## 🧠 State Machine (Coordinates Association)

| State | Description | Next |
|-------|-------------|------|
| **waiting_coords** | System is waiting for coordinates from user | When coordinates received → Update case |
| **completed** | Case updated with coordinates → Clear state | End |

**Flow:**
1. User sends: "Smoke in the forest" → System creates case → Saves state → Asks for location
2. User sends: "40.4168, -3.7038" → System detects pending state → Updates case → Clears state → Confirms

---

## 🛠️ Tech Stack

| Tool | Usage |
|------|-------|
| [n8n](https://n8n.io/) | Workflow orchestration |
| [Gemini AI](https://ai.google.dev) | Intent classification + Legal RAG |
| [WhatsApp Business API](https://developers.facebook.com/docs/whatsapp) | Incoming/outgoing messaging |
| [PostgreSQL](https://www.postgresql.org/) + [PostGIS](https://postgis.net/) | Storage + geospatial queries |
| [Google Maps API](https://mapsplatform.google.com/) | Reverse geocoding |
| [OpenWeatherMap](https://openweathermap.org/api) | Weather data for fire risk |
| [Google Sheets](https://sheets.google.com) | Dashboard history |
| [Gmail](https://gmail.com) | Email notifications |

---

## 📸 Screenshots

| Workflow Overview | WhatsApp Fire Alert | Legal Query Response | Dashboard Metrics |
|---|---|---|---|
| ![Overview](assets/screenshots/workflow_overview.png) | ![Fire Alert](assets/screenshots/fire_alert_whatsapp.png) | ![Legal Query](assets/screenshots/legal_query_whatsapp.png) | ![Dashboard](assets/screenshots/dashboard_metrics.png) |

| PostgreSQL Tables | PostGIS Location | Reverse Geocoding | Google Sheets Dashboard |
|---|---|---|---|
| ![Postgres](assets/screenshots/postgres_tables.png) | ![PostGIS](assets/screenshots/postgis_location.png) | ![Geocoding](assets/screenshots/reverse_geocoding.png) | ![Sheets](assets/screenshots/google_sheets_dashboard.png) |

---

## 📁 Project Structure

Webhook WhatsApp
│
└── Parse WhatsApp (normalizes text, location, images, documents)
│
└── Rate Limiter (15 msg/minuto)
│
└── PostgreSQL: Read State (check pending coordinates)
│
├── IF Pending State? (has_pending = true)
│ ├── YES → Extract Coordinates → Build SQL → Update Case → Reverse Geocoding → Clear State → Send Confirmation
│ └── NO → IF Legal Query? (regex detection)
│ ├── YES → Legal RAG Branch (Gemini with legal context)
│ └── NO → Gemini Classifier (classifies intent)
│
└── Process Classification
│
└── Validate Coordinates
│
└── Reverse Geocoding (Google Maps API)
│
└── IF Missing Coordinates?
│ ├── YES → Save State → Ask for location
│ └── NO → Prepare Registration
│
└── Switch (routes to appropriate table)
│ ├── FIRE → forest_incidents
│ ├── PEST → pest_cases
│ ├── PERMIT → permits
│ ├── WORK_REPORT → work_reports
│ └── INCIDENT → forest_incidents
│
└── Save to PostgreSQL + PostGIS
│
└── Prepare Response (with case_id + readable location)
│
└── IF Notify Supervisor? (HIGH priority)
│ ├── YES → Send WhatsApp to Supervisor
│ └── NO → (skip)
│
└── Send WhatsApp to User
│
└── Dashboard (daily at 8am)
├── Google Sheets (historical)
├── Email to Supervisor
└── WhatsApp to Supervisor

---

## 🚀 Setup Guide

### 1. Prerequisites

- n8n instance (self-hosted v2.10+ or n8n Cloud)
- PostgreSQL 13+ with PostGIS extension
- Meta for Developers account with WhatsApp Business API access
- Google Cloud account (Gemini AI + Maps Platform)
- OpenWeatherMap account
- Google Sheets account (for dashboard history)
- Gmail account (for email notifications)

### 2. Configure credentials in n8n

| Credential | Where to get |
|------------|--------------|
| `GEMINI_API_KEY` | [aistudio.google.com](https://aistudio.google.com) |
| `META_ACCESS_TOKEN` | Meta for Developers → App → WhatsApp → API Settings |
| `WHATSAPP_PHONE_NUMBER_ID` | Meta for Developers → WhatsApp → API Settings |
| `GOOGLE_MAPS_API_KEY` | Google Cloud Console → APIs & Services → Credentials |
| `OPENWEATHER_API_KEY` | [openweathermap.org](https://openweathermap.org/api) |
| PostgreSQL | Your PostgreSQL connection string |
| Google Sheets OAuth | n8n built-in OAuth |
| Gmail OAuth | n8n built-in OAuth |

### 3. Database setup

Run the following SQL scripts in order:

```bash
psql -U postgres -f database/schema.sql
psql -U postgres -f database/triggers.sql
psql -U postgres -f database/indexes.sql
4. Create Google Sheets dashboard
Create a new spreadsheet: sheets.new

Name it: AI Forest Assistant - Dashboard

Create a sheet named Dashboard

Add headers: FECHA, INCIDENTES_TOTAL, ALERTAS_TOTAL, CONSULTAS_LEGALES, TOP_UBICACIONES, INCIDENTES_ALTA, INCIDENTES_MEDIA, INCIDENTES_BAJA, INCENDIOS, PLAGAS, PERMISOS, INCIDENCIAS, PARTES_TRABAJO

Copy the Sheet ID from the URL

5. Import workflows to n8n
In n8n: ... menu → Import from File → select:

Workflow	File	Purpose
Core	workflows/AI_Forest_Assistant_01_Core_WhatsApp.json	Main message processing
Weather Alerts	workflows/AI_Forest_Assistant_02_Alertas_Clima.json	Fire risk every 4h
Dashboard	workflows/AI_Forest_Assistant_03_Dashboard_Metricas.json	Weekly metrics
6. Configure WhatsApp webhook
Field	Value
Callback URL	https://your-n8n.com/webhook/omnichannel-webhook
Verify Token	Your META_VERIFY_TOKEN
7. Activate workflows
Toggle each workflow to Active in n8n.

📊 Database Structure
Table: forest_incidents
Column	Type	Description
id	UUID	Primary key
case_id	TEXT	User-friendly ID (FOR-XXXXX)
incident_type	TEXT	FIRE, INCIDENT, OTHER
priority	TEXT	HIGH, MEDIUM, LOW
latitude	DOUBLE	Decimal degrees
longitude	DOUBLE	Decimal degrees
location	GEOGRAPHY	PostGIS point
parcela	TEXT	Plot number
status	TEXT	OPEN, CLOSED
metadata	JSONB	Additional data
Table: permits
Column	Type	Description
permit_type	TEXT	FELLING, PRUNING, CLEARING
applicant_name	TEXT	User's full name
urgency	TEXT	HIGH, MEDIUM, LOW
status	TEXT	PENDING, APPROVED, REJECTED
Table: pest_cases
Column	Type	Description
pest_type	TEXT	pine processionary, red weevil
affected_tree	TEXT	pine, palm, oak
severity	TEXT	HIGH, MEDIUM, LOW
status	TEXT	OPEN, CLOSED
Table: work_reports
Column	Type	Description
worker_name	TEXT	User's name
hours_worked	DECIMAL	Hours worked
tasks_completed	TEXT	Description of tasks
location_text	TEXT	Textual location
Table: queries
Column	Type	Description
query_type	TEXT	LEGAL_QUERY
question	TEXT	User's question
answer	TEXT	Gemini's response
user_phone	TEXT	User's phone number
Table: fire_alerts
Column	Type	Description
zone_name	TEXT	Forest zone name
temperature	DECIMAL	°C
humidity	DECIMAL	%
wind_speed	DECIMAL	km/h
fire_risk	TEXT	EXTREME, HIGH, MODERATE, LOW
alert_sent	BOOLEAN	Whether alert was sent
Table: conversation_state
Column	Type	Description
user_phone	TEXT	Primary key
current_state	TEXT	waiting_coords
pending_case_id	TEXT	Case waiting for coordinates
pending_type	TEXT	FIRE, PEST, PERMIT, INCIDENT
PostGIS Triggers
The location column is automatically updated from latitude/longitude on INSERT or UPDATE:

sql
CREATE TRIGGER set_incident_location
BEFORE INSERT OR UPDATE ON forest_incidents
FOR EACH ROW
EXECUTE FUNCTION update_incident_location();
🔧 Key Workflow Nodes
Node	Function
Parse WhatsApp	Normalizes incoming WhatsApp messages (text, location, images, documents)
Rate Limiter	15 messages per minute per conversation
IF Es Consulta Normativa	Detects legal queries via regex
Gemini Respuesta Legal	Legal RAG with layered context (fire, drones, AI, business, permits)
Gemini Clasificar Incidencia	Classifies intent: FIRE, PEST, PERMIT, INCIDENT, WORK_REPORT
Validar Coordenadas	Validates latitude/longitude ranges
Reverse Geocoding	Converts coordinates to readable location via Google Maps API
State Machine	PostgreSQL: Read State → IF pending → Extract Coordinates → Update Case → Clear State
Switch	Routes to appropriate table (forest_incidents, permits, pest_cases, work_reports)
Guardar en PostgreSQL	Saves data to respective table
Preparar Respuesta Usuario	Formats response with case_id + readable location
Enviar WhatsApp Supervisor	Notifies supervisor for HIGH priority cases
Dashboard	Calculates metrics every 24h → Google Sheets + Email + WhatsApp
🛡️ Security
All API keys and tokens must be stored as environment variables — never hardcoded

The webhook verification endpoint handles Meta's challenge-response authentication

Rate limiting per conversation prevents abuse

Empty messages and "read" events are filtered to prevent loops

Row Level Security (RLS) can be enabled in PostgreSQL for multi-tenant setups

📄 License
MIT License — free to use, modify, and distribute with attribution.

🤝 Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

👤 Author
Alejandro Peralta — Process Automation Specialist

GitHub: @alejandro-orbis

LinkedIn: linkedin.com/in/alejandro-orbis

Email: alejandro@orbisautomations.com

Built with ❤️ using n8n, Google Gemini, and the Meta Business API.

Created to protect our forests and optimize forest management — one message at a time.

text


