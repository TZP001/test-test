#
# Declaration for sign tools
#
# ---------------------
#
MKSIGNMS_TOOL = mkSignMSM
# Timeout set to 5min (300s)
MKSIGNMS_COMMAND_TIMEOUT = 300
#
# The PRE-production certificate and its password to use if EV DSCertificate does not exist
MKSIGNMS_PREPROD_CERTIFICATE = DSpreprod.pfx
MKSIGNMS_PREPROD_PASSWORD = $(DSCertificatePassword:-"ds")
#
# if EV DSCertificate exists then activate the PRODUCTION certificate WITH timestamp
MKSIGNMS_TIMESTAMP_OPTS = -timestamp "http://timestamp.verisign.com/scripts/timstamp.dll" -retry $(DSCertificateRetryCount:-"5")
MKSIGNMS_OPTS = $(DSCertificate:+MKSIGNMS_TIMESTAMP_OPTS)
#
MKSIGNMS_COMMAND = "$(MKSIGNMS_TOOL)" $(MKSIGNMS_OPTS) -file "$(_SIGN_OBJNAME)"
#
