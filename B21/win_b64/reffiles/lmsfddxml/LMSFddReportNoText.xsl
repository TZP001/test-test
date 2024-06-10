<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="report">
  <html>
	<head>
	<title><xsl:value-of select="@name"/></title>
	</head>
  <body>
    <h2><xsl:value-of select="@name"/></h2>
		<xsl:apply-templates/>
   </body>
   </html>
</xsl:template>

<xsl:template match="display">
	<img>
		<xsl:attribute name="src">
			<xsl:value-of select="@src"/>
		</xsl:attribute>  
		<xsl:attribute name="style">
			border: 1px solid;
		</xsl:attribute>
	</img><br/>
</xsl:template>

</xsl:stylesheet>
