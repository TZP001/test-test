---------------------------- adl.central_db_version ----------------------------------

CREATE TABLE adl.central_db_version
(
	value         VARCHAR(10) NOT NULL,
	upgrade_value VARCHAR(10)         ,
	upgrade_step  INTEGER             ,
	database_id   VARCHAR(20)
)
--TABLESPACE tablespace_name
;

INSERT INTO adl.central_db_version
(value)
VALUES
('2004_11_30');

CREATE UNIQUE INDEX adl.i_central_db_vers1 ON adl.central_db_version (value);

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
CREATE INDEX adl.i_workspace_tree_2 ON adl.workspace_tree (lower_name, is_deleted);

COMMIT;

---------------------------- adl.ws_tree_in_db ----------------------------------

CREATE TABLE adl.ws_tree_in_db
(
	id                 VARCHAR(20) NOT NULL,
	workspace_tree     VARCHAR(20) NOT NULL,
	database           VARCHAR(20) NOT NULL,
	creation_hist_evt  VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ws_tree_in_db_1 ON adl.ws_tree_in_db (workspace_tree, database);

COMMIT;

---------------------------- adl.multi_tree_ws_c_db ----------------------------------

CREATE TABLE adl.multi_tree_ws_c_db
(
	id                VARCHAR(20) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	lower_name        VARCHAR(32) NOT NULL,
	is_deleted        VARCHAR(1)  NOT NULL,
	native_database   VARCHAR(20) NOT NULL,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_multi_tree_db_1 ON adl.multi_tree_ws_c_db (id DESC);
-- * Recherche d'une arborescence non supprimée à partir du nom
CREATE INDEX adl.i_multi_tree_db_2 ON adl.multi_tree_ws_c_db (lower_name, is_deleted);

COMMIT;

---------------------------- adl.workspace_c_db ----------------------------------

CREATE TABLE adl.workspace_c_db
(
	id                VARCHAR(20) NOT NULL,
	multi_tree_ws     VARCHAR(20) NOT NULL,
	workspace_tree    VARCHAR(20) NOT NULL,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_workspace_c_db_1 ON adl.workspace_c_db (id DESC);
-- * Recherche des espaces de travail d'un espace multi-arborescence
CREATE        INDEX adl.i_workspace_c_db_2 ON adl.workspace_c_db (multi_tree_ws);

COMMIT;

---------------------------- adl.contents_server ----------------------------------

CREATE TABLE adl.contents_server
(
	id                VARCHAR(20)  NOT NULL,
	host_name         VARCHAR(255) NOT NULL,
	port_number       INTEGER      NOT NULL,
	description       VARCHAR(250)         ,
	creation_hist_evt VARCHAR(20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_contents_serv_1 ON adl.contents_server (id);

COMMIT;

---------------------------- adl.history_event ----------------------------------

CREATE TABLE adl.history_event
(
	id                 VARCHAR(20) NOT NULL,
	type               VARCHAR(10) NOT NULL,
	cmd_date           TIMESTAMP         NOT NULL,
	cmd_user           VARCHAR(20) NOT NULL,
	cmd_name           VARCHAR(32) NOT NULL,
	cmd_comment        VARCHAR(20),
	site               VARCHAR(20) NOT NULL,
	multi_tree_ws      VARCHAR(20),
	workspace_tree     VARCHAR(20),
	workspace          VARCHAR(20),
	ws_hist_rk         INTEGER,
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

---------------------------- adl.associated_comment ----------------------------------

CREATE TABLE adl.associated_comment
(
	id                 VARCHAR (20) NOT NULL,
	summary            VARCHAR(250) NOT NULL,
	file_content       VARCHAR (20),
	creation_hist_evt  VARCHAR (20) NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_ass_comment_1 ON adl.associated_comment (id);
-- * Recherche sur le résumé
CREATE INDEX        adl.i_ass_comment_2 ON adl.associated_comment (summary);

COMMIT;

---------------------------- adl.file_type ----------------------------------
-- Cette table est indispensable pour le adl_ls_type !

CREATE TABLE adl.file_type
(
	lower_name        VARCHAR(32) NOT NULL,
	case_name         VARCHAR(32) NOT NULL,
	file_content_type VARCHAR(10) NOT NULL,
	unix_executable   VARCHAR(1)  NOT NULL
)
--TABLESPACE tablespace_name
;

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


-- * Recherche sur identifiant = le nom en minuscules
CREATE UNIQUE INDEX adl.i_file_type_1 ON adl.file_type (lower_name);
-- * Recherche sur le nom avec respect de la casse
CREATE INDEX        adl.i_file_type_2 ON adl.file_type (case_name);

COMMIT;

---------------------------- adl.change_set_c_db ----------------------------------

CREATE TABLE adl.change_set_c_db
(
	id                VARCHAR(20)  NOT NULL,
	case_name         VARCHAR(32)  NOT NULL,
	lower_name        VARCHAR(32)  NOT NULL,
	is_deleted        VARCHAR(1)   NOT NULL,
	native_database   VARCHAR(20)  NOT NULL,
	creation_hist_evt VARCHAR(20)  NOT NULL
)
--TABLESPACE tablespace_name
;

-- * Recherche sur identifiant
CREATE UNIQUE INDEX adl.i_change_set_cdb_1 ON adl.change_set_c_db (id);
-- * Recherche à partir du nom et non supprimé
CREATE INDEX adl.i_change_set_cdb_2 ON adl.change_set_c_db (lower_name, is_deleted);

COMMIT;
