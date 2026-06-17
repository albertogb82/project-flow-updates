-- Migración acumulativa para la versión 1.3.28 (2026-06-17)
-- Basada en la migración previa de la versión 1.3.27

-- Migración acumulativa para la versión 1.3.27 (2026-06-16)
-- Basada en la migración previa de la versión 1.3.26

-- Migración acumulativa para la versión 1.3.26 (2026-06-15)
-- Basada en la migración previa de la versión 1.3.25

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



-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.26] --
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



-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.27] --
-- Update trigger function to audit issue changes (including additional fields)
CREATE OR REPLACE FUNCTION log_issue_updates()
RETURNS TRIGGER AS $$
DECLARE
    v_author TEXT;
BEGIN
    -- Resolve author from JWT email or default to 'Usuario'
    v_author := COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario');

    -- Status changes
    IF NEW.status_id IS DISTINCT FROM OLD.status_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'status', OLD.status_id, NEW.status_id);
    END IF;

    -- Title/Summary changes
    IF NEW.title IS DISTINCT FROM OLD.title THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'title', OLD.title, NEW.title);
    END IF;

    -- Description changes
    IF NEW.description IS DISTINCT FROM OLD.description THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'description', OLD.description, NEW.description);
    END IF;

    -- Assignee changes
    IF NEW.assignee IS DISTINCT FROM OLD.assignee THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'assignee', OLD.assignee, NEW.assignee);
    END IF;

    -- Reporter changes
    IF NEW.reporter IS DISTINCT FROM OLD.reporter THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'reporter', OLD.reporter, NEW.reporter);
    END IF;

    -- Priority changes
    IF NEW.priority IS DISTINCT FROM OLD.priority THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'priority', OLD.priority, NEW.priority);
    END IF;

    -- Story Points changes
    IF NEW.story_points IS DISTINCT FROM OLD.story_points THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'story_points', OLD.story_points::text, NEW.story_points::text);
    END IF;

    -- Sprint changes
    IF NEW.sprint_id IS DISTINCT FROM OLD.sprint_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'sprint', OLD.sprint_id, NEW.sprint_id);
    END IF;

    -- Parent changes
    IF NEW.parent_id IS DISTINCT FROM OLD.parent_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'parent', OLD.parent_id, NEW.parent_id);
    END IF;

    -- Type changes
    IF NEW.type_id IS DISTINCT FROM OLD.type_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'type', OLD.type_id, NEW.type_id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger function to log custom field value updates
CREATE OR REPLACE FUNCTION log_custom_field_updates()
RETURNS TRIGGER AS $$
DECLARE
    v_author TEXT;
BEGIN
    v_author := COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario');

    IF TG_OP = 'UPDATE' THEN
        IF NEW.value IS DISTINCT FROM OLD.value THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.issue_id, v_author, 'update', NEW.field_id, OLD.value, NEW.value);
        END IF;
    ELSIF TG_OP = 'INSERT' THEN
        IF NEW.value IS NOT NULL AND NEW.value <> '' THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.issue_id, v_author, 'update', NEW.field_id, NULL, NEW.value);
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.value IS NOT NULL AND OLD.value <> '' THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (OLD.issue_id, v_author, 'update', OLD.field_id, OLD.value, NULL);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Re-create issue trigger
DROP TRIGGER IF EXISTS issue_audit_trigger ON public.issues;
CREATE TRIGGER issue_audit_trigger
AFTER UPDATE ON public.issues
FOR EACH ROW
EXECUTE FUNCTION log_issue_updates();

-- Create trigger for custom field values
DROP TRIGGER IF EXISTS custom_field_audit_trigger ON public.custom_field_values;
CREATE TRIGGER custom_field_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON public.custom_field_values
FOR EACH ROW
EXECUTE FUNCTION log_custom_field_updates();



-- [NUEVOS CAMBIOS PARA LA VERSIÓN 1.3.28] --
-- Update trigger function to audit issue changes (including additional fields)
CREATE OR REPLACE FUNCTION log_issue_updates()
RETURNS TRIGGER AS $$
DECLARE
    v_author TEXT;
BEGIN
    -- Resolve author from JWT email or default to 'Usuario'
    v_author := COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario');

    -- Status changes
    IF NEW.status_id IS DISTINCT FROM OLD.status_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'status', OLD.status_id, NEW.status_id);
    END IF;

    -- Title/Summary changes
    IF NEW.title IS DISTINCT FROM OLD.title THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'title', OLD.title, NEW.title);
    END IF;

    -- Description changes
    IF NEW.description IS DISTINCT FROM OLD.description THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'description', OLD.description, NEW.description);
    END IF;

    -- Assignee changes
    IF NEW.assignee IS DISTINCT FROM OLD.assignee THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'assignee', OLD.assignee, NEW.assignee);
    END IF;

    -- Reporter changes
    IF NEW.reporter IS DISTINCT FROM OLD.reporter THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'reporter', OLD.reporter, NEW.reporter);
    END IF;

    -- Priority changes
    IF NEW.priority IS DISTINCT FROM OLD.priority THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'priority', OLD.priority, NEW.priority);
    END IF;

    -- Story Points changes
    IF NEW.story_points IS DISTINCT FROM OLD.story_points THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'story_points', OLD.story_points::text, NEW.story_points::text);
    END IF;

    -- Sprint changes
    IF NEW.sprint_id IS DISTINCT FROM OLD.sprint_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'sprint', OLD.sprint_id, NEW.sprint_id);
    END IF;

    -- Parent changes
    IF NEW.parent_id IS DISTINCT FROM OLD.parent_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'parent', OLD.parent_id, NEW.parent_id);
    END IF;

    -- Type changes
    IF NEW.type_id IS DISTINCT FROM OLD.type_id THEN
        INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
        VALUES (NEW.id, v_author, 'update', 'type', OLD.type_id, NEW.type_id);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger function to log custom field value updates
CREATE OR REPLACE FUNCTION log_custom_field_updates()
RETURNS TRIGGER AS $$
DECLARE
    v_author TEXT;
BEGIN
    v_author := COALESCE(current_setting('request.jwt.claim.email', true), 'Usuario');

    IF TG_OP = 'UPDATE' THEN
        IF NEW.value IS DISTINCT FROM OLD.value THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.issue_id, v_author, 'update', NEW.field_id, OLD.value, NEW.value);
        END IF;
    ELSIF TG_OP = 'INSERT' THEN
        IF NEW.value IS NOT NULL AND NEW.value <> '' THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (NEW.issue_id, v_author, 'update', NEW.field_id, NULL, NEW.value);
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        IF OLD.value IS NOT NULL AND OLD.value <> '' THEN
            INSERT INTO public.issue_history (issue_id, author, action_type, field_name, from_string, to_string)
            VALUES (OLD.issue_id, v_author, 'update', OLD.field_id, OLD.value, NULL);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Re-create issue trigger
DROP TRIGGER IF EXISTS issue_audit_trigger ON public.issues;
CREATE TRIGGER issue_audit_trigger
AFTER UPDATE ON public.issues
FOR EACH ROW
EXECUTE FUNCTION log_issue_updates();

-- Create trigger for custom field values
DROP TRIGGER IF EXISTS custom_field_audit_trigger ON public.custom_field_values;
CREATE TRIGGER custom_field_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON public.custom_field_values
FOR EACH ROW
EXECUTE FUNCTION log_custom_field_updates();

