<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Edited with XML Spy v4.2 -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="Manikin"><xsl:value-of select="/Settings/Selections/Manikin"/></xsl:variable>
<xsl:variable name="Simulation"><xsl:value-of select="/Settings/Selections/Simulation"/></xsl:variable>
<xsl:variable name="Analysis"><xsl:value-of select="/Settings/Selections/Analysis"/></xsl:variable>
<xsl:variable name="SScore"><xsl:value-of select="/Settings/Selections/Score"/></xsl:variable>
<xsl:variable name="Pixels">4</xsl:variable>
<xsl:variable name="Width">50</xsl:variable>
<xsl:variable name="Height"><xsl:value-of select="/Settings/Dimensions/Size/Y"/></xsl:variable>
<xsl:variable name="XPos">30</xsl:variable>
<xsl:variable name="YPos"><xsl:value-of select="/Settings/Dimensions/Position/Y+17"/></xsl:variable>
<xsl:template match="/">
<svg preserveAspectRatio="xMidYMid meet">
	<xsl:element name="text">
		<xsl:attribute name="x"><xsl:value-of select="$XPos - 15"/></xsl:attribute>
		<xsl:attribute name="y">160</xsl:attribute>
		<xsl:attribute name="glyph-orientation-horizontal">0</xsl:attribute>
		<xsl:attribute name="style">fill:rgb(0,0,0);font-size:15;font-family:arial;font-style:normal;font-weight:normal</xsl:attribute>
		<xsl:attribute name="transform">
			<xsl:text>rotate(90,</xsl:text>
			<xsl:value-of select="$XPos - 15"/>
			<xsl:text>,160)</xsl:text>
		</xsl:attribute>
		<xsl:text>Score</xsl:text>
	</xsl:element>
	
	<!--Part red-orange-yellow-green -->	
	<xsl:variable name="Offset"><xsl:value-of select="-15"/></xsl:variable>
	<xsl:call-template name="Parts">
		<xsl:with-param name="Ty"><xsl:value-of select="$Offset"/></xsl:with-param>
		<xsl:with-param name="Color">254,0,0</xsl:with-param>
		<xsl:with-param name="PartHeight"><xsl:value-of select="(4 * $Height div 11)"/></xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="Parts">
		<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (4 * $Height div 11)"/></xsl:with-param>
		<xsl:with-param name="Color">254,140,0</xsl:with-param>
		<xsl:with-param name="PartHeight"><xsl:value-of select="(2*$Height div 11)"/></xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="Parts">
		<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (6 * $Height div 11)"/></xsl:with-param>
		<xsl:with-param name="Color">254,254,0</xsl:with-param>
		<xsl:with-param name="PartHeight"><xsl:value-of select="(2*$Height div 11)"/></xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="Parts">
		<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (8 * $Height div 11)"/></xsl:with-param>
		<xsl:with-param name="Color">34,139,34</xsl:with-param>
		<xsl:with-param name="PartHeight"><xsl:value-of select="(3*$Height div 11)"/></xsl:with-param>
	</xsl:call-template>
    
    <!--Zone -->
	<xsl:if test="(/Settings/Visibility/Grid/Y != 'false')">
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (1 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (2 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (3 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (4 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (5 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (6 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (7 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (8 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (9 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="Zone">
			<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (10 * $Height div 11)"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
    
    <!--Score Scale -->
	<xsl:if test="(/Settings/Visibility/Axis/Y != 'false')">
		<xsl:for-each select="/Settings/Axis/YAxis[@Name=$SScore]/Y">
			<xsl:if test="(./@Score != 'Bads')">
			<xsl:element name="text">
				<xsl:attribute name="x"><xsl:value-of select="$XPos + 5"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$Offset +($YPos + $Height) - (((.) * ($Height div 11)) + ($Pixels))"/></xsl:attribute>
				<xsl:attribute name="style">fill:rgb(0,0,0);font-size:18</xsl:attribute>
				<xsl:value-of select="./@Score"/>
			</xsl:element>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
</svg>
</xsl:template>

<xsl:template name="Zone">
	<xsl:param name="Ty"/>
	<xsl:element name="line">
		<xsl:attribute name="x1"><xsl:value-of select="$XPos"/></xsl:attribute>
		<xsl:attribute name="y1"><xsl:value-of select="$YPos"/></xsl:attribute>
		<xsl:attribute name="x2"><xsl:value-of select="$XPos + $Width"/></xsl:attribute>
		<xsl:attribute name="y2"><xsl:value-of select="$YPos"/></xsl:attribute>
		<xsl:attribute name="style">stroke:rgb(0,0,0);stroke-width:0.2;stroke-dasharray:0.5,0.5</xsl:attribute>
		<xsl:attribute name="transform">
			<xsl:text>translate(0,</xsl:text>
			<xsl:value-of select="$Ty"/>
			<xsl:text>)</xsl:text>
		</xsl:attribute>	
	</xsl:element>	
</xsl:template>

<xsl:template name="Parts">
	<xsl:param name="Ty"/>
    <xsl:param name="Color"/>
    <xsl:param name="PartHeight"/>
    <xsl:element name="rect">
		<xsl:attribute name="x"><xsl:value-of select="$XPos"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="$YPos + $Ty"/></xsl:attribute>
		<xsl:attribute name="width">50</xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="$PartHeight"/></xsl:attribute>
		<xsl:attribute name="style">
			<xsl:text>stroke-width:0.5;stroke:rgb(0,0,0);fill:rgb(</xsl:text>
			<xsl:value-of select="$Color"/>
			<xsl:text>)</xsl:text>
		</xsl:attribute>
	</xsl:element>	
</xsl:template>
</xsl:stylesheet>

