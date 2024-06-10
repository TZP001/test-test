<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
	<head>
	<title>LMSFddDisplayConfiguration</title>
	</head>
  <body>
    <h2>Display Configuration</h2>
		<hr/>
		<xsl:apply-templates/>
		<xsl:call-template name="DofUsageExpansion"/>
   </body>
   </html>
</xsl:template>

<xsl:template match="LMSFddGraphDescriptor">
	<img>
		<xsl:attribute name="src">
			<xsl:value-of select="@src"/>
		</xsl:attribute>  
	</img><br/>
	<b>Graph type: </b><xsl:value-of select="@id"/><br/>
  <b>Space type: </b><xsl:value-of select="@space"/><br/>
  <b>Number of graphareas: </b><xsl:value-of select="count(LMSFddGraphAreaDescriptor)"/><br/>
	<xsl:for-each select="LMSFddGraphAreaDescriptor">
    <ul>
      <b>Graph area: </b><xsl:value-of select="@id"/>
		  <xsl:call-template name="SPSTemplate">
			  <xsl:with-param name="mySpace" select="../@space"/>
			  <xsl:with-param name="mySPS" select="@sps"/>
		  </xsl:call-template>
    </ul>
	</xsl:for-each>
	<b>Cursors: </b>
	<xsl:call-template name="parse1String">
	  <xsl:with-param name="list1" select="@supportedcursors"/>
	</xsl:call-template>
  
	<hr/>
</xsl:template>


<xsl:template name="SPSTemplate">
	<xsl:param name="mySpace" select="'Not Available'"/>
  <xsl:param name="mySPS" select="'Not Available'"/>
	<xsl:for-each select="//LMSFddDisplayConfiguration/LMSFddSPSDescriptor[@id=$mySPS]">
    <ul>
		<xsl:for-each select="LMSFddDDToGraphAxisMap[@space=$mySpace]">
			<b>Orientation: </b><xsl:value-of select="@id"/>
			<ul>
			<xsl:call-template name="parseGraphAxes">
				<xsl:with-param name="axeslist" select="../@graphaxes"/>
				<xsl:with-param name="dofslist" select="@dd"/>
			</xsl:call-template>
			</ul>
		</xsl:for-each>
    </ul>
  </xsl:for-each>
</xsl:template>

<xsl:template name="parseGraphAxes">
  <xsl:param name="axeslist" select="'Not Available'"/>
  <xsl:param name="dofslist" select="'Not Available'"/>
  <xsl:if test="not($axeslist='')">
	<li>
    <xsl:choose>
			<xsl:when test="contains($axeslist, ' ')">
				<b>Axis: </b><xsl:value-of select="substring-before($axeslist, ' ')"/>
				<b>, Dof: </b><xsl:value-of select="substring-before($dofslist, ' ')"/>
        <ul>
				<xsl:call-template name="DofUsageTemplate">
					<xsl:with-param name="dof" select="substring-before($dofslist, ' ')"/>
				</xsl:call-template>
        </ul>
				
			</xsl:when>
			<xsl:otherwise>
				<b>Axis: </b><xsl:value-of select="$axeslist"/>
				<b>, Dof: </b><xsl:value-of select="$dofslist"/>
        <ul>
				<xsl:call-template name="DofUsageTemplate">
					<xsl:with-param name="dof" select="$dofslist"/>
				</xsl:call-template>
        </ul>
				
			</xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="parseGraphAxes">
      <xsl:with-param name="axeslist">
        <xsl:value-of select="substring-after($axeslist, ' ')"/>
      </xsl:with-param>
      <xsl:with-param name="dofslist">
        <xsl:value-of select="substring-after($dofslist, ' ')"/>
      </xsl:with-param>
    </xsl:call-template>
	</li>
  </xsl:if>
</xsl:template>


<xsl:template name="parse1String">
  <xsl:param name="list1" select="'Not Available'"/>
  <xsl:if test="not($list1='')">
    <xsl:choose>
			<xsl:when test="contains($list1, ' ')">
				<xsl:value-of select="substring-before($list1, ' ')"/>
				, 
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$list1"/>
				, 
			</xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="parse1String">
      <xsl:with-param name="list1">
        <xsl:value-of select="substring-after($list1, ' ')"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="DofUsageTemplate">
	<xsl:param name="dof" select="'Not Available'"/>
	<xsl:for-each select="//LMSFddDisplayConfiguration/LMSFddSpaceDescriptor/LMSFddDofDescriptor[@id=$dof]">
		<xsl:for-each select="LMSFddOptionDependentDofUsage">
    <li>
			<b>DofUsage for option <xsl:number value="position()" format="1"/></b> (<xsl:value-of select="@spaceoption"/>): 
			<a>
				<xsl:attribute name="href">
				 #<xsl:value-of select="@dofusage"/>
				</xsl:attribute>
				<xsl:value-of select="@dofusage"/>
			</a>
      </li>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<xsl:template name="DofUsageExpansion">
  <h2>Dof Usages:</h2>
  <xsl:for-each select="//LMSFddDisplayConfiguration/LMSFddDofUsageDescriptor">
	  <a>
		  <xsl:attribute name="name">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:value-of select="@id"/>
		</a>
		<br/>
		<ul>
		<li>
		  <b>Limits: </b>
			<xsl:call-template name="parse1String">
				<xsl:with-param name="list1" select="@limits"/>
			</xsl:call-template>
		</li>
		<li>
		<b>Formats: </b>
		<xsl:call-template name="DofTypeTemplate">
			<xsl:with-param name="doftype" select="@doftype"/>
		</xsl:call-template>
		</li>
		</ul>
	</xsl:for-each>
  <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
</xsl:template>

<xsl:template name="DofTypeTemplate">
	<xsl:param name="doftype" select="'Not Available'"/>
	<xsl:for-each select="//LMSFddDisplayConfiguration/LMSFddDofTypeDescriptor[@id=$doftype]">
		<xsl:for-each select="LMSFddFormatDescriptor">
			<xsl:value-of select="@id"/>
			, 
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
