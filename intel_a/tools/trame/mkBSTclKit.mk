#
# Specifications for Build step mkBSTclKit
#
METACLASS_NAME = Starkit
METACLASS_SOURCE = Idl Grammar
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#MKMK_DGM_BEHAVIOUR = update
#
SOURCE_EXTENSION = *.tcl
#
VFS_DIR = $(MODPATH)/src/vfs
#
TCL_TMP_DIR = $(MOD_ObjectsPath)/tmp/
#
TCL_VFS_DIR = $(TCL_TMP_DIR)$(MODNAME).vfs/
TCL_SDX_DIR_LIB = $(TCL_TMP_DIR)$(MODNAME).vfs/lib/
#
_MKTCLKITINSTALL_PATH=$(_TCLKITINSTALL_PATH:-MkmkROOTINSTALL_PATH)


SDXKIT = $(_MKTCLKITINSTALL_PATH)/tclkit/tclkit852/sdx.kit
TCLLIB = $(_MKTCLKITINSTALL_PATH)/tclkit/tclkit852/tcllib.kit
TCLKIT_RUNTIME = $(_MKTCLKITINSTALL_PATH)/tclkit/tclkit852/$(MkmkOS_Buildtime)/tclkit.exe
TCLKIT = $(TCLKIT_RUNTIME)
#
SDX_TMP_DIR = $(TCL_TMP_DIR)sdx.vfs/
SDX_TMP_PATH = $(TCL_TMP_DIR)sdx.kit
TCLLIB_TMP_DIR = $(TCL_TMP_DIR)tcl.vfs/
TCLLIB_TMP_PATH = $(TCL_TMP_DIR)tcl.kit
TCLKIT_TMP_DIR = $(TCL_TMP_DIR)
TCLKIT_TMP_PATH = $(TCL_TMP_DIR)tclkit.exe
#
SDX_CMD = $(TCLKIT) sdx.kit unwrap sdx.kit
TCL_CMD = $(TCLKIT) sdx.kit unwrap tcl.kit
#
QWRAP_CMD = $(TCLKIT) sdx.kit qwrap "%SOURCE%"
UNWRAP_CMD = $(TCLKIT) sdx.kit unwrap "%SOURCE%"
WRAP_EXE_CMD = $(TCLKIT) sdx.kit wrap "%SOURCE%" -runtime $(TCLKIT_TMP_PATH)
WRAP_NONEXE_CMD = $(TCLKIT) sdx.kit wrap "%SOURCE%"
