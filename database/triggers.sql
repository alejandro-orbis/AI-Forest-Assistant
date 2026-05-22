-- ============================================================
-- AI Forest Assistant - Triggers
-- PostgreSQL + PostGIS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================================
-- updated_at helper
-- ============================================================

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS trigger AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- PostGIS location helper
-- ============================================================

CREATE OR REPLACE FUNCTION set_location_from_coordinates()
RETURNS trigger AS $$
BEGIN
    IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
        NEW.location := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- forest_incidents triggers
-- ============================================================

DROP TRIGGER IF EXISTS trg_forest_incidents_updated_at ON forest_incidents;
CREATE TRIGGER trg_forest_incidents_updated_at
BEFORE UPDATE ON forest_incidents
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_forest_incidents_location ON forest_incidents;
CREATE TRIGGER trg_forest_incidents_location
BEFORE INSERT OR UPDATE ON forest_incidents
FOR EACH ROW
EXECUTE FUNCTION set_location_from_coordinates();

-- ============================================================
-- pest_cases triggers
-- ============================================================

DROP TRIGGER IF EXISTS trg_pest_cases_updated_at ON pest_cases;
CREATE TRIGGER trg_pest_cases_updated_at
BEFORE UPDATE ON pest_cases
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_pest_cases_location ON pest_cases;
CREATE TRIGGER trg_pest_cases_location
BEFORE INSERT OR UPDATE ON pest_cases
FOR EACH ROW
EXECUTE FUNCTION set_location_from_coordinates();

-- ============================================================
-- permits triggers
-- ============================================================

DROP TRIGGER IF EXISTS trg_permits_updated_at ON permits;
CREATE TRIGGER trg_permits_updated_at
BEFORE UPDATE ON permits
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_permits_location ON permits;
CREATE TRIGGER trg_permits_location
BEFORE INSERT OR UPDATE ON permits
FOR EACH ROW
EXECUTE FUNCTION set_location_from_coordinates();

-- ============================================================
-- work_reports triggers
-- ============================================================

DROP TRIGGER IF EXISTS trg_work_reports_updated_at ON work_reports;
CREATE TRIGGER trg_work_reports_updated_at
BEFORE UPDATE ON work_reports
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_work_reports_location ON work_reports;
CREATE TRIGGER trg_work_reports_location
BEFORE INSERT OR UPDATE ON work_reports
FOR EACH ROW
EXECUTE FUNCTION set_location_from_coordinates();

-- ============================================================
-- conversation_state triggers
-- ============================================================

DROP TRIGGER IF EXISTS trg_conversation_state_updated_at ON conversation_state;
CREATE TRIGGER trg_conversation_state_updated_at
BEFORE UPDATE ON conversation_state
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
