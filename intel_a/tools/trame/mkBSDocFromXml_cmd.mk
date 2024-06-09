#
# Specifications for Build step Doc
#
# ---------------------
#
#---------------------------------------------------------------
# FROMXML_BUFFER a yes active le sous repertoire de la RTV
# dans lequel seront generes les differents fichiers
# mettre ce motcle a no pour les generer dans le RTV 
#---------------------------------------------------------------
FROMXML_BUFFER = no
#---------------------------------------------------------------
#
FROMXML_COMPILER = mkDocGenHtmlM
FROMXML_OPTS     = %IconsPath% -icharset %CHARSET% -ixml %XML% -ipath %IPATH% -opath %OPATH% -imod $(MODNAME) -ibrandext %BRANDEXT% -ibrand %BRAND% -iprod %PRODUCT% %AUTO% 
#
FROMXML_COMMAND = $(FROMXML_COMPILER) $(FROMXML_OPTS)
#

#
#DGM_VERSION = 1.0
#

