#
# Specifications for Build step mkBSHeaderList
#
METACLASS_NAME = HeaderList
#
DGM_GRAPH_PATH = FWDGM_GRAPHPATH
#
INTERFACES_LIST = ProtectedInterfaces PublicInterfaces PrivateInterfaces
#
ProtectedInterfaces = "$(FWPATH)/ProtectedInterfaces" "$(FWPATH)/ProtectedGenerated/$(MkmkOS_Buildtime)"	#$(IProtected_SUBDIR)
PublicInterfaces = "$(FWPATH)/PublicInterfaces" "$(FWPATH)/PublicGenerated/$(MkmkOS_Buildtime)"				#$(IPublic_SUBDIR)
PrivateInterfaces = "$(FWPATH)/PrivateInterfaces" "$(FWPATH)/PrivateGenerated/$(MkmkOS_Buildtime)"			#$(IPrivate_SUBDIR)
#
DGM_VERSION = 1.0
#
