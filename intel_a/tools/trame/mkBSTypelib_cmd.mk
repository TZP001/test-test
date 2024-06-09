#
# Specifications for Build step mkBStypelib
#
include mkBSIdl_cmd.mk
#
FORCE_TYPELIB = $(MKMK_FORCE_TYPELIB)
#
TPLIB_CPL = $(IDL_CPL)
TPLIB_CREATEDFILE = $(TPLIB_CPL).createdfiles
#
TPLIB_PIA_SNK = SpecialAPI/ProtectedInterfaces/pia.snk
TPLIB_BUILD_REVISION = $(MKMK_MAJORVERSION).$(MKMK_MINORVERSION).$(MKMK_BUILDNUMBER)
#
TPLIB_LINKWITH = $(REAL_LINK_WITH)
TPLIB_SNKEY = $(TPLIB_SNKEY_FULLPATH)
TPLIB_SNKEY_OPTS = -keyfile "$(TPLIB_SNKEY)"
#
TPLIB_OPTS = $(LOCAL_IDLFLAGS) -filetype typelib $(IDL_MKIDOPT) $(TPLIB_LINKWITH:+"-link") $(TPLIB_LINKWITH)
#
TPLIB_COMMAND = $(TPLIB_CPL) -version $(TPLIB_BUILD_REVISION) $(TPLIB_SNKEY:+TPLIB_SNKEY_OPTS) $(TPLIB_OPTS) 
#
DGM_DEPEND = TPLIB_OPTS PPROC_OPTS MKMK_MAJORVERSION MKMK_MINORVERSION FORCE_TYPELIB $(TPLIB_SNKEY:+"TPLIB_PIA_SNK")
DGM_VERSION = 1.1
#
