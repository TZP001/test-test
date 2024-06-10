<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Autor : Julien Marchand VMD
Date : 2006/11/09
Description : This xsl file converts a xml report file into the old xml format
-->
<!-- Edited with XML Spy v4.2 -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
	<xsl:element name="Report">
		<xsl:variable name="ManikinName"><xsl:value-of select="Report/Simulation/Step[1]/ReportedObject[1]/@Name"/></xsl:variable>
		<xsl:variable name="SimulationId"><xsl:value-of select="Report/@Name"/></xsl:variable>
		<xsl:variable name="GlobalScore">Global Score</xsl:variable>
		
		<xsl:element name="Manikin">
			<xsl:attribute name="Name"><xsl:value-of select="$ManikinName"/></xsl:attribute>
			<xsl:element name="Simulation">
				<xsl:attribute name="Id"><xsl:value-of select="$SimulationId"/></xsl:attribute>
				<Time>
					<Year><xsl:value-of select="Report/Simulation/Time/Year"/></Year>
					<Month><xsl:value-of select="Report/Simulation/Time/Month"/></Month>
					<Day><xsl:value-of select="Report/Simulation/Time/Day"/></Day>
					<Hour><xsl:value-of select="Report/Simulation/Time/Hour"/></Hour>
					<Minute><xsl:value-of select="Report/Simulation/Time/Minute"/></Minute>
					<Second><xsl:value-of select="Report/Simulation/Time/Second"/></Second>
				</Time>
				<xsl:for-each select="Report/Simulation/Step">
					<xsl:element name="Step">
						<xsl:attribute name="Time"><xsl:value-of select="./@Time"/></xsl:attribute>
						<xsl:for-each select="./ReportedObject/Analysis">
							<xsl:element name="Analysis">
								<xsl:variable name="Type"><xsl:value-of select="./@Type"/></xsl:variable>
								<xsl:variable name="RulaD">RULA Details</xsl:variable>
								<xsl:variable name="RulaDold">RULADetails</xsl:variable>
								<xsl:choose>
									<xsl:when test="($Type = $RulaD)">
										<xsl:attribute name="Type"><xsl:value-of select="$RulaDold"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="Type"><xsl:value-of select="$Type"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="(./Unit != 'Undefined')">
										<Activities><xsl:value-of select="./Activity"/></Activities>
									</xsl:when>
									<xsl:otherwise>
										<Activities></Activities>
									</xsl:otherwise>
								</xsl:choose>
								<Parameters>
									<xsl:for-each select="./Parameters/Parameter">
										<xsl:element name="Parameter">
											<xsl:attribute name="Name"><xsl:value-of select="./@Name"/></xsl:attribute>
											<Value><xsl:value-of select="./Value"/></Value>
											<xsl:choose>
												<xsl:when test="(./Unit != '')">
													<Unit><xsl:value-of select="./Unit"/></Unit>
												</xsl:when>
												<xsl:otherwise>
													<Unit>None</Unit>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element> <!-- Parameter -->
									</xsl:for-each> <!-- AllParameters -->
								</Parameters>
								<Results>
									<xsl:for-each select="./Results/Result">
										<xsl:element name="Result">
											<xsl:attribute name="Name"><xsl:value-of select="./@Name"/></xsl:attribute>
											<Value><xsl:value-of select="./Value"/></Value>
											<xsl:choose>
												<xsl:when test="(./Unit != '')">
													<Unit><xsl:value-of select="./Unit"/></Unit>
												</xsl:when>
												<xsl:otherwise>
													<Unit>None</Unit>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:element> <!-- Result -->
									</xsl:for-each> <!-- AllResults -->
								</Results>
							</xsl:element> <!-- Analysis -->
						</xsl:for-each> <!-- AllAnalysis -->
					</xsl:element> <!-- Step -->
				</xsl:for-each> <!-- AllSteps -->
			</xsl:element> <!-- Simulation -->
		</xsl:element> <!-- Manikin -->
	</xsl:element> <!-- Report -->
</xsl:template> <!-- MainTemplate -->
</xsl:stylesheet>
