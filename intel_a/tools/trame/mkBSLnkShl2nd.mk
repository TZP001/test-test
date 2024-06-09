#
# Specifications for Build step mkBSExternal
#
METACLASS_NAME = Link2ndPass
METACLASS_SOURCE = ImportCompilation Compilation Link1stPass GrammarVI
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
#ADD_OBJECTS = {a list of WSEDataPath's macros names}
#
SOURCE_EXTENSION = *.rc *.manifest
#
BSGR = Module 800 parallel "$(STEP_EXEPATH)" nohmap nohlist mkBSGlobalResource
#
_MK_BUILD_DLK = $(BUILD_DLK)
BUILT_TYPE = $(BUILT_OBJECT_TYPE) $(_MK_BUILD_DLK)
MOD_LINKWITH = $(MOD_LinkWith)
DEPEND_ON_MODULES = $(MOD_Depend)
#
LD_OBJLIST = MODmkobjlist
#
# MKMK_DISABLE_SIGNTOOL environment variable set to globaly disable ALL sign tool
# SIGN_ACTIVATION=NO in Imakefile.mk to disable sign tool in a module
# For C++ link-edit, MKMK_ENABLE_CPP_SIGNTOOL environment variable set to activate the sign tool on C++ modules
#
_SIGN_ACTIVATION = $(SIGN_ACTIVATION) $(MKMK_DISABLE_SIGNTOOL) $(MKMK_ENABLE_CPP_SIGNTOOL)
#
DGM_DEPEND = BUILT_TYPE MOD_LINKWITH MOD_LINKWITH_RTNAME DEPEND_ON_MODULES LD_OPTS LD_LIBS\
	EXTRA_COMMAND LOCAL_LD_ADDED_OBJECTS FWCOMPANYNAME FWCOPYRIGHT\
	_SIGN_ACTIVATION MKSIGNMS_OPTS
#
CERT_PATH = $(MODPATH)\src\cert
#
