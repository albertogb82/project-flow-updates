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
