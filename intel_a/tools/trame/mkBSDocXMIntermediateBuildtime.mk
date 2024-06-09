#
# Specifications for Build step mkBSDoc
#
METACLASS_NAME = DocXMIntermediateBuildtime
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH_DOC
#
SOURCE_EXTENSION = *.ditamap
# For Coverage tools
#
MOD_LINKWITH = $(MOD_LinkWith)
MOD_SRCLINKWITH = $(MOD_SrcLinkWith)
#
DGM_VERSION = 1.00

DGM_DEPEND = MOD_LINKWITH MOD_SRCLINKWITH
# 
