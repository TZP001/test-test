#
# Specifications for Build step mkBSExternal
#
METACLASS_NAME = Link-edit
METACLASS_SOURCE = ImportCompilation Compilation GrammarVI
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION = *.rc *.manifest
#
BSGR = Module 800 parallel "$(STEP_EXEPATH)" nohmap nohlist mkBSGlobalResource
#
BUILT_TYPE = $(BUILT_OBJECT_TYPE)
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
	EXTRA_COMMAND LOCAL_LD_ADDED_OBJECTS _SIGN_ACTIVATION FWCOMPANYNAME FWCOPYRIGHT\
	_SIGN_ACTIVATION MKSIGNMS_OPTS
#
