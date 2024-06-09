---------------------------- adl.dept_db_version ----------------------------------

CREATE TABLE adl.dept_db_version
(
	value         VARCHAR2(10) NOT NULL,
	upgrade_value VARCHAR2(10),
	upgrade_step  NUMBER(10),
    database_id   VARCHAR2(20)
) 
PCTFREE 5
TABLESPACE scm_tbs0
STORAGE (BUFFER_POOL KEEP);

CREATE UNIQUE INDEX adl.i_dept_db_vers_1 ON adl.dept_db_version (value) TABLESPACE scm_idx0
PCTFREE 5
STORAGE (BUFFER_POOL KEEP);

INSERT INTO adl.dept_db_version
(value)
VALUES
('2005_03_07');

COMMIT;

---------------------------- adl.site ----------------------------------

CREATE TABLE adl.site
(
	id          VARCHAR2(20) NOT NULL,
	lower_name  VARCHAR2(32)   NOT NULL,
	case_name   VARCHAR2(32) NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_site_1 ON adl.site (id) TABLESPACE scm_idx0
PCTFREE 10;
CREATE INDEX adl.i_site_2 ON adl.site (lower_name) TABLESPACE scm_idx0
PCTFREE 10;

COMMIT;

---------------------------- adl.database ----------------------------------

CREATE TABLE adl.database
(
	id                VARCHAR2(20)  NOT NULL,
	case_name         VARCHAR2(255) NOT NULL,
	upper_name        VARCHAR2(255) NOT NULL,
	is_central        VARCHAR2(1)   NOT NULL,
	is_dept           VARCHAR2(1)   NOT NULL,
	is_monitor        VARCHAR2(1)   NOT NULL,
	description       VARCHAR2(250)         ,
	creation_hist_evt VARCHAR2(20)  NOT NULL
) PCTFREE 10 
TABLESPACE scm_tbs0
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_database_1 ON adl.database (id) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);
CREATE INDEX adl.i_database_2 ON adl.database (upper_name, is_dept) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.counter ----------------------------------

CREATE TABLE adl.counter
(
	id    VARCHAR2(20) NOT NULL,
	type  VARCHAR2(15) NOT NULL,
	value NUMBER(10)   NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

CREATE UNIQUE INDEX adl.i_counter_1 ON adl.counter (id) TABLESPACE scm_idx0
PCTFREE 5;

INSERT INTO adl.counter
(id,     type,          value)
VALUES
('xxxx', 'PER_ATT_MOD', 100);

INSERT INTO adl.counter
(id,     type,          value)
VALUES
('yyyy', 'PER_CHD_MOD', 100);

COMMIT;

---------------------------- adl.multi_tree_ws ----------------------------------

CREATE TABLE adl.multi_tree_ws
(
	id                 VARCHAR2(20) NOT NULL,
	case_name          VARCHAR2(32) NOT NULL,
	lower_name         VARCHAR2(32) NOT NULL,
	is_deleted         VARCHAR2(1)  NOT NULL,
	nb_linked_ws       NUMBER(10)   NOT NULL,
	native_database    VARCHAR2(20) NOT NULL,
	merge_cmd_end      VARCHAR2(1)  NOT NULL,
	case_tck           VARCHAR2(32)         ,
	lower_tck          VARCHAR2(32)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_multi_tree_ws_1 ON adl.multi_tree_ws (id) TABLESPACE scm_idx1
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);
-- * Recherche d'un ensemble d'espaces de travail non supprimé à partir du nom
CREATE INDEX        adl.i_multi_tree_ws_2 ON adl.multi_tree_ws (lower_name, is_deleted) TABLESPACE scm_idx1
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.workspace_tree ----------------------------------

CREATE TABLE adl.workspace_tree
(
	id                 VARCHAR2(20) NOT NULL,
	case_name          VARCHAR2(32) NOT NULL,
	lower_name         VARCHAR2(32) NOT NULL,
	is_deleted         VARCHAR2(1)  NOT NULL,
	contents_server    VARCHAR2(20) NOT NULL,
	database           VARCHAR2(20) NOT NULL,
	promo_with_cr_mode VARCHAR2(10) NOT NULL,
	check_caa_rules    VARCHAR2(1)  NOT NULL,
	case_soft_level    VARCHAR2(32)         ,
	lower_soft_level   VARCHAR2(32)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs0
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_workspace_tree_1 ON adl.workspace_tree (id) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);
-- * Recherche d'une arborescence non supprimée à partir du nom
CREATE INDEX        adl.i_workspace_tree_2 ON adl.workspace_tree (lower_name, is_deleted) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.workspace ----------------------------------

CREATE TABLE adl.workspace
(
	id                 VARCHAR2(20) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	multi_tree_ws      VARCHAR2(20) NOT NULL,
	case_name          VARCHAR2(32) NOT NULL,
	lower_name         VARCHAR2(32) NOT NULL,
	is_deleted         VARCHAR2(1)  NOT NULL,
	request_is_locked  VARCHAR2(1)  NOT NULL,
	allow_auto_merge   VARCHAR2(1)  NOT NULL,
	allow_promo_any_ws VARCHAR2(1)  NOT NULL,
	allow_sync_cmd     VARCHAR2(1)  NOT NULL,
	allow_promote_cmd  VARCHAR2(1)  NOT NULL,
	allow_mrg_collect  VARCHAR2(1)  NOT NULL,
	child_sync_promo   VARCHAR2(1)  NOT NULL,
	flow_traces_files  VARCHAR2(1)  NOT NULL,
	chg_req_ws_typ     VARCHAR2(10) NOT NULL,
	publication_type   VARCHAR2(10) NOT NULL,
	per_attached_mod   NUMBER(10)           ,
	promo_with_cr_mode VARCHAR2(10)         ,
	check_caa_rules    VARCHAR2(1)          ,
	case_soft_level    VARCHAR2(32)         ,
	lower_soft_level   VARCHAR2(32)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL,
	deletion_hist_evt  VARCHAR2(20)
) 
PCTFREE 10
TABLESPACE scm_tbs2
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_workspace_1 ON adl.workspace (id) TABLESPACE scm_idx2
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche d'un espace de travail non supprimé avec le nom en minuscule 
CREATE        INDEX adl.i_workspace_2 ON adl.workspace (lower_name, is_deleted) TABLESPACE scm_idx2
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche d'un espace de travail non supprimé avec son espace multi-arborescence
CREATE        INDEX adl.i_workspace_3 ON adl.workspace (multi_tree_ws, is_deleted) TABLESPACE scm_idx2
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche d'un espace de travail non supprimé avec son arborescence d'espace de travail
CREATE        INDEX adl.i_workspace_4 ON adl.workspace (workspace_tree, is_deleted) TABLESPACE scm_idx2
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.workspace_counter ----------------------------------

CREATE TABLE adl.workspace_counter
(
	id        VARCHAR2(20) NOT NULL,
	type      VARCHAR2(10) NOT NULL,
	workspace VARCHAR2(20) NOT NULL,
	value     NUMBER(10)   NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_counter_1 ON adl.workspace_counter (id) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche sur le type et la branche
CREATE UNIQUE INDEX adl.i_ws_counter_2 ON adl.workspace_counter (workspace, type) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.workspace_revision ----------------------------------

CREATE TABLE adl.workspace_revision
(
	id_level_hist_rank VARCHAR2(27) NOT NULL,
	rank               NUMBER(10)   NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	ws_rev_level       NUMBER(10)   NOT NULL,
	previous_ws_rev    VARCHAR2(27)         ,
	first_history_rank NUMBER(10)   NOT NULL,
	last_history_rank  NUMBER(10)           ,
	last_refresh_rank  NUMBER(10)           ,
	parent_workspace   VARCHAR2(20)         ,
	main_config_branch VARCHAR2(22) NOT NULL,
	has_local_modif    VARCHAR2(1)  NOT NULL,
	is_working         VARCHAR2(1)  NOT NULL,
	reason             VARCHAR2(10) NOT NULL,
	sync_with_ws_rev   VARCHAR2(27)         ,
	sync_with_hist_rk  NUMBER(10)           ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_rev_1 ON adl.workspace_revision (id_level_hist_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche de la dernière version d'un espace de travail
CREATE UNIQUE INDEX adl.i_ws_rev_2 ON adl.workspace_revision (workspace, first_history_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche de la version d'un espace de travail avec un espace pere donné
CREATE        INDEX adl.i_ws_rev_3 ON adl.workspace_revision (parent_workspace, workspace) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.deleted_ws_group ----------------------------------

CREATE TABLE adl.deleted_ws_group
(
	elem_id            VARCHAR2(20) NOT NULL,
	group_id           VARCHAR2(20) NOT NULL,
	multi_tree_ws      VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	group_nb_elements  NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant de l'élément
CREATE UNIQUE INDEX adl.i_deleted_ws_grp_1 ON adl.deleted_ws_group (elem_id) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche des espaces de travail supprimés d'un espace de travail multi-arborescence
CREATE INDEX        adl.i_deleted_ws_grp_2 ON adl.deleted_ws_group (multi_tree_ws) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.image ----------------------------------

CREATE TABLE adl.image
(
	id                 VARCHAR2(20)  NOT NULL,
	type               VARCHAR2(10)  NOT NULL,
	multi_tree_ws      VARCHAR2(20)  NOT NULL,
	case_name          VARCHAR2(32)  NOT NULL,
	lower_name         VARCHAR2(32)  NOT NULL,
	case_proj_path     VARCHAR2(512) NOT NULL,
	lower_proj_path    VARCHAR2(512) NOT NULL,
	local_path_host    VARCHAR2(255)         ,
	is_deleted         VARCHAR2(1)   NOT NULL,
	case_tck           VARCHAR2(32)          ,
	lower_tck          VARCHAR2(32)          ,
	creation_hist_evt  VARCHAR2(20)  NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_image_1 ON adl.image (id) TABLESPACE scm_idx1
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche l'image non supprimée avec le nom en minuscule et l'espace de travail multi-arborescence
CREATE INDEX        adl.i_image_2 ON adl.image (multi_tree_ws, is_deleted, lower_name) TABLESPACE scm_idx1
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche l'image non supprimée avec le chemin en minuscules
CREATE INDEX        adl.i_image_3 ON adl.image (lower_proj_path, is_deleted) TABLESPACE scm_idx1
PCTFREE 10 
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.deleted_img_group ----------------------------------

CREATE TABLE adl.deleted_img_group
(
	elem_id            VARCHAR2(20) NOT NULL,
	group_id           VARCHAR2(20) NOT NULL,
	multi_tree_ws      VARCHAR2(20) NOT NULL,
	image              VARCHAR2(20) NOT NULL,
	group_nb_elements  NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant de l'élément
CREATE UNIQUE INDEX adl.i_del_img_grp_1 ON adl.deleted_img_group (elem_id) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche des images supprimées d'un espace de travail multi-arborescence
CREATE INDEX        adl.i_del_img_grp_2 ON adl.deleted_img_group (multi_tree_ws) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.last_ws_refresh ----------------------------------

CREATE TABLE adl.last_ws_refresh
(
	id                 VARCHAR2(20)  NOT NULL,
	image              VARCHAR2(20)  NOT NULL,
	workspace          VARCHAR2(20)  NOT NULL,
	workspace_revision VARCHAR2(27)  NOT NULL,
	history_rank       NUMBER(10)    NOT NULL,
	refresh_rank       NUMBER(10)    NOT NULL,
	is_projected       VARCHAR2(1)   NOT NULL,
	creation_hist_evt  VARCHAR2(20)  NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_last_ws_refresh1 ON adl.last_ws_refresh (id) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche de tous les derniers rafraîchissements d'un espace de travail
CREATE INDEX        adl.i_last_ws_refresh_2 ON adl.last_ws_refresh (workspace, is_projected) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.refreshed_ws_group ----------------------------------

CREATE TABLE adl.refreshed_ws_group
(
	elem_id            VARCHAR2(20) NOT NULL,
	group_id           VARCHAR2(20) NOT NULL,
	image              VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	group_nb_elements  NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_refreshed_ws_gr1 ON adl.refreshed_ws_group (elem_id) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche de tous les derniers rafraîchissements d'un espace de travail
CREATE INDEX        adl.i_refreshed_ws_gr2 ON adl.refreshed_ws_group (image) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur le groupe
CREATE INDEX        adl.i_refreshed_ws_gr3 ON adl.refreshed_ws_group (group_id) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.configuration ----------------------------------

CREATE TABLE adl.configuration
(
	id                 VARCHAR2(20) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_configuration_1 ON adl.configuration (id) TABLESPACE scm_idx0
PCTFREE 5
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.config_branch ----------------------------------

CREATE TABLE adl.config_branch
(
	id_level           VARCHAR2(22) NOT NULL,
	branch_level       NUMBER(10)   NOT NULL,
	configuration      VARCHAR2(20) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	per_changed_so_mod NUMBER(10)           ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_config_branch_1 ON adl.config_branch (id_level) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche sur espace de travail
CREATE        INDEX adl.i_config_branch_2 ON adl.config_branch (workspace) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);
-- * Recherche sur arborescence d'espace de travail
CREATE        INDEX adl.i_config_branch_3 ON adl.config_branch (workspace_tree) TABLESPACE scm_idx1
PCTFREE 5 
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.config_revision ----------------------------------

CREATE TABLE adl.config_revision
(
	id_level_hist_rank VARCHAR2(27) NOT NULL,
	rank               NUMBER(10)   NOT NULL,
	config_branch      VARCHAR2(22) NOT NULL,
	config_branch_type VARCHAR2(10) NOT NULL,
	cfg_br_level       NUMBER(10)   NOT NULL,
	previous_cfg_rev   VARCHAR2(27)         ,
	inv_cfg_rev_group  VARCHAR2(20)         ,
	type               VARCHAR2(10) NOT NULL,
	first_history_rank NUMBER(10)   NOT NULL,
	last_history_rank  NUMBER(10)           ,
	is_working         VARCHAR2(1)  NOT NULL,
	sync_with_cfg_rev  VARCHAR2(27)         ,
	sync_with_hist_rk  NUMBER(10)           ,
	first_so_chg_cr    VARCHAR2(27)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_cfg_rev_1 ON adl.config_revision (id_level_hist_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche de la dernière version de configuration d'une branche, version valide ou non
CREATE UNIQUE INDEX adl.i_cfg_rev_2 ON adl.config_revision (config_branch, first_history_rank) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.inv_cfg_rev_group ----------------------------------

CREATE TABLE adl.inv_cfg_rev_group
(
	elem_id            VARCHAR2(20) NOT NULL,
	group_id           VARCHAR2(20) NOT NULL,
	is_first           VARCHAR2 (1) NOT NULL,
	group_nb_elements  NUMBER(10)   NOT NULL,
	config_branch      VARCHAR2(22) NOT NULL,
	config_revision    VARCHAR2(27) NOT NULL,
	cr_first_hist_rank NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur l'identifiant de l'élément
CREATE UNIQUE INDEX adl.i_inv_cr_grp_1 ON adl.inv_cfg_rev_group (elem_id) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche sur l'identifiant du groupe
CREATE INDEX        adl.i_inv_cr_grp_2 ON adl.inv_cfg_rev_group (group_id) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche de toutes les versions invalides entre deux rangs historiques
CREATE INDEX        adl.i_inv_cr_grp_3 ON adl.inv_cfg_rev_group (config_branch, cr_first_hist_rank) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.cfg_rev_in_ws ----------------------------------

CREATE TABLE adl.cfg_rev_in_ws
(
	id_hist_rank       VARCHAR2(25) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	first_ws_rev       VARCHAR2(27) NOT NULL,
	first_history_rank NUMBER(10)   NOT NULL,
	config_branch      VARCHAR2(22) NOT NULL,
	config_revision    VARCHAR2(27)         , 
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_cr_in_ws_1 ON adl.cfg_rev_in_ws (id_hist_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche du derniere version d'une branche de configuration visible depuis une version d'espace de travail
CREATE INDEX        adl.i_cr_in_ws_2 ON adl.cfg_rev_in_ws (config_branch, workspace, first_history_rank) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.software_object ----------------------------------

CREATE TABLE adl.software_object
(
	id                 VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	is_folder          VARCHAR2 (1) NOT NULL,
	is_component       VARCHAR2 (1) NOT NULL,
	projected_as_file  VARCHAR2 (1) NOT NULL,
	rank_init          NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_soft_obj_1 ON adl.software_object (id) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.so_resp_in_wstree ----------------------------------

CREATE TABLE adl.so_resp_in_wstree
(
	id                VARCHAR2(20) NOT NULL,
	software_object   VARCHAR2(20) NOT NULL,
	workspace_tree    VARCHAR2(20) NOT NULL,
	responsible       VARCHAR2(20) NOT NULL,
	creation_hist_evt VARCHAR2(20) NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_resp_wstree_1 ON adl.so_resp_in_wstree (id) TABLESPACE scm_idx1
PCTFREE 10;
-- *Recherche du responsable d'un objet logiciel dans une arborescence
CREATE INDEX        adl.i_so_resp_wstree_2 ON adl.so_resp_in_wstree (software_object, workspace_tree) TABLESPACE scm_idx1
PCTFREE 10;
-- * Recherche du responsable de tous les objets dans une arborescence
CREATE INDEX        adl.i_so_resp_wstree_3 ON adl.so_resp_in_wstree (workspace_tree, responsible) TABLESPACE scm_idx1
PCTFREE 10;

COMMIT;

---------------------------- adl.perhaps_attached ----------------------------------

CREATE TABLE adl.perhaps_attached
(
	id                 VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	first_ws_rev_rank  NUMBER(10)   NOT NULL,
	next_ws_rev_rank   NUMBER(10)   NOT NULL,
	component          VARCHAR2(20) NOT NULL,
	creation_modulo    NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_per_att_1 ON adl.perhaps_attached (id) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche de tous les attachements potentiels visibles depuis une version de configuration
CREATE INDEX        adl.i_per_att_2 ON adl.perhaps_attached (workspace, first_ws_rev_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche de tous les attachements potentiels arrivés à échéance
CREATE INDEX        adl.i_per_att_3 ON adl.perhaps_attached (workspace, next_ws_rev_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche des attachements potentiels d'un composant donné visible depuis une version de configuration
CREATE INDEX        adl.i_per_att_4 ON adl.perhaps_attached (component, workspace, first_ws_rev_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche des attachements potentiels créés avec un modulo donné (si changement de modulo)
CREATE INDEX        adl.i_per_att_5 ON adl.perhaps_attached (creation_modulo) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.attached_component ----------------------------------

CREATE TABLE adl.attached_component
(
	id_level_hist_rank VARCHAR2(27) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	first_ws_rev       VARCHAR2(27) NOT NULL,
	first_history_rank NUMBER(10)   NOT NULL,
	component          VARCHAR2(20) NOT NULL,
	config_branch      VARCHAR2(22)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_att_comp_1 ON adl.attached_component (id_level_hist_rank) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche du dernier attachement d'un composant visible depuis une version de configuration
CREATE INDEX        adl.i_att_comp_2 ON adl.attached_component (workspace, component, first_history_rank) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.perhaps_changed_so ----------------------------------

CREATE TABLE adl.perhaps_changed_so
(
	id                 VARCHAR2(20) NOT NULL,
	config_branch      VARCHAR2(22) NOT NULL,
	first_cfg_rev_rank NUMBER(10)   NOT NULL,
	next_cfg_rev_rank  NUMBER(10)   NOT NULL,
	creation_modulo    NUMBER(10)   NOT NULL,
	software_object    VARCHAR2(20) NOT NULL,
	is_component       VARCHAR2(1)  NOT NULL,
	with_move          VARCHAR2(1)  NOT NULL,
	folder             VARCHAR2(20)         ,
	projected_name     VARCHAR2(20)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_per_chg_so_1 ON adl.perhaps_changed_so (id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des objets potentiellement modifiés depuis une version de configuration
CREATE INDEX        adl.i_per_chg_so_2 ON adl.perhaps_changed_so (config_branch, first_cfg_rev_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des objets potentiellement modifiés arrivés à échéance
CREATE INDEX        adl.i_per_chg_so_3 ON adl.perhaps_changed_so (config_branch, next_cfg_rev_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des objets potentiellement inclus dans un dossier depuis une version de configuration
CREATE INDEX        adl.i_per_chg_so_4 ON adl.perhaps_changed_so (with_move, folder, config_branch, first_cfg_rev_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche de la modification potentielle d'un objet logiciel dans une version de configuration
CREATE INDEX        adl.i_per_chg_so_5 ON adl.perhaps_changed_so (software_object, config_branch, first_cfg_rev_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des objets potentiellement inclus dans un dossier sous un nom de projection donné depuis une version de configuration
CREATE INDEX        adl.i_per_chg_so_6 ON adl.perhaps_changed_so (with_move, folder, projected_name, config_branch, first_cfg_rev_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des objets potentiellement sous un nom de projection donné
CREATE INDEX        adl.i_per_chg_so_7 ON adl.perhaps_changed_so (with_move, projected_name, config_branch) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.projected_name ----------------------------------

CREATE TABLE adl.projected_name
(
	id          VARCHAR2 (20) NOT NULL,
	case_value  VARCHAR2(128) NOT NULL,
	lower_value VARCHAR2(128) NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_proj_name_1 ON adl.projected_name (id) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur le nom avec respect majuscules / minuscules
CREATE INDEX        adl.i_proj_name_2 ON adl.projected_name (case_value) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur le nom en minuscules
CREATE INDEX        adl.i_proj_name_3 ON adl.projected_name (lower_value) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.file_content ----------------------------------

CREATE TABLE adl.file_content
(
	id                VARCHAR2(20) NOT NULL,
	type              VARCHAR2(10) NOT NULL,
	fs_creation_date  DATE         NOT NULL,
	size_on_server    NUMBER(10)   NOT NULL,
	creation_hist_evt VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_file_content_1 ON adl.file_content (id) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.contents_server ----------------------------------

CREATE TABLE adl.contents_server
(
	id                 VARCHAR2(20)  NOT NULL,
	host_name          VARCHAR2(255) NOT NULL,
	port_number        NUMBER(10)    NOT NULL,
	description        VARCHAR2(250)         ,
	creation_hist_evt  VARCHAR2(20)  NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs0
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_contents_serv_1 ON adl.contents_server (id) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.file_cont_in_srvr ----------------------------------

CREATE TABLE adl.file_cont_in_srvr
(
	id                VARCHAR2(20) NOT NULL,
	workspace_tree    VARCHAR2(20) NOT NULL,
	file_content      VARCHAR2(20) NOT NULL,
	contents_server   VARCHAR2(20) NOT NULL,
	creation_hist_evt VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_fc_in_srvr_1 ON adl.file_cont_in_srvr (id) TABLESPACE scm_idx2
PCTFREE 5;

-- *Recherche du serveur de contenu d'un contenu de fichier dans une arborescence
CREATE INDEX adl.i_fc_in_srvr_2 ON adl.file_cont_in_srvr (file_content, workspace_tree) TABLESPACE scm_idx2
PCTFREE 5;

CREATE INDEX adl.i_fc_in_srvr_3 ON adl.file_cont_in_srvr (contents_server, creation_hist_evt) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.associated_comment ----------------------------------

CREATE TABLE adl.associated_comment
(
	id                 VARCHAR2 (20) NOT NULL,
	summary            VARCHAR2(250) NOT NULL,
	file_content       VARCHAR2 (20)         ,
	creation_hist_evt  VARCHAR2 (20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ass_comment_1 ON adl.associated_comment (id) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche sur le résumé
CREATE INDEX        adl.i_ass_comment_2 ON adl.associated_comment (summary) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.soft_obj_change ----------------------------------

CREATE TABLE adl.soft_obj_change
(
	id_rank            VARCHAR2(25) NOT NULL,
	software_object    VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	rank               NUMBER(10)   NOT NULL,
	common_ancestor    VARCHAR2(25)         ,
	prev_so_chg_group  VARCHAR2(20)         ,
	deleted            VARCHAR2(1)          ,
	folder             VARCHAR2(20)         ,
	projected_name     VARCHAR2(20)         ,
	file_content       VARCHAR2(20)         ,
	unix_executable    VARCHAR2(1)          ,
	description        VARCHAR2(20)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_change_1 ON adl.soft_obj_change (id_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des modifications pour un objet logiciel et un type de modification, éventuellement entre deux rangs
CREATE INDEX        adl.i_so_change_2 ON adl.soft_obj_change (software_object, type, rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des modifications pour un nom de projection (pour l'administration)
CREATE INDEX        adl.i_so_change_3 ON adl.soft_obj_change (projected_name) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des modifications pour un contenu de fichier (pour l'administration)
CREATE INDEX        adl.i_so_change_4 ON adl.soft_obj_change (file_content) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.soft_obj_chg_group ----------------------------------

CREATE TABLE adl.soft_obj_chg_group
(
	elem_id            VARCHAR2(20) NOT NULL,
	group_id           VARCHAR2(20) NOT NULL,
	soft_obj_change    VARCHAR2(25) NOT NULL,
	so_chg_rank        NUMBER(10)   NOT NULL,
	is_first_in_group  VARCHAR2(1)  NOT NULL,
	group_nb_elements  NUMBER(10)   NOT NULL,
	group_soft_obj     VARCHAR2(20) NOT NULL,
	group_type         VARCHAR2(10) NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur identifiant de l'élément
CREATE UNIQUE INDEX adl.i_so_chg_group_1 ON adl.soft_obj_chg_group (elem_id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche sur identifiant du groupe
CREATE INDEX        adl.i_so_chg_group_2 ON adl.soft_obj_chg_group (group_id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche d'un groupe de modifications à partir d'un objet logiciel, d'un type de modification, et du rang d'une modification du groupe
CREATE INDEX        adl.i_so_chg_group_3 ON adl.soft_obj_chg_group (group_soft_obj, group_type, so_chg_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche sur l'identifiant de la première modification du groupe et du nombre d'éléments
CREATE INDEX        adl.i_so_chg_group_4 ON adl.soft_obj_chg_group (soft_obj_change, group_nb_elements, is_first_in_group) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.so_chg_exclusivity ----------------------------------

CREATE TABLE adl.so_chg_exclusivity
(
	id_rank            VARCHAR2(25) NOT NULL,
	software_object    VARCHAR2(20) NOT NULL,
	so_change_type     VARCHAR2(10) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	prev_so_chg_excl   VARCHAR2(25)         ,
	rank               NUMBER(10)   NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_excl_1 ON adl.so_chg_exclusivity (id_rank) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche des exclusivités pour un objet logiciel et un type de modification dans une arborescence
CREATE INDEX        adl.i_so_chg_excl_2 ON adl.so_chg_exclusivity (software_object, so_change_type, workspace_tree, rank) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.so_chg_grp_cfg_rev ----------------------------------

CREATE TABLE adl.so_chg_grp_cfg_rev
(
	id_level_hist_rank VARCHAR2(27) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	config_branch      VARCHAR2(22) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	first_config_rev   VARCHAR2(27) NOT NULL,
	first_history_rank NUMBER(10)   NOT NULL,
	software_object	   VARCHAR2(20) NOT NULL,
	so_chg_grp_type    VARCHAR2(10) NOT NULL,
	soft_obj_chg_group VARCHAR2(20)         ,
	proj_so_chg        VARCHAR2(25)         ,
	so_chg_exclusivity VARCHAR2(25)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_grp_cr_1 ON adl.so_chg_grp_cfg_rev (id_level_hist_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche de tous les liens dans une version de configuration
CREATE INDEX        adl.i_so_chg_grp_cr_2 ON adl.so_chg_grp_cfg_rev (config_branch, first_history_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche d'un lien portant une exclusivité (et donc un rang d'exclusivité) pour un objet logiciel et un type de modification dans une arborescence
CREATE INDEX        adl.i_so_chg_grp_cr_3 ON adl.so_chg_grp_cfg_rev (software_object, so_chg_grp_type, workspace_tree, so_chg_exclusivity) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche du dernier lien concernant un objet et un type de modification dans une version de configuration
CREATE INDEX        adl.i_so_chg_grp_cr_4 ON adl.so_chg_grp_cfg_rev (software_object, so_chg_grp_type, config_branch, first_history_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche sur une modification d'objet projeté
CREATE INDEX        adl.i_so_chg_grp_cr_5 ON adl.so_chg_grp_cfg_rev (proj_so_chg) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.so_chg_evt_grp_cr ----------------------------------

CREATE TABLE adl.so_chg_evt_grp_cr
(
	elem_id            VARCHAR2(20) NOT NULL,
	elem_type          VARCHAR2(10) NOT NULL,
	group_id           VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	config_branch      VARCHAR2(22) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	first_config_rev   VARCHAR2(27) NOT NULL,
	first_history_rank NUMBER(10)   NOT NULL,
	is_first           VARCHAR2 (1) NOT NULL,
	group_nb_elements  NUMBER(10)   NOT NULL,
	software_object    VARCHAR2(20) NOT NULL,
	so_change_type     VARCHAR2(10) NOT NULL,
	so_chg_grp_cfg_rev VARCHAR2(27)         ,
	so_chg_grp_cr_type VARCHAR2(10)         ,
	component          VARCHAR2(20) NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur l'identifiant de l'élément
CREATE UNIQUE INDEX adl.i_so_c_evt_g_cr_1 ON adl.so_chg_evt_grp_cr (elem_id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche sur l'identifiant du groupe
CREATE INDEX        adl.i_so_c_evt_g_cr_2 ON adl.so_chg_evt_grp_cr (group_id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche de tous les événements vus entre deux versions de configuration
CREATE INDEX        adl.i_so_c_evt_g_cr_3 ON adl.so_chg_evt_grp_cr (config_branch, first_history_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche de tous les événements concernant un objet logiciel entre deux versions de configuration
CREATE INDEX        adl.i_so_c_evt_g_cr_5 ON adl.so_chg_evt_grp_cr (software_object, config_branch, first_history_rank) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche de tous les événements apparus dans un composant entre deux versions de configuration
CREATE INDEX        adl.i_so_c_evt_g_cr_7 ON adl.so_chg_evt_grp_cr (component, config_branch, first_history_rank) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.checked_out_elem ----------------------------------

CREATE TABLE adl.checked_out_elem
(
	id                 VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	element            VARCHAR2(20) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	image              VARCHAR2(20) NOT NULL,
	file_content_type  VARCHAR2(10) NOT NULL,
	so_chg_exclusivity VARCHAR2(25)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_co_elem_1 ON adl.checked_out_elem(id) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur l'objet acquis dans un espace de travail
CREATE        INDEX adl.i_co_elem_2 ON adl.checked_out_elem(workspace, element) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur l'objet acquis dans une image d'un espace de travail
CREATE        INDEX adl.i_co_elem_3 ON adl.checked_out_elem(workspace, image, element) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur l'objet acquis portant une exclusivité (et donc un rang d'exclusivité) dans une arborescence
CREATE        INDEX adl.i_co_elem_4 ON adl.checked_out_elem(workspace_tree, element, so_chg_exclusivity) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.so_chg_merge ----------------------------------

CREATE TABLE adl.so_chg_merge
(
	id_rank            VARCHAR2(25) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	rank               NUMBER(10)   NOT NULL,
	software_object    VARCHAR2(20) NOT NULL,
	so_change_type     VARCHAR2(10) NOT NULL,
	soft_obj_chg_group VARCHAR2(20) NOT NULL,
	implicit_is_done   VARCHAR2(1)  NOT NULL,
	so_chg_exclusivity VARCHAR2(25)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL,
	is_solved          VARCHAR2(1)  NOT NULL,
	solve_rslt_so_chg  VARCHAR2(25)         ,
	solve_type         VARCHAR2(10)         ,
	solve_date         DATE                 ,
	solve_ws_rev       VARCHAR2(27)         ,
	solve_hist_evt     VARCHAR2(20)
) 
PCTFREE 20
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_merge1 ON adl.so_chg_merge(id_rank) TABLESPACE scm_idx1
PCTFREE 20;
-- * Recherche sur les fusions dans un espace de travail, résolues ou non, et dont
--   les tentatives de résolution implicites et automatiques ont été effectuées ou non
CREATE        INDEX adl.i_so_chg_merge2 ON adl.so_chg_merge(workspace, is_solved, implicit_is_done) TABLESPACE scm_idx1
PCTFREE 20;
-- * Recherche toutes les fusions d'un objet logiciel
CREATE        INDEX adl.i_so_chg_merge3 ON adl.so_chg_merge(software_object, so_change_type) TABLESPACE scm_idx1
PCTFREE 20;
-- * Recherche la fusion dont le résultat est une modification
CREATE        INDEX adl.i_so_chg_merge4 ON adl.so_chg_merge(solve_rslt_so_chg) TABLESPACE scm_idx1
PCTFREE 20;

COMMIT;

---------------------------- adl.promotion_request ----------------------------------

CREATE TABLE adl.promotion_request
(
	id                 VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	workspace_revision VARCHAR2(27) NOT NULL,
	collector_ws       VARCHAR2(20) NOT NULL,
	is_enabled         VARCHAR2(1)  NOT NULL,
	is_prepromotion    VARCHAR2(1)  NOT NULL,
	first_history_rank NUMBER(10)   NOT NULL,
	first_date         DATE         NOT NULL,
	disable_hist_evt   VARCHAR2(20)         ,
	disable_reason     VARCHAR2(10)         ,
	replaced_by_promo  VARCHAR2(20)         ,
	collector_is_child VARCHAR2(1)          ,
	collector_wr       VARCHAR2(27)         ,
	collector_hist_rk  NUMBER(10)           ,
	cr_collect_is_done VARCHAR2(1)          ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 20
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_promo_request_1 ON adl.promotion_request (id) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche des demandes de promotion actives d'un espace de travail
CREATE INDEX        adl.i_promo_request_2 ON adl.promotion_request (workspace, is_enabled) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche de la demande de promotion active d'un espace de travail vers un espace de travail
CREATE INDEX        adl.i_promo_request_3 ON adl.promotion_request (workspace, collector_ws, is_enabled) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche si une versio d'espace de trvail a une demande de promotion active
CREATE INDEX        adl.i_promo_request_4 ON adl.promotion_request (workspace_revision, is_enabled) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche des demandes de promotion en attente de collecte par un espace de travail
CREATE INDEX        adl.i_promo_request_5 ON adl.promotion_request (collector_ws, is_enabled) TABLESPACE scm_idx2
PCTFREE 20;

COMMIT;

---------------------------- adl.publication ----------------------------------

CREATE TABLE adl.publication
(
	id                 VARCHAR2(20) NOT NULL,
	workspace          VARCHAR2(20) NOT NULL,
	workspace_revision VARCHAR2(27) NOT NULL,
	ws_rev_rank        NUMBER(10)   NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	case_label         VARCHAR2(32) NOT NULL,
	lower_label        VARCHAR2(32) NOT NULL,
	is_enabled         VARCHAR2(1)  NOT NULL,
	enable_hist_rk     NUMBER(10)   NOT NULL,
	enable_date        DATE         NOT NULL,
	disable_hist_evt   VARCHAR2(20)         ,
	disable_reason     VARCHAR2(10)         ,
	next_publication   VARCHAR2(20)         ,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 20
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_publication_1 ON adl.publication (id) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche de la version d'espace de travail publiée avec un label dans un espace de travail
CREATE INDEX        adl.i_publication_2 ON adl.publication (workspace, is_enabled, lower_label) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche des publications actives d'un espace de travail avant un rang de version d'espace de travail donné
CREATE INDEX        adl.i_publication_3 ON adl.publication (workspace, is_enabled, ws_rev_rank) TABLESPACE scm_idx2
PCTFREE 20;
-- * Recherche des publications actives avec un label d'une revision d'un espace de travail
CREATE INDEX        adl.i_publication_4 ON adl.publication (workspace_revision, is_enabled, lower_label) TABLESPACE scm_idx2
PCTFREE 20;

COMMIT;

---------------------------- adl.history_event ----------------------------------

CREATE TABLE adl.history_event
(
	id                 VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	cmd_date           DATE         NOT NULL,
	cmd_user           VARCHAR2(20) NOT NULL,
	cmd_name           VARCHAR2(32) NOT NULL,
	cmd_comment        VARCHAR2(20)         ,
	site               VARCHAR2(20) NOT NULL,
	multi_tree_ws      VARCHAR2(20)         ,
	workspace_tree     VARCHAR2(20)         ,
	workspace          VARCHAR2(20)         ,
	ws_hist_rk         NUMBER(10)           ,
	image              VARCHAR2(20)
) 
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_hist_evt_1 ON adl.history_event (id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche sur l'utilisateur
CREATE        INDEX adl.i_hist_evt_2 ON adl.history_event (cmd_user) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche sur l'espace, la date et le rang historique
CREATE        INDEX adl.i_hist_evt_3 ON adl.history_event (workspace, cmd_date, ws_hist_rk) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.site_for_hist ----------------------------------

CREATE TABLE adl.site_for_hist
(
	id                VARCHAR2(20) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	lower_name        VARCHAR2(32) NOT NULL,
	last_export_date  DATE         NOT NULL
) 
PCTFREE 10 
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_site_hist_1 ON adl.site_for_hist (id) TABLESPACE scm_idx0
PCTFREE 10;

COMMIT;

---------------------------- adl.multi_tree_ws_hist ----------------------------------

CREATE TABLE adl.multi_tree_ws_hist
(
	id                VARCHAR2(20) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	lower_name        VARCHAR2(32) NOT NULL,
	is_deleted        VARCHAR2(1)  NOT NULL,
	last_export_date  DATE         NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_m_t_ws_hist_1 ON adl.multi_tree_ws_hist (id) TABLESPACE scm_idx1
PCTFREE 10;

COMMIT;

---------------------------- adl.ws_tree_for_hist ----------------------------------

CREATE TABLE adl.ws_tree_for_hist
(
	id                VARCHAR2(20) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	lower_name        VARCHAR2(32) NOT NULL,
	is_deleted        VARCHAR2(1)  NOT NULL,
	last_export_date  DATE         NOT NULL
) 
PCTFREE 10 
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_tree_hist_1 ON adl.ws_tree_for_hist (id) TABLESPACE scm_idx0
PCTFREE 10;

COMMIT;

---------------------------- adl.workspace_for_hist ----------------------------------

CREATE TABLE adl.workspace_for_hist
(
	id                VARCHAR2(20) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	lower_name        VARCHAR2(32) NOT NULL,
	is_deleted        VARCHAR2(1)  NOT NULL,
	last_export_date  DATE         NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_hist_1 ON adl.workspace_for_hist (id) TABLESPACE scm_idx1
PCTFREE 10;

COMMIT;

---------------------------- adl.image_for_hist ----------------------------------

CREATE TABLE adl.image_for_hist
(
	id                VARCHAR2(20) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	lower_name        VARCHAR2(32) NOT NULL,
	is_deleted        VARCHAR2(1)  NOT NULL,
	last_export_date  DATE         NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_image_for_hist_1 ON adl.image_for_hist (id) TABLESPACE scm_idx1
PCTFREE 10;

COMMIT;

---------------------------- adl.so_chg_fgt_info ----------------------------------

CREATE TABLE adl.so_chg_fgt_info
(
	id                 VARCHAR2(20) NOT NULL,
	so_chg_grp_cfg_rev VARCHAR2(27) NOT NULL,
	prev_so_chg_grp_cr VARCHAR2(27) NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_fgt_in_1 ON adl.so_chg_fgt_info (id) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche sur le groupe dans la version de configuration
CREATE UNIQUE INDEX adl.i_so_chg_fgt_in_2 ON adl.so_chg_fgt_info (so_chg_grp_cfg_rev) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.file_type ----------------------------------

CREATE TABLE adl.file_type
(
	lower_name        VARCHAR2(32) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	file_content_type VARCHAR2(10) NOT NULL,
	unix_executable   VARCHAR2(1)  NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant = le nom en minuscules
CREATE UNIQUE INDEX adl.i_file_type_1 ON adl.file_type (lower_name) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche sur le nom avec respect de la casse
CREATE INDEX        adl.i_file_type_2 ON adl.file_type (case_name) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.dept_db_clean ----------------------------------

CREATE TABLE adl.dept_db_clean
(
	cleaner           VARCHAR2(20) NOT NULL,
	workspace_tree    VARCHAR2(20),
	nb_table_cleaners NUMBER(10)   NOT NULL,
	nb_checker_sets   NUMBER(10)   NOT NULL,
	step              NUMBER(10)   NOT NULL,
	family_to_clean   VARCHAR2(20) NOT NULL,
	name_to_clean     VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

COMMIT;

---------------------------- adl.dept_id_to_clean ----------------------------------

CREATE TABLE adl.dept_id_to_clean
(
	family      VARCHAR2(20) NOT NULL,
	name        VARCHAR2(10) NOT NULL,
	id_to_clean VARCHAR2(27) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur la famille
CREATE INDEX adl.i_dept_id_to_cln_1 ON adl.dept_id_to_clean (family) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.transfer ----------------------------------

CREATE TABLE adl.transfer
(
	id                 VARCHAR2(20) NOT NULL,
	case_name          VARCHAR2(32) NOT NULL,
	lower_name         VARCHAR2(32) NOT NULL,
	multi_tree_ws      VARCHAR2(20) NOT NULL,
	image              VARCHAR2(20)         ,
	case_store_path    VARCHAR2(512)        ,
	lower_store_path   VARCHAR2(512)        ,
	local_path_host    VARCHAR2(255)        ,
	is_server          VARCHAR2(512)        ,
	is_server_host     VARCHAR2(255)        ,
	is_server_port     NUMBER(10)           ,
	site2              VARCHAR2(20)         ,
	is_with_mirror_ws  VARCHAR2(1)  NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_transfer_1 ON adl.transfer (id) TABLESPACE scm_idx0
PCTFREE 10;
-- * Recherche sur espace de travail multi-arborescence et nom
CREATE        INDEX adl.i_transfer_2 ON adl.transfer (multi_tree_ws, lower_name) TABLESPACE scm_idx0
PCTFREE 10;

COMMIT;

---------------------------- adl.transfer_in_tree ----------------------------------

CREATE TABLE adl.transfer_in_tree
(
	id                VARCHAR2(20) NOT NULL,
	transfer          VARCHAR2(20) NOT NULL,
	multi_tree_ws     VARCHAR2(20) NOT NULL,
	workspace_tree    VARCHAR2(20) NOT NULL,
	multi_tree_ws2    VARCHAR2(20) NOT NULL,
	workspace_tree2   VARCHAR2(20) NOT NULL,
	fw_status         VARCHAR2(10) NOT NULL,
	creation_hist_evt VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_trf_in_tree_1 ON adl.transfer_in_tree (id) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche sur transfert
CREATE        INDEX adl.i_trf_in_tree_2 ON adl.transfer_in_tree (transfer, workspace_tree) TABLESPACE scm_idx0
PCTFREE 5;
-- * Recherche sur espace de travail multi-arborescence
CREATE        INDEX adl.i_trf_in_tree_3 ON adl.transfer_in_tree (multi_tree_ws, workspace_tree) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.change_set -----------------------------

CREATE TABLE adl.change_set
(
	id                VARCHAR2(20)  NOT NULL,
	case_name         VARCHAR2(32)  NOT NULL,
	lower_name        VARCHAR2(32)  NOT NULL,
	is_opened         VARCHAR2(1)   NOT NULL,
	is_deleted        VARCHAR2(1)   NOT NULL,
	description       VARCHAR2(255)         ,
	last_attr_date    DATE          NOT NULL,
	last_chg_set_date DATE          NOT NULL,
	native_database   VARCHAR2(20)  NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 10
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_1 ON adl.change_set (id) TABLESPACE scm_idx2
PCTFREE 10;
-- * Recherche des change set non supprimés
CREATE INDEX adl.i_change_set_2 ON adl.change_set (is_deleted, is_opened) TABLESPACE scm_idx2
PCTFREE 10;

COMMIT;

---------------------------- adl.change_set_in_db -----------------------

CREATE TABLE adl.change_set_in_db
(
	id                VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	database          VARCHAR2(20)  NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_db_1 ON adl.change_set_in_db (id) TABLESPACE scm_idx2
PCTFREE 10;
-- * Recherche sur change set
CREATE INDEX adl.i_change_set_db_2 ON adl.change_set_in_db (change_set, database) TABLESPACE scm_idx2
PCTFREE 10;

COMMIT;

---------------------------- adl.change_set_mtws -----------------------------

CREATE TABLE adl.change_set_mtws
(
	id                VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	multi_tree_ws     VARCHAR2(20)  NOT NULL,
	is_current        VARCHAR2(1)   NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_set_mtws_1 ON adl.change_set_mtws (id) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur espace de travail multi-arborescence et courant
CREATE INDEX adl.i_so_c_set_mtws_2 ON adl.change_set_mtws (multi_tree_ws, is_current) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur objet ensemble de modifications
CREATE INDEX adl.i_so_c_set_mtws_3 ON adl.change_set_mtws (change_set) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.change_set_wstree -----------------------

CREATE TABLE adl.change_set_wstree
(
	id                VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	workspace_tree    VARCHAR2(20)  NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_set_wt_1 ON adl.change_set_wstree (id) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur arborescence
CREATE INDEX adl.i_so_c_set_wt_2 ON adl.change_set_wstree (workspace_tree, change_set) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur objet ensemble de modifications
CREATE INDEX adl.i_so_c_set_wt_3 ON adl.change_set_wstree (change_set) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.so_chg_change_set ----------------------

CREATE TABLE adl.so_chg_change_set
(
	id                VARCHAR2(20)  NOT NULL,
	soft_obj_change   VARCHAR2(25)  NOT NULL,
	so_chg_type       VARCHAR2(10)  NOT NULL,
	software_object	  VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	is_deleted        VARCHAR2(1)   NOT NULL,
	is_moved          VARCHAR2(1)   NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs3;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_chg_set_1 ON adl.so_chg_change_set (id) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche du CS d'une modification
CREATE INDEX adl.i_so_c_chg_set_2 ON adl.so_chg_change_set (soft_obj_change, is_deleted, is_moved) TABLESPACE scm_idx3
PCTFREE 5;
-- * Recherche des modifications d'un CS
CREATE INDEX adl.i_so_c_chg_set_3 ON adl.so_chg_change_set (change_set, is_deleted, is_moved) TABLESPACE scm_idx3
PCTFREE 5;

COMMIT;

---------------------------- adl.so_chg_chg_set_is ----------------------

CREATE TABLE adl.so_chg_chg_set_is
(
	id                VARCHAR2(20)  NOT NULL,
	so_chg_id         VARCHAR2(25)  NOT NULL,
	so_chg_type       VARCHAR2(10)  NOT NULL,
	soft_obj_id  	  VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_c_set_is_1 ON adl.so_chg_chg_set_is (id) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche des modifications d'un CS
CREATE INDEX adl.i_so_c_c_set_is_2 ON adl.so_chg_chg_set_is (change_set) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche des modifications d'un CS
CREATE INDEX adl.i_so_c_c_set_is_3 ON adl.so_chg_chg_set_is (so_chg_id) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;

---------------------------- adl.change_set_is -----------------------------

CREATE TABLE adl.change_set_is
(
	id                VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	site_for_hist     VARCHAR2(20)  NOT NULL,
	workspace_tree    VARCHAR2(20)  NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_is_1 ON adl.change_set_is (id) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur site pour historique
CREATE INDEX adl.i_change_set_is_2 ON adl.change_set_is (site_for_hist, workspace_tree) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur objet ensemble de modifications
CREATE INDEX adl.i_change_set_is_3 ON adl.change_set_is (change_set, site_for_hist) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.chg_req_change_set --------------------------

CREATE TABLE adl.chg_req_change_set
(
	id                VARCHAR2(20)  NOT NULL,
	change_set        VARCHAR2(20)  NOT NULL,
	chg_req_type      VARCHAR2(15)  NOT NULL,
	chg_req_id        VARCHAR2(20)          ,
	creation_hist_evt VARCHAR2(20)  NOT NULL
)
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_chg_req_c_set_1 ON adl.chg_req_change_set (id) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur CS
CREATE INDEX adl.i_chg_req_c_set_2 ON adl.chg_req_change_set (change_set) TABLESPACE scm_idx2
PCTFREE 5;
-- * Recherche sur l'application externe
CREATE INDEX adl.i_chg_req_c_set_3 ON adl.chg_req_change_set (chg_req_type, chg_req_id) TABLESPACE scm_idx2
PCTFREE 5;

COMMIT;
