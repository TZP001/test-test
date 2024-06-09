---------------------------- adl.mo_db_version ----------------------------------

CREATE TABLE adl.mo_db_version
(
	value         VARCHAR(10) NOT NULL,
	upgrade_value VARCHAR(10)         ,
	upgrade_step  INTEGER
)
--TABLESPACE tablespace_name
;

INSERT INTO adl.mo_db_version
(value)
VALUES
('2001_03_19');

CREATE UNIQUE INDEX adl.i_mo_db_version_1 ON adl.mo_db_version (value);

COMMIT;

---------------------------- adl.mo_lock ----------------------------------

CREATE TABLE adl.mo_lock
 (
	id                 VARCHAR(20)  NOT NULL,
	criteria           VARCHAR(128) NOT NULL,
	locking_mode       VARCHAR(15)  NOT NULL,
	is_persistent      VARCHAR(1)   NOT NULL,
	recovery_mode      VARCHAR(10)  NOT NULL,
	waiting_status     VARCHAR(10)  NOT NULL,
	command            VARCHAR(20)  NOT NULL,
	recoverable_object VARCHAR(20)          ,
	monitor            VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_mo_lock_1 ON adl.mo_lock (id);

COMMIT;

---------------------------- adl.mo_rec_obj ----------------------------------

CREATE TABLE adl.mo_rec_obj
 (
	id                 VARCHAR(20) NOT NULL,
	type               VARCHAR(80) NOT NULL,
	reference_db       VARCHAR(20) NOT NULL,
	lock_ref_number    INTEGER      NOT NULL,
	monitor            VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_mo_rec_obj_1 ON adl.mo_rec_obj (id);

COMMIT;
---------------------------- adl.mo_rec_obj_param ----------------------------------

CREATE TABLE adl.mo_rec_obj_param
 (
	id                 VARCHAR(20)  NOT NULL,
	param_name         VARCHAR(20)  NOT NULL,
	param_value        VARCHAR(128) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE INDEX adl.i_mo_rec_obj_par_1 ON adl.mo_rec_obj_param (id);

COMMIT;

---------------------------- adl.mo_command ----------------------------------

CREATE TABLE adl.mo_command
 (
	id                 VARCHAR(20)  NOT NULL,
	name               VARCHAR(40)  NOT NULL,
	type               VARCHAR( 8)  NOT NULL,
	-- User Informations
	user_id            VARCHAR(20)  NOT NULL,
	user_name          VARCHAR(20)  NOT NULL,
	-- System Informations
	host_name          VARCHAR(20)  NOT NULL,
	os_type            VARCHAR(20)  NOT NULL,
	os_name            VARCHAR(20)  NOT NULL,
	os_version         VARCHAR(20)  NOT NULL,
	processor          VARCHAR(20)  NOT NULL,
	process_id         INTEGER       NOT NULL,
	-- Dates
	client_launch_date TIMESTAMP          NOT NULL,
	client_begin_date  TIMESTAMP          NOT NULL,
	client_end_date    TIMESTAMP                  ,
	server_begin_date  TIMESTAMP          NOT NULL,
	server_end_date    TIMESTAMP          NOT NULL,
	-- Final states
	status             VARCHAR(10)  NOT NULL,
	exit_code          INTEGER               ,
	treated_items      INTEGER               ,
	success_treated    INTEGER               ,
	-- Monitor identifier
	monitor            VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_mo_command_1 ON adl.mo_command (id);

COMMIT;

---------------------------- adl.mo_command_cm_ctxt ----------------------------------

CREATE TABLE adl.mo_command_cm_ctxt
 (
	command            VARCHAR(20)  NOT NULL,
	multi_tree_ws      VARCHAR(20),
	multi_tree_ws_name VARCHAR(32),
	ws_tree            VARCHAR(20),
	ws_tree_name       VARCHAR(32),
	workspace          VARCHAR(20),
	workspace_name     VARCHAR(32),
	image              VARCHAR(20),
	image_name         VARCHAR(32)
)
--TABLESPACE tablespace_name
;

-- * Recherche sur la commande
CREATE INDEX adl.i_mo_cmd_cm_ctxt_1 ON adl.mo_command_cm_ctxt (command);

COMMIT;
