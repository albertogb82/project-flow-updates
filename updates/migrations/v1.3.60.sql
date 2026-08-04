-- Migration v1.3.60: Atlassian Rovo & Jira Connector
CREATE TABLE IF NOT EXISTS public.app_preferences (
  setting_key text PRIMARY KEY,
  setting_value jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now()
);
