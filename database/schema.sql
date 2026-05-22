-- ============================================================
-- AI Forest Assistant - Database Schema
-- PostgreSQL + PostGIS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================================
-- General forest incidents
-- ============================================================

CREATE TABLE IF NOT EXISTS forest_incidents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id TEXT UNIQUE,
    incident_type TEXT NOT NULL,
    description TEXT,
    priority TEXT DEFAULT 'MEDIA',
    reporter_name TEXT,
    reporter_phone TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location GEOMETRY(Point, 4326),
    parcela TEXT,
    status TEXT DEFAULT 'ABIERTO',
    ai_classification TEXT,
    assigned_to TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- Pest cases
-- ============================================================

CREATE TABLE IF NOT EXISTS pest_cases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id TEXT UNIQUE,
    pest_type TEXT,
    affected_tree TEXT,
    description TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location GEOMETRY(Point, 4326),
    severity TEXT DEFAULT 'MEDIA',
    status TEXT DEFAULT 'ABIERTO',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- Forestry permits
-- ============================================================

CREATE TABLE IF NOT EXISTS permits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id TEXT UNIQUE,
    permit_type TEXT,
    applicant_name TEXT,
    applicant_phone TEXT,
    description TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location GEOMETRY(Point, 4326),
    urgency TEXT DEFAULT 'MEDIA',
    status TEXT DEFAULT 'PENDIENTE',
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- Daily work reports
-- ============================================================

CREATE TABLE IF NOT EXISTS work_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    worker_name TEXT,
    hours_worked NUMERIC,
    tasks_completed TEXT,
    location_text TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    location GEOMETRY(Point, 4326),
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- Legal / normative queries
-- ============================================================

CREATE TABLE IF NOT EXISTS queries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    case_id TEXT UNIQUE,
    query_type TEXT DEFAULT 'CONSULTA_NORMATIVA',
    question TEXT,
    answer TEXT,
    user_phone TEXT,
    user_name TEXT,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- Weather / wildfire risk alerts
-- ============================================================

CREATE TABLE IF NOT EXISTS fire_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    zone_name TEXT,
    temperature NUMERIC,
    humidity NUMERIC,
    wind_speed NUMERIC,
    fire_risk TEXT,
    alert_sent BOOLEAN DEFAULT false,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- Conversation state for multi-step WhatsApp flows
-- ============================================================

CREATE TABLE IF NOT EXISTS conversation_state (
    user_phone TEXT PRIMARY KEY,
    current_state TEXT,
    pending_case_id TEXT,
    pending_type TEXT,
    context_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
