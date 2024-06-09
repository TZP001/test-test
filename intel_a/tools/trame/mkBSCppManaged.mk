#
# Specifications for Build step mkBSCppManaged
#
METACLASS_NAME = CompilSharp
METACLASS_SOURCE = GrammarVI
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION_SNK = *.snk
#
SOURCE_EXTENSION_XML = *.ProfileCard.xml $(MKMK_DEVSTAGE:%+"*.ProfileCard.dev")
SOURCE_EXTENSION_XML_REPLACEMENT = $(MKMK_DEVSTAGE:%+".dev .xml")
#
TLBTOPAS_EXTENSION = _TLB.pas
SOURCE_FILTERS = "*.cpp" "*.rc"
COMPILER_FILTERS = "*.cpp"
#
DEPENDENT_ON = $(MOD_LinkWith) $(CLR_TLB) $(CLR_TLBTOPAS) $(CLR_TLBTOASSEMBLY)
#
SRCLIST = .mkSrcList
OBJLIST = .mkObjList
#
BSGR = Module 800 parallel "$(STEP_EXEPATH)" nohmap nohlist mkBSGlobalResource
#
