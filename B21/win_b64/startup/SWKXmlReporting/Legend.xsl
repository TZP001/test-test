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
<xsl:variable name="Width"><xsl:value-of select="/Settings/Dimensions/Size/X"/></xsl:variable>
<xsl:variable name="Height"><xsl:value-of select="/Settings/Dimensions/Size/Y"/></xsl:variable>
<xsl:variable name="XPos">10</xsl:variable>
<xsl:variable name="YPos"><xsl:value-of select="/Settings/Dimensions/Position/Y+100"/></xsl:variable>
<xsl:template match="/">
<svg preserveAspectRatio="xMidYMid meet">
	<!-- ** legend ** -->
	<xsl:variable name="CbOffset">15</xsl:variable>
	<xsl:variable name="SCount"><xsl:value-of select="count(/Settings/Scores/Analysis[@Type=$Analysis]/Score)"/></xsl:variable>
	<xsl:element name="rect">
		<xsl:attribute name="x"><xsl:value-of select="$XPos"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="$YPos"/></xsl:attribute>
		<xsl:attribute name="width">160</xsl:attribute>
		<xsl:attribute name="height"><xsl:value-of select="($SCount * $CbOffset) + 20"/></xsl:attribute>
		<xsl:attribute name="rx">10</xsl:attribute>
		<xsl:attribute name="ry">10</xsl:attribute>
		<xsl:attribute name="style">fill:rgb(254,254,254);stroke-width:0.75; stroke:rgb(0,0,0)</xsl:attribute>
	</xsl:element>
	
	<xsl:for-each select="/Settings/Scores/Analysis[@Type=$Analysis]/Score">
		<xsl:variable name="ScOffset"><xsl:value-of select="/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=current()]"/></xsl:variable>
		<xsl:variable name="CScore"><xsl:value-of select="current()"/></xsl:variable>
		
		<xsl:if test="$SScore = $CScore">
			<xsl:element name="rect">
				<xsl:attribute name="x"><xsl:value-of select="$XPos + 2"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$YPos + ($ScOffset * $CbOffset) + 12"/></xsl:attribute>
				<xsl:attribute name="width">155</xsl:attribute>
				<xsl:attribute name="height">15</xsl:attribute>
				<xsl:attribute name="style">fill:rgb(254,254,254);stroke-width:0.5;stroke:rgb(0,0,0)</xsl:attribute>
			</xsl:element>
		</xsl:if>
		
		<!--ColorBox offset de y+=15 -->		
		<xsl:call-template name="ColorBox">
			<xsl:with-param name="Ty"><xsl:value-of select="$ScOffset * $CbOffset"/></xsl:with-param>
			<xsl:with-param name="Color"><xsl:value-of select="/Settings/Colors/Color[@Name=current()]"/></xsl:with-param>
		</xsl:call-template>
		
		<!--text offset de y+=15 -->
		<xsl:call-template name="ColorText">
			<xsl:with-param name="Ty"><xsl:value-of select="$ScOffset * $CbOffset"/></xsl:with-param>
			<xsl:with-param name="Text"><xsl:value-of select="$CScore"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
</svg>
</xsl:template>

<xsl:template name="ColorBox">
	<xsl:param name="Ty"/>
    <xsl:param name="Color"/>
    <xsl:element name="rect">
		<xsl:attribute name="x"><xsl:value-of select="$XPos+5"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="$YPos"/></xsl:attribute>
		<xsl:attribute name="width">20</xsl:attribute>
		<xsl:attribute name="height">8</xsl:attribute>
		<xsl:attribute name="style">
			<xsl:text>stroke-width:0;fill:rgb(</xsl:text>
			<xsl:value-of select="$Color"/>
			<xsl:text>)</xsl:text>
		</xsl:attribute>
		<xsl:attribute name="transform">
			<xsl:text>translate(0</xsl:text>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$Ty + 15"/>
			<xsl:text>)</xsl:text>
		</xsl:attribute>
	</xsl:element>
</xsl:template>
<xsl:template name="ColorText">
	<xsl:param name="Ty"/>
	<xsl:param name="Text"/>
	<xsl:element name="text">
		<xsl:attribute name="x"><xsl:value-of select="$XPos + 30"/></xsl:attribute>
		<xsl:attribute name="y"><xsl:value-of select="$YPos + $Ty + 23"/></xsl:attribute>
		<xsl:attribute name="style">fill:rgb(0,0,0);font-size:11;font-family:arial;font-style:italic;font-weight:normal</xsl:attribute>
		<xsl:value-of select="$Text"/>
		<xsl:if test="$SScore = $Text">
			<animateColor attributeName="fill" attributeType="XML" values="black;gray;lightgray;gray" dur="5s" repeatCount="indefinite"/>
		</xsl:if>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
