import sys , traceback
from java.lang import *

def wsadminToList(inStr):
	outList=[]
	if (len(inStr)>0 and inStr[0]=='[' and inStr[-1]==']'):
		tmpList = inStr[1:-1].split(" ")
	else:
		tmpList = inStr.split("\n")  #splits for Windows or Linux
	for item in tmpList:
		item = item.rstrip();        #removes any Windows "\r"
		if (len(item)>0):
			outList.append(item)
	return outList
#endDef

def wsadminAttrsToList(inStr):
	outList=[]
	tmpList = inStr.split("\n")  #splits for Windows or Linux
	for item in tmpList:
		item = item.rstrip();        #removes any Windows "\r"
		if (len(item)>0):
			outList.append(item)
	return outList
#endDef

def removeAllEnovia (appname, cell, node, server):
	global AdminApp
	global AdminConfig

# look for installedApps, if application name is the current beeing installed, remove it
# if application name starts with "ENOVIA_" and is deployed on the same server, remove it
	apps = wsadminToList(AdminApp.list())
	for app in apps:
		print "Application found "+app
		if appname == app :
			print "Remove old "+app
			AdminApp.uninstall(app, "-cell "+cell+" -node "+node)
		else:
			if app.startswith("ENOVIA_") :
				deployments = AdminConfig.getid("/Deployment:"+app+"/")
				deploymentTargets = AdminConfig.showAttribute(deployments, "deploymentTargets")
				for dt in wsadminToList(deploymentTargets) :
					if dt.startswith(server+"(") :
						print "Remove ENOVIA Application on "+server+" "+app
						AdminApp.uninstall(app, "-cell "+cell+" -node "+node)
						break

	pattern = "JDBCDriver(cells/"+cell+"/nodes/"+node+"/servers/"+server
# remove all enovia jdbcdrivers installed on the same server
	jdbcs = AdminConfig.list("JDBCProvider")
	for jdbc in wsadminToList(jdbcs) :
		print "JDBCProvider found "+jdbc
		if jdbc.startswith("ENOVIA_") and jdbc.find(pattern) :
  			print "Removing Enovia JDBCProvider: "+jdbc
  			AdminConfig.remove(jdbc)
	print "Saving configuration..."
	AdminConfig.save()
#endDef

def removeWASVariable(cell, node, varName):
	global AdminConfig
	
	print "Trying to remove old variable "+varName+" ..."

	variable_list = AdminConfig.list("VariableSubstitutionEntry")

	for variable in wsadminToList(variable_list):
		entry = AdminConfig.show(variable)
		if entry.find("symbolicName "+varName) != -1 :		
			print "Symbolic Name is matched. Deleting entry "+variable+" ..."
			AdminConfig.remove(variable)

	print "Saving configuration..."
	AdminConfig.save()
#endDef

def setWASVariable (cell, node, varName, varValue, desc):
	global AdminConfig
	
	print "Setting "+varName+" variable to "+varValue+" ..."

	attrs = "[[entries [[[description \""+desc+"\"] [symbolicName "+varName+"] [value \""+varValue+"\"]]]]]"

	varMap = AdminConfig.getid("/Cell:"+cell+"/Node:"+node+"/VariableMap:/")

	AdminConfig.modify(varMap, attrs)

	print "Saving configuration..."
	AdminConfig.save()
#endDef

def setupJAAS (cell, node, aliasName, aliasDescription, defaultUser, defaultPassword):
	global AdminConfig
	
	aliases = AdminConfig.list("JAASAuthData")
	for al in wsadminToList(aliases):
		thisAlias = AdminConfig.show(al, "[alias]")
		if wsadminToList(thisAlias)[1] == aliasName:
			print "Removing old JAAS Auth Alias: "+thisAlias
			AdminConfig.remove(al)
			AdminConfig.save()
	print "Creating JAASAuthData - "+aliasName 
	
	alias_attr = ["alias",aliasName]
	desc_attr =  ["description",aliasDescription]
	userid_attr = ["userId",defaultUser]
	password_attr = ["password",defaultPassword]
	attrs = [alias_attr,desc_attr,userid_attr,password_attr]
	security = AdminConfig.list("Security")
	AdminConfig.create("JAASAuthData", security, attrs)
	
	print "Saving JAASAuthData... " 
	AdminConfig.save()
#endDef

def getJDBCTemplate (templName):
	global AdminConfig
	print "Retrieving JDBC template "+templName+" ..."
	
	nameProperty = "[name \""+templName+"\"]"
	templates = AdminConfig.listTemplates("JDBCProvider", templName)
	for template in wsadminToList(templates):
		value = AdminConfig.show(template)
		for attr in wsadminAttrsToList(value):
			if attr.find(nameProperty) != -1:
				return template
#endDef

def setupJDBCDriver (jdbcName, cell, node, server, template):
	global AdminConfig
	print "Remove any old jdbc providers by this name..."
	jps = AdminConfig.getid("/JDBCProvider:"+jdbcName+"/")
	for jpID in wsadminToList(jps):
		print "Removing old entry: "+jpID
		AdminConfig.remove(jpID)
		AdminConfig.save()
	
	print "Creating JDBC driver "+jdbcName+" ..."
	attrs = [["name",jdbcName]]
	serverid = AdminConfig.getid("/Cell:"+cell+"/Node:"+node+"/Server:"+server+"/")
	driver = AdminConfig.createUsingTemplate("JDBCProvider", serverid, attrs, template)
	AdminConfig.save()
	return driver
#endDef

def setupDataSource (cell,node,server,jdbcProviderName,dataSourceName,paramNames,paramValues,jndiName,J2C_aliasName,statementCacheSize):
	global AdminConfig
	
	print "Removing the WAS40DataSource object created via the template"
	try:
		was40ds = AdminConfig.getid("/JDBCProvider:"+jdbcProviderName+"/WAS40DataSource:/")
		AdminConfig.remove(was40ds)
		AdminConfig.save()
	except:
		print "Cannot remove the WAS40DataSource"
	
	print "Modifying the datasource object -- name, jndiName"
	datasource = AdminConfig.getid("/JDBCProvider:"+jdbcProviderName+"/DataSource:/")
	
	name_attr = ["name",dataSourceName]
	jndi_attr = ["jndiName",jndiName]
	stmt_attr = ["statementCacheSize",statementCacheSize]
	autm_attr = ["authMechanismPreference","BASIC_PASSWORD"]
	autd_attr = ["authDataAlias",J2C_aliasName]
	attrs  = [name_attr,jndi_attr,stmt_attr,autm_attr,autd_attr]
	AdminConfig.modify(datasource,attrs)
	AdminConfig.save()
	
	print "Retrieving all properties from the template and modify them according to database settings."
	properties = AdminConfig.showAttribute(datasource,"propertySet")
	properties = AdminConfig.show(properties)
	index = properties.index(" ")
	properties = properties[index+2:-2]
	ppties = properties.split(" ")
	for ppty in ppties:
		index = ppty.index("(")
		pptyName = ppty[:index]
		pptyValue = ppty[index:]
		for i in range(len(paramNames)):
			if pptyName == paramNames[i]:
				AdminConfig.modify(pptyValue, [["value", paramValues[i]]])

		
	#Set the auth mapping properties
	AdminConfig.create("MappingModule", datasource, [["mappingConfigAlias", "DefaultPrincipalMapping"], ["authDataAlias", []]])
	
	scope = AdminConfig.getid("/Cell:"+cell+"/Node:"+node+"/Server:"+server+"/")
	adapters = AdminConfig.list("J2CResourceAdapter",scope)
	adapters = wsadminToList(adapters)
	for adapter in adapters:
		if adapter.find("builtin_rra") != -1 :
			adapter = adapter[1:-1]
			index = adapter.index("(")
			adapter = adapter[index:]
			AdminConfig.modify(datasource, [["relationalResourceAdapter", adapter]])
	
	print "Saving datasource configuration..."
	AdminConfig.save()
#endDef

def removeProperty(cell, node, server, propName):
	global AdminConfig
	
	print "Removing existing Property "+propName+" ..."
	
	pattern = propName+"(cells/"+cell+"/nodes/"+node+"/servers/"+server

	properties = AdminConfig.list("Property")
	properties = wsadminToList(properties)
	
	for property in properties:
		if property.find(pattern) == 0:
			print "Property Name is matched. Deleting "+propName+" ..."
			AdminConfig.remove(property)
	print "Saving datasource configuration..."
	AdminConfig.save()
#endDef

def setupCustomProperty(cell, node, server, varName, varValue):
	global AdminConfig
	
	print "Setting JVM Custom Property "+varName+" to "+varValue+" ..."

	serv = AdminConfig.getid("/Cell:"+cell+"/Node:"+node+"/Server:"+server+"/")
	jvm = AdminConfig.list("JavaVirtualMachine", serv)
	AdminConfig.modify(jvm, "[[systemProperties [[[name "+varName+"] [value \""+varValue+"\"]]]]]")

	print "Saving configuration..."
	AdminConfig.save()
#endDef

def setupProcessDefinition(cell, node, server, varName, varValue):
	global AdminConfig
	
	print "Setting Process Definition environment entry "+varName+" to "+varValue+" ..."

	serv = AdminConfig.getid("/Cell:"+cell+"/Node:"+node+"/Server:"+server+"/")
	processDef = AdminConfig.list("JavaProcessDef", serv)
	AdminConfig.modify(processDef,"[[environment [[[name "+varName+"] [value \""+varValue+"\"]]]]]")

	print "Saving datasource configuration..."
	AdminConfig.save()
#endDef

def installEar(cell, node, server, appname, earpath):
	global AdminApp

	AdminApp.install(earpath, "-appname "+appname+" -cell "+cell+" -server "+server+" -node "+node)

	print "Saving configuration..."
	AdminConfig.save()
#endDef

#Retrieve all parameters from the property file 
cell = System.getProperty("cell")
node = System.getProperty("node")
server = System.getProperty("server")
appname = System.getProperty("applicationName")
jdbcDriverPathName = System.getProperty("jdbcDriverPathName")
jdbcDriverPathValue = System.getProperty("jdbcDriverPathValue")
jdbcDriverPathDesc = System.getProperty("jdbcDriverPathDesc")
JSystemDefaultUser = System.getProperty("JSystemDefaultUser")
JSystemDefaultPassword = System.getProperty("JSystemDefaultPassword")
JSystemAliasName = node + "/" + appname + System.getProperty("JSystemAliasName")
JSystemAliasDescription = System.getProperty("JSystemAliasDescription")
jdbcProviderName = System.getProperty("jdbcProviderName")
jdbcProviderTemplate = System.getProperty("jdbcProviderTemplate")
datasourceName = System.getProperty("datasourceName")
datasourceJndiName = System.getProperty("datasourceJndiName")
datasourceStatementCacheSize = System.getProperty("datasourceStatementCacheSize")

datasourceParams = []
datasourceValues = []
i = 0
while 1 :
	i = i + 1;
	name = System.getProperty("datasourceParam"+str(i))
	value = System.getProperty("datasourceValue"+str(i))
	if name is None :
		break
	datasourceParams.append(name)	
	datasourceValues.append(value)	

envEntryNames = []
envEntryValues = []
i = 0
while 1 :
	i = i + 1;
	name = System.getProperty("envEntryName"+str(i))
	value = System.getProperty("envEntryValue"+str(i))
	if name is None :
		break
	envEntryNames.append(name)	
	envEntryValues.append(value)	

customPropertyNames = []
customPropertyValues = []
i = 0
while 1 :
	i = i + 1;
	name = System.getProperty("customPropertyName"+str(i))
	value = System.getProperty("customPropertyValue"+str(i))
	if name is None :
		break
	customPropertyNames.append(name)	
	customPropertyValues.append(value)	

earpath = System.getProperty("earPath")

#########################################################
#Uninstall all ENOVIA Applications first
#########################################################
try :
	removeAllEnovia(appname, cell, node, server)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in removing existing Enovia applications"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
else :
	print "****** Done removing existing Enovia application"

#########################################################
#Setup Websphere variable for jdbc driver path
#########################################################
try :
	removeWASVariable(cell, node, jdbcDriverPathName)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in removing existing WebSphere Variable"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
else :
	print "****** Done removing existing WebSphere Variable "+jdbcDriverPathName

try :
	setWASVariable(cell, node, jdbcDriverPathName, jdbcDriverPathValue, jdbcDriverPathDesc)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in creating WebSphere Variable"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
else :
	print "****** Done creating WebSphere Variable "+jdbcDriverPathName

#########################################################
#Setup JAAS Login Alias
#########################################################
try :
	setupJAAS(cell, node, JSystemAliasName, JSystemAliasDescription, JSystemDefaultUser, JSystemDefaultPassword)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in creating J2C Alias"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
else :
	print "****** Done creating J2C Alias "+JSystemAliasName+" ******"

#########################################################
#Setup JDBC Driver 
#########################################################
try :
	template = getJDBCTemplate(jdbcProviderTemplate)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in retrieving JDBC Driver Template"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
try :
	provider = setupJDBCDriver(jdbcProviderName, cell, node, server, template)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in creating JDBC Driver"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
else :
	print "****** Done creating JDBC Driver "+jdbcProviderName+" ******"

#########################################################
#Setup JSystem Data Source
#########################################################
try :
	setupDataSource(cell,node,server,jdbcProviderName,datasourceName,datasourceParams,datasourceValues,datasourceJndiName,JSystemAliasName,datasourceStatementCacheSize)
except :
	etype, evalue, etraceback = sys.exc_info()
	print "Exception in creating Data Source"
	print "Error Type: " + str(etype)
	print "Error Value: " + str(evalue)
	print "Traceback: " + str(traceback.extract_tb(etraceback))
	sys.exit(100)
else :
	print "****** Done creating data source "+datasourceName+" ******"

#########################################################
#Setup Process Definition
#########################################################
for i in range(len(envEntryNames)):
	try :
		removeProperty(cell,node,server,envEntryNames[i])
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in removing Process Definition"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done removing Process Definition "+envEntryNames[i]+" ******"

for i in range(len(envEntryNames)):
	try :
		setupProcessDefinition(cell,node,server,envEntryNames[i],envEntryValues[i])
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in configuring Process Definition"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done configuring Process Definition "+envEntryNames[i]+" ******"


#########################################################
#Setup JVM Custom Properties ( not in WebSphere Portal )
#########################################################
if not earpath is None: 
	for i in range(len(customPropertyNames)):
		try :
			removeProperty(cell, node, server, customPropertyNames[i])
		except :
			etype, evalue, etraceback = sys.exc_info()
			print "Exception in removing JVM custom property"
			print "Error Type: " + str(etype)
			print "Error Value: " + str(evalue)
			print "Traceback: " + str(traceback.extract_tb(etraceback))
			sys.exit(100)
		else :
			print "****** Done removing JVM custom property "+customPropertyNames[i]+" ******"

	for i in range(len(customPropertyNames)):
		try :
			setupCustomProperty(cell, node, server, customPropertyNames[i], customPropertyValues[i])
		except :
			etype, evalue, etraceback = sys.exc_info()
			print "Exception in creating JVM custom property"
			print "Error Type: " + str(etype)
			print "Error Value: " + str(evalue)
			print "Traceback: " + str(traceback.extract_tb(etraceback))
			sys.exit(100)
		else :
			print "****** Done creating JVM custom property "+customPropertyNames[i]+" ******"

#########################################################
#Install ear
#########################################################

if not earpath is None: 

	try :
		installEar(cell, node, server, appname, earpath)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in installing ear"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** installing "+earpath+" ******"

#########################################################
#Install WASSetupUI plug-ins specific objects
#########################################################

print "**********************************************************"
print "****** Installing WASSetupUI plug-ins specific data ******"
print "**********************************************************"

plugInEnvCount = int(System.getProperty("PlugInEnvCount"))
for i in range(plugInEnvCount):
	name = System.getProperty("PlugInEnvName"+str(i+1))
	try :
		removeProperty(cell, node, server, name)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in removing Process Definition"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done removing Process Definition "+name+" ******"

for i in range(plugInEnvCount):
	name = System.getProperty("PlugInEnvName"+str(i+1))
	value = System.getProperty("PlugInEnvValue"+str(i+1))
	try :
		setupProcessDefinition(cell, node, server, name, value)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in configuring Process Definition"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done configuring Process Definition "+name+" ******"

plugInJavaCount = int(System.getProperty("PlugInJavaCount"))
for i in range(plugInJavaCount):
	name = System.getProperty("PlugInJavaName"+str(i+1))
	value = System.getProperty("PlugInJavaValue"+str(i+1))
	try :
		setupCustomProperty(cell, node, server, name, value)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in creating JVM custom property"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done creating JVM custom property "+name+" ******"

plugInDSCount = int(System.getProperty("PlugInDSCount"))
for i in range(plugInDSCount):
	plugInDSHost = System.getProperty("PlugInDSHost"+str(i+1))
	plugInDSPort = System.getProperty("PlugInDSPort"+str(i+1))
	plugInDSName = System.getProperty("PlugInDSName"+str(i+1))
	plugInDSUser = System.getProperty("PlugInDSUser"+str(i+1))
	plugInDSPassword = System.getProperty("PlugInDSPassword"+str(i+1))
	plugInDSUrl = System.getProperty("PlugInDSUrl"+str(i+1))
	plugInDSJndi = System.getProperty("PlugInDSJndi"+str(i+1))
	plugInDSProvider = System.getProperty("PlugInDSProvider"+str(i+1))
	alias = node+"/PlugInAlias"+str(i+1)
	descr = "PlugInAlias"+str(i+1)+" JAAS Login"
	try :
		setupJAAS(cell, node, alias, descr, plugInDSUser, plugInDSPassword)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in creating J2C Alias"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done creating J2C Alias "+alias+" ******"
	
	try :
		template = getJDBCTemplate(plugInDSProvider)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in retrieving JDBC Driver Template"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)

	providerName = "PlugInProvider"+str(i+1)
	try :
		provider = setupJDBCDriver(providerName, cell, node, server, template)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in creating JDBC Driver"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "Done creating JDBC Driver "+providerName+" ******"

	dsName = "PlugInDataSource"+str(i+1)
	dsParams = []
	dsValues = []
	if plugInDSProvider.find("Oracle") != -1 :
		dsParams.append("URL")
		dsValues.append(plugInDSUrl)
	else :
		dsParams.append("databaseName")
		dsValues.append(plugInDSName)
		dsParams.append("serverName")
		dsValues.append(plugInDSHost)
		dsParams.append("portNumber")
		dsValues.append(plugInDSPort)
		dsParams.append("driverType")
		dsValues.append("4")
		
	try :
		setupDataSource(cell,node,server,providerName,dsName,dsParams,dsValues,plugInDSJndi,alias,datasourceStatementCacheSize)
	except :
		etype, evalue, etraceback = sys.exc_info()
		print "Exception in creating Data Source"
		print "Error Type: " + str(etype)
		print "Error Value: " + str(evalue)
		print "Traceback: " + str(traceback.extract_tb(etraceback))
		sys.exit(100)
	else :
		print "****** Done creating data source "+dsName+" ******"

#########################################################
#Done
#########################################################
#Note: Do not remove or change following statement: it is needed on Windows to test completion
print "****** Jacl Configuration completed successfully. ******"
sys.exit(0)
