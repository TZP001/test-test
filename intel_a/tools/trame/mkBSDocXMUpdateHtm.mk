#
# Specifications for Build step mkBSDoc
#
METACLASS_NAME = DocXMUpdateHtm
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_DOC
#
INHTM_PATH = $(DOCPATH)\intermediate_@LANG@\$(MODNAME)\htm\$(MODNAME) 
OUTHTM_PATH = $(DOCPATH)\@LANG@\$(MODNAME)
#
SOURCE_EXTENSION = *.htm
# For Coverage tools
#
DGM_VERSION = 1.00

DGM_DEPEND = DGM_VERSION
# 
