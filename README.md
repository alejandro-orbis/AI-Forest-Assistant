# AI Forest Assistant

🌲 **AI Forest Assistant** is an omnichannel forest monitoring, alerting, and management system built with **n8n**, **Gemini AI**, **WhatsApp Business API**, **PostgreSQL/PostGIS**, **Google Maps**, **OpenWeatherMap**, **Google Sheets**, and **Gmail**.

It automates fire reports, pest tracking, permit requests, work reports, legal queries, supervisor escalation, weather-based fire alerts, and weekly dashboard reporting.

[![n8n](https://img.shields.io/badge/n8n-Workflow-orange?style=flat-square)](https://n8n.io/)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI-4285F4?style=flat-square&logo=google)](https://ai.google.dev)
[![WhatsApp](https://img.shields.io/badge/WhatsApp-Business_API-25D366?style=flat-square&logo=whatsapp)](https://developers.facebook.com/docs/whatsapp)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat-square&logo=postgresql)](https://www.postgresql.org/)
[![PostGIS](https://img.shields.io/badge/PostGIS-3.4-4169E1?style=flat-square)](https://postgis.net/)
[![Google Maps](https://img.shields.io/badge/Google_Maps-API-4285F4?style=flat-square&logo=googlemaps)](https://mapsplatform.google.com/)
[![OpenWeatherMap](https://img.shields.io/badge/OpenWeatherMap-API-FC4C02?style=flat-square)](https://openweathermap.org/api)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/Status-MVP-22c55e?style=flat-square)](https://github.com/alejandro-orbis)

---

## Documentation

| Language | File |
|---|---|
| English | [README.md](README.md) |
| Spanish | [README.ES.md](README.ES.md) |

---

## What it does

Forestry workers, citizens, or field teams can interact with the assistant through WhatsApp.

| Function | Description |
|---|---|
| Fire report | Reports smoke, fire, flames, burned areas, or possible thermal focus |
| Pest report | Detects pests such as pine processionary, red weevil, bark beetles, or tree diseases |
| Permit request | Processes requests for pruning, felling, clearing, or forestry authorizations |
| Legal query | Answers forestry regulation questions with a legal-context branch |
| Work report | Logs daily work hours, field tasks, and locations |
| Weather alert | Calculates fire risk from weather data and sends alerts |
| Supervisor escalation | Sends critical cases to a supervisor through WhatsApp |
| Pending coordinates | Associates a later coordinate message with the original pending case |
| Dashboard | Sends weekly metrics through Google Sheets, Gmail, and WhatsApp |

---

## Key features

| Feature | Description |
|---|---|
| WhatsApp-first workflow | WhatsApp Business API is used for incoming and outgoing messages |
| Gemini classification | Gemini classifies messages into fire, pest, permit, incident, legal query, work report, or other |
| Conversation state | Stores pending cases and associates follow-up coordinates automatically |
| Reverse geocoding | Converts coordinates into readable locations with Google Maps API |
| PostgreSQL + PostGIS | Stores cases and supports geospatial data |
| Smart escalation | Sends supervisor alerts for high-priority cases such as fires |
| Legal RAG branch | Uses layered forestry regulation context for legal questions |
| Weather alerts | Uses weather data to estimate fire risk levels |
| Dashboard metrics | Generates weekly metrics and stores historical snapshots |
| Rate limiting | Prevents spam and repeated processing per conversation |

---

## High-level architecture

```text
Webhook WhatsApp
└── Parse WhatsApp
    └── Rate Limiter
        └── PostgreSQL: Read Conversation State
            └── IF Pending Coordinates?
                ├── YES
                │   └── Extract Coordinates
                │       └── Build SQL Update
                │           └── Update Pending Case
                │               └── Reverse Geocoding
                │                   └── Prepare User Response
                │                       ├── Send WhatsApp to User
                │                       ├── Clear Conversation State
                │                       └── IF Escalate Updated Case?
                │                           ├── YES → Send WhatsApp to Supervisor
                │                           └── NO → Do Nothing
                └── NO
                    └── IF Legal Query?
                        ├── YES → Legal RAG → Save Query → Send Response
                        └── NO
                            └── Gemini Classifier
                                └── Process Classification
                                    └── IF Create Case?
                                        ├── NO → Send Casual Response
                                        └── YES
                                            └── Validate Coordinates
                                                └── IF Coordinates Valid?
                                                    ├── YES → Reverse Geocoding → Save Case
                                                    └── NO → Save Pending State → Ask for Coordinates
```

---

## Conversation state for pending coordinates

The system handles multi-turn conversations where the user first reports a case and sends the location later.

| State | Description | Next step |
|---|---|---|
| `waiting_coords` | The system is waiting for coordinates for an existing case | User sends coordinates |
| completed | Case is updated and state is cleared | End |

Example:

```text
User: Hay humo en el bosque
Assistant: Necesito la ubicación exacta.

User: 40.4168, -3.7038
Assistant: Caso completado con coordenadas.
Supervisor: Case updated with location.
```

---

## Tech stack

| Tool | Usage |
|---|---|
| n8n | Workflow orchestration |
| Gemini AI | Intent classification and legal responses |
| WhatsApp Business API | Messaging channel |
| PostgreSQL | Main database |
| PostGIS | Geospatial storage and queries |
| Google Maps API | Reverse geocoding |
| OpenWeatherMap | Weather data for fire risk |
| Google Sheets | Dashboard history |
| Gmail | Email summaries and notifications |

---

## Workflows

| Workflow | File | Purpose |
|---|---|---|
| Core | `workflows/AI_Forest_Assistant_01_Core_WhatsApp.json` | Main WhatsApp case workflow |
| Weather alerts | `workflows/AI_Forest_Assistant_02_Alertas_Clima.json` | Fire-risk weather alerts |
| Dashboard | `workflows/AI_Forest_Assistant_03_Dashboard_Metricas.json` | Metrics, reporting, Sheets, email, WhatsApp |

---

## Project structure

```text
AI-Forest-Assistant/
├── README.md
├── README.ES.md
├── LICENSE
├── workflows/
│   ├── AI_Forest_Assistant_01_Core_WhatsApp.json
│   ├── AI_Forest_Assistant_02_Alertas_Clima.json
│   └── AI_Forest_Assistant_03_Dashboard_Metricas.json
├── database/
│   ├── schema.sql
│   ├── triggers.sql
│   └── indexes.sql
└── assets/
    └── screenshots/
        ├── workflow_overview.png
        ├── fire_alert_whatsapp.png
        ├── legal_query_whatsapp.png
        ├── dashboard_metrics.png
        ├── postgres_tables.png
        ├── postgis_location.png
        ├── reverse_geocoding.png
        └── google_sheets_dashboard.png
```

---

## Screenshots

| Workflow overview | WhatsApp fire alert | Legal query response | Dashboard metrics |
|---|---|---|---|
| ![Workflow overview](assets/screenshots/workflow_overview.png) | ![Fire alert](assets/screenshots/fire_alert_whatsapp.png) | ![Legal query](assets/screenshots/legal_query_whatsapp.png) | ![Dashboard](assets/screenshots/dashboard_metrics.png) |

| PostgreSQL tables | PostGIS location | Reverse geocoding | Google Sheets dashboard |
|---|---|---|---|
| ![PostgreSQL tables](assets/screenshots/postgres_tables.png) | ![PostGIS location](assets/screenshots/postgis_location.png) | ![Reverse geocoding](assets/screenshots/reverse_geocoding.png) | ![Google Sheets dashboard](assets/screenshots/google_sheets_dashboard.png) |

---

## Setup guide

### 1. Prerequisites

- n8n instance, self-hosted or cloud
- PostgreSQL 13+ with PostGIS enabled
- Meta for Developers account with WhatsApp Business API access
- Google Cloud account for Gemini AI and Google Maps
- OpenWeatherMap account
- Google Sheets account
- Gmail account

### 2. Environment variables

Store all credentials as environment variables. Do not hardcode secrets inside workflow nodes.

```env
GEMINI_API_KEY=
META_ACCESS_TOKEN=
META_VERIFY_TOKEN=
WHATSAPP_PHONE_NUMBER_ID=
GOOGLE_MAPS_API_KEY=
OPENWEATHER_API_KEY=
SUPERVISOR_WHATSAPP=
SUPERVISOR_EMAIL=
RATE_LIMIT_PER_MINUTE=15
```

### 3. n8n credentials

| Credential | Usage |
|---|---|
| PostgreSQL | Database connection |
| Google Sheets OAuth | Dashboard historical rows |
| Gmail OAuth | Email summaries |
| WhatsApp token via env vars | WhatsApp Business API |
| Gemini API key via env vars | Classification and legal responses |
| Google Maps API key via env vars | Reverse geocoding |
| OpenWeatherMap API key via env vars | Weather risk alerts |

### 4. Database setup

Run the database scripts in order:

```bash
psql -U postgres -f database/schema.sql
psql -U postgres -f database/triggers.sql
psql -U postgres -f database/indexes.sql
```

Enable PostGIS if it is not already enabled:

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

### 5. Google Sheets dashboard

Create a Google Sheet named:

```text
AI Forest Assistant - Dashboard
```

Create or rename a tab:

```text
Dashboard
```

Recommended headers:

```text
FECHA
INCIDENTES_TOTAL
INCIDENTES_ALTA
INCIDENTES_MEDIA
INCIDENTES_BAJA
INCENDIOS
PLAGAS
PERMISOS
INCIDENCIAS
PARTES_TRABAJO
CONSULTAS_LEGALES
ALERTAS_TOTAL
ALERTAS_EXTREMO
ALERTAS_ALTO
ALERTAS_MODERADO
ALERTAS_BAJO
TOP_UBICACIONES
INCIDENTES_POR_TIPO_JSON
ALERTAS_JSON
GENERADO_EN
```

### 6. Import workflows into n8n

In n8n, go to:

```text
Menu → Import from File
```

Import the workflow JSON files from the `workflows/` folder.

### 7. Configure WhatsApp webhook

| Field | Value |
|---|---|
| Callback URL | `https://your-n8n-domain.com/webhook/omnichannel-webhook` |
| Verify Token | `META_VERIFY_TOKEN` |
| Webhook events | WhatsApp messages |

### 8. Activate workflows

Activate the three workflows in n8n:

- Core WhatsApp workflow
- Weather alerts workflow
- Dashboard metrics workflow

---

## Database structure

### `forest_incidents`

| Column | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `case_id` | TEXT | User-friendly case ID |
| `incident_type` | TEXT | Fire, incident, or other general case |
| `description` | TEXT | Case summary |
| `priority` | TEXT | ALTA, MEDIA, BAJA |
| `reporter_name` | TEXT | User name |
| `reporter_phone` | TEXT | WhatsApp number |
| `latitude` | DOUBLE PRECISION | Latitude |
| `longitude` | DOUBLE PRECISION | Longitude |
| `location` | GEOGRAPHY/GEOMETRY | PostGIS point |
| `parcela` | TEXT | Plot number |
| `status` | TEXT | ABIERTO, CERRADO |
| `ai_classification` | TEXT | AI output category |
| `assigned_to` | TEXT | Assigned team/person |
| `metadata` | JSONB | Additional details |

### `pest_cases`

| Column | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `pest_type` | TEXT | Pest or disease, e.g. procesionaria, picudo rojo |
| `affected_tree` | TEXT | Affected tree/species, e.g. pino, palmera |
| `description` | TEXT | Case summary |
| `latitude` | DOUBLE PRECISION | Latitude |
| `longitude` | DOUBLE PRECISION | Longitude |
| `severity` | TEXT | ALTA, MEDIA, BAJA |
| `status` | TEXT | ABIERTO, CERRADO |
| `metadata` | JSONB | Case ID and additional fields |

### `permits`

| Column | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `permit_type` | TEXT | Felling, pruning, clearing, etc. |
| `applicant_name` | TEXT | Applicant name |
| `applicant_phone` | TEXT | Applicant phone |
| `description` | TEXT | Request description |
| `latitude` | DOUBLE PRECISION | Latitude |
| `longitude` | DOUBLE PRECISION | Longitude |
| `urgency` | TEXT | ALTA, MEDIA, BAJA |
| `status` | TEXT | PENDING, APPROVED, REJECTED |
| `metadata` | JSONB | Case ID and additional fields |

### `work_reports`

| Column | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `worker_name` | TEXT | Worker name |
| `hours_worked` | DECIMAL | Hours worked |
| `tasks_completed` | TEXT | Tasks completed |
| `location_text` | TEXT | Textual location |
| `latitude` | DOUBLE PRECISION | Latitude |
| `longitude` | DOUBLE PRECISION | Longitude |
| `metadata` | JSONB | Additional details |

### `queries`

| Column | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `case_id` | TEXT | Query ID |
| `query_type` | TEXT | CONSULTA_NORMATIVA |
| `question` | TEXT | User question |
| `answer` | TEXT | Assistant answer |
| `user_phone` | TEXT | User phone |
| `user_name` | TEXT | User name |
| `metadata` | JSONB | Additional details |

### `fire_alerts`

| Column | Type | Description |
|---|---|---|
| `id` | UUID | Primary key |
| `zone_name` | TEXT | Forest zone name |
| `temperature` | DECIMAL | Temperature |
| `humidity` | DECIMAL | Humidity |
| `wind_speed` | DECIMAL | Wind speed |
| `fire_risk` | TEXT | EXTREMO, ALTO, MODERADO, BAJO |
| `alert_sent` | BOOLEAN | Whether alert was sent |
| `created_at` | TIMESTAMP | Creation timestamp |

### `conversation_state`

| Column | Type | Description |
|---|---|---|
| `user_phone` | TEXT | User phone |
| `current_state` | TEXT | Usually `waiting_coords` |
| `pending_case_id` | TEXT | Case waiting for coordinates |
| `pending_type` | TEXT | INCENDIO, PLAGA, PERMISO, INCIDENCIA |
| `context_data` | JSONB | Optional context |
| `created_at` | TIMESTAMP | Created at |
| `updated_at` | TIMESTAMP | Updated at |

---

## PostGIS trigger example

The `location` column in `forest_incidents` can be updated automatically from latitude and longitude.

```sql
CREATE OR REPLACE FUNCTION update_incident_location()
RETURNS trigger AS $$
BEGIN
  IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
    NEW.location := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_incident_location
BEFORE INSERT OR UPDATE ON forest_incidents
FOR EACH ROW
EXECUTE FUNCTION update_incident_location();
```

---

## Key workflow nodes

| Node | Function |
|---|---|
| Parse WhatsApp | Normalizes incoming WhatsApp messages |
| Rate Limiter | Limits messages per conversation |
| PostgreSQL: Read State | Checks if the user has a pending case |
| IF Pending State? | Routes coordinates to the pending case |
| Extract Coordinates | Extracts latitude and longitude from text |
| Build SQL Update | Updates the correct table for the pending case |
| IF Legal Query? | Detects legal questions |
| Gemini Legal Response | Generates legal/contextual response |
| Gemini Classifier | Classifies operational intent |
| Process Classification | Normalizes Gemini output and decides `crear_caso` |
| IF Create Case? | Skips casual messages |
| Validate Coordinates | Validates coordinate ranges |
| Reverse Geocoding | Converts coordinates into readable location |
| IF Missing Coordinates? | Saves pending state and asks for location |
| Prepare Registration | Builds payload for the correct table |
| Switch | Routes to `forest_incidents`, `pest_cases`, `permits`, or `work_reports` |
| Prepare User Response | Formats user response with ID and location |
| Notify Supervisor | Sends high-priority alerts |
| Dashboard Metrics | Builds weekly metrics and reports |

---

## Dashboard metrics

The dashboard workflow runs daily and summarizes the last seven days.

It collects:

- total cases
- incidents by type
- high/medium/low priority totals
- pest, permit, work report, and incident counts
- legal query count
- fire alert count
- top locations
- JSON snapshots for advanced dashboards

Outputs:

- Google Sheets historical row
- email to supervisor
- WhatsApp summary to supervisor

---

## Security notes

- Store all API keys and tokens as environment variables.
- Never commit `.env` files.
- Do not hardcode Meta, Gemini, Google Maps, or OpenWeatherMap credentials.
- Enable PostgreSQL Row Level Security if you adapt this for multi-tenant use.
- Keep WhatsApp webhook verification tokens private.
- Use rate limiting to reduce spam and repeated emergency messages.

---

## Roadmap

- Multi-channel support for Instagram and Facebook Messenger
- Live web dashboard with map
- Duplicate incident detection
- Supervisor assignment by zone or incident type
- Case lifecycle management: open, in progress, resolved, closed
- Photo analysis for pests and fire evidence
- Automated PDF reports
- Multi-tenant organization support

---

## License

MIT License — free to use, modify, and distribute with attribution.

---

## Author

**Alejandro Peralta**  
Process Automation Specialist

- GitHub: [@alejandro-orbis](https://github.com/alejandro-orbis)
- LinkedIn: [linkedin.com/in/alejandro-orbis](https://linkedin.com/in/alejandro-orbis)
- Email: alejandro@orbisautomations.com

Built with ❤️ using n8n, Google Gemini, and the Meta Business API.

Created to protect forests and optimize forest management — one message at a time.
