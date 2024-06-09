# Oct 2009 XNU
# Specifications for Build step mkBSCodeGen1st
# Step calling code generator on .simulia file
#

DGM_GRAPH_PATH = MODDGM_GRAPHPATH
METACLASS_NAME = CodeGen1st
DGM_VERSION = 0.01
MKMK_DGM_BEHAVIOUR = update

# triggers extension
SOURCE_EXTENSION = *.smaCodeGen1

# Where to search SOURCE_EXTENSION
CODEGEN_SOURCE_SEARCH_PATH = $(SRCPATH) $(MODPATH)/src
#
DGM_DEPEND = MKMK_DEBUG
#
