#
# Specifications for Build step mkBSCSCSource
#
include mkBSCompil_cmd.mk
#
CSC_SOURCE_SEARCH_PATH = $(ILocal) $(SRCPATH)
#

CSC_DERIVED_EXTENSION = .csc.xml
CSC_DEFAULT_DERIVED_PATH = $(OBJPATH)/csc

CSC_ILOCAL_PATH = ILocal
CSC_SRC_PATH = SRCPATH

src = $(OBJPATH)/csc
LocalInterfaces = $(GLocal)/csc
PublicInterfaces = $(GPublic)/csc
ProtectedInterfaces = $(GPublic)/csc
PrivateInterfaces = $(GPublic)/csc


CSC_DEPEND_ON = CSC_VERSION 
CSC_VERSION = $(mkcsVERSION)

CSC_SETTINGS_LIST = CSC_SETTINGS_FILE_CHECK
CSC_SETTINGS_FILE_CHECK = $(mkcsROOT_PATH)/resources/mkCheckSource/Settings_Check.xml
#CSC_SETTINGS_FILE_CHECK = $(CSC_ROOT_PATH)/resources/mkCheckSource/settings/settings.csc.xml

CSC_FILTER_LIST = CSC_FILTER_FILE_STD
CSC_FILTER_FILE_STD = $(mkcsROOT_PATH)/resources/mkCheckSource/Filter.xml
# CSC_FILTER_FILE_STD = $(CSC_ROOT_PATH)/resources/mkCheckSource/filers/filters.csc.xml

CSC_CHECK_LIST = CSC_CHECK_FILE_STD
CSC_CHECK_FILE_STD = $(mkcsROOT_PATH)/resources/mkCheckSource/Settings_Check.xml
# CSC_CHECK_FILE_STD = $(CSC_ROOT_PATH)/resources/mkCheckSource/checklist.csc.xml


CSC_COMPILER = mkCheckSource_in_mkmk

CSC_INCLUDE = $(CPP_INCLUDE)
#
CSC_OPTS = $(LOCAL_CSCFLAGS) $(CPP_OPTS) $(LOCAL_POST_CSCFLAGS)
#
CSC_COMMAND = $(CSC_COMPILER) $(CSC_OPTS) $(CSC_INCLUDE) $(MOTIF_INCPATH) -csc_output %OBJECT% %SOURCE%
#---------------------
#
#
DGM_VERSION = 1.0
#

