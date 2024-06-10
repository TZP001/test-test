-- COPYRIGHT 2004 DASSAULT SYSTEMES

-- Description:
-- ORACLE SQL commands used to create tables for Search persistency in Settings database.
-- This script must be ran before Search Persistency can be used with ORACLE, when
-- the Favorites and Settings are stored in two databases ; as ORACLE JDBC XA
-- driver does not allows DDL statements inside transactions.


-- Creation of tables
CREATE TABLE PPRQUERY  (  "ID" VARCHAR(30) NOT NULL,
				"USERNAME" VARCHAR(30),
				"ADAPTERID" VARCHAR(30),
				"QUERYTYPE" int,
				"SHARED" int,
				"QUERYNAME" VARCHAR(30),
				"VALUE" BLOB,
				PRIMARY KEY(ID));

CREATE TABLE PPRSELECTUNDER (  "ID" VARCHAR(30) NOT NULL,
				"USERNAME" VARCHAR(30),
				"ADAPTERID" VARCHAR(30),
				"CRITERTYPE" int,
				"SHARED" int,
				"SELNAME" VARCHAR(30),
				"VALUE" BLOB,
				PRIMARY KEY(Id));

QUIT;
-- Grant access (not needed if this SQL script is ran using the user/password created to store Settings)

-- grant all on PPRQUERY  to public;
-- grant all on PPRSELECTUNDER to public;
