---------------------------- adl.dept_db_version ----------------------------------

CREATE TABLE adl.dept_db_version
(
	value         VARCHAR(10) NOT NULL,
	upgrade_value VARCHAR(10)         ,
	upgrade_step  INTEGER             ,
	database_id   VARCHAR(20)
)
--TABLESPACE tablespace_name
;

INSERT INTO adl.dept_db_version
(value)
VALUES
('2005_03_07');

CREATE UNIQUE INDEX adl.i_dept_db_vers_1 ON adl.dept_db_version (value);

COMMIT;

---------------------------- adl.site ----------------------------------

CREATE TABLE adl.site
(
	id          VARCHAR(20) NOT NULL,
	lower_name  VARCHAR(32) NOT NULL,
	case_name   VARCHAR(32) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_site_1 ON adl.site (id);
CREATE INDEX adl.i_site_2 ON adl.site (lower_name);

COMMIT;

---------------------------- adl.database ----------------------------------

CREATE TABLE adl.database
(
	id                 VARCHAR(20)  NOT NULL,
	case_name          VARCHAR(255) NOT NULL,
	upper_name         VARCHAR(255) NOT NULL,
	is_central         VARCHAR(1)   NOT NULL,
	is_dept            VARCHAR(1)   NOT NULL,
	is_monitor         VARCHAR(1)   NOT NULL,
	description        VARCHAR(250)         ,
	creation_hist_evt  VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_database_1 ON adl.database (id);
CREATE INDEX adl.i_database_2 ON adl.database (upper_name);

COMMIT;

---------------------------- adl.counter ----------------------------------

CREATE TABLE adl.counter
(
	id    VARCHAR(20) NOT NULL,
	type  VARCHAR(15) NOT NULL,
	value INTEGER     NOT NULL
)
--TABLESPACE tablespace_name
;

INSERT INTO adl.counter
(id,     type,          value)
VALUES
('xxxx', 'PER_ATT_MOD', 100);

INSERT INTO adl.counter
(id,     type,          value)
VALUES
('yyyy', 'PER_CHD_MOD', 100);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_counter_1 ON adl.counter (id);

COMMIT;

---------------------------- adl.multi_tree_ws ----------------------------------

CREATE TABLE adl.multi_tree_ws
(
	id                 VARCHAR(20) NOT NULL,
	case_name          VARCHAR(32) NOT NULL,
	lower_name         VARCHAR(32) NOT NULL,
	is_deleted         VARCHAR(1)  NOT NULL,
	nb_linked_ws       INTEGER     NOT NULL,
	native_database    VARCHAR(20) NOT NULL,
	merge_cmd_end      VARCHAR(1)  NOT NULL,
	case_tck           VARCHAR(32)         ,
	lower_tck          VARCHAR(32)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_multi_tree_ws_1 ON adl.multi_tree_ws (id DESC);
-- * Recherche d'un ensemble d'espaces de travail non supprimé à partir du nom
CREATE INDEX        adl.i_multi_tree_ws_2 ON adl.multi_tree_ws (lower_name, is_deleted);

COMMIT;

---------------------------- adl.workspace_tree ----------------------------------

CREATE TABLE adl.workspace_tree
(
	id                 VARCHAR(20) NOT NULL,
	case_name          VARCHAR(32) NOT NULL,
	lower_name         VARCHAR(32) NOT NULL,
	is_deleted         VARCHAR(1)  NOT NULL,
	contents_server    VARCHAR(20) NOT NULL,
	database           VARCHAR(20) NOT NULL,
	promo_with_cr_mode VARCHAR(10) NOT NULL,
	check_caa_rules    VARCHAR(1)  NOT NULL,
	case_soft_level    VARCHAR(32)         ,
	lower_soft_level   VARCHAR(32)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_workspace_tree_1 ON adl.workspace_tree (id DESC);
-- * Recherche d'une arborescence non supprimée à partir du nom
CREATE INDEX        adl.i_workspace_tree_2 ON adl.workspace_tree (lower_name, is_deleted);

COMMIT;

---------------------------- adl.workspace ----------------------------------

CREATE TABLE adl.workspace
(
	id                 VARCHAR(20) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	multi_tree_ws      VARCHAR(20) NOT NULL,
	case_name          VARCHAR(32) NOT NULL,
	lower_name         VARCHAR(32) NOT NULL,
	is_deleted         VARCHAR(1)  NOT NULL,
	request_is_locked  VARCHAR(1)  NOT NULL,
	allow_auto_merge   VARCHAR(1)  NOT NULL,
	allow_promo_any_ws VARCHAR(1)  NOT NULL,
	allow_sync_cmd     VARCHAR(1)  NOT NULL,
	allow_promote_cmd  VARCHAR(1)  NOT NULL,
	allow_mrg_collect  VARCHAR(1)  NOT NULL,
	child_sync_promo   VARCHAR(1)  NOT NULL,
	flow_traces_files  VARCHAR(1)  NOT NULL,
	chg_req_ws_typ     VARCHAR(10) NOT NULL,
	publication_type   VARCHAR(10) NOT NULL,
	per_attached_mod   INTEGER             ,
	promo_with_cr_mode VARCHAR(10)         ,
	check_caa_rules    VARCHAR(1)          ,
	case_soft_level    VARCHAR(32)         ,
	lower_soft_level   VARCHAR(32)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL,
	deletion_hist_evt  VARCHAR(20)
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_workspace_1 ON adl.workspace (id DESC);
-- * Recherche d'un espace de travail non supprimé avec le nom en minuscule
CREATE        INDEX adl.i_workspace_2 ON adl.workspace (lower_name, is_deleted);
-- * Recherche d'un espace de travail non supprimé avec son espace multi-arborescence
CREATE        INDEX adl.i_workspace_3 ON adl.workspace (multi_tree_ws, is_deleted);
-- * Recherche d'un espace de travail non supprimé avec son arborescence d'espace de travail
CREATE        INDEX adl.i_workspace_4 ON adl.workspace (workspace_tree, is_deleted);

COMMIT;

---------------------------- adl.workspace_counter ----------------------------------

CREATE TABLE adl.workspace_counter
(
	id        VARCHAR(20) NOT NULL,
	type      VARCHAR(10) NOT NULL,
	workspace VARCHAR(20) NOT NULL,
	value     INTEGER     NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_counter_1 ON adl.workspace_counter (id);
-- * Recherche sur le type et la branche
CREATE UNIQUE INDEX adl.i_ws_counter_2 ON adl.workspace_counter (workspace, type);

COMMIT;

---------------------------- adl.workspace_revision ----------------------------------

CREATE TABLE adl.workspace_revision
(
	id_level_hist_rank VARCHAR(27) NOT NULL,
	rank               INTEGER     NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	ws_rev_level       INTEGER     NOT NULL,
	previous_ws_rev    VARCHAR(27)         ,
	first_history_rank INTEGER     NOT NULL,
	last_history_rank  INTEGER           ,
	last_refresh_rank  INTEGER           ,
	parent_workspace   VARCHAR(20)         ,
	main_config_branch VARCHAR(22) NOT NULL,
	has_local_modif    VARCHAR(1)  NOT NULL,
	is_working         VARCHAR(1)  NOT NULL,
	reason             VARCHAR(10) NOT NULL,
	sync_with_ws_rev   VARCHAR(27)         ,
	sync_with_hist_rk  INTEGER           ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_rev_1 ON adl.workspace_revision (id_level_hist_rank);
-- * Recherche de la dernière version d'un espace de travail
CREATE UNIQUE INDEX adl.i_ws_rev_2 ON adl.workspace_revision (workspace, first_history_rank DESC);
-- * Recherche de la version d'un espace de travail avec un espace pere donné
CREATE        INDEX adl.i_ws_rev_3 ON adl.workspace_revision (parent_workspace, workspace);

COMMIT;

---------------------------- adl.deleted_ws_group ----------------------------------

CREATE TABLE adl.deleted_ws_group
(
	elem_id            VARCHAR(20) NOT NULL,
	group_id           VARCHAR(20) NOT NULL,
	multi_tree_ws      VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	group_nb_elements  INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant de l'élément
CREATE UNIQUE INDEX adl.i_deleted_ws_grp_1 ON adl.deleted_ws_group (elem_id);
-- * Recherche des espaces de travail supprimés d'un espace de travail multi-arborescence
CREATE INDEX        adl.i_deleted_ws_grp_2 ON adl.deleted_ws_group (multi_tree_ws);

COMMIT;

---------------------------- adl.image ----------------------------------


CREATE TABLE adl.image
(
	id                 VARCHAR(20)  NOT NULL,
	type               VARCHAR(10)  NOT NULL,
	multi_tree_ws      VARCHAR(20)  NOT NULL,
	case_name          VARCHAR(32)  NOT NULL,
	lower_name         VARCHAR(32)  NOT NULL,
	case_proj_path     VARCHAR(512) NOT NULL,
	lower_proj_path    VARCHAR(254) NOT NULL,
	local_path_host    VARCHAR(255)         ,
	is_deleted         VARCHAR(1)   NOT NULL,
	case_tck           VARCHAR(32)          ,
	lower_tck          VARCHAR(32)          ,
	creation_hist_evt  VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;
-- "lower_proj_path" a ete racourci pour que l'index "image_3" ne depasse pas
-- 255 caracteres.

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_image_1 ON adl.image (id);
-- * Recherche l'image non supprimée avec le nom en minuscule et l'espace de travail multi-arborescence
CREATE INDEX        adl.i_image_2 ON adl.image (multi_tree_ws, is_deleted, lower_name);
-- * Recherche l'image non supprimée avec le chemin en minuscules
CREATE INDEX        adl.i_image_3 ON adl.image (lower_proj_path, is_deleted);

COMMIT;

---------------------------- adl.deleted_img_group ----------------------------------


CREATE TABLE adl.deleted_img_group
(
	elem_id            VARCHAR(20) NOT NULL,
	group_id           VARCHAR(20) NOT NULL,
	multi_tree_ws      VARCHAR(20) NOT NULL,
	image              VARCHAR(20) NOT NULL,
	group_nb_elements  INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant de l'élément
CREATE UNIQUE INDEX adl.i_deleted_img_grp1 ON adl.deleted_img_group (elem_id);
-- * Recherche des images supprimées d'un espace de travail multi-arborescence
CREATE INDEX        adl.i_deleted_img_grp2 ON adl.deleted_img_group (multi_tree_ws);

COMMIT;

---------------------------- adl.last_ws_refresh ----------------------------------

CREATE TABLE adl.last_ws_refresh
(
	id                 VARCHAR(20)  NOT NULL,
	image              VARCHAR(20)  NOT NULL,
	workspace          VARCHAR(20)  NOT NULL,
	workspace_revision VARCHAR(27)  NOT NULL,
	history_rank       INTEGER    NOT NULL,
	refresh_rank       INTEGER    NOT NULL,
	is_projected       VARCHAR(1)   NOT NULL,
	creation_hist_evt  VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_last_ws_refresh1 ON adl.last_ws_refresh (id);
-- * Recherche de tous les derniers rafraîchissements d'un espace de travail
CREATE INDEX        adl.i_last_ws_refresh2 ON adl.last_ws_refresh (workspace, is_projected);

COMMIT;

---------------------------- adl.refreshed_ws_group ----------------------------------

CREATE TABLE adl.refreshed_ws_group
(
	elem_id            VARCHAR(20) NOT NULL,
	group_id           VARCHAR(20) NOT NULL,
	image              VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	group_nb_elements  INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_refreshed_ws_gr1 ON adl.refreshed_ws_group (elem_id);
-- * Recherche de tous les derniers rafraîchissements d'un espace de travail
CREATE INDEX        adl.i_refreshed_ws_gr2 ON adl.refreshed_ws_group (image);
-- * Recherche sur le groupe
CREATE INDEX        adl.i_refreshed_ws_gr3 ON adl.refreshed_ws_group (group_id);

COMMIT;

---------------------------- adl.configuration ----------------------------------

CREATE TABLE adl.configuration
(
	id                 VARCHAR(20) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_configuration_1 ON adl.configuration (id DESC);

COMMIT;

---------------------------- adl.config_branch ----------------------------------

CREATE TABLE adl.config_branch
(
	id_level           VARCHAR(22) NOT NULL,
	branch_level       INTEGER     NOT NULL,
	configuration      VARCHAR(20) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	per_changed_so_mod INTEGER           ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_config_branch_1 ON adl.config_branch (id_level DESC);
-- * Recherche sur espace de travail
CREATE        INDEX adl.i_config_branch_2 ON adl.config_branch (workspace);
-- * Recherche sur arborescence d'espace de travail
CREATE        INDEX adl.i_config_branch_3 ON adl.config_branch (workspace_tree);

COMMIT;

---------------------------- adl.config_revision ----------------------------------

CREATE TABLE adl.config_revision
(
	id_level_hist_rank VARCHAR(27) NOT NULL,
	rank               INTEGER     NOT NULL,
	config_branch      VARCHAR(22) NOT NULL,
	config_branch_type VARCHAR(10) NOT NULL,
	cfg_br_level       INTEGER     NOT NULL,
	previous_cfg_rev   VARCHAR(27)         ,
	inv_cfg_rev_group  VARCHAR(20)         ,
	type               VARCHAR(10) NOT NULL,
	first_history_rank INTEGER     NOT NULL,
	last_history_rank  INTEGER           ,
	is_working         VARCHAR(1)  NOT NULL,
	sync_with_cfg_rev  VARCHAR(27)         ,
	sync_with_hist_rk  INTEGER           ,
	first_so_chg_cr    VARCHAR(27)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_cfg_rev_1 ON adl.config_revision (id_level_hist_rank DESC);
-- * Recherche de la dernière version de configuration d'une branche, version valide ou non
CREATE UNIQUE INDEX adl.i_cfg_rev_2 ON adl.config_revision (config_branch, first_history_rank DESC);
-- ATTENTION : dans les requêtes, il faut toujours préciser is_valid = 'x'

COMMIT;

---------------------------- adl.inv_cfg_rev_group ----------------------------------

CREATE TABLE adl.inv_cfg_rev_group
(
	elem_id            VARCHAR(20) NOT NULL,
	group_id           VARCHAR(20) NOT NULL,
	is_first           VARCHAR (1) NOT NULL,
	group_nb_elements  INTEGER     NOT NULL,
	config_branch      VARCHAR(22) NOT NULL,
	config_revision    VARCHAR(27) NOT NULL,
	cr_first_hist_rank INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur l'identifiant de l'élément
CREATE UNIQUE INDEX adl.i_inv_cr_grp_1 ON adl.inv_cfg_rev_group (elem_id);
-- * Recherche sur l'identifiant du groupe
CREATE INDEX        adl.i_inv_cr_grp_2 ON adl.inv_cfg_rev_group (group_id);
-- * Recherche de toutes les versions invalides entre deux rangs historiques
CREATE INDEX        adl.i_inv_cr_grp_3 ON adl.inv_cfg_rev_group (config_branch, cr_first_hist_rank DESC);

COMMIT;

---------------------------- adl.cfg_rev_in_ws ----------------------------------

CREATE TABLE adl.cfg_rev_in_ws
(
	id_hist_rank       VARCHAR(25) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	first_ws_rev       VARCHAR(27) NOT NULL,
	first_history_rank INTEGER     NOT NULL,
	config_branch      VARCHAR(22) NOT NULL,
	config_revision    VARCHAR(27)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_cr_in_ws_1 ON adl.cfg_rev_in_ws (id_hist_rank DESC);
-- * Recherche du derniere version d'une branche de configuration visible depuis une version d'espace de travail
CREATE INDEX        adl.i_cr_in_ws_2 ON adl.cfg_rev_in_ws (config_branch, workspace, first_history_rank DESC);

COMMIT;

---------------------------- adl.software_object ----------------------------------

CREATE TABLE adl.software_object
(
	id                 VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	is_folder          VARCHAR (1) NOT NULL,
	is_component       VARCHAR (1) NOT NULL,
	projected_as_file  VARCHAR (1) NOT NULL,
	rank_init          INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_soft_obj_1 ON adl.software_object (id);

COMMIT;

---------------------------- adl.so_resp_in_wstree ----------------------------------

CREATE TABLE adl.so_resp_in_wstree
(
	id                VARCHAR(20) NOT NULL,
	software_object   VARCHAR(20) NOT NULL,
	workspace_tree    VARCHAR(20) NOT NULL,
	responsible       VARCHAR(20) NOT NULL,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_resp_wstree_1 ON adl.so_resp_in_wstree (id);
-- *Recherche du responsable d'un objet logiciel dans une arborescence
CREATE INDEX        adl.i_so_resp_wstree_2 ON adl.so_resp_in_wstree (software_object, workspace_tree);
-- *Recherche du responsable de tous les objets dans une arborescence
CREATE INDEX        adl.i_so_resp_wstree_3 ON adl.so_resp_in_wstree (workspace_tree, responsible);

COMMIT;

---------------------------- adl.perhaps_attached ----------------------------------

CREATE TABLE adl.perhaps_attached
(
	id                 VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	first_ws_rev_rank  INTEGER     NOT NULL,
	next_ws_rev_rank   INTEGER     NOT NULL,
	component          VARCHAR(20) NOT NULL,
	creation_modulo    INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_per_att_1 ON adl.perhaps_attached (id);
-- * Recherche de tous les attachements potentiels visibles depuis une version de configuration
CREATE INDEX        adl.i_per_att_2 ON adl.perhaps_attached (workspace, first_ws_rev_rank);
-- * Recherche de tous les attachements potentiels arrivés à échéance
CREATE INDEX        adl.i_per_att_3 ON adl.perhaps_attached (workspace, next_ws_rev_rank);
-- * Recherche des attachements potentiels d'un composant donné visible depuis une version de configuration
CREATE INDEX        adl.i_per_att_4 ON adl.perhaps_attached (component, workspace, first_ws_rev_rank);
-- * Recherche des attachements potentiels créés avec un modulo donné (si changement de modulo)
CREATE INDEX        adl.i_per_att_5 ON adl.perhaps_attached (creation_modulo);

COMMIT;

---------------------------- adl.attached_component ----------------------------------

CREATE TABLE adl.attached_component
(
	id_level_hist_rank VARCHAR(27) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	first_ws_rev       VARCHAR(27) NOT NULL,
	first_history_rank INTEGER     NOT NULL,
	component          VARCHAR(20) NOT NULL,
	config_branch      VARCHAR(22)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_att_comp_1 ON adl.attached_component (id_level_hist_rank DESC);
-- * Recherche du dernier attachement d'un composant visible depuis une version de configuration
CREATE INDEX        adl.i_att_comp_2 ON adl.attached_component (workspace, component, first_history_rank DESC);

COMMIT;

---------------------------- adl.perhaps_changed_so ----------------------------------

CREATE TABLE adl.perhaps_changed_so
(
	id                 VARCHAR(20) NOT NULL,
	config_branch      VARCHAR(22) NOT NULL,
	first_cfg_rev_rank INTEGER     NOT NULL,
	next_cfg_rev_rank  INTEGER     NOT NULL,
	creation_modulo    INTEGER     NOT NULL,
	software_object    VARCHAR(20) NOT NULL,
	is_component       VARCHAR(1)  NOT NULL,
	with_move          VARCHAR(1)  NOT NULL,
	folder             VARCHAR(20)         ,
	projected_name     VARCHAR(20)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_per_chg_so_1 ON adl.perhaps_changed_so (id);
-- * Recherche des objets potentiellement modifiés depuis une version de configuration
CREATE INDEX        adl.i_per_chg_so_2 ON adl.perhaps_changed_so (config_branch, first_cfg_rev_rank);
-- * Recherche des objets potentiellement modifiés arrivés à échéance
CREATE INDEX        adl.i_per_chg_so_3 ON adl.perhaps_changed_so (config_branch, next_cfg_rev_rank);
-- * Recherche des objets potentiellement inclus dans un dossier depuis une version de configuration
CREATE INDEX        adl.i_per_chg_so_4 ON adl.perhaps_changed_so (with_move, folder, config_branch, first_cfg_rev_rank);
-- * Recherche de la modification potentielle d'un objet logiciel dans une version de configuration
CREATE INDEX        adl.i_per_chg_so_5 ON adl.perhaps_changed_so (software_object, config_branch, first_cfg_rev_rank);
-- * Recherche des objets potentiellement inclus dans un dossier sous un nom de projection donné depuis une version de configuration
CREATE INDEX        adl.i_per_chg_so_6 ON adl.perhaps_changed_so (with_move, folder, projected_name, config_branch, first_cfg_rev_rank);
-- * Recherche des objets potentiellement sous un nom de projection donné
CREATE INDEX        adl.i_per_chg_so_7 ON adl.perhaps_changed_so (with_move, projected_name, config_branch);

COMMIT;

---------------------------- adl.projected_name ----------------------------------

CREATE TABLE adl.projected_name
(
	id          VARCHAR (20) NOT NULL,
	case_value  VARCHAR(128) NOT NULL,
	lower_value VARCHAR(128) NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_proj_name_1 ON adl.projected_name (id);
-- * Recherche sur le nom avec respect majuscules / minuscules
CREATE INDEX        adl.i_proj_name_2 ON adl.projected_name (case_value);
-- * Recherche sur le nom en minuscules
CREATE INDEX        adl.i_proj_name_3 ON adl.projected_name (lower_value);

COMMIT;

---------------------------- adl.file_content ----------------------------------

CREATE TABLE adl.file_content
(
	id                VARCHAR(20) NOT NULL,
	type              VARCHAR(10) NOT NULL,
	fs_creation_date  TIMESTAMP NOT NULL,
	size_on_server    INTEGER NOT NULL,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_file_content_1 ON adl.file_content (id);

COMMIT;

---------------------------- adl.contents_server ----------------------------------

CREATE TABLE adl.contents_server
(
	id                 VARCHAR(20)  NOT NULL,
	host_name          VARCHAR(255) NOT NULL,
	port_number        INTEGER      NOT NULL,
	description        VARCHAR(250)         ,
	creation_hist_evt  VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_contents_serv_1 ON adl.contents_server (id);

COMMIT;

---------------------------- adl.file_cont_in_srvr ----------------------------------

CREATE TABLE adl.file_cont_in_srvr
(
	id                VARCHAR(20) NOT NULL,
	workspace_tree    VARCHAR(20) NOT NULL,
	file_content      VARCHAR(20) NOT NULL,
	contents_server   VARCHAR(20) NOT NULL,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_fc_in_srvr_1 ON adl.file_cont_in_srvr (id);
-- *Recherche du serveur de contenu d'un contenu de fichier dans une arborescence
CREATE INDEX        adl.i_fc_in_srvr_2 ON adl.file_cont_in_srvr (file_content, workspace_tree);
-- *Recherche des contenus de fichiers pour un serveur de fichier
CREATE INDEX        adl.i_fc_in_srvr_3 ON adl.file_cont_in_srvr (contents_server, creation_hist_evt);

COMMIT;

---------------------------- adl.associated_comment ----------------------------------

CREATE TABLE adl.associated_comment
(
	id                 VARCHAR (20) NOT NULL,
	summary            VARCHAR(250) NOT NULL,
	file_content       VARCHAR (20)         ,
	creation_hist_evt  VARCHAR (20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ass_comment_1 ON adl.associated_comment (id);
-- * Recherche sur le résumé
CREATE INDEX        adl.i_ass_comment_2 ON adl.associated_comment (summary);

COMMIT;

---------------------------- adl.soft_obj_change ----------------------------------

CREATE TABLE adl.soft_obj_change
(
	id_rank            VARCHAR(25) NOT NULL,
	software_object    VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	rank               INTEGER     NOT NULL,
	common_ancestor    VARCHAR(25)         ,
	prev_so_chg_group  VARCHAR(20)         ,
	deleted            VARCHAR(1)          ,
	folder             VARCHAR(20)         ,
	projected_name     VARCHAR(20)         ,
	file_content       VARCHAR(20)         ,
	unix_executable    VARCHAR(1)          ,
	description        VARCHAR(20)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_change_1 ON adl.soft_obj_change (id_rank DESC);
-- * Recherche des modifications pour un objet logiciel et un type de modification, éventuellement entre deux rangs
CREATE INDEX        adl.i_so_change_2 ON adl.soft_obj_change (software_object, type, rank DESC);
-- * Recherche des modifications pour un nom de projection (pour l'administration)
CREATE INDEX        adl.i_so_change_3 ON adl.soft_obj_change (projected_name);
-- * Recherche des modifications pour un contenu de fichier (pour l'administration)
CREATE INDEX        adl.i_so_change_4 ON adl.soft_obj_change (file_content);

COMMIT;

---------------------------- adl.soft_obj_chg_group ----------------------------------

CREATE TABLE adl.soft_obj_chg_group
(
	elem_id            VARCHAR(20) NOT NULL,
	group_id           VARCHAR(20) NOT NULL,
	soft_obj_change    VARCHAR(25) NOT NULL,
	so_chg_rank        INTEGER     NOT NULL,
	is_first_in_group  VARCHAR(1)  NOT NULL,
	group_nb_elements  INTEGER     NOT NULL,
	group_soft_obj     VARCHAR(20) NOT NULL,
	group_type         VARCHAR(10) NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant de l'élément
CREATE UNIQUE INDEX adl.i_so_chg_group_1 ON adl.soft_obj_chg_group (elem_id);
-- * Recherche sur identifiant du groupe
CREATE INDEX        adl.i_so_chg_group_2 ON adl.soft_obj_chg_group (group_id);
-- * Recherche d'un groupe de modifications à partir d'un objet logiciel, d'un type de modification, et du rang d'une modification du groupe
CREATE INDEX        adl.i_so_chg_group_3 ON adl.soft_obj_chg_group (group_soft_obj, group_type, so_chg_rank);
-- * Recherche sur l'identifiant de la première modification du groupe et du nombre d'éléments
CREATE INDEX        adl.i_so_chg_group_4 ON adl.soft_obj_chg_group (soft_obj_change, group_nb_elements, is_first_in_group);

COMMIT;

---------------------------- adl.so_chg_exclusivity ----------------------------------

CREATE TABLE adl.so_chg_exclusivity
(
	id_rank            VARCHAR(25) NOT NULL,
	software_object    VARCHAR(20) NOT NULL,
	so_change_type     VARCHAR(10) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	prev_so_chg_excl   VARCHAR(25)         ,
	rank               INTEGER     NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_excl_1 ON adl.so_chg_exclusivity (id_rank DESC);
-- * Recherche des exclusivités pour un objet logiciel et un type de modification dans une arborescence
CREATE INDEX        adl.i_so_chg_excl_2 ON adl.so_chg_exclusivity (software_object, so_change_type, workspace_tree, rank DESC);

COMMIT;

---------------------------- adl.so_chg_grp_cfg_rev ----------------------------------

CREATE TABLE adl.so_chg_grp_cfg_rev
(
	id_level_hist_rank VARCHAR(27) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	config_branch      VARCHAR(22) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	first_config_rev   VARCHAR(27) NOT NULL,
	first_history_rank INTEGER     NOT NULL,
	software_object	   VARCHAR(20) NOT NULL,
	so_chg_grp_type    VARCHAR(10) NOT NULL,
	soft_obj_chg_group VARCHAR(20)         ,
	proj_so_chg        VARCHAR(25)         ,
	so_chg_exclusivity VARCHAR(25)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_grp_cr_1 ON adl.so_chg_grp_cfg_rev (id_level_hist_rank DESC);
-- * Recherche de tous les liens dans une version de configuration
CREATE INDEX        adl.i_so_chg_grp_cr_2 ON adl.so_chg_grp_cfg_rev (config_branch, first_history_rank DESC);
-- * Recherche d'un lien portant une exclusivité (et donc un rang d'exclusivité) pour un objet logiciel et un type de modification dans une arborescence
CREATE INDEX        adl.i_so_chg_grp_cr_3 ON adl.so_chg_grp_cfg_rev (software_object, so_chg_grp_type, workspace_tree, so_chg_exclusivity DESC);
-- * Recherche du dernier lien concernant un objet et un type de modification dans une version de configuration
CREATE INDEX        adl.i_so_chg_grp_cr_4 ON adl.so_chg_grp_cfg_rev (software_object, so_chg_grp_type, config_branch, first_history_rank DESC);
-- * Recherche sur une modification d'objet projeté
CREATE INDEX        adl.i_so_chg_grp_cr_5 ON adl.so_chg_grp_cfg_rev (proj_so_chg);

COMMIT;

---------------------------- adl.so_chg_evt_grp_cr ----------------------------------


CREATE TABLE adl.so_chg_evt_grp_cr
(
	elem_id            VARCHAR(20) NOT NULL,
	elem_type          VARCHAR(10) NOT NULL,
	group_id           VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	config_branch      VARCHAR(22) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	first_config_rev   VARCHAR(27) NOT NULL,
	first_history_rank INTEGER     NOT NULL,
	is_first           VARCHAR (1) NOT NULL,
	group_nb_elements  INTEGER     NOT NULL,
	software_object    VARCHAR(20) NOT NULL,
	so_change_type     VARCHAR(10) NOT NULL,
	so_chg_grp_cfg_rev VARCHAR(27)         ,
	so_chg_grp_cr_type VARCHAR(10)         ,
	component          VARCHAR(20) NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur l'identifiant de l'élément
CREATE UNIQUE INDEX adl.i_so_c_evt_g_cr_1 ON adl.so_chg_evt_grp_cr (elem_id);
-- * Recherche sur l'identifiant du groupe
CREATE INDEX        adl.i_so_c_evt_g_cr_2 ON adl.so_chg_evt_grp_cr (group_id);
-- * Recherche de tous les événements vus entre deux versions de configuration
CREATE INDEX        adl.i_so_c_evt_g_cr_3 ON adl.so_chg_evt_grp_cr (config_branch, first_history_rank DESC);
-- * Recherche de tous les événements concernant un objet logiciel entre deux versions de configuration
CREATE INDEX        adl.i_so_c_evt_g_cr_5 ON adl.so_chg_evt_grp_cr (software_object, config_branch, first_history_rank DESC);
-- * Recherche de tous les événements apparus dans un composant entre deux versions de configuration
CREATE INDEX        adl.i_so_c_evt_g_cr_7 ON adl.so_chg_evt_grp_cr (component, config_branch, first_history_rank DESC);

COMMIT;

---------------------------- adl.checked_out_elem ----------------------------------

CREATE TABLE adl.checked_out_elem
(
	id                 VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	element            VARCHAR(20) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	image              VARCHAR(20) NOT NULL,
	file_content_type  VARCHAR(10) NOT NULL,
	so_chg_exclusivity VARCHAR(25)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_co_elem_1 ON adl.checked_out_elem(id);
-- * Recherche sur l'objet acquis dans un espace de travail
CREATE        INDEX adl.i_co_elem_2 ON adl.checked_out_elem(workspace, element);
-- * Recherche sur l'objet acquis dans une image d'un espace de travail
CREATE        INDEX adl.i_co_elem_3 ON adl.checked_out_elem(workspace, image, element);
-- * Recherche sur l'objet acquis portant une exclusivité (et donc un rang d'exclusivité) dans une arborescence
CREATE        INDEX adl.i_co_elem_4 ON adl.checked_out_elem(workspace_tree, element, so_chg_exclusivity DESC);

COMMIT;

---------------------------- adl.so_chg_merge ----------------------------------

CREATE TABLE adl.so_chg_merge
(
	id_rank            VARCHAR(25) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	rank               INTEGER     NOT NULL,
	software_object    VARCHAR(20) NOT NULL,
	so_change_type     VARCHAR(10) NOT NULL,
	soft_obj_chg_group VARCHAR(20) NOT NULL,
	implicit_is_done   VARCHAR(1)  NOT NULL,
	so_chg_exclusivity VARCHAR(25)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL,
	is_solved          VARCHAR(1)  NOT NULL,
	solve_rslt_so_chg  VARCHAR(25)         ,
	solve_type         VARCHAR(10)         ,
	solve_date         TIMESTAMP                 ,
	solve_ws_rev       VARCHAR(27)         ,
	solve_hist_evt     VARCHAR(20)
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_merge1 ON adl.so_chg_merge(id_rank);
-- * Recherche sur les fusions dans un espace de travail, résolues ou non, et dont
--   les tentatives de résolution implicites et automatiques ont été effectuées ou non
CREATE        INDEX adl.i_so_chg_merge2 ON adl.so_chg_merge(workspace, is_solved, implicit_is_done);
-- * Recherche toutes les fusions d'un objet logiciel
CREATE        INDEX adl.i_so_chg_merge3 ON adl.so_chg_merge(software_object, so_change_type);
-- * Recherche la fusion dont le résultat est une modification
CREATE        INDEX adl.i_so_chg_merge4 ON adl.so_chg_merge(solve_rslt_so_chg);

COMMIT;

---------------------------- adl.promotion_request ----------------------------------

CREATE TABLE adl.promotion_request
(
	id                 VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	workspace_revision VARCHAR(27) NOT NULL,
	collector_ws       VARCHAR(20) NOT NULL,
	is_enabled         VARCHAR(1)  NOT NULL,
	is_prepromotion    VARCHAR(1)  NOT NULL,
	first_history_rank INTEGER     NOT NULL,
	first_date         TIMESTAMP   NOT NULL,
	disable_hist_evt   VARCHAR(20)         ,
	disable_reason     VARCHAR(10)         ,
	replaced_by_promo  VARCHAR(20)         ,
	collector_is_child VARCHAR(1)          ,
	collector_wr       VARCHAR(27)         ,
	collector_hist_rk  INTEGER             ,
	cr_collect_is_done VARCHAR(1)          ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_promo_request_1 ON adl.promotion_request (id);
-- * Recherche des demandes de promotion actives d'un espace de travail
CREATE INDEX        adl.i_promo_request_2 ON adl.promotion_request (workspace, is_enabled);
-- * Recherche de la demande de promotion active d'un espace de travail vers un espace de travail
CREATE INDEX        adl.i_promo_request_3 ON adl.promotion_request (workspace, collector_ws, is_enabled);
-- * Recherche si une versio d'espace de trvail a une demande de promotion active
CREATE INDEX        adl.i_promo_request_4 ON adl.promotion_request (workspace_revision, is_enabled);
-- * Recherche des demandes de promotion en attente de collecte par un espace de travail
CREATE INDEX        adl.i_promo_request_5 ON adl.promotion_request (collector_ws, is_enabled);

COMMIT;

---------------------------- adl.publication ----------------------------------

CREATE TABLE adl.publication
(
	id                 VARCHAR(20) NOT NULL,
	workspace          VARCHAR(20) NOT NULL,
	workspace_revision VARCHAR(27) NOT NULL,
	ws_rev_rank        INTEGER     NOT NULL,
	type               VARCHAR(10) NOT NULL,
	case_label         VARCHAR(32) NOT NULL,
	lower_label        VARCHAR(32) NOT NULL,
	is_enabled         VARCHAR(1)  NOT NULL,
	enable_hist_rk     INTEGER     NOT NULL,
	enable_date        TIMESTAMP   NOT NULL,
	disable_hist_evt   VARCHAR(20)         ,
	disable_reason     VARCHAR(10)         ,
	next_publication   VARCHAR(20)         ,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_publication_1 ON adl.publication (id);
-- * Recherche de la version d'espace de travail publiée avec un label dans un espace de travail
CREATE INDEX        adl.i_publication_2 ON adl.publication (workspace, is_enabled, lower_label);
-- * Recherche des publications actives d'un espace de travail avant un rang de version d'espace de travail donné
CREATE INDEX        adl.i_publication_3 ON adl.publication (workspace, is_enabled, ws_rev_rank);
-- * Recherche des publications actives avec un label d'une revision d'un espace de travail
CREATE INDEX        adl.i_publication_4 ON adl.publication (workspace_revision, is_enabled, lower_label);

COMMIT;

---------------------------- adl.history_event ----------------------------------

CREATE TABLE adl.history_event
(
	id                 VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	cmd_date           TIMESTAMP   NOT NULL,
	cmd_user           VARCHAR(20) NOT NULL,
	cmd_name           VARCHAR(32) NOT NULL,
	cmd_comment        VARCHAR(20)         ,
	site               VARCHAR(20) NOT NULL,
	multi_tree_ws      VARCHAR(20)         ,
	workspace_tree     VARCHAR(20)         ,
	workspace          VARCHAR(20)         ,
	ws_hist_rk         INTEGER           ,
	image              VARCHAR(20)
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_hist_evt_1 ON adl.history_event (id);
-- * Recherche sur l'utilisateur
CREATE        INDEX adl.i_hist_evt_2 ON adl.history_event (cmd_user);
-- * Recherche sur l'espace, la date et le rang historique
CREATE        INDEX adl.i_hist_evt_3 ON adl.history_event (workspace, cmd_date, ws_hist_rk);

COMMIT;

---------------------------- adl.site_for_hist ----------------------------------

CREATE TABLE adl.site_for_hist
(
	id                VARCHAR(20) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	lower_name        VARCHAR(32) NOT NULL,
	last_export_date  TIMESTAMP   NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_site_hist_1 ON adl.site_for_hist (id DESC);

COMMIT;

---------------------------- adl.multi_tree_ws_hist ----------------------------------

CREATE TABLE adl.multi_tree_ws_hist
(
	id                VARCHAR(20) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	lower_name        VARCHAR(32) NOT NULL,
	is_deleted        VARCHAR(1)  NOT NULL,
	last_export_date  TIMESTAMP   NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_m_t_ws_hist_1 ON adl.multi_tree_ws_hist (id DESC);

COMMIT;

---------------------------- adl.ws_tree_for_hist ----------------------------------

CREATE TABLE adl.ws_tree_for_hist
(
	id                VARCHAR(20) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	lower_name        VARCHAR(32) NOT NULL,
	is_deleted        VARCHAR(1)  NOT NULL,
	last_export_date  TIMESTAMP   NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_tree_hist_1 ON adl.ws_tree_for_hist (id DESC);

COMMIT;

---------------------------- adl.workspace_for_hist ----------------------------------

CREATE TABLE adl.workspace_for_hist
(
	id                VARCHAR(20) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	lower_name        VARCHAR(32) NOT NULL,
	is_deleted        VARCHAR(1)  NOT NULL,
	last_export_date  TIMESTAMP   NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_hist_1 ON adl.workspace_for_hist (id DESC);

COMMIT;

---------------------------- adl.image_for_hist ----------------------------------

CREATE TABLE adl.image_for_hist
(
	id                VARCHAR(20) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	lower_name        VARCHAR(32) NOT NULL,
	is_deleted        VARCHAR(1)  NOT NULL,
	last_export_date  TIMESTAMP   NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_image_for_hist_1 ON adl.image_for_hist (id DESC);

COMMIT;

---------------------------- adl.so_chg_fgt_info ----------------------------------

CREATE TABLE adl.so_chg_fgt_info
(
	id                 VARCHAR(20) NOT NULL,
	so_chg_grp_cfg_rev VARCHAR(27) NOT NULL,
	prev_so_chg_grp_cr VARCHAR(27) NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_chg_fgt_in_1 ON adl.so_chg_fgt_info (id);
-- * Recherche sur le groupe dans la version de configuration
CREATE UNIQUE INDEX adl.i_so_chg_fgt_in_2 ON adl.so_chg_fgt_info (so_chg_grp_cfg_rev);

COMMIT;

---------------------------- adl.file_type ----------------------------------

CREATE TABLE adl.file_type
(
	lower_name        VARCHAR(32) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	file_content_type VARCHAR(10) NOT NULL,
	unix_executable   VARCHAR(1)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant = le nom en minuscules
CREATE UNIQUE INDEX adl.i_file_type_1 ON adl.file_type (lower_name);
-- * Recherche sur le nom avec respect de la casse
CREATE INDEX        adl.i_file_type_2 ON adl.file_type (case_name);

---------------------------- adl.dept_db_clean ----------------------------------

CREATE TABLE adl.dept_db_clean
(
	cleaner           VARCHAR(20) NOT NULL,
	workspace_tree    VARCHAR(20),
	nb_table_cleaners INTEGER     NOT NULL,
	nb_checker_sets   INTEGER     NOT NULL,
	step              INTEGER     NOT NULL,
	family_to_clean   VARCHAR(20) NOT NULL,
	name_to_clean     VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

---------------------------- adl.dept_id_to_clean ----------------------------------

CREATE TABLE adl.dept_id_to_clean
(
	family      VARCHAR(20) NOT NULL,
	name        VARCHAR(10) NOT NULL,
	id_to_clean VARCHAR(27) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur la famille
CREATE INDEX adl.i_dept_id_to_cln_1 ON adl.dept_id_to_clean (family);

---------------------------- adl.transfer ----------------------------------

CREATE TABLE adl.transfer
(
	id                 VARCHAR(20) NOT NULL,
	case_name          VARCHAR(32) NOT NULL,
	lower_name         VARCHAR(32) NOT NULL,
	multi_tree_ws      VARCHAR(20) NOT NULL,
	image              VARCHAR(20)         ,
	case_store_path    VARCHAR(512)        ,
	lower_store_path   VARCHAR(512)        ,
	local_path_host    VARCHAR(255)        ,
	is_server          VARCHAR(512)        ,
	is_server_host     VARCHAR(255)        ,
	is_server_port     INTEGER             ,
	site2              VARCHAR(20)         ,
	is_with_mirror_ws  VARCHAR(1)  NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_transfer_1 ON adl.transfer (id);
-- * Recherche sur espace de travail multi-arborescence et nom
CREATE        INDEX adl.i_transfer_2 ON adl.transfer (multi_tree_ws, lower_name);

COMMIT;

---------------------------- adl.transfer_in_tree ----------------------------------

CREATE TABLE adl.transfer_in_tree
(
	id                VARCHAR(20) NOT NULL,
	transfer          VARCHAR(20) NOT NULL,
	multi_tree_ws     VARCHAR(20) NOT NULL,
	workspace_tree    VARCHAR(20) NOT NULL,
	multi_tree_ws2    VARCHAR(20) NOT NULL,
	workspace_tree2   VARCHAR(20) NOT NULL,
	fw_status         VARCHAR(10) NOT NULL,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_trf_in_tree_1 ON adl.transfer_in_tree (id);
-- * Recherche sur transfert
CREATE        INDEX adl.i_trf_in_tree_2 ON adl.transfer_in_tree (transfer, workspace_tree);
-- * Recherche sur espace de travail multi-arborescence
CREATE        INDEX adl.i_trf_in_tree_3 ON adl.transfer_in_tree (multi_tree_ws, workspace_tree);

COMMIT;

---------------------------- adl.change_set -----------------------------

CREATE TABLE adl.change_set
(
	id                VARCHAR(20)  NOT NULL,
	case_name         VARCHAR(32)  NOT NULL,
	lower_name        VARCHAR(32)  NOT NULL,
	is_opened         VARCHAR(1)   NOT NULL,
	is_deleted        VARCHAR(1)   NOT NULL,
	description       VARCHAR(255)         ,
	last_attr_date    TIMESTAMP    NOT NULL,
	last_chg_set_date TIMESTAMP    NOT NULL,
	native_database   VARCHAR(20)  NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_1 ON adl.change_set (id);
-- * Recherche des change set non supprimés
CREATE INDEX adl.i_change_set_2 ON adl.change_set (is_deleted, is_opened);

COMMIT;

---------------------------- adl.change_set_in_db -----------------------

CREATE TABLE adl.change_set_in_db
(
	id                VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	database          VARCHAR(20)  NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_db_1 ON adl.change_set_in_db (id);
-- * Recherche sur change set
CREATE INDEX adl.i_change_set_db_2 ON adl.change_set_in_db (change_set, database);

COMMIT;

---------------------------- adl.change_set_mtws -----------------------------

CREATE TABLE adl.change_set_mtws
(
	id                VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	multi_tree_ws     VARCHAR(20)  NOT NULL,
	is_current        VARCHAR(1)   NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_set_mtws_1 ON adl.change_set_mtws (id);
-- * Recherche sur espace de travail multi-arborescence et courant
CREATE INDEX adl.i_so_c_set_mtws_2 ON adl.change_set_mtws (multi_tree_ws, is_current);
-- * Recherche sur objet ensemble de modifications
CREATE INDEX adl.i_so_c_set_mtws_3 ON adl.change_set_mtws (change_set);

COMMIT;

---------------------------- adl.change_set_wstree -----------------------

CREATE TABLE adl.change_set_wstree
(
	id                VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	workspace_tree    VARCHAR(20)  NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_set_wt_1 ON adl.change_set_wstree (id);
-- * Recherche sur arborescence
CREATE INDEX adl.i_so_c_set_wt_2 ON adl.change_set_wstree (workspace_tree, change_set);
-- * Recherche sur objet ensemble de modifications
CREATE INDEX adl.i_so_c_set_wt_3 ON adl.change_set_wstree (change_set);

COMMIT;

---------------------------- adl.so_chg_change_set ----------------------

CREATE TABLE adl.so_chg_change_set
(
	id                VARCHAR(20)  NOT NULL,
	soft_obj_change   VARCHAR(25)  NOT NULL,
	so_chg_type       VARCHAR(10)  NOT NULL,
	software_object	  VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	is_deleted        VARCHAR(1)   NOT NULL,
	is_moved          VARCHAR(1)   NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_chg_set_1 ON adl.so_chg_change_set (id);
-- * Recherche du CS d'une modification
CREATE INDEX adl.i_so_c_chg_set_2 ON adl.so_chg_change_set (soft_obj_change, is_deleted, is_moved);
-- * Recherche des modifications d'un CS
CREATE INDEX adl.i_so_c_chg_set_3 ON adl.so_chg_change_set (change_set, is_deleted, is_moved);

COMMIT;

---------------------------- adl.so_chg_chg_set_is ----------------------

CREATE TABLE adl.so_chg_chg_set_is
(
	id                VARCHAR(20)  NOT NULL,
	so_chg_id         VARCHAR(25)  NOT NULL,
	so_chg_type       VARCHAR(10)  NOT NULL,
	soft_obj_id  	  VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_so_c_c_set_is_1 ON adl.so_chg_chg_set_is (id);
-- * Recherche des modifications d'un CS
CREATE INDEX adl.i_so_c_c_set_is_2 ON adl.so_chg_chg_set_is (change_set);
-- * Recherche sur modification
CREATE INDEX adl.i_so_c_c_set_is_3 ON adl.so_chg_chg_set_is (so_chg_id);
COMMIT;

---------------------------- adl.change_set_is -----------------------------

CREATE TABLE adl.change_set_is
(
	id                VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	site_for_hist     VARCHAR(20)  NOT NULL,
	workspace_tree    VARCHAR(20)  NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_is_1 ON adl.change_set_is (id);
-- * Recherche sur site pour historique
CREATE INDEX adl.i_change_set_is_2 ON adl.change_set_is (site_for_hist, workspace_tree);
-- * Recherche sur objet ensemble de modifications
CREATE INDEX adl.i_change_set_is_3 ON adl.change_set_is (change_set, site_for_hist);

COMMIT;

---------------------------- adl.chg_req_change_set --------------------------

CREATE TABLE adl.chg_req_change_set
(
	id                VARCHAR(20)  NOT NULL,
	change_set        VARCHAR(20)  NOT NULL,
	chg_req_type      VARCHAR(15)  NOT NULL,
	chg_req_id        VARCHAR(20)          ,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_chg_req_c_set_1 ON adl.chg_req_change_set (id);
-- * Recherche sur CS
CREATE INDEX adl.i_chg_req_c_set_2 ON adl.chg_req_change_set (change_set);
-- * Recherche sur l'application externe
CREATE INDEX adl.i_chg_req_c_set_3 ON adl.chg_req_change_set (chg_req_type, chg_req_id);

COMMIT;
