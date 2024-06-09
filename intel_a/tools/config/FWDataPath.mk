##############################################################
#
# Pathname which start from the framework's pathname
#
#############################################################
#
MKMKOSBT = $(MkmkOS_Buildtime)
#
IDCARD_PATH = IdentityCard
IDCARD_OBJPATH = $(IDCARD_PATH)/Objects/$(MKMKOSBT)
VARIOUS_PATH = various/$(MKMKOSBT)
VIEWPATH_DOC = various/$(MkmkOS_DOC)
IMPORTED_PATH = ImportedInterfaces/$(MKMKOSBT)
#
BSCMAKE_OBJPATH = $(IDCARD_OBJPATH)
FW_MKDATA_PATH = $(IDCARD_OBJPATH)/.mkdata.mkb
FW_RTVIEWDATA = $(VARIOUS_PATH)/framework.data
FWmksbrlist = $(IDCARD_OBJPATH)/.mksbrlist.o
HEADERLIST_PATH = $(VARIOUS_PATH)/HList
HEADERSTUB_MAP = $(IMPORTED_PATH)/.HeaderTable.map
HEADERSTUB_FILE = $(IDCARD_OBJPATH)/.HeaderTable.file
HEADERDIR_LIST = $(IMPORTED_PATH)/HeaderDir.txt
#
FWDGM_GRAPHPATH = $(IDCARD_OBJPATH)
FWCSC_DBPATH = $(IDCARD_OBJPATH)/mkcsc
#
CAAV5LICENSING = mkCAAV5Licensing.cpp
CAAV5LICENSING_PATH = $(IDCARD_OBJPATH)/$(CAAV5LICENSING) # ! Extension must be changed
#
COPYRIGHT = Copyright.cpp
COPYRIGHT_PATH = $(IDCARD_OBJPATH)/$(COPYRIGHT) # ! Extension must be changed
#
VERSIONINFO = mkVersionInfo
VERSIONINFOTRAME = $(VERSIONINFO).trame
VERSIONINFOHEADER = $(VERSIONINFO).header
#
XMLVERSIONINFO = mkXmlVersionInfo
XMLVERSIONINFOTRAME_RC = $(XMLVERSIONINFO).trame_vi_rc
XMLVERSIONINFOTRAME_H = $(XMLVERSIONINFO).trame_vi_h
XMLASSEMBLYINFO = mkXmlAssemblyInfo
XMLASSEMBLYINFOTRAME_CS = $(XMLASSEMBLYINFO).trame_ai_cs
XMLASSEMBLYINFOTRAME_CPP = $(XMLASSEMBLYINFO).trame_ai_cpp
XMLASSEMBLYINFOTRAME_JSL = $(XMLASSEMBLYINFO).trame_ai_jsl
XMLASSEMBLYINFOTRAME_VB = $(XMLASSEMBLYINFO).trame_ai_vb
XMLASSEMBLYINFOTRAME_H_CS = $(XMLASSEMBLYINFO).trame_ai_h_cs
XMLASSEMBLYINFOTRAME_H_JSL = $(XMLASSEMBLYINFO).trame_ai_h_jsl
XMLASSEMBLYINFOTRAME_H_VB = $(XMLASSEMBLYINFO).trame_ai_h_vb
XMLPOLICY = mkXmlPolicy
XMLPOLICY_CONFIG = $(XMLPOLICY).trame_p_config
XMLPOLICY_OPTION = $(XMLPOLICY).trame_p_option
XMLMANIFEST = mkXmlManifest
XMLMANIFESTTRAME_MF = $(XMLMANIFEST).trame_mf
#
XREFDB_PATH = $(IDCARD_OBJPATH)/XrefDB
XREFDB_NAME = $(XREFDB_PATH)/Dependencies.mkXDB
XREFDGM_GRAPHPATH = $(XREFDB_PATH)
#
# POUR Documentation JAVA
DOCHTML = DocGenerated.html
#
CORBA_VARIOUS_JAVA = various/$(MKMKOSBT)
#
IPrivate = PrivateInterfaces
GPrivate = PrivateGenerated/$(MKMKOSBT)
IProtected = ProtectedInterfaces
GProtected = ProtectedGenerated/$(MKMKOSBT)
IPublic = PublicInterfaces
GPublic = PublicGenerated/$(MKMKOSBT)
#
V4Adaptors = V4Adaptors
GV4 = V4Generated/$(MKMKOSBT)
#
FW_ROOT_PATH = /
#
