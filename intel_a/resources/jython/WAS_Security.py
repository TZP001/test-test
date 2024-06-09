import sys
from java.lang import *
from com.ibm.ws.security.ltpa import LTPAServerObject
from com.ibm.ws.security.util import PasswordUtil

def modifyLdapRegistry ( ldapUserRegistry, serverType, baseDN, bindDN, bindPassword, ldapHostnPort, serverId, serverPassword ):
	global AdminConfig
	print "*** modify LDAPUserRegistry ***"
	
	parm = [["primaryAdminId", serverId]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["type", serverType]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["baseDN", baseDN]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["bindDN", bindDN]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["bindPassword", bindPassword]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["realm", ldapHostnPort]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["limit", "0"]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["serverId", serverId]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm = [["serverPassword", serverPassword]]
	AdminConfig.modify(ldapUserRegistry, parm )
	parm=[["hosts", []]]
	AdminConfig.modify(ldapUserRegistry, parm )
	fields = ldapHostnPort.split(":" )
	parm=[["hosts", [[["host", fields[0]],["port", fields[1]]]]]]
	AdminConfig.modify(ldapUserRegistry, parm )
#endDef 

def modifyLdapSearchFilter ( ldapSearchFilter, userFilter, groupFilter, serverType ):
	global AdminConfig
	print "*** modify LDAPSearchFilter ***"

	if serverType == "IBM_DIRECTORY_SERVER" :
		userIdMap = "*:uid"
	if serverType == "SECUREWAY" :
		userIdMap = "*:uid"
	if serverType == "IPLANET" :
		userIdMap = "inetOrgPerson:uid"
	if serverType == "DOMINO502" :
		userIdMap = "person:uid"
	if serverType == "ACTIVE_DIRECTORY" :
		userIdMap = "user:sAMAccountName"
	if serverType == "NDS" :
		userIdMap = "person:cn"
	if serverType == "CUSTOM" :
		userIdMap = "*:uid"

	parm = [["userFilter", userFilter], ["groupFilter", groupFilter], ["userIdMap", userIdMap]]
	AdminConfig.modify(ldapSearchFilter, parm )
#endDef 

def modifyLtpa ( ltpa, password, domain ):
	global AdminConfig
	print "*** modify LTPA ***"
	
#	parm = [["password", password]]
#	AdminConfig.modify(ltpa, parm )
	parm = [["singleSignon", [["domainName",domain],["enabled", "true"]]]]
	AdminConfig.modify(ltpa, parm )

#	pwd = password
#	if ( password[0:5] == "{xor}" ) :
#		pwd = PasswordUtil.decode(password)

#	srv = LTPAServerObject()
#	str = String(pwd)
#	bytes = str.getBytes("UTF-8")
#	properties = srv.genKeys(bytes)
#	sharedKey = properties.getProperty("com.ibm.websphere.ltpa.3DESKey")
#	publicKey = properties.getProperty("com.ibm.websphere.ltpa.PublicKey")
#	privateKey = properties.getProperty("com.ibm.websphere.ltpa.PrivateKey")
#	keys = [["private", [["byteArray", privateKey]]], ["public", [["byteArray", publicKey]]], ["shared", [["byteArray", sharedKey]]]]
#	AdminConfig.modify(ltpa, keys )
#endDef 

def modifySecurity ( security, ltpa, ldapUserRegistry ):
	global AdminConfig
	print "*** modify Security ***"

	mechanism = [["activeAuthMechanism", ltpa]]
	AdminConfig.modify(security, mechanism )
	registry = [["activeUserRegistry", ldapUserRegistry]]
	AdminConfig.modify(security, registry )
	enabled = [["enabled", "true"]]
	AdminConfig.modify(security, enabled )
	enforceJava2Security = [["enforceJava2Security", "false"]]
	AdminConfig.modify(security, enforceJava2Security )
#endDef 
global AdminConfig
#########################################################
#Getting parameters
#########################################################
print "****** Getting parameters ******"

baseDN = System.getProperty( "BaseDN" )
bindDN = System.getProperty( "BindDN" )
bindPassword = System.getProperty( "BindPassword" )
serverType = System.getProperty( "LdapServerType" )
ldapHostnPort = System.getProperty( "LdapHostnPort" )
serverId = System.getProperty( "ServerId" )
serverPassword = System.getProperty( "ServerPassword" )
password = System.getProperty( "Password" )
domain = System.getProperty( "Domain" )
cell = System.getProperty( "Cell" )
userFilter = System.getProperty( "UserFilter" )
groupFilter = System.getProperty( "GroupFilter" )

scope = AdminConfig.getid("/Cell:"+cell+"/" )
#########################################################
#modify ldap user registry
#########################################################
ldapUserRegistry = AdminConfig.list("LDAPUserRegistry", scope )
modifyLdapRegistry(ldapUserRegistry, serverType, baseDN, bindDN, bindPassword, ldapHostnPort, serverId, serverPassword )

#########################################################
#modify ldap search filter
#########################################################
ldapSearchFilter = AdminConfig.list("LDAPSearchFilter", scope )
modifyLdapSearchFilter(ldapSearchFilter, userFilter, groupFilter, serverType )

#########################################################
#modify ltpa parameters
#########################################################
ltpa = AdminConfig.list("LTPA", scope )
modifyLtpa(ltpa, password, domain )

#########################################################
#enable global security 
#########################################################
security = AdminConfig.list("Security", scope )
modifySecurity(security, ltpa, ldapUserRegistry )

#########################################################
#save configuration
#########################################################
print "Saving configuration..."
AdminConfig.save( )
#########################################################
#Done
#########################################################
#Note: Do not remove or change following statement: it is needed on Windows to test completion
print "****** Jacl Configuration completed successfully. ******"
sys.exit(0)
