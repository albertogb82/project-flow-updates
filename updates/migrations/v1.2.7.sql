-- =====================================================
-- MIGRACIÓN v1.2.5: CONFIGURACIÓN POR DEFECTO DE PROYECTOS
-- CRM, PROJECTFLOW CORE Y SUPPORT
-- Generado automáticamente de forma segura sin tickets.
-- =====================================================

-- 1. PROYECTOS
INSERT INTO public.projects ("id", "name", "key", "description", "icon", "icon_color", "custom_icon_url", "owner", "created_at", "issue_type_screen_scheme_id", "workflow_scheme_id", "issue_type_scheme_id", "permission_scheme_id", "category", "deleted_at", "link_scheme_id")
VALUES ('p-pf', 'ProjectFlow Core', 'PF', 'Proyecto principal de desarrollo', 'Target', '#3c8af6', '', 'Alberto García', '2026-04-19T10:15:54.001Z', 'itss-default', 'ws-default', 'its-default', 'ps-default', NULL, NULL, 'ls-default')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "key" = EXCLUDED."key", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "icon_color" = EXCLUDED."icon_color", "custom_icon_url" = EXCLUDED."custom_icon_url", "owner" = EXCLUDED."owner", "created_at" = EXCLUDED."created_at", "issue_type_screen_scheme_id" = EXCLUDED."issue_type_screen_scheme_id", "workflow_scheme_id" = EXCLUDED."workflow_scheme_id", "issue_type_scheme_id" = EXCLUDED."issue_type_scheme_id", "permission_scheme_id" = EXCLUDED."permission_scheme_id", "category" = EXCLUDED."category", "deleted_at" = EXCLUDED."deleted_at", "link_scheme_id" = EXCLUDED."link_scheme_id";
INSERT INTO public.projects ("id", "name", "key", "description", "icon", "icon_color", "custom_icon_url", "owner", "created_at", "issue_type_screen_scheme_id", "workflow_scheme_id", "issue_type_scheme_id", "permission_scheme_id", "category", "deleted_at", "link_scheme_id")
VALUES ('proj-1778145251135', 'Support', 'SUPP', 'soporte', 'FolderKanban', '#3b82f6', '', 'Alberto García', '2026-05-07T09:14:11.146Z', 'itss-default', 'ws-default', 'its-default', 'ps-default', 'Client Support', NULL, 'ls-default')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "key" = EXCLUDED."key", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "icon_color" = EXCLUDED."icon_color", "custom_icon_url" = EXCLUDED."custom_icon_url", "owner" = EXCLUDED."owner", "created_at" = EXCLUDED."created_at", "issue_type_screen_scheme_id" = EXCLUDED."issue_type_screen_scheme_id", "workflow_scheme_id" = EXCLUDED."workflow_scheme_id", "issue_type_scheme_id" = EXCLUDED."issue_type_scheme_id", "permission_scheme_id" = EXCLUDED."permission_scheme_id", "category" = EXCLUDED."category", "deleted_at" = EXCLUDED."deleted_at", "link_scheme_id" = EXCLUDED."link_scheme_id";
INSERT INTO public.projects ("id", "name", "key", "description", "icon", "icon_color", "custom_icon_url", "owner", "created_at", "issue_type_screen_scheme_id", "workflow_scheme_id", "issue_type_scheme_id", "permission_scheme_id", "category", "deleted_at", "link_scheme_id")
VALUES ('proj-crm', 'CRM Accounts & Opportunities', 'CRM', 'CRM Project for managing client accounts and sales opportunities.', 'FolderKanban', '#10b981', '', 'Alberto García', '2026-05-26T14:57:05.603Z', 'itss-crm', 'ws-crm', 'its-crm', 'ps-default', 'CRM', NULL, 'ls-default')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "key" = EXCLUDED."key", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "icon_color" = EXCLUDED."icon_color", "custom_icon_url" = EXCLUDED."custom_icon_url", "owner" = EXCLUDED."owner", "created_at" = EXCLUDED."created_at", "issue_type_screen_scheme_id" = EXCLUDED."issue_type_screen_scheme_id", "workflow_scheme_id" = EXCLUDED."workflow_scheme_id", "issue_type_scheme_id" = EXCLUDED."issue_type_scheme_id", "permission_scheme_id" = EXCLUDED."permission_scheme_id", "category" = EXCLUDED."category", "deleted_at" = EXCLUDED."deleted_at", "link_scheme_id" = EXCLUDED."link_scheme_id";

-- 2. ESQUEMAS DE TIPOS DE INCIDENCIA
INSERT INTO public.issue_type_schemes ("id", "name", "description")
VALUES ('its-default', 'Default Software Scheme', 'Esquema base para desarrollo de software ágil.')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.issue_type_schemes ("id", "name", "description")
VALUES ('its-crm', 'CRM Issue Type Scheme', 'Issue type scheme for CRM projects')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";

-- 4. TIPOS DE INCIDENCIA
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('bug', 'Bug', 'Fallo o error en el sistema.', 'Bug', '#e5493a', FALSE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('epic', 'Épica', 'Un gran segmento de trabajo que puede dividirse.', 'Zap', '#904ee2', FALSE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('story', 'Historia', 'Característica o requerimiento desde la perspectiva del usuario.', 'Bookmark', '#63ba3c', FALSE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('task', 'Tarea', 'Una unidad de trabajo genérica.', 'CheckSquare', '#4bade8', FALSE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('subtask', 'Sub-tarea', 'Pequeña parte de un bloque de trabajo.', 'Network', '#4bade8', TRUE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('opportunity', 'Opportunity', 'CRM Opportunity (sale opportunity, subtask of Account)', 'DollarSign', 'hsl(120, 100%, 40%)', TRUE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('contact', 'Contact', 'CRM Contact representing a person (subtask of Account)', 'User', 'hsl(280, 100%, 50%)', TRUE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";
INSERT INTO public.issue_types ("id", "name", "description", "icon", "color", "is_subtask")
VALUES ('account', 'Account', 'CRM Account representing a client/company', 'FolderKanban', 'hsl(210, 100%, 50%)', FALSE)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "icon" = EXCLUDED."icon", "color" = EXCLUDED."color", "is_subtask" = EXCLUDED."is_subtask";

-- 3. ASOCIACIONES DE TIPOS DE INCIDENCIA EN ESQUEMAS
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-its-default-epic', 'its-default', 'epic')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-its-default-story', 'its-default', 'story')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-its-default-task', 'its-default', 'task')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-its-default-subtask', 'its-default', 'subtask')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-its-default-bug', 'its-default', 'bug')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-crm-acc', 'its-crm', 'account')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-crm-opp', 'its-crm', 'opportunity')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";
INSERT INTO public.issue_type_scheme_entries ("id", "scheme_id", "issue_type_id")
VALUES ('itse-crm-con', 'its-crm', 'contact')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id";

-- 7. DEFINICIONES DE FLUJOS DE TRABAJO
INSERT INTO public.workflow_definitions ("id", "name", "description", "status", "parent_definition_id", "initial_state_id")
VALUES ('wf-simplified', 'Software Simplified Workflow', 'Un flujo simple con Por Hacer, En Progreso y Hecho.', 'active', NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "status" = EXCLUDED."status", "parent_definition_id" = EXCLUDED."parent_definition_id", "initial_state_id" = EXCLUDED."initial_state_id";
INSERT INTO public.workflow_definitions ("id", "name", "description", "status", "parent_definition_id", "initial_state_id")
VALUES ('wf-1777886403524', 'Flujo de tareas simple', '', 'active', NULL, 'state-todo-1777886403524')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "status" = EXCLUDED."status", "parent_definition_id" = EXCLUDED."parent_definition_id", "initial_state_id" = EXCLUDED."initial_state_id";
INSERT INTO public.workflow_definitions ("id", "name", "description", "status", "parent_definition_id", "initial_state_id")
VALUES ('wf-bug', 'Bug Tracking Workflow', 'Flujo diseñado específicamente para manejar fallos.', 'active', NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "status" = EXCLUDED."status", "parent_definition_id" = EXCLUDED."parent_definition_id", "initial_state_id" = EXCLUDED."initial_state_id";
INSERT INTO public.workflow_definitions ("id", "name", "description", "status", "parent_definition_id", "initial_state_id")
VALUES ('wf-crm-account', 'CRM Account Workflow', 'Workflow for CRM client accounts', 'active', NULL, 'wfs-crm-acc-possible')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "status" = EXCLUDED."status", "parent_definition_id" = EXCLUDED."parent_definition_id", "initial_state_id" = EXCLUDED."initial_state_id";
INSERT INTO public.workflow_definitions ("id", "name", "description", "status", "parent_definition_id", "initial_state_id")
VALUES ('wf-crm-opportunity', 'CRM Opportunity Workflow', 'Workflow for CRM sales opportunities', 'active', NULL, 'wfs-crm-opp-discovery')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "status" = EXCLUDED."status", "parent_definition_id" = EXCLUDED."parent_definition_id", "initial_state_id" = EXCLUDED."initial_state_id";
INSERT INTO public.workflow_definitions ("id", "name", "description", "status", "parent_definition_id", "initial_state_id")
VALUES ('wf-crm-contact', 'CRM Contact Workflow', 'Workflow for CRM contacts', 'active', NULL, 'wfs-crm-con-pending')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "status" = EXCLUDED."status", "parent_definition_id" = EXCLUDED."parent_definition_id", "initial_state_id" = EXCLUDED."initial_state_id";

-- 8. ESTADOS DE WORKFLOWS
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-sim-todo', 'wf-simplified', 'Por Hacer', 'todo', 'hsl(215, 16%, 47%)', 0, 'todo', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-sim-inprogress', 'wf-simplified', 'En Progreso', 'in_progress', 'hsl(216, 80%, 50%)', 1, 'inprogress', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-sim-done', 'wf-simplified', 'Hecho', 'done', 'hsl(142, 71%, 45%)', 2, 'done', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('state-todo-1777886403524', 'wf-1777886403524', 'To Do', 'todo', '#94a3b8', 0, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('state-done-1777886403524', 'wf-1777886403524', 'Done', 'done', '#22c55e', 1, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('state-1777971417760', 'wf-1777886403524', 'En Progreso', 'in_progress', '#3b82f6', 0, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('state-1777971864118', 'wf-1777886403524', 'QA', 'in_progress', '#3b82f6', 0, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-bug-open', 'wf-bug', 'Abierto', 'todo', 'hsl(215, 16%, 47%)', 0, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-bug-investigating', 'wf-bug', 'Investigando', 'in_progress', 'hsl(35, 92%, 53%)', 1, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-bug-fixing', 'wf-bug', 'Corrigiendo', 'in_progress', 'hsl(216, 80%, 50%)', 2, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-bug-inqa', 'wf-bug', 'En Pruebas', 'in_progress', 'hsl(280, 67%, 55%)', 3, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-bug-closed', 'wf-bug', 'Cerrado', 'done', 'hsl(142, 71%, 45%)', 4, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-acc-possible', 'wf-crm-account', 'Possible', 'todo', 'hsl(200, 30%, 50%)', 0, 'possible', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-acc-won', 'wf-crm-account', 'Won', 'done', 'hsl(142, 70%, 45%)', 1, 'won', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-acc-lost', 'wf-crm-account', 'Lost', 'done', 'hsl(0, 70%, 50%)', 2, 'lost', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-opp-discovery', 'wf-crm-opportunity', 'Discovery', 'todo', 'hsl(200, 80%, 40%)', 0, 'discovery', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-opp-presales', 'wf-crm-opportunity', 'Presales', 'inprogress', 'hsl(40, 90%, 50%)', 1, 'presales', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-opp-sent', 'wf-crm-opportunity', 'Sent to Client', 'inprogress', 'hsl(280, 70%, 60%)', 2, 'sent_to_client', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-opp-won', 'wf-crm-opportunity', 'Won', 'done', 'hsl(142, 70%, 45%)', 3, 'won', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-opp-lost', 'wf-crm-opportunity', 'Lost', 'done', 'hsl(0, 70%, 50%)', 4, 'lost', NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-con-pending', 'wf-crm-contact', 'Pending', 'todo', 'hsl(40, 90%, 50%)', 0, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-con-active', 'wf-crm-contact', 'Active', 'inprogress', 'hsl(142, 70%, 45%)', 1, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";
INSERT INTO public.workflow_states ("id", "workflow_definition_id", "name", "category", "color", "order_index", "status_id", "parent_state_id")
VALUES ('wfs-crm-con-inactive', 'wf-crm-contact', 'Inactive', 'done', 'hsl(0, 70%, 50%)', 2, NULL, NULL)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "category" = EXCLUDED."category", "color" = EXCLUDED."color", "order_index" = EXCLUDED."order_index", "status_id" = EXCLUDED."status_id", "parent_state_id" = EXCLUDED."parent_state_id";

-- 9. TRANSICIONES DE WORKFLOWS
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1777972249761-xoyuq', 'wf-1777886403524', 'Back', NULL, 'state-todo-1777886403524', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1777972249761-m3pdc', 'wf-1777886403524', 'Resuelto', NULL, 'state-done-1777886403524', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1777972249762-kdsjd', 'wf-1777886403524', 'In progress', 'state-1777971864118', 'state-1777971417760', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1777972249762-3cmf4', 'wf-1777886403524', 'QA', 'state-1777971417760', 'state-1777971864118', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041835-c8quc', 'wf-bug', 'En progreso', 'wfs-bug-investigating', 'wfs-bug-fixing', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041836-zcux0', 'wf-bug', 'Back', 'wfs-bug-investigating', 'wfs-bug-open', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041836-8icba', 'wf-bug', 'QA', 'wfs-bug-fixing', 'wfs-bug-inqa', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041836-vrmhh', 'wf-bug', 'Back', 'wfs-bug-fixing', 'wfs-bug-investigating', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041837-pd5b2', 'wf-bug', 'Done', 'wfs-bug-inqa', 'wfs-bug-closed', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041837-cgoyo', 'wf-bug', 'Back', 'wfs-bug-closed', 'wfs-bug-inqa', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041837-zylv6', 'wf-bug', 'In progress', 'wfs-bug-fixing', 'wfs-bug-fixing', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041838-q7ol1', 'wf-bug', 'Re-open', 'wfs-bug-closed', 'wfs-bug-open', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041838-yo39p', 'wf-bug', 'Back', 'wfs-bug-inqa', 'wfs-bug-investigating', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779699041838-quus9', 'wf-bug', 'Investigando', 'wfs-bug-open', 'wfs-bug-investigating', '[{"id":"rule-1777997089474","order":0,"config":{"fields":["description","cf-1777977618982","assignee"]},"enabled":true,"ruleName":"Field Required Validator","ruleType":"validator","description":"Ensures specific fields are not empty before transition."},{"id":"rule-1777998633480","order":1,"config":{"field":"","template":"Resolvido por {{currentUser.displayName}}{{issue.projectId}}"},"enabled":true,"ruleName":"Set Field via Template","ruleType":"post_function","description":"Set a field value using a template (e.g. ''Fix for {{issue.key}}'')."},{"id":"rule-1779263439321","order":2,"config":{"runAs":"current_user","projectId":"current","linkTypeId":"relates","issueTypeId":"task","copyStrategy":"all","customFields":[{"value":"Copia de: {{issue.description}}","fieldId":"description"}],"commentsOption":"none","reporterMapping":"current_user","summaryTemplate":"Subtarea: {{issue.summary}} [{{issue.key}}]","newCommentTemplate":"","useCurrentUserIfDeactivated":true},"enabled":true,"ruleName":"Create Issue","ruleType":"post_function","description":"Crea y vincula una incidencia automática."},{"id":"rule-1777997125411","order":3,"config":{"comment":"Hemos actualizado el ticket"},"enabled":true,"ruleName":"Add Comment","ruleType":"post_function","description":"Add a comment to the issue automatically."},{"id":"rule-1778150812553","order":4,"config":{"script":"console.log(''Transition executed for '' + issue.key)"},"enabled":true,"ruleName":"Script Post-function","ruleType":"post_function","description":"Execute custom JS logic after transition."},{"id":"rule-1779375898237","config":{"runAs":"current_user","projectId":"current","linkTypeId":"","issueTypeId":"","copyStrategy":"all","customFields":[],"commentsOption":"none","reporterMapping":"current_user","summaryTemplate":"Tarea vinculada a {{issue.key}}","newCommentTemplate":"","useCurrentUserIfDeactivated":true},"ruleName":"Create Issue","ruleType":"post_function","description":"Crea y vincula una incidencia automática."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-acc-poss-to-won', 'wf-crm-account', 'Mark as Won', 'wfs-crm-acc-possible', 'wfs-crm-acc-won', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-acc-poss-to-lost', 'wf-crm-account', 'Mark as Lost', 'wfs-crm-acc-possible', 'wfs-crm-acc-lost', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-acc-won-to-lost', 'wf-crm-account', 'Mark as Lost', 'wfs-crm-acc-won', 'wfs-crm-acc-lost', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-acc-lost-to-won', 'wf-crm-account', 'Reopen as Won', 'wfs-crm-acc-lost', 'wfs-crm-acc-won', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-acc-any-to-poss', 'wf-crm-account', 'Move to Possible', NULL, 'wfs-crm-acc-possible', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-opp-disc-to-pre', 'wf-crm-opportunity', 'Move to Presales', 'wfs-crm-opp-discovery', 'wfs-crm-opp-presales', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-opp-pre-to-sent', 'wf-crm-opportunity', 'Send to Client', 'wfs-crm-opp-presales', 'wfs-crm-opp-sent', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-opp-sent-to-won', 'wf-crm-opportunity', 'Close Won', 'wfs-crm-opp-sent', 'wfs-crm-opp-won', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-opp-sent-to-lost', 'wf-crm-opportunity', 'Close Lost', 'wfs-crm-opp-sent', 'wfs-crm-opp-lost', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-opp-any-to-lost', 'wf-crm-opportunity', 'Mark as Lost', NULL, 'wfs-crm-opp-lost', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-opp-any-to-disc', 'wf-crm-opportunity', 'Move to Discovery', NULL, 'wfs-crm-opp-discovery', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-con-pend-to-act', 'wf-crm-contact', 'Activate', 'wfs-crm-con-pending', 'wfs-crm-con-active', '[{"id":"rule-con-act","order":1,"config":{},"enabled":true,"ruleName":"activate_portal_user","ruleType":"post_function","description":"Activa la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-con-act-to-inact', 'wf-crm-contact', 'Deactivate', 'wfs-crm-con-active', 'wfs-crm-con-inactive', '[{"id":"rule-con-deact","order":1,"config":{},"enabled":true,"ruleName":"deactivate_portal_user","ruleType":"post_function","description":"Desactiva la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779969158404-mu1ak', 'wf-crm-contact', 'Activate', 'wfs-crm-con-pending', 'wfs-crm-con-active', '[{"id":"rule-con-act","order":1,"config":{},"enabled":true,"ruleName":"activate_portal_user","ruleType":"post_function","description":"Activa la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779969158405-s2xoj', 'wf-crm-contact', 'Deactivate', 'wfs-crm-con-active', 'wfs-crm-con-inactive', '[{"id":"rule-con-deact","order":1,"config":{},"enabled":true,"ruleName":"deactivate_portal_user","ruleType":"post_function","description":"Desactiva la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779969158405-kj1ya', 'wf-crm-contact', 'Deactivate', 'wfs-crm-con-pending', 'wfs-crm-con-inactive', '[{"id":"rule-con-pend-deact","order":1,"config":{},"enabled":true,"ruleName":"deactivate_portal_user","ruleType":"post_function","description":"Desactiva la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('trans-1779969158405-2c62o', 'wf-crm-contact', 'Reactivate', 'wfs-crm-con-inactive', 'wfs-crm-con-active', '[{"id":"rule-con-react","order":1,"config":{},"enabled":true,"ruleName":"activate_portal_user","ruleType":"post_function","description":"Activa la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-con-pend-to-inact', 'wf-crm-contact', 'Deactivate', 'wfs-crm-con-pending', 'wfs-crm-con-inactive', '[{"id":"rule-con-pend-deact","order":1,"config":{},"enabled":true,"ruleName":"deactivate_portal_user","ruleType":"post_function","description":"Desactiva la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";
INSERT INTO public.workflow_transitions ("id", "workflow_definition_id", "name", "from_status_id", "to_status_id", "rules")
VALUES ('tr-con-inact-to-act', 'wf-crm-contact', 'Reactivate', 'wfs-crm-con-inactive', 'wfs-crm-con-active', '[{"id":"rule-con-react","order":1,"config":{},"enabled":true,"ruleName":"activate_portal_user","ruleType":"post_function","description":"Activa la cuenta del usuario del portal asociado a este contacto."}]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "workflow_definition_id" = EXCLUDED."workflow_definition_id", "name" = EXCLUDED."name", "from_status_id" = EXCLUDED."from_status_id", "to_status_id" = EXCLUDED."to_status_id", "rules" = EXCLUDED."rules";

-- 5. ESQUEMAS DE TRABAJO (WORKFLOW SCHEMES)
INSERT INTO public.workflow_schemes ("id", "name", "description")
VALUES ('ws-default', 'Default Software Workflow Scheme', 'Aplica el flujo simplificado por defecto, y seguimiento estricto para Bugs.')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.workflow_schemes ("id", "name", "description")
VALUES ('ws-crm', 'CRM Workflow Scheme', 'Workflow scheme for CRM projects')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";

-- 6. MAPEOS DE WORKFLOW A TIPOS DE INCIDENCIA
INSERT INTO public.workflow_scheme_mappings ("id", "scheme_id", "issue_type_id", "workflow_definition_id")
VALUES ('wsm-ws-default-_default', 'ws-default', '_default', 'wf-1777886403524')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id", "workflow_definition_id" = EXCLUDED."workflow_definition_id";
INSERT INTO public.workflow_scheme_mappings ("id", "scheme_id", "issue_type_id", "workflow_definition_id")
VALUES ('wsm-ws-default-bug', 'ws-default', 'bug', 'wf-bug')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id", "workflow_definition_id" = EXCLUDED."workflow_definition_id";
INSERT INTO public.workflow_scheme_mappings ("id", "scheme_id", "issue_type_id", "workflow_definition_id")
VALUES ('wsm-crm-acc', 'ws-crm', 'account', 'wf-crm-account')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id", "workflow_definition_id" = EXCLUDED."workflow_definition_id";
INSERT INTO public.workflow_scheme_mappings ("id", "scheme_id", "issue_type_id", "workflow_definition_id")
VALUES ('wsm-crm-opp', 'ws-crm', 'opportunity', 'wf-crm-opportunity')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id", "workflow_definition_id" = EXCLUDED."workflow_definition_id";
INSERT INTO public.workflow_scheme_mappings ("id", "scheme_id", "issue_type_id", "workflow_definition_id")
VALUES ('wsm-crm-con', 'ws-crm', 'contact', 'wf-crm-contact')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id", "workflow_definition_id" = EXCLUDED."workflow_definition_id";
INSERT INTO public.workflow_scheme_mappings ("id", "scheme_id", "issue_type_id", "workflow_definition_id")
VALUES ('wsm-crm-def', 'ws-crm', '_default', 'wf-simplified')
ON CONFLICT ("id") DO UPDATE SET "scheme_id" = EXCLUDED."scheme_id", "issue_type_id" = EXCLUDED."issue_type_id", "workflow_definition_id" = EXCLUDED."workflow_definition_id";

-- 10. ESQUEMAS DE PANTALLA POR TIPO DE INCIDENCIA (ISSUE TYPE SCREEN SCHEMES)
INSERT INTO public.issue_type_screen_schemes ("id", "name", "description")
VALUES ('itss-default', 'Default Issue Mapping', 'Mapeo predeterminado de pantallas.')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.issue_type_screen_schemes ("id", "name", "description")
VALUES ('itss-crm', 'CRM Issue Type Screen Scheme', 'Asociación de pantallas para el proyecto CRM')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";

-- 12. ESQUEMAS DE PANTALLAS (SCREEN SCHEMES)
INSERT INTO public.screen_schemes ("id", "name", "description")
VALUES ('ss-default', 'Default Screen Scheme', 'Aplica Default Screen a todas las operaciones.')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.screen_schemes ("id", "name", "description")
VALUES ('ss-bug', 'Bug Screen Scheme', 'Aplica Bug Screen a todas las operaciones.')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.screen_schemes ("id", "name", "description")
VALUES ('ss-crm-account', 'CRM Account Screen Scheme', 'Esquema de pantallas para Cuentas CRM')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.screen_schemes ("id", "name", "description")
VALUES ('ss-crm-opportunity', 'CRM Opportunity Screen Scheme', 'Esquema de pantallas para Oportunidades CRM')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";
INSERT INTO public.screen_schemes ("id", "name", "description")
VALUES ('ss-crm-contact', 'CRM Contact Screen Scheme', 'Esquema de pantallas para Contactos CRM')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description";

-- 11. ENTRADAS DE ESQUEMAS DE PANTALLA POR TIPO
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itss-e-default', 'itss-default', '_default', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itss-e-bug', 'itss-default', 'bug', 'ss-bug')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-1777975011789', 'itss-default', 'story', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-1777975019789', 'itss-default', 'riesgo', 'ss-bug')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-1777975027488', 'itss-default', 'task', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-1777975040951', 'itss-default', 'subtask', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-1777975048701', 'itss-default', 'epic', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-crm-acc', 'itss-crm', 'account', 'ss-crm-account')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-crm-opp', 'itss-crm', 'opportunity', 'ss-crm-opportunity')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-crm-def-1', 'itss-crm', '_default', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-crm-def-2', 'itss-crm', 'default', 'ss-default')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";
INSERT INTO public.issue_type_screen_scheme_entries ("id", "scheme_id", "issue_type_id", "screen_scheme_id")
VALUES ('itse-crm-con-entry', 'itss-crm', 'contact', 'ss-crm-contact')
ON CONFLICT ("scheme_id", "issue_type_id") DO UPDATE SET "screen_scheme_id" = EXCLUDED."screen_scheme_id";

-- 14. PANTALLAS (SCREENS)
INSERT INTO public.screens ("id", "name", "description", "type")
VALUES ('screen-default', 'Pantalla Predeterminada', 'Pantalla genérica para incidencias.', 'edit')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "type" = EXCLUDED."type";
INSERT INTO public.screens ("id", "name", "description", "type")
VALUES ('screen-1776597053411', 'ver editar', '', 'edit')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "type" = EXCLUDED."type";
INSERT INTO public.screens ("id", "name", "description", "type")
VALUES ('screen-1776597528025', 'Pantalla de creacion', '', 'edit')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "type" = EXCLUDED."type";
INSERT INTO public.screens ("id", "name", "description", "type")
VALUES ('sc-crm-account', 'CRM Account Screen', 'Pantalla para incidencias de tipo Cuenta en CRM', 'edit')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "type" = EXCLUDED."type";
INSERT INTO public.screens ("id", "name", "description", "type")
VALUES ('sc-crm-opportunity', 'CRM Opportunity Screen', 'Pantalla para incidencias de tipo Oportunidad en CRM', 'edit')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "type" = EXCLUDED."type";
INSERT INTO public.screens ("id", "name", "description", "type")
VALUES ('sc-crm-contact', 'CRM Contact Screen', 'Pantalla para incidencias de tipo Contacto en CRM', 'edit')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "description" = EXCLUDED."description", "type" = EXCLUDED."type";

-- 13. ENTRADAS DE ESQUEMAS DE PANTALLAS
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-4', 'ss-default', 'view', 'screen-default')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-bug-1', 'ss-bug', 'default', 'screen-1776597528025')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-5', 'ss-bug', 'default', 'screen-1776597528025')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-6', 'ss-bug', 'create', 'screen-1776597528025')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-7', 'ss-bug', 'edit', 'screen-1776597053411')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-8', 'ss-bug', 'view', 'screen-1776597053411')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-1777974847255', 'ss-default', 'default', 'screen-1776597528025')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-3', 'ss-default', 'edit', 'screen-1776597053411')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-1777974871852', 'ss-default', 'create', 'screen-1776597528025')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-acc-def', 'ss-crm-account', 'default', 'sc-crm-account')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-acc-cre', 'ss-crm-account', 'create', 'sc-crm-account')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-acc-edi', 'ss-crm-account', 'edit', 'sc-crm-account')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-acc-vie', 'ss-crm-account', 'view', 'sc-crm-account')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-opp-def', 'ss-crm-opportunity', 'default', 'sc-crm-opportunity')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-opp-cre', 'ss-crm-opportunity', 'create', 'sc-crm-opportunity')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-opp-edi', 'ss-crm-opportunity', 'edit', 'sc-crm-opportunity')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-opp-vie', 'ss-crm-opportunity', 'view', 'sc-crm-opportunity')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-con-def', 'ss-crm-contact', 'default', 'sc-crm-contact')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-con-cre', 'ss-crm-contact', 'create', 'sc-crm-contact')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-con-edi', 'ss-crm-contact', 'edit', 'sc-crm-contact')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";
INSERT INTO public.screen_scheme_entries ("id", "scheme_id", "operation", "screen_id")
VALUES ('sse-crm-con-vie', 'ss-crm-contact', 'view', 'sc-crm-contact')
ON CONFLICT ("scheme_id", "operation") DO UPDATE SET "screen_id" = EXCLUDED."screen_id";

-- 15. PESTAÑAS DE PANTALLAS (SCREEN TABS)
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-1776597062804-ectgm', 'screen-1776597053411', 'General', 0, '2026-04-19T11:11:02.804Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-1776597863111-mxgvc', 'screen-1776597528025', 'General', 0, '2026-04-19T11:24:23.117Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-1776597869252-rmr6v', 'screen-1776597528025', 'Otros Datos', 0, '2026-04-19T11:24:29.253Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-1776597942109-kp50z', 'screen-1776597053411', 'Otros Datos', 0, '2026-04-19T11:25:42.115Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-auto-1776599735697-xcqsz', 'screen-default', 'General', 0, '2026-04-19T11:55:35.698Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-crm-account-general', 'sc-crm-account', 'General', 0, '2026-05-27T11:45:14.339Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-crm-opp-general', 'sc-crm-opportunity', 'General', 0, '2026-05-27T11:45:14.339Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";
INSERT INTO public.screen_tabs ("id", "screen_id", "name", "tab_order", "created_at")
VALUES ('tab-crm-contact-general', 'sc-crm-contact', 'General', 0, '2026-05-28T10:20:13.511Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "tab_order" = EXCLUDED."tab_order", "created_at" = EXCLUDED."created_at";

-- 16. CAMPOS DE PESTAÑAS DE PANTALLAS (SCREEN FIELDS)
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597872491-2brp5', 'title', 'editable', 0, 'tab-1776597863111-mxgvc', FALSE, 'Título', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597874902-bc4bv', 'status', 'editable', 0, 'tab-1776597863111-mxgvc', FALSE, 'Estado', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597879113-m0he1', 'type', 'editable', 0, 'tab-1776597863111-mxgvc', FALSE, 'Tipo de incidencia', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597908645-va0xj', 'title', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Título', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597910572-iqn34', 'status', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Estado', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597912695-7ko7u', 'assignee', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Responsable', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597917116-q3731', 'labels', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Etiquetas', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597920407-m823q', 'cf_budget', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Presupuesto', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597976197-2ll2i', 'priority', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Prioridad', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597973760-3orbj', 'description', 'editable', 0, 'tab-1776597062804-ectgm', TRUE, 'Descripción', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597922711-zigs5', 'cf_cliente', 'editable', 0, 'tab-1776597942109-kp50z', FALSE, 'Cliente', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776598169729-3aayi', 'description', 'editable', 0, 'tab-1776597863111-mxgvc', FALSE, 'Descripción', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776598173400-juyh6', 'priority', 'editable', 0, 'tab-1776597863111-mxgvc', FALSE, 'Prioridad', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597914557-fqkky', 'reporter', 'readonly', 0, 'tab-1776597062804-ectgm', FALSE, 'Informador', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1777888469792-5rswn', 'storyPoints', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Story Points', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1777978484807-o8ml6', 'cf_et3wxt', 'editable', 0, 'tab-1776597062804-ectgm', FALSE, 'Criticidad', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1777978495211-3sust', 'cf_et3wxt', 'editable', 0, 'tab-1776597863111-mxgvc', FALSE, 'Criticidad', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1778153226872-bxpfz', 'title', 'editable', 0, 'tab-auto-1776599735697-xcqsz', FALSE, 'Título', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1778153229047-y4ftk', 'description', 'editable', 0, 'tab-auto-1776599735697-xcqsz', FALSE, 'Descripción', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1778153230600-robb0', 'priority', 'editable', 0, 'tab-auto-1776599735697-xcqsz', FALSE, 'Prioridad', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1778153232177-wi0r0', 'status', 'editable', 0, 'tab-auto-1776599735697-xcqsz', FALSE, 'Estado', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1778153237127-ujdzs', 'assignee', 'editable', 0, 'tab-auto-1776599735697-xcqsz', FALSE, 'Responsable', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1778153239564-kuhk5', 'reporter', 'editable', 0, 'tab-auto-1776599735697-xcqsz', FALSE, 'Informador', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-1776597876938-j1oqn', 'assignee', 'editable', 0, 'tab-1776597869252-rmr6v', FALSE, 'Responsable', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-title', 'title', 'editable', 0, 'tab-crm-account-general', FALSE, 'Título', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-desc', 'description', 'editable', 1, 'tab-crm-account-general', FALSE, 'Descripción', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-status', 'status', 'editable', 2, 'tab-crm-account-general', FALSE, 'Estado', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-priority', 'priority', 'editable', 3, 'tab-crm-account-general', FALSE, 'Prioridad', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-assignee', 'assignee', 'editable', 4, 'tab-crm-account-general', FALSE, 'Responsable', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-reporter', 'reporter', 'editable', 5, 'tab-crm-account-general', FALSE, 'Informador', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-vat', 'cf_vat_cif', 'editable', 10, 'tab-crm-account-general', FALSE, 'VAT / CIF', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-person', 'cf_contact_person', 'editable', 11, 'tab-crm-account-general', FALSE, 'Contact Person', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-phone', 'cf_contact_phone', 'editable', 12, 'tab-crm-account-general', FALSE, 'Contact Phone', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-web', 'cf_website', 'editable', 13, 'tab-crm-account-general', FALSE, 'Website', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-ind', 'cf_industry', 'editable', 14, 'tab-crm-account-general', FALSE, 'Industry', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-size', 'cf_company_size', 'editable', 15, 'tab-crm-account-general', FALSE, 'Company Size', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-title', 'title', 'editable', 0, 'tab-crm-opp-general', FALSE, 'Título', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-desc', 'description', 'editable', 1, 'tab-crm-opp-general', FALSE, 'Descripción', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-status', 'status', 'editable', 2, 'tab-crm-opp-general', FALSE, 'Estado', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-priority', 'priority', 'editable', 3, 'tab-crm-opp-general', FALSE, 'Prioridad', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-assignee', 'assignee', 'editable', 4, 'tab-crm-opp-general', FALSE, 'Responsable', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-reporter', 'reporter', 'editable', 5, 'tab-crm-opp-general', FALSE, 'Informador', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-parent', 'parent', 'editable', 6, 'tab-crm-opp-general', FALSE, 'Parent/Cuenta', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-cf-amt', 'cf_original_amount', 'editable', 10, 'tab-crm-opp-general', FALSE, 'Original Amount', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-cf-curr', 'cf_opportunity_currency', 'editable', 11, 'tab-crm-opp-general', FALSE, 'Opportunity Currency', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-cf-base', 'cf_amount_in_base_currency', 'readonly', 12, 'tab-crm-opp-general', FALSE, 'Amount in Base Currency', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-cf-prob', 'cf_close_probability', 'editable', 13, 'tab-crm-opp-general', FALSE, 'Close Probability', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-opp-cf-date', 'cf_estimated_close_date', 'editable', 14, 'tab-crm-opp-general', FALSE, 'Estimated Close Date', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-email', 'cf_email', 'editable', 16, 'tab-crm-account-general', FALSE, 'Company Email', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-logo', 'cf_logo', 'editable', 17, 'tab-crm-account-general', FALSE, 'Company Logo', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-title', 'title', 'editable', 0, 'tab-crm-contact-general', FALSE, 'Nombre del Contacto', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-desc', 'description', 'editable', 1, 'tab-crm-contact-general', FALSE, 'Notas / Detalles', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-status', 'status', 'editable', 2, 'tab-crm-contact-general', FALSE, 'Estado', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-priority', 'priority', 'editable', 3, 'tab-crm-contact-general', FALSE, 'Prioridad', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-assignee', 'assignee', 'editable', 4, 'tab-crm-contact-general', FALSE, 'Responsable', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-reporter', 'reporter', 'editable', 5, 'tab-crm-contact-general', FALSE, 'Informador', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-parent', 'parent', 'editable', 6, 'tab-crm-contact-general', FALSE, 'Cuenta', 'system')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-email', 'cf_contact_email', 'editable', 10, 'tab-crm-contact-general', FALSE, 'Email del Contacto', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-phone', 'cf_contact_phone', 'editable', 11, 'tab-crm-contact-general', FALSE, 'Teléfono del Contacto', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-terms', 'cf_contact_accepted_terms', 'editable', 12, 'tab-crm-contact-general', FALSE, 'Acepta Términos', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-marketing', 'cf_contact_accepted_marketing', 'editable', 13, 'tab-crm-contact-general', FALSE, 'Acepta Comunicaciones', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-portal', 'cf_contact_create_portal_user', 'editable', 14, 'tab-crm-contact-general', FALSE, 'Crear Usuario Portal', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-address', 'cf_account_address', 'editable', 18, 'tab-crm-account-general', FALSE, 'Dirección de la Cuenta', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-acc-cf-country', 'cf_account_country', 'editable', 19, 'tab-crm-account-general', FALSE, 'País de la Cuenta', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-personal-email', 'cf_contact_personal_email', 'editable', 15, 'tab-crm-contact-general', FALSE, 'Email Personal', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-dept', 'cf_contact_department', 'editable', 16, 'tab-crm-contact-general', FALSE, 'Departamento', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-job-profile', 'cf_contact_job_profile', 'editable', 17, 'tab-crm-contact-general', FALSE, 'Perfil Profesional', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-job-title', 'cf_contact_job_title', 'editable', 18, 'tab-crm-contact-general', FALSE, 'Cargo', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-seniority', 'cf_contact_seniority', 'editable', 19, 'tab-crm-contact-general', FALSE, 'Seniority', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-address', 'cf_contact_address', 'editable', 20, 'tab-crm-contact-general', FALSE, 'Dirección', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";
INSERT INTO public.screen_fields ("id", "field_key", "field_mode", "field_order", "tab_id", "is_rich_text", "name", "type")
VALUES ('sf-crm-con-cf-country', 'cf_contact_country', 'editable', 21, 'tab-crm-contact-general', FALSE, 'País', 'custom')
ON CONFLICT ("id") DO UPDATE SET "field_key" = EXCLUDED."field_key", "field_mode" = EXCLUDED."field_mode", "field_order" = EXCLUDED."field_order", "tab_id" = EXCLUDED."tab_id", "is_rich_text" = EXCLUDED."is_rich_text", "name" = EXCLUDED."name", "type" = EXCLUDED."type";

-- 18. DEFINICIONES DE CAMPOS PERSONALIZADOS
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_vat_cif', 'VAT / CIF', 'cf_vat_cif', 'text', 'Company Tax ID', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.676Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_person', 'Contact Person', 'cf_contact_person', 'text', 'Main Contact Name', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.678Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_phone', 'Contact Phone', 'cf_contact_phone', 'text', 'Contact Phone Number', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.679Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_website', 'Website', 'cf_website', 'url', 'Company Website URL', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.681Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_industry', 'Industry', 'cf_industry', 'select', 'Company Industry/Sector', '["Technology","Finance","Services","Health","Retail","Other"]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.682Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_company_size', 'Company Size', 'cf_company_size', 'select', 'Total Employees', '["1-10","11-50","51-200","201+"]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.683Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_original_amount', 'Original Amount', 'cf_original_amount', 'number', 'Deal original amount', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.684Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_opportunity_currency', 'Opportunity Currency', 'cf_opportunity_currency', 'select', 'Deal currency', '["EUR","USD","GBP","MXN","JPY"]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.685Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_amount_in_base_currency', 'Amount in Base Currency', 'cf_amount_in_base_currency', 'number', 'Deal amount in corporate currency', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.686Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_close_probability', 'Close Probability', 'cf_close_probability', 'select', 'Winning probability', '["10%","30%","50%","75%","90%","100%"]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.687Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_estimated_close_date', 'Estimated Close Date', 'cf_estimated_close_date', 'date', 'Expected closing date', '[]'::jsonb, FALSE, FALSE, '2026-05-26T15:01:24.688Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_email', 'Company Email', 'cf_email', 'text', 'Company Email Address', '[]'::jsonb, FALSE, FALSE, '2026-05-27T15:23:11.427Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_logo', 'Company Logo', 'cf_logo', 'url', 'Company Logo Image URL', '[]'::jsonb, FALSE, FALSE, '2026-05-27T15:23:11.429Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_email', 'Email del Contacto', 'cf_contact_email', 'text', 'Correo electrónico del contacto', '[]'::jsonb, FALSE, FALSE, '2026-05-28T10:20:13.490Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_accepted_terms', 'Acepta Términos', 'cf_contact_accepted_terms', 'checkbox', 'Acepta los términos y condiciones de la compañía', '[]'::jsonb, FALSE, FALSE, '2026-05-28T10:20:13.492Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_accepted_marketing', 'Acepta Comunicaciones', 'cf_contact_accepted_marketing', 'checkbox', 'Acepta envíos de comunicaciones comerciales', '[]'::jsonb, FALSE, FALSE, '2026-05-28T10:20:13.493Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_create_portal_user', 'Crear Usuario Portal', 'cf_contact_create_portal_user', 'checkbox', 'Indica si se debe dar de alta al contacto como usuario del portal', '[]'::jsonb, FALSE, FALSE, '2026-05-28T10:20:13.494Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_email_sent', 'Email Consentimiento Enviado', 'cf_contact_email_sent', 'checkbox', 'Indica si ya se envió el email de consentimiento', '[]'::jsonb, FALSE, FALSE, '2026-05-28T10:20:13.495Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_personal_email', 'Email Personal', 'cf_contact_personal_email', 'text', 'Correo electrónico personal del contacto', '[]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.350Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_department', 'Departamento', 'cf_contact_department', 'text', 'Departamento del contacto', '[]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.351Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_job_profile', 'Perfil Profesional', 'cf_contact_job_profile', 'select', 'Perfil profesional o rol del contacto', '["Agile Coach","Analista Big Data","Analista Funcional","Arquitecto Big Data","Arquitecto de datos","Arquitecto Java","Arquitecto Microservicios","Chief Scrum Master","Comercial","Data Governance","Data Quality","Data Science","DBA","Desarrollador Big Data","Desarrollador Java","Desarrollador Microservicios","Devops","Digital Market Consultant","Documentación","DPO","Financiero","Front End","Fullstack","Marketing/Comunicación","Office manager","People","Preventa","Product Owner","QA","Scrum Master","Service Delivery","sysDev","Technical Lead","Técnico de Seguridad","Técnico de Sistemas","Técnico de Soporte","Técnico informática interna","Técnico microinformática","UX"]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.352Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_job_title', 'Cargo', 'cf_contact_job_title', 'text', 'Cargo o título profesional', '[]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.353Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_seniority', 'Seniority', 'cf_contact_seniority', 'select', 'Nivel de seniority del contacto', '["Analyst","CEO/President/Owner","C-level","Consultant","Director-level","Individual contributor","Manager-level","Partner","VP-level","Other"]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.354Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_address', 'Dirección del Contacto', 'cf_contact_address', 'text', 'Dirección física del contacto', '[]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.355Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_account_address', 'Dirección de la Cuenta', 'cf_account_address', 'text', 'Dirección física de la cuenta', '[]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.356Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_contact_country', 'País del Contacto', 'cf_contact_country', 'select', 'País de residencia del contacto', '["Afganistán","Albania","Alemania","Andorra","Angola","Antigua y Barbuda","Arabia Saudita","Argelia","Argentina","Armenia","Australia","Austria","Azerbaiyán","Bahamas","Bangladés","Barbados","Baréin","Bélgica","Belice","Benín","Bielorrusia","Birmania","Bolivia","Bosnia y Herzegovina","Botsuana","Brasil","Brunéi","Bulgaria","Burkina Faso","Burundi","Bután","Cabo Verde","Camboya","Camerún","Canadá","Catar","Chad","Chile","China","Chipre","Ciudad del Vaticano","Colombia","Comoras","Corea del Norte","Corea del Sur","Costa de Marfil","Costa Rica","Croacia","Cuba","Dinamarca","Dominica","Ecuador","Egipto","El Salvador","Emiratos Árabes Unidos","Eritrea","Eslovaquia","Eslovenia","España","Estados Unidos","Estonia","Etiopía","Filipinas","Finlandia","Fiyi","Francia","Gabón","Gambia","Georgia","Ghana","Granada","Grecia","Guatemala","Guyana","Guinea","Guinea Ecuatorial","Guinea-Bisáu","Haití","Honduras","Hungría","India","Indonesia","Irak","Irán","Irlanda","Islandia","Islas Marshall","Islas Salomón","Israel","Italia","Jamaica","Japón","Jordania","Kazajistán","Kenia","Kirguistán","Kiribati","Kuwait","Laos","Lesoto","Letonia","Líbano","Liberia","Libia","Liechtenstein","Lituania","Luxemburgo","Macedonia del Norte","Madagascar","Malasia","Malaui","Maldivas","Malí","Malta","Marruecos","Mauricio","Mauritania","México","Micronesia","Moldavia","Mónaco","Mongolia","Montenegro","Mozambique","Namibia","Nauru","Nepal","Nicaragua","Níger","Nigeria","Noruega","Nueva Zelanda","Omán","Países Bajos","Pakistán","Palaos","Panamá","Papúa Nueva Guinea","Paraguay","Perú","Polonia","Portugal","Reino Unido","República Centroafricana","República Checa","República del Congo","República Democrática del Congo","República Dominicana","Ruanda","Rumania","Rusia","Samoa","San Cristóbal y Nieves","San Marino","San Vicente y las Granadinas","Santa Lucía","Santo Tomé y Príncipe","Senegal","Serbia","Seychelles","Sierra Leona","Singapur","Siria","Somalia","Sri Lanka","Suazilandia","Sudáfrica","Sudán","Sudán del Sur","Suecia","Suiza","Surinam","Tailandia","Taiwán","Tanzania","Tayikistán","Timor Oriental","Togo","Tonga","Trinidad y Tobago","Túnez","Turkmenistán","Turquía","Tuvalu","Ucrania","Uganda","Uruguay","Uzbekistán","Vanuatu","Venezuela","Vietnam","Yemen","Yibuti","Zambia","Zimbabue"]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.357Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_fields ("id", "name", "field_key", "field_type", "description", "options", "is_required", "is_system", "created_at")
VALUES ('cf_account_country', 'País de la Cuenta', 'cf_account_country', 'select', 'País de registro de la cuenta', '["Afganistán","Albania","Alemania","Andorra","Angola","Antigua y Barbuda","Arabia Saudita","Argelia","Argentina","Armenia","Australia","Austria","Azerbaiyán","Bahamas","Bangladés","Barbados","Baréin","Bélgica","Belice","Benín","Bielorrusia","Birmania","Bolivia","Bosnia y Herzegovina","Botsuana","Brasil","Brunéi","Bulgaria","Burkina Faso","Burundi","Bután","Cabo Verde","Camboya","Camerún","Canadá","Catar","Chad","Chile","China","Chipre","Ciudad del Vaticano","Colombia","Comoras","Corea del Norte","Corea del Sur","Costa de Marfil","Costa Rica","Croacia","Cuba","Dinamarca","Dominica","Ecuador","Egipto","El Salvador","Emiratos Árabes Unidos","Eritrea","Eslovaquia","Eslovenia","España","Estados Unidos","Estonia","Etiopía","Filipinas","Finlandia","Fiyi","Francia","Gabón","Gambia","Georgia","Ghana","Granada","Grecia","Guatemala","Guyana","Guinea","Guinea Ecuatorial","Guinea-Bisáu","Haití","Honduras","Hungría","India","Indonesia","Irak","Irán","Irlanda","Islandia","Islas Marshall","Islas Salomón","Israel","Italia","Jamaica","Japón","Jordania","Kazajistán","Kenia","Kirguistán","Kiribati","Kuwait","Laos","Lesoto","Letonia","Líbano","Liberia","Libia","Liechtenstein","Lituania","Luxemburgo","Macedonia del Norte","Madagascar","Malasia","Malaui","Maldivas","Malí","Malta","Marruecos","Mauricio","Mauritania","México","Micronesia","Moldavia","Mónaco","Mongolia","Montenegro","Mozambique","Namibia","Nauru","Nepal","Nicaragua","Níger","Nigeria","Noruega","Nueva Zelanda","Omán","Países Bajos","Pakistán","Palaos","Panamá","Papúa Nueva Guinea","Paraguay","Perú","Polonia","Portugal","Reino Unido","República Centroafricana","República Checa","República del Congo","República Democrática del Congo","República Dominicana","Ruanda","Rumania","Rusia","Samoa","San Cristóbal y Nieves","San Marino","San Vicente y las Granadinas","Santa Lucía","Santo Tomé y Príncipe","Senegal","Serbia","Seychelles","Sierra Leona","Singapur","Siria","Somalia","Sri Lanka","Suazilandia","Sudáfrica","Sudán","Sudán del Sur","Suecia","Suiza","Surinam","Tailandia","Taiwán","Tanzania","Tayikistán","Timor Oriental","Togo","Tonga","Trinidad y Tobago","Túnez","Turkmenistán","Turquía","Tuvalu","Ucrania","Uganda","Uruguay","Uzbekistán","Vanuatu","Venezuela","Vietnam","Yemen","Yibuti","Zambia","Zimbabue"]'::jsonb, FALSE, FALSE, '2026-05-28T11:02:02.360Z')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "field_key" = EXCLUDED."field_key", "field_type" = EXCLUDED."field_type", "description" = EXCLUDED."description", "options" = EXCLUDED."options", "is_required" = EXCLUDED."is_required", "is_system" = EXCLUDED."is_system", "created_at" = EXCLUDED."created_at";

-- 17. CONTEXTOS DE CAMPOS PERSONALIZADOS
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_vat_cif-account', 'cf_vat_cif', 'proj-crm', 'account', '2026-05-26T15:01:24.689Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_person-account', 'cf_contact_person', 'proj-crm', 'account', '2026-05-26T15:01:24.692Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_phone-account', 'cf_contact_phone', 'proj-crm', 'account', '2026-05-26T15:01:24.694Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_website-account', 'cf_website', 'proj-crm', 'account', '2026-05-26T15:01:24.695Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_industry-account', 'cf_industry', 'proj-crm', 'account', '2026-05-26T15:01:24.696Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_company_size-account', 'cf_company_size', 'proj-crm', 'account', '2026-05-26T15:01:24.697Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_original_amount-opportunity', 'cf_original_amount', 'proj-crm', 'opportunity', '2026-05-26T15:01:24.698Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_opportunity_currency-opportunity', 'cf_opportunity_currency', 'proj-crm', 'opportunity', '2026-05-26T15:01:24.699Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_amount_in_base_currency-opportunity', 'cf_amount_in_base_currency', 'proj-crm', 'opportunity', '2026-05-26T15:01:24.701Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_close_probability-opportunity', 'cf_close_probability', 'proj-crm', 'opportunity', '2026-05-26T15:01:24.702Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_estimated_close_date-opportunity', 'cf_estimated_close_date', 'proj-crm', 'opportunity', '2026-05-26T15:01:24.703Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_email-account', 'cf_email', 'proj-crm', 'account', '2026-05-27T15:23:11.434Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_logo-account', 'cf_logo', 'proj-crm', 'account', '2026-05-27T15:23:11.436Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_email-contact', 'cf_contact_email', 'proj-crm', 'contact', '2026-05-28T10:20:13.500Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_phone-contact', 'cf_contact_phone', 'proj-crm', 'contact', '2026-05-28T10:20:13.503Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_accepted_terms-contact', 'cf_contact_accepted_terms', 'proj-crm', 'contact', '2026-05-28T10:20:13.504Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_accepted_marketing-contact', 'cf_contact_accepted_marketing', 'proj-crm', 'contact', '2026-05-28T10:20:13.505Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_create_portal_user-contact', 'cf_contact_create_portal_user', 'proj-crm', 'contact', '2026-05-28T10:20:13.506Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_email_sent-contact', 'cf_contact_email_sent', 'proj-crm', 'contact', '2026-05-28T10:20:13.507Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_personal_email-contact', 'cf_contact_personal_email', 'proj-crm', 'contact', '2026-05-28T11:02:02.368Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_department-contact', 'cf_contact_department', 'proj-crm', 'contact', '2026-05-28T11:02:02.370Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_job_profile-contact', 'cf_contact_job_profile', 'proj-crm', 'contact', '2026-05-28T11:02:02.371Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_job_title-contact', 'cf_contact_job_title', 'proj-crm', 'contact', '2026-05-28T11:02:02.372Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_seniority-contact', 'cf_contact_seniority', 'proj-crm', 'contact', '2026-05-28T11:02:02.374Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_address-contact', 'cf_contact_address', 'proj-crm', 'contact', '2026-05-28T11:02:02.375Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_account_address-account', 'cf_account_address', 'proj-crm', 'account', '2026-05-28T11:02:02.376Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_contact_country-contact', 'cf_contact_country', 'proj-crm', 'contact', '2026-05-28T11:02:02.377Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";
INSERT INTO public.custom_field_contexts ("id", "field_id", "project_id", "issue_type_id", "created_at")
VALUES ('ctx-crm-cf_account_country-account', 'cf_account_country', 'proj-crm', 'account', '2026-05-28T11:02:02.378Z')
ON CONFLICT ("id") DO UPDATE SET "field_id" = EXCLUDED."field_id", "project_id" = EXCLUDED."project_id", "issue_type_id" = EXCLUDED."issue_type_id", "created_at" = EXCLUDED."created_at";

-- 19. TABLEROS (BOARDS)
INSERT INTO public.boards ("id", "project_id", "name", "board_type", "pjql_filter", "created_at", "card_fields")
VALUES ('board-1777885973981', 'p-pf', 'PF_Scrum', 'scrum', 'project = "ProjectFlow Core"', '2026-05-04T09:12:53.996Z', '{}'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "project_id" = EXCLUDED."project_id", "name" = EXCLUDED."name", "board_type" = EXCLUDED."board_type", "pjql_filter" = EXCLUDED."pjql_filter", "created_at" = EXCLUDED."created_at", "card_fields" = EXCLUDED."card_fields";
INSERT INTO public.boards ("id", "project_id", "name", "board_type", "pjql_filter", "created_at", "card_fields")
VALUES ('board-crm', 'proj-crm', 'CRM Board', 'kanban', 'project = "CRM"', '2026-05-26T15:02:21.281Z', '[]'::jsonb)
ON CONFLICT ("id") DO UPDATE SET "project_id" = EXCLUDED."project_id", "name" = EXCLUDED."name", "board_type" = EXCLUDED."board_type", "pjql_filter" = EXCLUDED."pjql_filter", "created_at" = EXCLUDED."created_at", "card_fields" = EXCLUDED."card_fields";

-- 20. COLUMNAS DE TABLEROS
INSERT INTO public.board_columns ("id", "board_id", "name", "status_ids", "order_index")
VALUES ('col-1777885973964-0', 'board-1777885973981', 'Por Hacer', ARRAY['wfs-sim-todo', 'state-todo-1777886403524'], 0)
ON CONFLICT ("id") DO UPDATE SET "board_id" = EXCLUDED."board_id", "name" = EXCLUDED."name", "status_ids" = EXCLUDED."status_ids", "order_index" = EXCLUDED."order_index";
INSERT INTO public.board_columns ("id", "board_id", "name", "status_ids", "order_index")
VALUES ('col-1777885973964-1', 'board-1777885973981', 'Abierto', ARRAY['wfs-bug-open', 'wfs-bug-investigating'], 1)
ON CONFLICT ("id") DO UPDATE SET "board_id" = EXCLUDED."board_id", "name" = EXCLUDED."name", "status_ids" = EXCLUDED."status_ids", "order_index" = EXCLUDED."order_index";
INSERT INTO public.board_columns ("id", "board_id", "name", "status_ids", "order_index")
VALUES ('col-1777885973964-5', 'board-1777885973981', 'In progress', ARRAY['wfs-bug-fixing', 'state-1777971417760'], 2)
ON CONFLICT ("id") DO UPDATE SET "board_id" = EXCLUDED."board_id", "name" = EXCLUDED."name", "status_ids" = EXCLUDED."status_ids", "order_index" = EXCLUDED."order_index";
INSERT INTO public.board_columns ("id", "board_id", "name", "status_ids", "order_index")
VALUES ('col-1777885973964-6', 'board-1777885973981', 'En Pruebas', ARRAY['wfs-bug-inqa'], 3)
ON CONFLICT ("id") DO UPDATE SET "board_id" = EXCLUDED."board_id", "name" = EXCLUDED."name", "status_ids" = EXCLUDED."status_ids", "order_index" = EXCLUDED."order_index";
INSERT INTO public.board_columns ("id", "board_id", "name", "status_ids", "order_index")
VALUES ('col-1777885973964-7', 'board-1777885973981', 'Cerrado', ARRAY['wfs-bug-closed', 'state-done-1777886403524'], 4)
ON CONFLICT ("id") DO UPDATE SET "board_id" = EXCLUDED."board_id", "name" = EXCLUDED."name", "status_ids" = EXCLUDED."status_ids", "order_index" = EXCLUDED."order_index";



