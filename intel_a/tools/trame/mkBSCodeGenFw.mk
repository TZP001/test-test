# Oct 2009 XNU
# Specifications for Build step mkBSCodeGenFw
# Step calling code generator on .simulia file
#

DGM_GRAPH_PATH = FWDGM_GRAPHPATH
METACLASS_NAME = CodeGenFw
DGM_VERSION = 0.01
MKMK_DGM_BEHAVIOUR = update

# triggers extension
SOURCE_EXTENSION = *.smaCodeGenFw

# Where to search SOURCE_EXTENSION
CODEGEN_SOURCE_SEARCH_PATH = $(IPublic) $(IProtected) $(IPrivate)
#
DGM_DEPEND = MKMK_DEBUG
#
