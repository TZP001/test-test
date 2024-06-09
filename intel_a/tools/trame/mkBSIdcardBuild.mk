# @(#) preprocess
#
# Specifications for Build step mkBSIDCardScript
#
METACLASS_NAME = CI-Script
#
DGM_GRAPH_PATH = FWDGM_GRAPHPATH
#
SOURCE_EXTENSION_FOR_TEST = *.xml *.h
#
IDCARD_NAME   = IdentityCard$(MKMK_IDCARDEXTEND:-".h")
IDCARD_NAME_SOURCE_XML  = IdentityCard$(MKMK_IDCARDEXTEND:-".xml")

#

#if os MOBILE 
IDCARD_SCRIPT_NAME=
#else
IDCARD_SCRIPT_NAME = $(FWNAME)IC.script 
#endif
IDCARD_XML_NAME = $(FWNAME)IC.xml
TABLECOPYRIGHT = TableCopyright.mk
COPYRIGHTMK = Copyright.mk
#
# The name of the C++ object which will be used as source
# depending of framework type (code or packaging)
#
IDCARD_H_TYPELATE = mkBOidcardSource_h
#
IDCARD_XML_TYPELATE = mkBOidcardSource_xml
#
include mkMacLevData.mk
#
DGM_VERSION = 2.2
DGM_DEPEND =  MKMK_PP_DEFINED COPYRIGHT COPYRIGHTROOT_PATH MKMK_IDCARDLEVEL
#
COPYRIGHTROOT_PATH = $(CopyrightROOT_PATH)
MKMK_IDCARDLEVEL = 000000
#

