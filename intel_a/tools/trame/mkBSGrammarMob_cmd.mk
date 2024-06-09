# @(#) preprocess
# ----------------------
# Specifications for Build step mkBSGrammarMob
# ----------------------

MACOSXSDK_LEVEL = macosx10.6
XCODEBUILD_CMD = xcodebuild build -sdk $(MACOSXSDK_LEVEL) -nodistribute  -nobonjourbuildhosts
#
DGM_DEPEND =  
#DGM_VERSION = 0.1
#
