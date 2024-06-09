---------------------------- adl.central_db_version ----------------------------------

CREATE TABLE adl.central_db_version
(
	value         VARCHAR2(10) NOT NULL,
	upgrade_value VARCHAR2(10),
	upgrade_step  NUMBER(10),
    database_id   VARCHAR2(20)
) 
PCTFREE 5
TABLESPACE scm_tbs0;

INSERT INTO adl.central_db_version
(value)
VALUES
('2004_11_30');

CREATE UNIQUE INDEX adl.i_central_db_vers1 ON adl.central_db_version (value) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.site ----------------------------------

CREATE TABLE adl.site
(
	id          VARCHAR2(20) NOT NULL,
	lower_name  VARCHAR2(32) NOT NULL,
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
CREATE INDEX adl.i_workspace_tree_2 ON adl.workspace_tree (lower_name, is_deleted) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.ws_tree_in_db ----------------------------------

CREATE TABLE adl.ws_tree_in_db
(
	id                 VARCHAR2(20) NOT NULL,
	workspace_tree     VARCHAR2(20) NOT NULL,
	database           VARCHAR2(20) NOT NULL,
	creation_hist_evt  VARCHAR2(20) NOT NULL
) 
PCTFREE 5
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_tree_in_db_1 ON adl.ws_tree_in_db (workspace_tree, database) TABLESPACE scm_idx0
PCTFREE 5;

COMMIT;

---------------------------- adl.multi_tree_ws_c_db ----------------------------------

CREATE TABLE adl.multi_tree_ws_c_db
(
	id                VARCHAR2(20) NOT NULL,
	case_name         VARCHAR2(32) NOT NULL,
	lower_name        VARCHAR2(32) NOT NULL,
	is_deleted        VARCHAR2(1)  NOT NULL,
	native_database   VARCHAR2(20) NOT NULL,
	creation_hist_evt VARCHAR2(20) NOT NULL
) 
PCTFREE 5 
TABLESPACE scm_tbs0;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_multi_tree_db_1 ON adl.multi_tree_ws_c_db (id) TABLESPACE scm_idx0
PCTFREE 10;
-- * Recherche d'une arborescence non supprimée à partir du nom
CREATE INDEX adl.i_multi_tree_db_2 ON adl.multi_tree_ws_c_db (lower_name, is_deleted) TABLESPACE scm_idx0
PCTFREE 10;

COMMIT;

---------------------------- adl.workspace_c_db ----------------------------------

CREATE TABLE adl.workspace_c_db
(
	id                VARCHAR2(20) NOT NULL,
	multi_tree_ws     VARCHAR2(20) NOT NULL,
	workspace_tree    VARCHAR2(20) NOT NULL,
	creation_hist_evt VARCHAR2(20) NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_workspace_c_db_1 ON adl.workspace_c_db (id) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche des espaces de travail d'un espace multi-arborescence
CREATE INDEX adl.i_workspace_c_db_2 ON adl.workspace_c_db (multi_tree_ws) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.contents_server ----------------------------------

CREATE TABLE adl.contents_server
(
	id                VARCHAR2(20)  NOT NULL,
	host_name         VARCHAR2(255) NOT NULL,
	port_number       NUMBER(10)    NOT NULL,
	description       VARCHAR2(250)         ,
	creation_hist_evt VARCHAR2(20)  NOT NULL
) 
PCTFREE 10
TABLESPACE scm_tbs0
STORAGE (BUFFER_POOL KEEP);

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_contents_serv_1 ON adl.contents_server (id) TABLESPACE scm_idx0
PCTFREE 10
STORAGE (BUFFER_POOL KEEP);

COMMIT;

---------------------------- adl.history_event ----------------------------------

CREATE TABLE adl.history_event
(
	id                 VARCHAR2(20) NOT NULL,
	type               VARCHAR2(10) NOT NULL,
	cmd_date           DATE         NOT NULL,
	cmd_user           VARCHAR2(20) NOT NULL,
	cmd_name           VARCHAR2(32) NOT NULL,
	cmd_comment        VARCHAR2(20),
	site               VARCHAR2(20) NOT NULL,
	multi_tree_ws      VARCHAR2(20),
	workspace_tree     VARCHAR2(20),
	workspace          VARCHAR2(20),
	ws_hist_rk         NUMBER(10),
	image              VARCHAR2(20)
) 
PCTFREE 5
TABLESPACE scm_tbs1;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_hist_evt_1 ON adl.history_event (id) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur l'utilisateur
CREATE        INDEX adl.i_hist_evt_2 ON adl.history_event (cmd_user) TABLESPACE scm_idx1
PCTFREE 5;
-- * Recherche sur l'espace, la date et le rang historique
CREATE        INDEX adl.i_hist_evt_3 ON adl.history_event (workspace, cmd_date, ws_hist_rk) TABLESPACE scm_idx1
PCTFREE 5;

COMMIT;

---------------------------- adl.associated_comment ----------------------------------

CREATE TABLE adl.associated_comment
(
	id                 VARCHAR2 (20) NOT NULL,
	summary            VARCHAR2(250) NOT NULL,
	file_content       VARCHAR2 (20),
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

-- * C++
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cpp',        'cpp',         'TEXT',       'N');
-- * java
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('java',       'java',        'TEXT',       'N');
-- * C++ avec Templates
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('tpinst',     'TPinst',      'TEXT',       'N');
-- * Templates
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('hxx',        'hxx',         'TEXT',       'N');
-- * C++
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cxx',        'cxx',         'TEXT',       'N');
-- * c standard
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('c',          'c',           'TEXT',       'N');
-- * Lex
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('l',          'l',           'TEXT',       'N');
-- * c généré par Lex ou Yacc
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('lc',         'lc',          'TEXT',       'N');
-- * Yacc
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('y',          'y',           'TEXT',       'N');
-- * Header généré par Lex ou Yacc
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('yc',         'yc',          'TEXT',       'N');
-- * Header
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('h',          'h',           'TEXT',       'N');
-- * Header fortran
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('hf',         'hf',          'TEXT',       'N');
-- * Macro level
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('level',      'level',       'TEXT',       'N');
-- * Shells
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('sh',         'sh',          'TEXT',       'Y');
-- * Makefile
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('mk',         'mk',          'TEXT',       'N');
-- * Fortran
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('f',          'f',           'TEXT',       'N');
-- * Express
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('express',    'express',     'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('exm',        'exm',         'TEXT',       'N');
-- * Circe
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('circe',      'circe',       'TEXT',       'N');
-- * Fichiers textes
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('txt',        'txt',         'TEXT',       'N');
-- * Fichiers descriptifs module V4
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('mdf',        'mdf',         'TEXT',       'N');
-- * Liste V4
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ll',         'll',          'TEXT',       'N');
-- * include schema Adele (myself)
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('hman',       'hman',        'TEXT',       'N');
-- * Manuel Adele
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('man',        'man',         'TEXT',       'N');
-- * ** Pour Sniff
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('sniff_custom',     'sniff_custom',      'TEXT',       'N');
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('custom',     'custom',      'TEXT',       'N');
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('sniff_parser',     'sniff_parser',      'TEXT',       'N');
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('parser',     'parser',      'TEXT',       'N');
-- * Fichiers binaires pour la visualisation
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cgr',        'cgr',         'BINARY',     'N');
-- * Fichiers binaires pour java
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('jar',        'jar',         'BINARY',     'N');
-- * Fichiers binaires : HPGL : graphique vectoriel
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('gl',         'gl',          'BINARY',     'N');
-- * Icones : format texte "editable"
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('pm',         'pm',          'TEXT',       'N');
-- * Declaratif
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('dcls',       'dcls',        'TEXT',       'N');
-- * Pour le GII
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('fsd',        'fsd',         'TEXT',       'N');
-- * Pour le GII ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('fsdinc',     'fsdinc',      'TEXT',       'N');
-- * Pour le GII ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('fsdmod',     'fsdmod',      'TEXT',       'N');
-- * Pour le GII ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('fsdpar',     'fsdpar',      'TEXT',       'N');
-- * Ressources (?)
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('exsrc',      'exsrc',       'TEXT',       'N');
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ddlsrc',      'ddlsrc',     'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cisrc',      'cisrc',       'TEXT',       'N');
-- * Lex et Yacc pour Adele
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('yadl',       'yadl',        'TEXT',       'N');
-- * Lexx Adele 3.2
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ladl',       'ladl',        'TEXT',       'N');
-- * Dictionnaire
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('dic',        'dic',         'TEXT',       'N');
-- * Fichiers messages
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('msg',        'msg',         'TEXT',       'N');
-- * Modeles
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('model',      'model',       'BINARY',     'N');
-- * output des FunctionTest
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('out',        'out',         'TEXT',       'N');
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('output',        'output',   'TEXT',       'N');
-- * binaire
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('bin',        'bin',         'BINARY',     'N');
-- * executable
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('exe',        'exe',         'BINARY',     'Y');
-- * archive / librairie AIX
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('a',          'a',           'BINARY',     'Y');
-- * librairie
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('lib',        'lib',         'BINARY',     'N');
-- * librairie
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('so',         'so',          'BINARY',     'Y');
-- * librairie
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('sl',         'sl',          'BINARY',     'Y');
-- * Header Corba
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('idl',        'idl',         'TEXT',       'N');
-- * Caracteristiques, fichier binaire
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('settings',   'settings',    'BINARY',     'N');
-- * Fichiers Record
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('rec',        'rec',         'BINARY',     'N');
-- * sources à pre-processer
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('c_',         'c_',          'TEXT',       'N');
-- * cpp pour prépro V4
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cpp_',       'cpp_',        'TEXT',       'N');
-- * Fortran pour prepro V4
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('f_',         'f_',          'TEXT',       'N');
-- * Assembleur pour prepro V4
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('s_',         's_',          'TEXT',       'N');
-- * Environnement (?)
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('env',        'env',         'TEXT',       'N');
-- * Book FrameMaker
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('bk',         'bk',          'BINARY',     'N');
-- * chapitre Framemaker
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('frm',        'frm',         'BINARY',     'N');
-- * toc FrameMaker ou doc Word
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('doc',        'doc',         'BINARY',     'N');
-- * Excel
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('xls',        'xls',         'BINARY',     'N');
-- * PowerPoint
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ppt',        'ppt',         'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('mif',        'mif',         'TEXT',       'N');
-- * Rich Text File
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('rtf',        'rtf',         'TEXT',       'N');
-- * HTML
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('html',       'html',        'TEXT',       'N');
-- * HTML
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('htm',        'htm',         'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('css',        'css',         'TEXT',       'N');
-- * doc Acrobat
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('pdf',        'pdf',         'BINARY',     'N');
-- * Poscript
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ps',         'ps',          'TEXT',       'N');
-- * format tiff
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('tif',        'tif',         'BINARY',     'N');
-- * Compuserve gif
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('gif',        'gif',         'BINARY',     'N');
-- * Fichier bitmap
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('rgb',        'rgb',         'BINARY',     'N');
-- * Fichier bitmap
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('bmp',        'bmp',         'BINARY',     'N');
-- * image jpeg
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('jpg',        'jpg',         'BINARY',     'N');
-- * image png
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('png',        'png',         'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cgm',        'cgm',         'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ncgm',        'NCGM',       'BINARY',     'N');
-- * Virtual Reality pour Web
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('vrml',       'vrml',        'BINARY',     'N');
-- * Movie player
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('mpg',        'mpg',         'BINARY',     'N');
-- * Son
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('wav',        'wav',         'BINARY',     'N');
-- * Audio-video
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('avi',        'avi',         'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('qt',         'qt',          'BINARY',     'N');
-- * Audio-video
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('mov',        'mov',         'BINARY',     'N');
-- * Java (code de machine virtuelle)
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('class',      'class',       'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('tplib',      'tplib',       'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('tsrc',       'tsrc',        'TEXT',       'N');
-- * Bibliotheque de types
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('tlb',       'tlb',          'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('tpsrc',      'tpsrc',       'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('fact',       'fact',        'TEXT',       'N');
-- * Batch Windows
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('bat',        'bat',         'TEXT',       'N');
-- * Langage Perl
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('pl',         'pl',          'TEXT',       'Y');
-- * Langage Perl
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('perl',       'perl',        'TEXT',       'Y');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('feat',       'feat',        'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catscript',  'CATScript',   'TEXT',       'N');
-- * Message CATIA
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catnls',     'CATNls',      'TEXT',       'N');
-- * Ressource CATIA
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catrsc',     'CATRsc',      'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catpart',    'CATPart',     'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catproduct', 'CATProduct',  'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catsettings', 'CATSettings', 'BINARY',   'Y');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catdlg',     'CATDlg',       'TEXT',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('iid',     'iid',             'TEXT',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('clsid',     'clsid',         'TEXT',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('dico',     'dico',           'TEXT',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('frx',     'frx',            'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('ico',     'ico',            'BINARY',     'N');
-- * Metadata
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('metadata',     'metadata',      'TEXT',   'N');
-- * Visual Basic
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('vbp',     'vbp',      'TEXT',       'N');
-- * Visual Basic
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('vbw',     'vbw',      'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cls',     'cls',      'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('bas',     'bas',      'TEXT',       'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catfct',   'CATfct', 'BINARY',      'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catdrawing',   'CATDrawing', 'BINARY',   'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catsystem',   'CATSystem', 'BINARY',     'N');
-- * ???
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catgscript',   'CATGScript', 'TEXT',     'N');
-- * Java script
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('js',           'js',         'TEXT',     'N');
-- * ??
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('csv',           'csv',         'TEXT',     'N');
-- * ?? 
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catprocess',           'CATProcess',         'BINARY',     'N');
-- * ?? 
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catanalysis',           'CATAnalysis',         'BINARY',     'N');
-- * ?? 
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('catalog',           'catalog',         'BINARY',     'N');
-- * ?? 
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('idf',           'idf',         'TEXT',     'N');
-- * eXtensible Markup Language
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('xml',           'xml',         'TEXT',     'N');
-- * Document Type Definition
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('dtd',           'dtd',         'TEXT',     'N');
-- * fichier compresse
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('zip',           'zip',         'BINARY',     'N');
-- * Java Server Page
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('jsp',           'jsp',         'TEXT',     'N');
-- * 
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('cgmreplay',           'CGMReplay',         'BINARY',     'N');
-- * reference a un fichier externe 
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('extref',           'ExtRef',         'TEXT',     'N');
-- * sert  à stocker les propriétés JAVA (en particulier les messages internationalisés)
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('properties',           'properties',         'TEXT',     'N');
-- * declaratif des evenements emis par les objets ENOVIA
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('event',           'event',         'TEXT',     'N');
-- * Dynamic Link Library
INSERT INTO adl.file_type
(lower_name, case_name,  file_content_type, unix_executable)
VALUES
('dll',           'dll',         'BINARY',     'Y');

COMMIT;

---------------------------- adl.change_set_c_db ----------------------------------

CREATE TABLE adl.change_set_c_db
(
	id                VARCHAR2(20)  NOT NULL,
	case_name         VARCHAR2(32)  NOT NULL,
	lower_name        VARCHAR2(32)  NOT NULL,
	is_deleted        VARCHAR2(1)   NOT NULL,
	native_database   VARCHAR2(20)  NOT NULL,
	creation_hist_evt VARCHAR2(20)  NOT NULL
) PCTFREE 10 
TABLESPACE scm_tbs2;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_cdb_1 ON adl.change_set_c_db (id) TABLESPACE scm_idx2
PCTFREE 10;
-- * Recherche à partir du nom et non supprimé
CREATE INDEX adl.i_change_set_cdb_2 ON adl.change_set_c_db (lower_name, is_deleted) TABLESPACE scm_idx2
PCTFREE 10;

COMMIT;
