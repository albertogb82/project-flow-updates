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


