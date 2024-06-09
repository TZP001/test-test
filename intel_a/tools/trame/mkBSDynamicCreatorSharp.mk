#
# Specifications for Build step mkBSDynamicCreatorSharp
#
METACLASS_NAME = DynamicCreator
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
SOURCE_EXTENSION_XML = *.ProfileCard.xml $(MKMK_DEVSTAGE:%+"*.ProfileCard.dev")
SOURCE_EXTENSION_XML_REPLACEMENT = $(MKMK_DEVSTAGE:%+".dev .xml")
#
DYNAMICCREATOR_COMPILER = code\bin\DynamicCreator.dll
# For Coverage Tools
SOURCE_EXTENSION_FOR_TEST = *.ProfileCard.xml *.ProfileCard.dev *.lst
#
