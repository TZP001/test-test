#
# Specifications for Build step GrammarV4
############################################
#
FSD = mkrundcg
MAO = mkrunmao
#
FSD_CREATEDFILE = catdcg.createdfiles
FSD_USEDFILE = catdcg.usedfiles
#
MAO_CREATEDFILE = catmao.createdfiles
MAO_USEDFILE = catmao.usedfiles
#
FSD_OPTS = $(LOCAL_FSDFLAGS)
FSD_COMMAND = $(FSD) $(FSD_OPTS) -p $(FSD_SOURCE_PATH) -m
#
MAO_OPTS = $(LOCAL_MAOFLAGS)
MAO_COMMAND = $(MAO) -p $(FSD_SOURCE_PATH) -f %SOURCE%
#
DGM_DEPEND = FSD_OPTS
DGM_VERSION = 1.0
#

