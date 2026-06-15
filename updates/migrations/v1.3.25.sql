-- Migración acumulativa para la versión 1.3.25 (2026-06-15)
-- Basada en la migración previa de la versión 1.3.24

-- Migración acumulativa para la versión 1.3.24 (2026-06-15)
-- Basada en la migración previa de la versión 1.3.23

-- Migración acumulativa para la versión Consolidación del Editor Avanzado (RITA y validación de sintaxis) en Custom Fields y post-funciones (2026-06-12)
-- Basada en la migración previa de la versión 1.3.22

-- Migración acumulativa para la versión 1.3.22 (2026-06-11)
-- Basada en la migración previa de la versión 1.3.21

-- Migración acumulativa para la versión 1.3.21 (2026-06-11)
-- Basada en la migración previa de la versión Soporte para edición en línea de estados, asignaciones y campos personalizados desde el panel de actividades vinculadas

-- Migración acumulativa para la versión Soporte para edición en línea de estados, asignaciones y campos personalizados desde el panel de actividades vinculadas (2026-06-11)
-- Basada en la migración previa de la versión 1.3.20

-- Migración para la versión 1.3.20 (2026-06-11)
-- Garantiza columna screen_id en workflow_transitions (acumulativo)
ALTER TABLE public.workflow_transitions ADD COLUMN IF NOT EXISTS screen_id TEXT;


-- [NUEVOS CAMBIOS PARA LA VERSIÓN Soporte para edición en línea de estados, asignaciones y campos personalizados desde el panel de actividades vinculadas] --
-- Agrega aquí nuevas sentencias SQL específicas de esta versión:


-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.21] --
-- Agrega aquí nuevas sentencias SQL específicas de esta versión:


-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.22] --
-- Agrega aquí nuevas sentencias SQL específicas de esta versión:


-- [NUEVOS CAMBIOS PARA LA VERSIÓN Consolidación del Editor Avanzado (RITA y validación de sintaxis) en Custom Fields y post-funciones] --
-- Agrega aquí nuevas sentencias SQL específicas de esta versión:


-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.24] --
-- Update trigger function to audit sprint changes on issues table
CREATE OR REPLACE FUNCTION log_issue_updates()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log updates
    IF TG_OP = 'UPDATE' THEN
        -- Status changes
        IF NEW.status_id IS DISTINCT FROM OLD.status_id THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'status', OLD.status_id, NEW.status_id);
        END IF;

        -- Title changes
        IF NEW.title IS DISTINCT FROM OLD.title THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'title', OLD.title, NEW.title);
        END IF;

        -- Description changes
        IF NEW.description IS DISTINCT FROM OLD.description THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'description', OLD.description, NEW.description);
        END IF;

        -- Assignee changes
        IF NEW.assignee IS DISTINCT FROM OLD.assignee THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'assignee', OLD.assignee, NEW.assignee);
        END IF;

        -- Priority changes
        IF NEW.priority IS DISTINCT FROM OLD.priority THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'priority', OLD.priority, NEW.priority);
        END IF;

        -- Story Points changes
        IF NEW.story_points IS DISTINCT FROM OLD.story_points THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'story_points', OLD.story_points::text, NEW.story_points::text);
        END IF;

        -- Sprint changes
        IF NEW.sprint_id IS DISTINCT FROM OLD.sprint_id THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'sprint', OLD.sprint_id, NEW.sprint_id);
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.25] --
-- Update trigger function to audit sprint changes on issues table
CREATE OR REPLACE FUNCTION log_issue_updates()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log updates
    IF TG_OP = 'UPDATE' THEN
        -- Status changes
        IF NEW.status_id IS DISTINCT FROM OLD.status_id THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'status', OLD.status_id, NEW.status_id);
        END IF;

        -- Title changes
        IF NEW.title IS DISTINCT FROM OLD.title THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'title', OLD.title, NEW.title);
        END IF;

        -- Description changes
        IF NEW.description IS DISTINCT FROM OLD.description THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'description', OLD.description, NEW.description);
        END IF;

        -- Assignee changes
        IF NEW.assignee IS DISTINCT FROM OLD.assignee THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'assignee', OLD.assignee, NEW.assignee);
        END IF;

        -- Priority changes
        IF NEW.priority IS DISTINCT FROM OLD.priority THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'priority', OLD.priority, NEW.priority);
        END IF;

        -- Story Points changes
        IF NEW.story_points IS DISTINCT FROM OLD.story_points THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'story_points', OLD.story_points::text, NEW.story_points::text);
        END IF;

        -- Sprint changes
        IF NEW.sprint_id IS DISTINCT FROM OLD.sprint_id THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.id, COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario'), 'update', 'sprint', OLD.sprint_id, NEW.sprint_id);
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

