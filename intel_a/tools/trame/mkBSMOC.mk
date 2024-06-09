#
# Specifications for Build step mkBSMOC
#
METACLASS_NAME = MOC
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION = *.mocsrc
#
MOC_RUNTIME = $(MkmkROOTINSTALL_PATH)\code\command\moc.exe
MOC_OPTS = "%HEADER%" -o "%SOURCE%"
MOC_DEFAULT_DIR = $(GLocal)
MOC_PRIVATE_DIR = $(GPrivate)
MOC_PROTECTED_DIR = $(GProtected)
MOC_PUBLIC_DIR = $(GPublic)
MOC_INCL_FILE = $(GLocal)/mocincl.mk
#
DGM_DEPEND = LOCAL_MOC_FLAGS

