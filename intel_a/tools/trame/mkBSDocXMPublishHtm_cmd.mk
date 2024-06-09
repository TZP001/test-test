#
# Specifications for Build step Publication 
#
# ---------------------
#
DOT_COMPILER = $(JAVA_HOME)/bin/java 
#
DOT_TRANSTYPE = xhtml3ds
#
DOT_DOST = $(DITA_OT_DIR)/lib/dostdelta3ds.jar
DOT_XSL  = $(DITA_OT_DIR)/xsl/xslhtml/3ds-d.xsl
#
DOT_JAR = 	-jar "$(DOT_DOST)" 

DOT_OPTS = 	/ditadir:"$(DITA_OT_DIR)" \
		/i:"%ROOTMAP%" \
		/xsl:"$(DITA_OT_DIR)/xsl/dita2xhtml_template_3dsdelta.xsl" \
		/ditaext:xml \
		/transtype:$(DOT_TRANSTYPE) \
		/outdir:"%OUTDIR%" \
		/indexshow:no \
		/artlbl:no \
		/draft:no \
		/OUTEXT:htm \
		/logdir:%LOGDIR% \
		/tempdir:%TEMPDIR% \
		/basedir:"%BASEDIR%" \
		/cleantemp:no \ 
 		/filter:"%DITAVAL%"

#
DOT_COMMAND = $(DOT_COMPILER) $(DOT_JAR) $(DOT_OPTS)
DOT_ODT_COMMAND = mkSimulDitaOpenToolkit
#
