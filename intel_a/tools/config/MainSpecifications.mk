#####################################################################
# Main declaration file
#
#####################################################################
#
# Path to search for in WS concatenation
# May be overwriten by EV "MkmkCATIAV5Level_PATH=Framework/PublicInterfaces/OtherCATIAV5Level.h"
CATIAV5Level_PATH = SpecialAPI/PublicInterfaces/CATIAV5Level.h
#
# Logicals to add to CATIAV5Level.h when preprocessing Imakefile.mk and IdentityCard.h
#  if NO_LOCAL_DEFINITION_FOR_IID is set nothing will be added,
#  otherwise LOCAL_DEFINITION_FOR_IID will be true
# Environment value MK_V5LEVEL_ADDON will be added
CNEXTLEVEL_ADDON = $(MkmkADDON_LEVEL) $(NO_LOCAL_DEFINITION_FOR_IID:%@"LOCAL_DEFINITION_FOR_IID") $(MK_V5LEVEL_ADDON)
#
