#
# Specifications for Build step mkBSDoc
#
METACLASS_NAME = DocXMRootMapStructure
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_DOC
#
# a l'origine : IN_PATH = $(DOCPATH)\intermediate_@LANG@\$(MODNAME)\xml\$(MODNAME)
IN_PATH = $(DOCPATH)\intermediate_@LANG@\$(MODNAME)
OUT_PATH = $(DOCPATH)\intermediate_@LANG@\$(MODNAME)\xml\$(MODNAME) 
#
SOURCE_EXTENSION = RootMap.ditamap
# For Coverage tools
#
DGM_VERSION = 1.01

DGM_DEPEND = DGM_VERSION
# 
