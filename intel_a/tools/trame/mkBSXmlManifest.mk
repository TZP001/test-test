#
# Specifications for Build step mkBSXmlManifest
#
METACLASS_NAME = GrammarMF
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION_XML = *.ProfileCard.xml $(MKMK_DEVSTAGE:%+"*.ProfileCard.dev")
SOURCE_EXTENSION_XML_REPLACEMENT = $(MKMK_DEVSTAGE:%+".dev .xml")
#
