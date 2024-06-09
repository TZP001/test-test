#
# Specifications for Build step mkBSIdcardBuildAndCrypt
#
DGM_VERSION = 2.3
#
MKMK_IDCARDLEVEL = $(Mkmk_IDCARDLEVEL)
#
# The name of the C++ object which will be used as source
# depending of framework type (code or packaging)
#
SOURCE_EXTENSION_FOR_TEST = *.xml *.h
#
IDCARD_H_TYPELATE = mkBOidcardSource_h_crypt
IDCARD_XML_TYPELATE = mkBOidcardSource_xml_crypt
#
include mkBSIdcardBuild.mk
#
include mkMacLevData.mk
#

