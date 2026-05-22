-- ============================================================
-- AI Forest Assistant - Indexes
-- PostgreSQL + PostGIS
-- ============================================================

-- ============================================================
-- forest_incidents
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_forest_incidents_created_at
ON forest_incidents(created_at);

CREATE INDEX IF NOT EXISTS idx_forest_incidents_case_id
ON forest_incidents(case_id);

CREATE INDEX IF NOT EXISTS idx_forest_incidents_type
ON forest_incidents(incident_type);

CREATE INDEX IF NOT EXISTS idx_forest_incidents_priority
ON forest_incidents(priority);

CREATE INDEX IF NOT EXISTS idx_forest_incidents_status
ON forest_incidents(status);

CREATE INDEX IF NOT EXISTS idx_forest_incidents_location
ON forest_incidents
USING GIST(location);

CREATE INDEX IF NOT EXISTS idx_forest_incidents_metadata
ON forest_incidents
USING GIN(metadata);

-- ============================================================
-- pest_cases
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_pest_cases_created_at
ON pest_cases(created_at);

CREATE INDEX IF NOT EXISTS idx_pest_cases_case_id
ON pest_cases(case_id);

CREATE INDEX IF NOT EXISTS idx_pest_cases_severity
ON pest_cases(severity);

CREATE INDEX IF NOT EXISTS idx_pest_cases_location
ON pest_cases
USING GIST(location);

CREATE INDEX IF NOT EXISTS idx_pest_cases_metadata
ON pest_cases
USING GIN(metadata);

-- ============================================================
-- permits
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_permits_created_at
ON permits(created_at);

CREATE INDEX IF NOT EXISTS idx_permits_case_id
ON permits(case_id);

CREATE INDEX IF NOT EXISTS idx_permits_status
ON permits(status);

CREATE INDEX IF NOT EXISTS idx_permits_urgency
ON permits(urgency);

CREATE INDEX IF NOT EXISTS idx_permits_location
ON permits
USING GIST(location);

CREATE INDEX IF NOT EXISTS idx_permits_metadata
ON permits
USING GIN(metadata);

-- ============================================================
-- work_reports
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_work_reports_created_at
ON work_reports(created_at);

CREATE INDEX IF NOT EXISTS idx_work_reports_worker_name
ON work_reports(worker_name);

CREATE INDEX IF NOT EXISTS idx_work_reports_location
ON work_reports
USING GIST(location);

CREATE INDEX IF NOT EXISTS idx_work_reports_metadata
ON work_reports
USING GIN(metadata);

-- ============================================================
-- queries
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_queries_created_at
ON queries(created_at);

CREATE INDEX IF NOT EXISTS idx_queries_case_id
ON queries(case_id);

CREATE INDEX IF NOT EXISTS idx_queries_query_type
ON queries(query_type);

CREATE INDEX IF NOT EXISTS idx_queries_metadata
ON queries
USING GIN(metadata);

-- ============================================================
-- fire_alerts
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_fire_alerts_created_at
ON fire_alerts(created_at);

CREATE INDEX IF NOT EXISTS idx_fire_alerts_fire_risk
ON fire_alerts(fire_risk);

CREATE INDEX IF NOT EXISTS idx_fire_alerts_alert_sent
ON fire_alerts(alert_sent);

CREATE INDEX IF NOT EXISTS idx_fire_alerts_metadata
ON fire_alerts
USING GIN(metadata);

-- ============================================================
-- conversation_state
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_conversation_state_current_state
ON conversation_state(current_state);

CREATE INDEX IF NOT EXISTS idx_conversation_state_pending_case_id
ON conversation_state(pending_case_id);

CREATE INDEX IF NOT EXISTS idx_conversation_state_updated_at
ON conversation_state(updated_at);
