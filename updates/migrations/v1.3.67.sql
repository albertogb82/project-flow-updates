-- Migración acumulativa para la versión 1.3.67 (2026-08-06)
-- Basada en la migración previa de la versión 1.3.66

-- Migración acumulativa para la versión 1.3.66 (2026-08-05)
-- Basada en la migración previa de la versión 1.3.65

-- Migración acumulativa para la versión 1.3.65 (2026-08-05)
-- Basada en la migración previa de la versión 1.3.64

-- Migración acumulativa para la versión 1.3.64 (2026-08-04)
-- Basada en la migración previa de la versión 1.3.63

-- Migración acumulativa para la versión 1.3.63 (2026-08-04)
-- Basada en la migración previa de la versión 1.3.62

-- Migración acumulativa para la versión 1.3.62 (2026-08-04)
-- Basada en la migración previa de la versión 1.3.61

-- Migración acumulativa para la versión 1.3.61 (2026-08-04)
-- Basada en la migración previa de la versión 1.3.59

-- Migración acumulativa para la versión 1.3.59 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.58

-- Migración acumulativa para la versión 1.3.58 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.57

-- Migración acumulativa para la versión 1.3.57 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.56

-- Migración acumulativa para la versión 1.3.56 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.55

-- Migración acumulativa para la versión 1.3.55 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.54

-- Migración acumulativa para la versión 1.3.54 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.53

-- Migración acumulativa para la versión 1.3.53 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.52

-- Migración acumulativa para la versión 1.3.52 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.51

-- Migración acumulativa para la versión 1.3.51 (2026-08-03)
-- Basada en la migración previa de la versión 1.3.50

-- Migración acumulativa para la versión 1.3.50 (2026-07-20)
-- Basada en la migración previa de la versión 1.3.49

-- Migración acumulativa para la versión 1.3.49 (2026-07-16)
-- Basada en la migración previa de la versión 1.3.48

-- Migración acumulativa para la versión 1.3.48 (2026-07-16)
-- Basada en la migración previa de la versión 1.3.47

-- Migración acumulativa para la versión 1.3.47 (2026-07-16)
-- Basada en la migración previa de la versión 1.3.46

-- Migración acumulativa para la versión 1.3.46 (2026-07-16)
-- Basada en la migración previa de la versión 1.3.45

-- Migración acumulativa para la versión 1.3.45 (2026-07-16)
-- Basada en la migración previa de la versión 1.3.44

-- Migración acumulativa para la versión 1.3.44 (2026-07-16)
-- Basada en la migración previa de la versión 1.3.43

-- Migración para la versión 1.3.43 (2026-07-15)
-- Actualización de metadatos de ProjectFlow para vistas previas en Telegram y redes sociales
SELECT 1;


-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.44] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.45] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.46] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.47] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.48] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.49] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.50] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.51] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.52] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.53] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.54] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.55] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.56] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.57] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.58] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.59] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.61] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.62] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.63] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.64] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.65] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);


-- CAMBIOS DESDE 20260805_system_audit_logs.sql --
-- Migration: Add system_audit_logs table and retention setting with database triggers
CREATE TABLE IF NOT EXISTS public.system_audit_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    user_email TEXT,
    user_name TEXT,
    action TEXT NOT NULL,
    category TEXT DEFAULT 'GENERAL',
    details JSONB DEFAULT '{}'::jsonb,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sys_audit_created_at ON public.system_audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_sys_audit_user_id ON public.system_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_sys_audit_category ON public.system_audit_logs(category);
CREATE INDEX IF NOT EXISTS idx_sys_audit_action ON public.system_audit_logs(action);

ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS audit_log_retention_days INTEGER DEFAULT 30;

-- Trigger Function for Issues (Captures ALL manual, API, transition, and automation events)
CREATE OR REPLACE FUNCTION trigger_system_audit_log_issue()
RETURNS TRIGGER AS $$
DECLARE
    v_user_email TEXT;
    v_user_name TEXT;
    v_user_id TEXT;
    v_details JSONB;
BEGIN
    v_user_email := NULLIF(current_setting('request.jwt.claim.email', true), '');
    v_user_id := NULLIF(current_setting('request.jwt.claim.sub', true), '');
    IF v_user_id IS NULL THEN
        v_user_id := NULLIF(current_setting('request.jwt.claim.user_id', true), '');
    END IF;

    IF TG_OP = 'INSERT' THEN
        v_user_email := COALESCE(v_user_email, NEW.reporter, 'sistema');
        v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
        v_details := jsonb_build_object(
            'issue_id', NEW.id,
            'issue_key', NEW.key,
            'project_id', NEW.project_id,
            'title', NEW.title,
            'status_id', NEW.status_id,
            'type_id', NEW.type_id
        );
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, 'system'),
            v_user_email,
            v_user_name,
            'CREATE_ISSUE',
            'INCIDENCIAS',
            v_details,
            NOW()
        );
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.status_id IS DISTINCT FROM OLD.status_id OR
           NEW.title IS DISTINCT FROM OLD.title OR
           NEW.assignee IS DISTINCT FROM OLD.assignee OR
           NEW.priority IS DISTINCT FROM OLD.priority OR
           NEW.description IS DISTINCT FROM OLD.description OR
           NEW.type_id IS DISTINCT FROM OLD.type_id OR
           NEW.deleted_at IS DISTINCT FROM OLD.deleted_at THEN

            v_user_email := COALESCE(v_user_email, 'sistema');
            v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
            v_details := jsonb_build_object(
                'issue_id', NEW.id,
                'issue_key', NEW.key,
                'project_id', NEW.project_id,
                'title', NEW.title,
                'status_id', NEW.status_id,
                'old_status', OLD.status_id,
                'new_status', NEW.status_id,
                'old_assignee', OLD.assignee,
                'new_assignee', NEW.assignee,
                'old_title', OLD.title,
                'new_title', NEW.title
            );
            INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
            VALUES (
                'audit_' || md5(random()::text || clock_timestamp()::text),
                COALESCE(v_user_id, 'system'),
                v_user_email,
                v_user_name,
                'UPDATE_ISSUE',
                'INCIDENCIAS',
                v_details,
                NOW()
            );
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        v_user_email := COALESCE(v_user_email, 'sistema');
        v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
        v_details := jsonb_build_object(
            'issue_id', OLD.id,
            'issue_key', OLD.key,
            'project_id', OLD.project_id,
            'title', OLD.title
        );
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, 'system'),
            v_user_email,
            v_user_name,
            'DELETE_ISSUE',
            'INCIDENCIAS',
            v_details,
            NOW()
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sys_audit_issue_trigger ON public.issues;
CREATE TRIGGER sys_audit_issue_trigger
AFTER INSERT OR UPDATE OR DELETE ON public.issues
FOR EACH ROW
EXECUTE FUNCTION trigger_system_audit_log_issue();

-- Trigger Function for Comments
CREATE OR REPLACE FUNCTION trigger_system_audit_log_comment()
RETURNS TRIGGER AS $$
DECLARE
    v_user_email TEXT;
    v_user_name TEXT;
    v_user_id TEXT;
BEGIN
    v_user_email := NULLIF(current_setting('request.jwt.claim.email', true), '');
    v_user_id := NULLIF(current_setting('request.jwt.claim.sub', true), '');
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, NEW.author, 'system'),
            COALESCE(v_user_email, 'sistema'),
            COALESCE(v_user_email, NEW.author, 'sistema'),
            'ADD_COMMENT',
            'INCIDENCIAS',
            jsonb_build_object(
                'issue_id', NEW.issue_id,
                'comment_id', NEW.id,
                'comment_body', NEW.body
            ),
            NOW()
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sys_audit_comment_trigger ON public.comments;
CREATE TRIGGER sys_audit_comment_trigger
AFTER INSERT ON public.comments
FOR EACH ROW
EXECUTE FUNCTION trigger_system_audit_log_comment();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.66] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);


-- CAMBIOS DESDE 20260805_system_audit_logs.sql --
-- Migration: Add system_audit_logs table and retention setting with database triggers
CREATE TABLE IF NOT EXISTS public.system_audit_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    user_email TEXT,
    user_name TEXT,
    action TEXT NOT NULL,
    category TEXT DEFAULT 'GENERAL',
    details JSONB DEFAULT '{}'::jsonb,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sys_audit_created_at ON public.system_audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_sys_audit_user_id ON public.system_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_sys_audit_category ON public.system_audit_logs(category);
CREATE INDEX IF NOT EXISTS idx_sys_audit_action ON public.system_audit_logs(action);

ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS audit_log_retention_days INTEGER DEFAULT 30;

-- Trigger Function for Issues (Captures ALL manual, API, transition, and automation events)
CREATE OR REPLACE FUNCTION trigger_system_audit_log_issue()
RETURNS TRIGGER AS $$
DECLARE
    v_user_email TEXT;
    v_user_name TEXT;
    v_user_id TEXT;
    v_details JSONB;
BEGIN
    v_user_email := NULLIF(current_setting('request.jwt.claim.email', true), '');
    v_user_id := NULLIF(current_setting('request.jwt.claim.sub', true), '');
    IF v_user_id IS NULL THEN
        v_user_id := NULLIF(current_setting('request.jwt.claim.user_id', true), '');
    END IF;

    IF TG_OP = 'INSERT' THEN
        v_user_email := COALESCE(v_user_email, NEW.reporter, 'sistema');
        v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
        v_details := jsonb_build_object(
            'issue_id', NEW.id,
            'issue_key', NEW.key,
            'project_id', NEW.project_id,
            'title', NEW.title,
            'status_id', NEW.status_id,
            'type_id', NEW.type_id
        );
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, 'system'),
            v_user_email,
            v_user_name,
            'CREATE_ISSUE',
            'INCIDENCIAS',
            v_details,
            NOW()
        );
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.status_id IS DISTINCT FROM OLD.status_id OR
           NEW.title IS DISTINCT FROM OLD.title OR
           NEW.assignee IS DISTINCT FROM OLD.assignee OR
           NEW.priority IS DISTINCT FROM OLD.priority OR
           NEW.description IS DISTINCT FROM OLD.description OR
           NEW.type_id IS DISTINCT FROM OLD.type_id OR
           NEW.deleted_at IS DISTINCT FROM OLD.deleted_at THEN

            v_user_email := COALESCE(v_user_email, 'sistema');
            v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
            v_details := jsonb_build_object(
                'issue_id', NEW.id,
                'issue_key', NEW.key,
                'project_id', NEW.project_id,
                'title', NEW.title,
                'status_id', NEW.status_id,
                'old_status', OLD.status_id,
                'new_status', NEW.status_id,
                'old_assignee', OLD.assignee,
                'new_assignee', NEW.assignee,
                'old_title', OLD.title,
                'new_title', NEW.title
            );
            INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
            VALUES (
                'audit_' || md5(random()::text || clock_timestamp()::text),
                COALESCE(v_user_id, 'system'),
                v_user_email,
                v_user_name,
                'UPDATE_ISSUE',
                'INCIDENCIAS',
                v_details,
                NOW()
            );
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        v_user_email := COALESCE(v_user_email, 'sistema');
        v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
        v_details := jsonb_build_object(
            'issue_id', OLD.id,
            'issue_key', OLD.key,
            'project_id', OLD.project_id,
            'title', OLD.title
        );
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, 'system'),
            v_user_email,
            v_user_name,
            'DELETE_ISSUE',
            'INCIDENCIAS',
            v_details,
            NOW()
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sys_audit_issue_trigger ON public.issues;
CREATE TRIGGER sys_audit_issue_trigger
AFTER INSERT OR UPDATE OR DELETE ON public.issues
FOR EACH ROW
EXECUTE FUNCTION trigger_system_audit_log_issue();

-- Trigger Function for Comments
CREATE OR REPLACE FUNCTION trigger_system_audit_log_comment()
RETURNS TRIGGER AS $$
DECLARE
    v_user_email TEXT;
    v_user_name TEXT;
    v_user_id TEXT;
BEGIN
    v_user_email := NULLIF(current_setting('request.jwt.claim.email', true), '');
    v_user_id := NULLIF(current_setting('request.jwt.claim.sub', true), '');
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, NEW.author, 'system'),
            COALESCE(v_user_email, 'sistema'),
            COALESCE(v_user_email, NEW.author, 'sistema'),
            'ADD_COMMENT',
            'INCIDENCIAS',
            jsonb_build_object(
                'issue_id', NEW.issue_id,
                'comment_id', NEW.id,
                'comment_body', NEW.body
            ),
            NOW()
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sys_audit_comment_trigger ON public.comments;
CREATE TRIGGER sys_audit_comment_trigger
AFTER INSERT ON public.comments
FOR EACH ROW
EXECUTE FUNCTION trigger_system_audit_log_comment();




-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.67] --

-- CAMBIOS DESDE 20260701_project_specialists.sql --
-- Migration: Create project_specialists table
CREATE TABLE IF NOT EXISTS public.project_specialists (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    system_prompt TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    skills JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- CAMBIOS DESDE 20260701_project_specialists_telegram.sql --
-- Migration: Add Telegram features and Automations table to Project Specialists
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_token TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_chat_id TEXT;
ALTER TABLE public.project_specialists ADD COLUMN IF NOT EXISTS telegram_enabled BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS public.project_specialist_automations (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    specialist_id TEXT REFERENCES public.project_specialists(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    hour INTEGER NOT NULL,
    minute INTEGER NOT NULL,
    prompt TEXT NOT NULL,
    enabled BOOLEAN DEFAULT true,
    last_run TIMESTAMP WITH TIME ZONE
);


-- CAMBIOS DESDE 20260702_dynamic_specialist_skills.sql --
-- Migration: Create project_specialist_skills table
CREATE TABLE IF NOT EXISTS public.project_specialist_skills (
    id TEXT PRIMARY KEY,
    project_id TEXT REFERENCES public.projects(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    type TEXT NOT NULL, -- 'static_context' | 'sql_query'
    definition JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert a default crm skill so we can seamlessly transition the existing hardcoded crm skill!
INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES (
    'crm',
    NULL, -- Global skill
    'Acceso a Datos CRM',
    'Permite leer y analizar cuentas y oportunidades del CRM asociadas a este proyecto.',
    'sql_query',
    '{"query": "SELECT key, title, status_id, priority, type_id, created_at FROM public.issues WHERE project_id = $1 AND type_id IN (''opportunity'', ''account'') AND deleted_at IS NULL ORDER BY created_at DESC LIMIT 30"}'
) ON CONFLICT (id) DO NOTHING;


-- CAMBIOS DESDE 20260716_default_specialist_skills.sql --
-- Migration: Add default specialist skills for issues, CRM accounts, CRM contacts and CRM opportunities.
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS telegram_chat_id text UNIQUE;

INSERT INTO public.project_specialist_skills (id, project_id, name, description, type, definition)
VALUES 
(
    'gestion-issues',
    NULL,
    'Gestión de Incidencias (Issues)',
    'Permite leer y analizar incidencias del proyecto, incluyendo estados, asignados y prioridades para facilitar su filtrado.',
    'sql_query',
    '{"query": "SELECT i.key, i.title, i.description, ws.name as status, i.priority, u.display_name as assignee, r.display_name as reporter, i.parent_id, i.created_at FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id LEFT JOIN public.users u ON i.assignee = u.id LEFT JOIN public.users r ON i.reporter = r.id WHERE i.project_id = $1 AND i.type_id NOT IN (''account'', ''contact'', ''opportunity'') AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-accounts-contacts',
    NULL,
    'Cuentas y Contactos CRM',
    'Permite consultar la lista de cuentas de clientes, sus datos (VAT/CIF, email, web) y todos los contactos enlazados.',
    'sql_query',
    '{"query": "SELECT i.id, i.key, i.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_vat_cif'' LIMIT 1) as vat_cif, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_email'' LIMIT 1) as email, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_website'' LIMIT 1) as website, (SELECT jsonb_agg(jsonb_build_object(''contact_id'', c.id, ''contact_name'', c.title, ''email'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_email'' LIMIT 1), ''phone'', (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = c.id AND cf.field_key = ''cf_contact_phone'' LIMIT 1))) FROM public.issues c WHERE c.parent_id = i.id AND c.type_id = ''contact'' AND c.deleted_at IS NULL) as contacts FROM public.issues i LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''account'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 30"}'::jsonb
),
(
    'crm-opportunities',
    NULL,
    'Oportunidades CRM',
    'Permite consultar las oportunidades de negocio enlazadas a las cuentas, sus montos, probabilidades y fechas de cierre.',
    'sql_query',
    '{"query": "SELECT i.key, i.title as opportunity_name, p.title as account_name, ws.name as status, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_original_amount'' LIMIT 1) as amount, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_opportunity_currency'' LIMIT 1) as currency, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_close_probability'' LIMIT 1) as probability, (SELECT value FROM public.custom_field_values cfv JOIN public.custom_fields cf ON cfv.field_id = cf.id WHERE cfv.issue_id = i.id AND cf.field_key = ''cf_estimated_close_date'' LIMIT 1) as estimated_close_date FROM public.issues i LEFT JOIN public.issues p ON i.parent_id = p.id LEFT JOIN public.workflow_states ws ON i.status_id = ws.id WHERE i.project_id = $1 AND i.type_id = ''opportunity'' AND i.deleted_at IS NULL ORDER BY i.created_at DESC LIMIT 50"}'::jsonb
),
(
    'crm-instructions',
    NULL,
    'Guía de Operaciones CRM e Incidencias',
    'Instrucciones operativas para el especialista sobre cómo interactuar, consultar y guiar la creación de tareas, cuentas, contactos y oportunidades.',
    'static_context',
    '{"text": "Instrucciones de operaciones en ProjectFlow:\n1. Incidencias y tareas: Para interactuar, buscar o filtrar tareas, usa las herramientas searchIssues y getIssueDetails con PJQL.\n2. Cuentas CRM: Son de tipo ''account''. Tienen campos como VAT/CIF (cf_vat_cif), Email (cf_email), Web (cf_website), Industria (cf_industry), Dirección (cf_account_address) y País (cf_account_country). El sistema cuenta con Enriquecimiento Automático: al ingresar el nombre de la empresa en la interfaz web, se rellenarán estos campos automáticamente a través de internet. NO pidas estos datos al usuario; indícale que solo introduzca el nombre en la interfaz web y deje que el sistema los complete por él.\n3. Contactos CRM: Son de tipo ''contact'' con parent_id apuntando a la cuenta. Tienen campos como Email (cf_contact_email), Teléfono (cf_contact_phone), Cargo (cf_contact_job_title) y Departamento (cf_contact_department). Solicita estos datos si no están definidos.\n4. Oportunidades CRM: Son de tipo ''opportunity'' con parent_id apuntando a la cuenta. Tienen campos como Monto Original (cf_original_amount), Moneda (cf_opportunity_currency), Probabilidad de Cierre (cf_close_probability) y Fecha Estimada (cf_estimated_close_date). Solicita estos datos si no están definidos."}'::jsonb
)
ON CONFLICT (id) DO UPDATE SET 
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    type = EXCLUDED.type,
    definition = EXCLUDED.definition,
    updated_at = NOW();


-- CAMBIOS DESDE 20260720_license_discount_percent.sql --
-- Adición de columna discount_percent a la tabla system_settings
ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS discount_percent integer DEFAULT 0;


-- CAMBIOS DESDE 20260804_pat_and_ai_audit.sql --
-- Migration: Personal Access Tokens (PAT) & AI Audit Logs
-- Date: 2026-08-04

CREATE TABLE IF NOT EXISTS public.personal_access_tokens (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  scopes JSONB DEFAULT '["read", "write"]'::jsonb,
  expires_at TIMESTAMPTZ,
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_pat_token_hash ON public.personal_access_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_pat_user_id ON public.personal_access_tokens(user_id);

CREATE TABLE IF NOT EXISTS public.ai_audit_logs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_id TEXT,
  endpoint TEXT NOT NULL,
  method TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  ip_address TEXT,
  details JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_audit_user_id ON public.ai_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_audit_created_at ON public.ai_audit_logs(created_at);


-- CAMBIOS DESDE 20260805_system_audit_logs.sql --
-- Migration: Add system_audit_logs table and retention setting with database triggers
CREATE TABLE IF NOT EXISTS public.system_audit_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    user_email TEXT,
    user_name TEXT,
    action TEXT NOT NULL,
    category TEXT DEFAULT 'GENERAL',
    details JSONB DEFAULT '{}'::jsonb,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sys_audit_created_at ON public.system_audit_logs(created_at);
CREATE INDEX IF NOT EXISTS idx_sys_audit_user_id ON public.system_audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_sys_audit_category ON public.system_audit_logs(category);
CREATE INDEX IF NOT EXISTS idx_sys_audit_action ON public.system_audit_logs(action);

ALTER TABLE public.system_settings ADD COLUMN IF NOT EXISTS audit_log_retention_days INTEGER DEFAULT 30;

-- Trigger Function for Issues (Captures ALL manual, API, transition, and automation events)
CREATE OR REPLACE FUNCTION trigger_system_audit_log_issue()
RETURNS TRIGGER AS $$
DECLARE
    v_user_email TEXT;
    v_user_name TEXT;
    v_user_id TEXT;
    v_details JSONB;
BEGIN
    v_user_email := NULLIF(current_setting('request.jwt.claim.email', true), '');
    v_user_id := NULLIF(current_setting('request.jwt.claim.sub', true), '');
    IF v_user_id IS NULL THEN
        v_user_id := NULLIF(current_setting('request.jwt.claim.user_id', true), '');
    END IF;

    IF TG_OP = 'INSERT' THEN
        v_user_email := COALESCE(v_user_email, NEW.reporter, 'sistema');
        v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
        v_details := jsonb_build_object(
            'issue_id', NEW.id,
            'issue_key', NEW.key,
            'project_id', NEW.project_id,
            'title', NEW.title,
            'status_id', NEW.status_id,
            'type_id', NEW.type_id
        );
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, 'system'),
            v_user_email,
            v_user_name,
            'CREATE_ISSUE',
            'INCIDENCIAS',
            v_details,
            NOW()
        );
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.status_id IS DISTINCT FROM OLD.status_id OR
           NEW.title IS DISTINCT FROM OLD.title OR
           NEW.assignee IS DISTINCT FROM OLD.assignee OR
           NEW.priority IS DISTINCT FROM OLD.priority OR
           NEW.description IS DISTINCT FROM OLD.description OR
           NEW.type_id IS DISTINCT FROM OLD.type_id OR
           NEW.deleted_at IS DISTINCT FROM OLD.deleted_at THEN

            v_user_email := COALESCE(v_user_email, 'sistema');
            v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
            v_details := jsonb_build_object(
                'issue_id', NEW.id,
                'issue_key', NEW.key,
                'project_id', NEW.project_id,
                'title', NEW.title,
                'status_id', NEW.status_id,
                'old_status', OLD.status_id,
                'new_status', NEW.status_id,
                'old_assignee', OLD.assignee,
                'new_assignee', NEW.assignee,
                'old_title', OLD.title,
                'new_title', NEW.title
            );
            INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
            VALUES (
                'audit_' || md5(random()::text || clock_timestamp()::text),
                COALESCE(v_user_id, 'system'),
                v_user_email,
                v_user_name,
                'UPDATE_ISSUE',
                'INCIDENCIAS',
                v_details,
                NOW()
            );
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        v_user_email := COALESCE(v_user_email, 'sistema');
        v_user_name := COALESCE(NULLIF(current_setting('request.jwt.claim.name', true), ''), v_user_email);
        v_details := jsonb_build_object(
            'issue_id', OLD.id,
            'issue_key', OLD.key,
            'project_id', OLD.project_id,
            'title', OLD.title
        );
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, 'system'),
            v_user_email,
            v_user_name,
            'DELETE_ISSUE',
            'INCIDENCIAS',
            v_details,
            NOW()
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sys_audit_issue_trigger ON public.issues;
CREATE TRIGGER sys_audit_issue_trigger
AFTER INSERT OR UPDATE OR DELETE ON public.issues
FOR EACH ROW
EXECUTE FUNCTION trigger_system_audit_log_issue();

-- Trigger Function for Comments
CREATE OR REPLACE FUNCTION trigger_system_audit_log_comment()
RETURNS TRIGGER AS $$
DECLARE
    v_user_email TEXT;
    v_user_name TEXT;
    v_user_id TEXT;
BEGIN
    v_user_email := NULLIF(current_setting('request.jwt.claim.email', true), '');
    v_user_id := NULLIF(current_setting('request.jwt.claim.sub', true), '');
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.system_audit_logs (id, user_id, user_email, user_name, action, category, details, created_at)
        VALUES (
            'audit_' || md5(random()::text || clock_timestamp()::text),
            COALESCE(v_user_id, NEW.author, 'system'),
            COALESCE(v_user_email, 'sistema'),
            COALESCE(v_user_email, NEW.author, 'sistema'),
            'ADD_COMMENT',
            'INCIDENCIAS',
            jsonb_build_object(
                'issue_id', NEW.issue_id,
                'comment_id', NEW.id,
                'comment_body', NEW.body
            ),
            NOW()
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sys_audit_comment_trigger ON public.comments;
CREATE TRIGGER sys_audit_comment_trigger
AFTER INSERT ON public.comments
FOR EACH ROW
EXECUTE FUNCTION trigger_system_audit_log_comment();


