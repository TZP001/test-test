#
# Specifications for Build step ListV4
#
# Constants declaration and specs to use lkxdfz
include mkBSlkxdfzSpecs.mk
#
# The command to link using lkxdfz
MKMKMACRO_LEVEL = $(MkmkMACRO_LEVEL)
MK_DEPENDANCES=$(OUTPUT)/LIST.deps
LKXDFZ_COMMAND = mkcpllistv4.sh -o $(OUTPUT) -n
# All of those values will be set as "used" for all sources
DGM_DEPEND = MKMKMACRO_LEVEL
DGM_VERSION = 1.0.1
#

