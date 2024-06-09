#
# Specifications for Build step Doc
#
# ---------------------
#
GENXML_COMPILER = mkDocGenXmlM
# GENXML_OPTS     = -i %SOURCE% -o %CIBLE% 
GENXML_OPTS     = -i %SOURCE% -o %CIBLE% -f %INCLUDE% -mod %MODNAME%
#
GENXML_COMMAND = $(GENXML_COMPILER) $(GENXML_OPTS)
#

#
#DGM_VERSION = 1.0
#

