#
# Specifications for Build step mkBSGrammarMob
#
METACLASS_NAME = GrammarMob
#
DGM_GRAPH_PATH = MODDGM_GRAPHPATH
#
# DGM_DEPEND = 
#

PRODUCT_TYPE = com.apple.product-type.application
PBXProjVersion = 45
XCodeCompatibility = 3.1

DGM_DEPEND =  PRODUCT_TYPE PBXProjVersion XCodeCompatibility

XCODEBUID_GENPATH = build/Release/$(APPNAME).app/Contents/Resources

DGM_VERSION = 0.1
#
# XCODE TYPE FOR EXTENSION 

XCODE.<default> = sourcecode
XCODE.xib = file.xib
XCODE.plist = text.plist.xml
XCODE.png = image.png
XCODE.gif = image.gif
XCODE.jpg = image.jpg
XCODE.txt = sourcecode.text
#
