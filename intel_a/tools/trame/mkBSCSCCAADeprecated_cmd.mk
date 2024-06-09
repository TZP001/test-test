#
# Specifications for Build step mkBSCSCCAADeprecated 
#
include mkBSCompil_cmd.mk
#---------------------

CSC_COMPILER = CAA_front_end

CSC_INCLUDE = $(CPP_INCLUDE)
_CSC_XML_FILE = $(CSC_XML_FILE)
_CSC_COMPIL_ERROR_OUTPUT = $(CSC_COMPIL_ERROR_OUTPUT)

# test [JTF 22/06/05]
MKMKADDON = $(MkmkADDON_LEVEL)
CSC_MSVER = $(MK_MSCVER:+"-D_MSC_VER=")$(MK_MSCVER) $(MK_MSCVER:+"--edg_microsoft_version ")$(MK_MSCVER)

#
CSC_OPTS_CPP = $(LOCAL_CSCFLAGS) $(CPP_OPTS) $(LOCAL_POST_CSCFLAGS) $(CSC_MSVER) $(CSC_DEPRECATED_MODE:+"-deprecated") $(CSC_NODOC_MODE:+"-nodoc") $(_CSC_XML_FILE:+"-tracking") $(_CSC_XML_FILE) $(_CSC_COMPIL_ERROR_OUTPUT:+"-compil_error_output") $(_CSC_COMPIL_ERROR_OUTPUT) 
#
CSC_COMMAND_CPP = $(CSC_COMPILER) $(CSC_OPTS_CPP) $(CSC_INCLUDE) $(MOTIF_INCPATH) %SOURCE%

#---------------------

CSC_OPTS_C = $(LOCAL_CSCFLAGS) $(C_OPTS) $(LOCAL_POST_CSCFLAGS) $(CSC_MSVER) $(CSC_DEPRECATED_MODE:+"-deprecated") $(CSC_NODOC_MODE:+"-nodoc") $(_CSC_XML_FILE:+"-tracking") $(_CSC_XML_FILE) $(_CSC_COMPIL_ERROR_OUTPUT:+"-compil_error_output") $(_CSC_COMPIL_ERROR_OUTPUT) 
#
CSC_COMMAND_C = $(CSC_COMPILER) $(CSC_OPTS_C) $(CSC_INCLUDE) $(MOTIF_INCPATH) %SOURCE%
#---------------------

#
DGM_VERSION = 1.0
#

