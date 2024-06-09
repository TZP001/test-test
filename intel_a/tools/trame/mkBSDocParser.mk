#
# Specifications for Build step mkBSDoc
#
METACLASS_NAME = DocParser
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_DOC
#
# report dans WSDataPath.mk
###  PREFIX_DERIVED_PATH = $(DOCPATH)/online$(LANG)/$(MODNAME)
#
SOURCE_EXTENSION = *.cnfxml *.htm *.xml
# For Coverage tools
SOURCE_EXTENSION_FOR_TEST = *.cnfxml *.htm *.html *.js *.xml *.jpg *.bmp
#
MOD_LINKWITH = $(MOD_LinkWith)
#
DGM_VERSION = 1.02

DGM_DEPEND = MOD_LINKWITH
# 
# a positionner des que checkpii dispo 
# 
# DGM_DEPEND = MOD_LINKWITH CHECKPII_COMMAND CHECKPII_VERSION CHECKPII_ACTIVATION
#
