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
	<xsl:for-each select="freetitle">
	   <h3>
	   <xsl:value-of select="@text"/>
	   </h3><br/>
	</xsl:for-each>
	<img>
		<xsl:attribute name="src">
			<xsl:value-of select="@src"/>
		</xsl:attribute>  
		<xsl:attribute name="style">
			border: 1px solid;
		</xsl:attribute>
	</img><br/>
	<xsl:for-each select="legend">
	  <table border = "1">
	    <tr bgcolor="#cccccc">
		    <th>Plot</th>
			<xsl:call-template name="parseListToTableHeader">
				<xsl:with-param name="somelist" select="@attributes"/>
			</xsl:call-template>
		</tr>
		<xsl:for-each select="legendplot">
			<tr>
			    <td align="center">
				<xsl:attribute name="style">
				  <xsl:value-of select="@color"/>
				</xsl:attribute>
				  -
				</td>
				<xsl:call-template name = "parseListToTableData">
					<xsl:with-param name="datalist" select="@values"/>
				</xsl:call-template>
			</tr>
		</xsl:for-each>
	  </table>
	</xsl:for-each>
</xsl:template>

<xsl:template name="parseListToTableHeader">
  <xsl:param name="somelist" select="'Not Available'"/>
  <xsl:if test="not($somelist='')">
    <xsl:choose>
			<xsl:when test="contains($somelist, ' ')">
			  <th align="left">
				<xsl:value-of select="substring-before($somelist, ' ')"/>
			  </th>
			</xsl:when>
			<xsl:otherwise>
			  <th align="left">
				<xsl:value-of select="$somelist"/>
			  </th>
			</xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="parseListToTableHeader">
      <xsl:with-param name="somelist">
		<th align="left">
          <xsl:value-of select="substring-after($somelist, ' ')"/>
		</th>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="parseListToTableData">
  <xsl:param name="datalist" select="'Not Available'"/>
  <xsl:if test="not($datalist='')">
    <xsl:choose>
			<xsl:when test="contains($datalist, ' ')">
			  <td align="left">
				<xsl:value-of select="substring-before($datalist, ' ')"/>
			  </td>
			</xsl:when>
			<xsl:otherwise>
			  <td align="left">
				<xsl:value-of select="$datalist"/>
			  </td>
			</xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="parseListToTableData">
      <xsl:with-param name="datalist">
		<td align="left">
          <xsl:value-of select="substring-after($datalist, ' ')"/>
		</td>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>
