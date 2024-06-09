#
# Specifications for Build step mkBSPIFExeV4
#
PIFPROD_LIST = $(OBJPATH)/.pifexev4.list
# The command to link using lkxdfz
PIFEXE_COMMAND = mkpifexev4.sh -pifout $(PIFEXEPATHNAME)\
						-piflib $(RTV_MODUV4PIFPRO) -piflist $(PIFPROD_LIST)\
						-stubgeo $(V4_SRCCATGEO)
# All of those values will be set as "used" for all sources
LKX_ENVIRONMENT = $(LKX_DGM_DEPEND)
LKX_DGM_DEPEND =
DGM_DEPEND = $(LKX_DGM_DEPEND)
#---------------------------------------------------------------------------
#
DGM_VERSION = 1.0
#

