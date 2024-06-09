#
# Specifications for Build step mkBSPIFProV4PMx
# Specifics declaration per OS
include mkBSLinkV4Specs.mk
# Constants declaration and specs to use lkxdfz
include mkBSlkxdfzSpecs.mk
#
# The command to link using lkxdfz
PIFPROPMX_COMMAND = mkpifpropmxv4.sh -n %CDF% -f $(FU)
# All of those values will be set as "used" for all sources
DGM_DEPEND = $(LKX_DGM_DEPEND) $(FU)
DGM_VERSION = 1.0
#

