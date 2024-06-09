##############################################################
#
# Pathname which start from the Workspace's pathname
#
##############################################################
#
MKMKOSBT = $(MkmkOS_Buildtime)
#
RTV_PATH = $(MKMKOSBT)
RTV_PATH_JAVA = $(MKMKOSBT)
RTV_DOC_PATH = Doc
#
RTV_DSXDEVVISUAL = $(RTV_PATH)/resources/VisualDesigners
dsgencomponent = $(RTV_DSXDEVVISUAL)/DialogDesigner/Components
dsgenenum = $(RTV_DSXDEVVISUAL)/DialogDesigner/Components
dsgendelegate = $(RTV_DSXDEVVISUAL)/DialogDesigner/Components
#
RTV_MULTIOS = $(MKMKOSBT)/multios/$(MKMKOSBT)
RTV_MULTIOSJAR = $(RTV_MULTIOS)/jar
RTV_MULTIOSCAB = $(RTV_MULTIOS)/cab
RTV_MULTIOSXPI = $(RTV_MULTIOS)/xpi
RTV_CODEBINMSI = $(MKMKOSBT)/code/bin
multiosroot = $(RTV_MULTIOS)
multiosjar = $(RTV_MULTIOSJAR)
multioscab = $(RTV_MULTIOSCAB)
multiosxpi = $(RTV_MULTIOSXPI)
codebinmsi = $(RTV_CODEBINMSI)
#
RTV_MODUV4 = $(RTV_PATH)/moduv4
RTV_MODUV4PMO = $(RTV_MODUV4)/pmo
RTV_MODUV4PMD = $(RTV_MODUV4)/pmd
RTV_MODUV4PMX = $(RTV_MODUV4)/pmx
RTV_MODUV5PMO = $(RTV_MODUV4)/pmov5
RTV_MODUV5PMD = $(RTV_MODUV4)/pmdv5
RTV_MODUV5LSTSHARED = $(RTV_MODUV4)/lstshared
RTV_MODUV4PIFPC = $(RTV_MODUV4)/pifpc
RTV_MODUV4PIFPRO = $(RTV_MODUV4)/pifpro
RTV_MODUV4PIFEXE = $(RTV_PATH)/pif/exe
#
RTV_TOCPRODV4 = $(RTV_PATH)/tocprod
RTV_CONFIGFSDV4 = $(RTV_PATH)/dec
v4dcgconfig = $(RTV_CONFIGFSDV4)
#
RTV_CODESTEPLIB = $(RTV_PATH)/code/steplib
RTV_CODEBIN = $(RTV_PATH)/code/bin
RTV_CODELIB = $(RTV_PATH)/code/lib
RTV_CODETLB1 = $(RTV_PATH)/code/tlb1
RTV_RESOURCES = $(RTV_PATH)/resources
RTV_FEATCTLG = $(RTV_PATH)/resources/featurecatalog
RTV_MSGCTLG = $(RTV_PATH)/resources/msgcatalog
RTV_CODEINST = $(RTV_PATH)/code/bin_inst
RTV_CODEIC = $(RTV_PATH)/code/productIC
RTV_CPSPATH	= $(RTV_CODEIC)/ComponentsDefinition
RTV_CODEDICTIONARY = $(RTV_PATH)/code/dictionary
RTV_CODECOMMAND = $(RTV_PATH)/code/command
#
RTV_CATGEO = $(RTV_CODELIB)/catgeo
RTV_CATLIB = $(RTV_CODELIB)/catlib
#
RTV_JAVACLIENT = $(RTV_PATH_JAVA)/docs/java
RTV_JAVASERVER = $(RTV_PATH_JAVA)/docs/javaserver
RTV_JAVACOMMON = $(RTV_PATH_JAVA)/docs/javacommon
RTV_JAVAJPO = $(RTV_PATH_JAVA)/docs/javajpo
RTV_JAVADOCS = $(RTV_PATH_JAVA)/docs
#
RTV_JAVACORBA = $(RTV_JAVACOMMON)
#
RTV_SHARP = $(RTV_PATH)/code/clr
#
RTV_APIJAVA = $(RTV_DOC_PATH)/docs/api
RTV_SRCJAVA = $(RTV_PATH)/code/commands
#
CAAV5_DEPRECATEDAPI = CAADoc/Doc/generated/refman/DeprecatedAPI.script
CAAV5_UNAUTHORIZEDAPI = CAADoc/Doc/generated/refman/UnauthorizedAPI.script
#
CTRL_FRAMEWORK = System
CTRL_DESTINATION = code/dictionary
CTRL_FILTER = /code/bin/
#
javaclient = $(RTV_JAVACLIENT)
javadocs = $(RTV_JAVADOCS)
typelib = $(RTV_CODEBIN)
pia = $(RTV_CODEBIN)
chm = $(RTV_CODEBIN)
#
MACLEV = CATIAV5Level.lvl
#
###############################################################
#
# Pathname which start from the installation of mkmk without OS
#
###############################################################
#
MKMK_TOOLSLIB = code/lib
MKMK_TOOLSBIN = code/bin
MKMK_MSGCATALOG = resources/msgcatalog
MKMK_DICTIONARY = code/dictionary
#
# PYTHON
PY_OUTPUT_PATH = $(RTV_PATH)/code/python/lib
#
