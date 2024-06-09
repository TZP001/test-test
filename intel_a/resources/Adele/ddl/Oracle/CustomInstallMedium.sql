Rem +=================================================================+
Rem ! COPYRIGHT DASSAULT SYSTEMES - 1998                              !
Rem +-----------------------------------------------------------------+
Rem ! PURPOSE:                                                        !
Rem ! Script to be executed after creating a new instance             !
Rem ! and whose purpose it to create ADL's tablespaces                !
Rem ! and create the 'adl' account -> administrator                   !
Rem !                                                                 !
Rem ! NOTE: this script must be executed with SYSTEM login            !
Rem +-----------------------------------------------------------------+
Rem ! Aug 1998    YGD - Creation                                      !
Rem +=================================================================+

Rem +======================================================+
Rem ! Clean-up a previous installation
Rem +======================================================+
DROP USER &1.;
DROP PROFILE &1._profile;
DROP TABLESPACE SCM_TBS0;
DROP TABLESPACE SCM_TBS1;
DROP TABLESPACE SCM_TBS2;
DROP TABLESPACE SCM_TBS3;
DROP TABLESPACE SCM_IDX0;
DROP TABLESPACE SCM_IDX1;
DROP TABLESPACE SCM_IDX2;
DROP TABLESPACE SCM_IDX3;
DROP TABLESPACE SCM_TMP;

Rem +=================================================+
Rem ! Create 4 tablespaces for data
Rem +=================================================+
CREATE TABLESPACE SCM_TBS0
  DATAFILE '&3./scm_tbs0.dbf' SIZE 1544K AUTOEXTEND ON NEXT 120K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 48K
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE SCM_TBS1
  DATAFILE '&3./scm_tbs1.dbf' SIZE 11272K  AUTOEXTEND ON NEXT 4352K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 512K
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE SCM_TBS2
  DATAFILE '&3./scm_tbs2.dbf' SIZE 30728K AUTOEXTEND ON NEXT 15360K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1920K
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE SCM_TBS3
  DATAFILE '&3./scm_tbs3.dbf' SIZE 184328K AUTOEXTEND ON NEXT 92160K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 18432K
  SEGMENT SPACE MANAGEMENT AUTO;

Rem +===============================================+
Rem ! Create 4 tablespaces for indexes
Rem +===============================================+
CREATE TABLESPACE SCM_IDX0
  DATAFILE '&4./scm_idx0.dbf' SIZE 2408K AUTOEXTEND ON NEXT 244K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 48K
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE SCM_IDX1
  DATAFILE '&4./scm_idx1.dbf' SIZE 25608K  AUTOEXTEND ON NEXT 9216K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 512K
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE SCM_IDX2
  DATAFILE '&4./scm_idx2.dbf' SIZE 92168K  AUTOEXTEND ON NEXT 46080K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1920K
  SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE SCM_IDX3
  DATAFILE '&4./scm_idx3.dbf' SIZE 552968K  AUTOEXTEND ON NEXT 276480K
  EXTENT MANAGEMENT LOCAL UNIFORM SIZE 18432K
  SEGMENT SPACE MANAGEMENT AUTO;

Rem +===============================================+
Rem ! Create a tablespace for temporary data
Rem +===============================================+
CREATE TEMPORARY TABLESPACE SCM_TMP
  TEMPFILE '&5./scm_tmp.dbf' SIZE 10M
  REUSE AUTOEXTEND ON NEXT 30M MAXSIZE 500M;

Rem +===========================================+
Rem ! Create a Oracle profile: &1._profile
Rem +===========================================+
CREATE PROFILE &1._profile LIMIT
  COMPOSITE_LIMIT           UNLIMITED
  FAILED_LOGIN_ATTEMPTS     UNLIMITED
  SESSIONS_PER_USER         UNLIMITED
  PASSWORD_LIFE_TIME  	    UNLIMITED
  CPU_PER_SESSION           UNLIMITED
  PASSWORD_REUSE_TIME       UNLIMITED
  CPU_PER_CALL              UNLIMITED
  PASSWORD_REUSE_MAX        UNLIMITED
  LOGICAL_READS_PER_SESSION UNLIMITED
  PASSWORD_VERIFY_FUNCTION  DEFAULT
  LOGICAL_READS_PER_CALL    UNLIMITED
  PASSWORD_LOCK_TIME        UNLIMITED
  IDLE_TIME                 UNLIMITED
  PASSWORD_GRACE_TIME       UNLIMITED
  CONNECT_TIME              UNLIMITED
  PRIVATE_SGA               UNLIMITED;

Rem +===========================================================+
Rem ! Create a Oracle user: ADL 
Rem +===========================================================+
CREATE USER &1. 
  IDENTIFIED BY &2.
  DEFAULT TABLESPACE SCM_TBS0
  TEMPORARY TABLESPACE SCM_TMP
  PROFILE &1._profile
  QUOTA UNLIMITED ON SCM_TBS0
  QUOTA UNLIMITED ON SCM_TBS1
  QUOTA UNLIMITED ON SCM_TBS2
  QUOTA UNLIMITED ON SCM_TBS3
  QUOTA UNLIMITED ON SCM_IDX0
  QUOTA UNLIMITED ON SCM_IDX1
  QUOTA UNLIMITED ON SCM_IDX2
  QUOTA UNLIMITED ON SCM_IDX3;

GRANT connect, resource TO &1.;
