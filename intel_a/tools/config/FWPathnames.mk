#
MKMKOSVAR = $(MkmkOS_Buildtime)
OBJECT_OSVAR = Objects/$(MKMKOSVAR)
#
IDCARDDIR = IdentityCard # pour makefile CI
IDCARD_PATH = $(FWPATH)/$(IDCARDDIR)
IDCARD_PATH_OS = $(IDCARD_PATH)/$(OBJECT_OSVAR)
IDCARD_SCRNAME = $(FWNAME)IC.script
#
PREQLIST_EXTEND = IC.required
PREQLIST_NAME = $(FWNAME)$(PREQLIST_EXTEND)
#
VARIOUS_PATH = $(FWPATH)/various/$(MKMKOSVAR)
DOC_VARIOUS_PATH = $(FWPATH)/various/$(MkmkOS_DOC)
#
IPrivate = $(FWPATH)/PrivateInterfaces
GPrivate = $(FWPATH)/PrivateGenerated/$(MKMKOSVAR)
IProtected = $(FWPATH)/ProtectedInterfaces
GProtected = $(FWPATH)/ProtectedGenerated/$(MKMKOSVAR)
IPublic = $(FWPATH)/PublicInterfaces
GPublic = $(FWPATH)/PublicGenerated/$(MKMKOSVAR)
#
V4Adaptors = $(FWPATH)/V4Adaptors
GV4 = $(FWPATH)/V4Generated/$(MKMKOSVAR)
#
FWmkdata = $(IDCARD_PATH_OS)/.mkdata.mkb
FWmkHLpath = $(IDCARD_PATH_OS)/.mkHLpath.mk
FWRTViewData = $(VARIOUS_PATH)/framework.data
#
HLIST_PATH = $(VARIOUS_PATH)/HList
FWLIST_PATH = $(VARIOUS_PATH)
# POUR Documentation JAVA
DOCHTML = $(FWPATH)/DocGenerated.html
#
