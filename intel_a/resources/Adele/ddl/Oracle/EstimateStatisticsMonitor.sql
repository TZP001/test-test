set TIMING ON
ANALYZE TABLE adl.mo_db_version      ESTIMATE STATISTICS SAMPLE 20 PERCENT;
ANALYZE TABLE adl.mo_lock            ESTIMATE STATISTICS SAMPLE 20 PERCENT;
ANALYZE TABLE adl.mo_rec_obj         ESTIMATE STATISTICS SAMPLE 20 PERCENT;
ANALYZE TABLE adl.mo_rec_obj_param   ESTIMATE STATISTICS SAMPLE 20 PERCENT;
ANALYZE TABLE adl.mo_command         ESTIMATE STATISTICS SAMPLE 20 PERCENT;
ANALYZE TABLE adl.mo_command_cm_ctxt ESTIMATE STATISTICS SAMPLE 20 PERCENT;
