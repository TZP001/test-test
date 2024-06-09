---------------------------- adl.mo_rec_obj_param ----------------------------------

DROP INDEX adl.i_mo_rec_obj_param_1;
CREATE INDEX adl.i_mo_rec_obj_par_1 ON adl.mo_rec_obj_param (id) TABLESPACE adele_idx;

---------------------------- adl.mo_db_version ----------------------------------

UPDATE adl.mo_db_version
SET value = '2001_03_19';

---------------------------- adl.mo_command ----------------------------------

ALTER TABLE adl.mo_command
ADD (type  VARCHAR2(8));

UPDATE adl.mo_command
SET type = 'User';

ALTER TABLE adl.mo_command
MODIFY (type NOT NULL);


---------------------------- Final commit ----------------------------------

COMMIT;
