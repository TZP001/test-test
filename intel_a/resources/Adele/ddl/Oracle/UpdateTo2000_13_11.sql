---------------------------- adl.mo_db_version ----------------------------------

CREATE TABLE adl.mo_db_version
(
	value         VARCHAR2(10) NOT NULL,
	upgrade_value VARCHAR2(10)         ,
	upgrade_step  NUMBER(10)
) PCTFREE 10 PCTUSED 70
TABLESPACE adele_tbs
STORAGE (initial 20K  next 10K);

INSERT INTO adl.mo_db_version
(value)
VALUES
('2000_11_13');

CREATE UNIQUE INDEX adl.i_mo_db_version_1 ON adl.mo_db_version (value) TABLESPACE adele_idx;

COMMIT;


---------------------------- adl.mo_command_cm_ctxt ----------------------------------

ALTER TABLE adl.mo_command_cm_ctxt MODIFY multi_tree_ws NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY multi_tree_ws_name NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY ws_tree NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY ws_tree_name NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY workspace NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY workspace_name NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY image NULL;
ALTER TABLE adl.mo_command_cm_ctxt MODIFY image_name NULL;

DROP INDEX adl.i_mo_command_cm_ctxt_1;
CREATE INDEX adl.i_mo_cmd_cm_ctxt_1 ON adl.mo_command_cm_ctxt (command);
