#
# Specifications for Build step mkBSDoc
#
METACLASS_NAME = DocXMParser
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_DOC
#
SOURCE_EXTENSION = *.cnfxml *.htm *.xml
# SMACODEGEN_EXTENSION = *.smaCodeGen1 *.smaCodeGen2 *.smaCodeGen3 *.smaCodeGenFw
SMACODEGEN_EXTENSION = *.smaCodeGen*
#
#
ID2URL_PATH = $(DOCPATH)\resources\msgcatalog
#
MOD_LINKWITH = $(MOD_LinkWith)
#
DGM_VERSION = 1.0

DGM_DEPEND = MOD_LINKWITH
# 
