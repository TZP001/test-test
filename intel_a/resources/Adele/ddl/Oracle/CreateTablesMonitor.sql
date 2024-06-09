---------------------------- adl.mo_db_version ----------------------------------

CREATE TABLE adl.mo_db_version
(
	value         VARCHAR2(10) NOT NULL,
	upgrade_value VARCHAR2(10)         ,
	upgrade_step  NUMBER(10)
) 
PCTFREE 5
TABLESPACE scm_tbs0;

INSERT INTO adl.mo_db_version
(value)
VALUES
('2001_03_19');

CREATE UNIQUE INDEX adl.i_mo_db_version_1 ON adl.mo_db_version (value) 
PCTFREE 5
TABLESPACE scm_idx0;

COMMIT;

---------------------------- adl.mo_lock ----------------------------------

CREATE TABLE adl.mo_lock
 (
	id                 VARCHAR2(20)  NOT NULL,
	criteria           VARCHAR2(128) NOT NULL,
	locking_mode       VARCHAR2(15)  NOT NULL,
	is_persistent      VARCHAR2(1)   NOT NULL,
	recovery_mode      VARCHAR2(10)  NOT NULL,
	waiting_status     VARCHAR2(10)  NOT NULL,
	command            VARCHAR2(20)  NOT NULL,
	recoverable_object VARCHAR2(20)          ,
	monitor            VARCHAR2(20)  NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_mo_lock_1 ON adl.mo_lock (id) 
PCTFREE 5
TABLESPACE scm_idx0;

COMMIT;

---------------------------- adl.mo_rec_obj ----------------------------------

CREATE TABLE adl.mo_rec_obj
 (
	id                 VARCHAR2(20) NOT NULL,
	type               VARCHAR2(80) NOT NULL,
	reference_db       VARCHAR2(20) NOT NULL,
	lock_ref_number    INTEGER      NOT NULL,
	monitor            VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_mo_rec_obj_1 ON adl.mo_rec_obj (id) 
PCTFREE 5
TABLESPACE scm_idx0;

COMMIT;
---------------------------- adl.mo_rec_obj_param ----------------------------------

CREATE TABLE adl.mo_rec_obj_param
 (
	id                 VARCHAR2(20)  NOT NULL,
	param_name         VARCHAR2(20)  NOT NULL,
	param_value        VARCHAR2(128) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE INDEX adl.i_mo_rec_obj_par_1 ON adl.mo_rec_obj_param (id) 
PCTFREE 5
TABLESPACE scm_idx0;

COMMIT;

---------------------------- adl.mo_command ----------------------------------

CREATE TABLE adl.mo_command
 (
	id                 VARCHAR2(20)  NOT NULL,
	name               VARCHAR2(40)  NOT NULL,
	type               VARCHAR2( 8)  NOT NULL,
	-- User Informations
	user_id            VARCHAR2(20)  NOT NULL,
	user_name          VARCHAR2(20)  NOT NULL,
	-- System Informations
	host_name          VARCHAR2(20)  NOT NULL,
	os_type            VARCHAR2(20)  NOT NULL,
	os_name            VARCHAR2(20)  NOT NULL,
	os_version         VARCHAR2(20)  NOT NULL,
	processor          VARCHAR2(20)  NOT NULL,
	process_id         INTEGER       NOT NULL,
	-- Dates
	client_launch_date DATE          NOT NULL,
	client_begin_date  DATE          NOT NULL,
	client_end_date    DATE                  ,
	server_begin_date  DATE          NOT NULL,
	server_end_date    DATE          NOT NULL,
	-- Final states
	status             VARCHAR2(10)  NOT NULL,
	exit_code          INTEGER               ,
	treated_items      INTEGER               ,
	success_treated    INTEGER               ,
	-- Monitor identifier
	monitor            VARCHAR2(20)  NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_mo_command_1 ON adl.mo_command (id) 
PCTFREE 10 
TABLESPACE scm_idx1;

COMMIT;

---------------------------- adl.mo_command_cm_ctxt ----------------------------------

CREATE TABLE adl.mo_command_cm_ctxt
 (
	command            VARCHAR2(20)  NOT NULL,
	multi_tree_ws      VARCHAR2(20),
	multi_tree_ws_name VARCHAR2(32),
	ws_tree            VARCHAR2(20),
	ws_tree_name       VARCHAR2(32),
	workspace          VARCHAR2(20),
	workspace_name     VARCHAR2(32),
	image              VARCHAR2(20),
	image_name         VARCHAR2(32)
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur la commande
CREATE INDEX adl.i_mo_cmd_cm_ctxt_1 ON adl.mo_command_cm_ctxt (command) 
PCTFREE 10 
TABLESPACE scm_idx1;

COMMIT;
