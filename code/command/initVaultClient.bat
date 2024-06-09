@echo off

echo creating c:\tmp if it does not exist ...
mkdir c:\tmp

echo generating .properties file
cp \\janus\CXR11rel\BSF\solaris_a\reffiles\DUP\DB2\VaultServer.properties c:\tmp\VaultServer.tmp
cp \\janus\CXR11rel\BSF\solaris_a\reffiles\DUP\DB2\VaultClient.properties c:\tmp\VaultClient.tmp

sed -e "s?<SettingPath>?/tmp/orbixcfg?g" -e "s?<HostName>?%1?g" -e "s?<PortNumber>?1570?g" -e "s?<SecuredPath>?/tmp/orbixcfg/VaultSecure?g" -e "s?<TmpPath>?/tmp/orbixcfg/VaultTmp?g" c:\tmp\VaultServer.tmp > c:\tmp\VaultServer.properties
sed -e "s?<SettingPath>?/tmp/orbixcfg?g" -e "s?<HostName>?%1?g" -e "s?<PortNumber>?1570?g" -e "s?<SecuredPath>?/tmp/orbixcfg/VaultSecure?g" -e "s?<TmpPath>?/tmp/orbixcfg/VaultTmp?g" c:\tmp\VaultClient.tmp > c:\tmp\VaultClient.properties

set VaultClient_PropertiesFilePath=c:\tmp
set VaultClient_PropertiesFileName=VaultClient.properties
set VaultServer_PropertiesFilePath=c:\tmp
set VaultServer_PropertiesFileName=VaultServer.properties
