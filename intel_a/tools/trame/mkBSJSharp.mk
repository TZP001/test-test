#
# Specifications for Build step mkBSJSharp
#
METACLASS_NAME = CompilSharp
METACLASS_SOURCE = GrammarVI
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION = *.jsl
SOURCE_EXTENSION_JAVA = *.java
SOURCE_EXTENSION_SNK = *.snk
#
SOURCE_EXTENSION_XML = *.ProfileCard.xml $(MKMK_DEVSTAGE:%+"*.ProfileCard.dev")
SOURCE_EXTENSION_XML_REPLACEMENT = $(MKMK_DEVSTAGE:%+".dev .xml")
#
TLBTOPAS_EXTENSION = _TLB.pas
RESOURCE_FILTERS = "*.resx"
ASSEMBLYINFO_FILTERS = "*.h.jsl"
#
DEPENDENT_ON = $(MOD_LinkWith) $(CLR_TLB) $(CLR_TLBTOPAS) $(JSHARP_LIBPATH) $(JSHARP_REFLIBS)
#
OBJLIST = .mkObjList
#