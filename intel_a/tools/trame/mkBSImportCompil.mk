#
# Specifications for Build step mkBSImportCompil
#
include mkBSCompil.mk
#
METACLASS_NAME = ImportCompilation
METACLASS_SOURCE =
#
SOURCE_EXTENSION = *.tlbcpp
ENCODED_SOURCE_EXTENSION = *.tlbcpp
#
DEPENDENT_ON = $(TLB_GENERATED_PATH)
