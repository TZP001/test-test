#
# Specifications for Build step mkBSDynamicCreator
#
METACLASS_NAME = DynamicCreator
#
DGM_GRAPH_PATH = FWDGM_GRAPHPATH
#
SOURCE_EXTENSION_FOR_TEST = *.ProfileCard.xml *.ProfileCard.dev
#
SOURCE_EXTENSION_XML = *.ProfileCard.xml $(MKMK_DEVSTAGE:%+"*.ProfileCard.dev")
SOURCE_EXTENSION_XML_REPLACEMENT = $(MKMK_DEVSTAGE:%+".dev .xml")
#
DYNAMICCREATOR_COMPILER = code\bin\DynamicCreator.dll
#
