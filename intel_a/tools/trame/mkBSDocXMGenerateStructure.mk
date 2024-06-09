#
# Specifications for Build step mkBSDoc
#
METACLASS_NAME = DocXMGenerateStructure
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_DOC
#
IN_PATH = $(DOCPATH)\intermediate_@LANG@\$(MODNAME)\xml\$(MODNAME) 
OUT_PATH = $(DOCPATH)\@LANG@\$(MODNAME)
#
SOURCE_EXTENSION = RootMapStructure.ditamap
# For Coverage tools
#
DGM_VERSION = 1.00

DGM_DEPEND = DGM_VERSION
# 
