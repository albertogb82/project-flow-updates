-- Migración para la versión 1.3.19 (2026-06-11)
-- Garantiza columna screen_id en workflow_transitions
ALTER TABLE public.workflow_transitions ADD COLUMN IF NOT EXISTS screen_id TEXT;
