########
# Custom variables for Single Sign-On solution
#
# Use by Server Manager shell (runServerManager) 
########

#export CATLoginServletHost=<host the web application server is running on>
#export CATLoginServletPort=<port number the web application server is running on>
#export CATLoginServletURI=<uri path to the login servlet>

### Default values for SSO exit 

export CATLoginCryptLibrary=GW0SecuMgrAccess
export CATLoginCryptFunction=encodeBase64Password
export CATLoginUncryptFunction=decodeBase64Password

