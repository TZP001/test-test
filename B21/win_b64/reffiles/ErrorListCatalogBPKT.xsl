<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <head />
            <body>
		<table width="90%" border="0" cellspacing="2" cellpadding="4">
			<xsl:for-each select="ErrorCheck">
				<xsl:apply-templates select="ErrorLateType"/>
				<xsl:apply-templates select="ErrorName"/>
			</xsl:for-each>
		</table>
			 </body>
        </html>
    </xsl:template>

	<xsl:template match="ErrorName">
		<br />
		<font color="#0000FF">
			<a target="Error" >
				<xsl:value-of select="@Name"/>
			</a>
		</font> 
		<br />
			Error Type:<font color="#990066">Identical Type Name</font> 
		<br />
			<strong> Type Name: </strong>
			<xsl:value-of select="@TypeName" />
		<br />
		<xsl:for-each select="Doc">
			<strong>Document: </strong>
			<xsl:value-of select="@Path" />
			<br />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="ErrorLateType">
		<br />
		<font color="#0000FF">
			<a target="Error">
				<xsl:value-of select="@Name"/>
			</a>
		</font> 
		<br />
			Error Type:<font color="#CC0066">Identical Type Physical Name</font> 
		<br />
		<br />
			<strong>Type Physical Name: </strong>
			<xsl:value-of select="@LateType" />
		<br />
		<xsl:for-each select="Doc">
			<strong>Document: </strong>
			<xsl:value-of select="@Path" />
			<br />
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
