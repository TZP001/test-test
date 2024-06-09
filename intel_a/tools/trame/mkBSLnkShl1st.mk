#
# Specifications for Build step mkBSExternal
#
METACLASS_NAME = Link1stPass
METACLASS_SOURCE = ImportCompilation Compilation GrammarVI
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
#ADD_OBJECTS = {a list of WSEDataPath's macros names}
#
SOURCE_EXTENSION = *.rc
#
BSGR = Module 800 parallel "$(STEP_EXEPATH)" nohmap nohlist mkBSGlobalResource
#
BUILT_TYPE = $(BUILT_OBJECT_TYPE)
MOD_LINKWITH = $(MOD_LinkWith)
#
LD_OBJLIST = MODmkobjlist
#
DGM_DEPEND = BUILT_TYPE MOD_LINKWITH LD_OPTS LD_LIBS\
	EXTRA_COMMAND LOCAL_LD_ADDED_OBJECTS FWCOMPANYNAME FWCOPYRIGHT
#
