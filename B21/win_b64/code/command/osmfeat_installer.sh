#!/bin/ksh
# install osm feat compiler
OS=$MkmkOS_Runtime
debug=debug
case $OS in
  intel_*) OTHER=x:/BSF$debug TGT=e:/ws/osmfeat/$OS;;
  *) OTHER=/u/lego/CXR16rel/BSF TGT=$HOME/ws/osmfeat/$MkmkOS_Runtime ;;
esac
TGT=${OSMFEATROOT_PATH:-$TGT}
FROM=$ADL_IMAGE_DIR
set -x
cd $FROM
rm -rf "$TGT"
mkrtv -W $FROM  -t $TGT -FW ObjectSpecsModeler
#w:ajax/CXR15rel
mkrtv -W $OTHER -t $TGT -FW System ObjectModelerBase ObjectModelerInterfaces CATVirtualVaultSystem CATPLMDictionary XMLParser ObjectModelerCATIA CATPDMBaseInterfaces CATDataCompatibilityInfra CATIADataBasics SpecialAPI ObjectModelerCATSDM Administration CATV4DataAdmin CATV4System

