-- ══════════════════════════════════════════════════════════════════════════════
-- School branding — co-branded parent/teacher experience
--
-- Adds display_name, short_name, tagline, logo_url columns to the schools table
-- so each school can present its own identity inside the app instead of seeing
-- the Habterra wordmark. Habterra remains attributed in the user-dropdown
-- ("Powered by Habterra") and on the public marketing site.
--
-- Run this in the Supabase SQL Editor. Idempotent — safe to re-run.
-- ══════════════════════════════════════════════════════════════════════════════

ALTER TABLE schools ADD COLUMN IF NOT EXISTS display_name text;
ALTER TABLE schools ADD COLUMN IF NOT EXISTS short_name   text;
ALTER TABLE schools ADD COLUMN IF NOT EXISTS tagline      text;
ALTER TABLE schools ADD COLUMN IF NOT EXISTS logo_url     text;

-- Backfill: when display_name is NULL, the app falls back to schools.name.
-- These updates set the explicit display label and a tagline that reads well
-- under the wordmark in the topbar.

UPDATE schools
SET display_name = 'Woodstock School',
    short_name   = 'Woodstock',
    tagline      = 'Parent & Teacher Companion',
    -- Served from public/schools/woodstock/. The mark-white variant is the
    -- white-on-transparent seal — sized for the dark teal topbar. A color
    -- and black variant are also bundled for any light-background surfaces
    -- we add later (certificates, parent print-outs).
    logo_url     = '/schools/woodstock/mark-white.png'
WHERE domain = 'woodstockschool.in';

UPDATE schools
SET display_name = 'NLIS Riyadh',
    short_name   = 'NLIS',
    tagline      = 'Parent & Teacher Companion'
WHERE domain = 'nlis.edu.sa';

-- Verification
-- SELECT name, display_name, short_name, tagline, logo_url FROM schools ORDER BY name;
