#
# Specifications for Build step mkBSWIDL
#
METACLASS_NAME = WIDL
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION = *.widlsrc *.xsdsrc
#
WIDL_RUNTIME = $(MkmkROOTINSTALL_PATH)\code\command\widlCompiler.bat
WIDL_CPL = WIDL
#WIDL_INCL = -concat $(MOD_ObjectsPath)/.incdirs.mk
WIDL_INCL = -concat $(MOD_MACDIRS_PATH)
WIDL_WARNING = $(MKMK_WARNING:+"-w")
WIDL_OPTS = $(WIDL_WARNING) -file "%SOURCE%"
WIDL_USEDFILE = $(WIDL_CPL).usedfiles

WIDL_SOURCE_DIR = $(GLocal)
WIDL_DOC_DIR = $(GLocal)
