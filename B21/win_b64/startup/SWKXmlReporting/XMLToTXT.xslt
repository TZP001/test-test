<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Autor : Julien Marchand VMD
Date : 2006/10/26
Description : This xslt file converts a xml report file into txt
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Sets the type of output file to html -->
    <xsl:output method="text" indent="yes" />
    <!--
    /**
    * This is the *main* template.
    **/
    -->
    <xsl:template match="/">
      <xsl:for-each select="Report/Simulation">
          <xsl:variable name="SimulationID"><xsl:value-of select="./@Id"/></xsl:variable>
          <!-- Concat report date and time -->
          <xsl:variable name="Date">
            <xsl:value-of select="./Time/Year"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="./Time/Month"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="./Time/Day"/>
            <xsl:text>    </xsl:text>
            <xsl:value-of select="./Time/Hour"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="./Time/Minute"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="./Time/Second"/>
          </xsl:variable>
          <xsl:for-each select="./Step">
            <xsl:variable name="CurrentStepTime" >
              <xsl:value-of select="./@Time"/>
            </xsl:variable>
            <xsl:for-each select="./ReportedObject">
              <xsl:variable name="ReportedObjectName" >
                <xsl:value-of select="./@Name"/>
              </xsl:variable>
              <xsl:for-each select="./Analysis">
                <xsl:call-template name="PrintAnalysis">
                  <xsl:with-param name="Date"><xsl:value-of select="$Date"/></xsl:with-param>
                  <xsl:with-param name="SimulationID"><xsl:value-of select="$SimulationID"/></xsl:with-param>
                  <xsl:with-param name="ReportedObjectName"><xsl:value-of select="$ReportedObjectName"/></xsl:with-param>
                  <xsl:with-param name="ReportName"><xsl:value-of select="/Report/@Name"/></xsl:with-param>
                  <xsl:with-param name="CurrentStepTime"><xsl:value-of select="$CurrentStepTime"/></xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
      </xsl:for-each>
    <xsl:text>
</xsl:text>
  </xsl:template>
  <!--
    /** 
    * Prints every analysis at current time step according to the object name passed as parameter.
    * @param Date 
    *   Represents the current report date
    * @param ReportName 
    *   Represents the current report name
    * @param SimulationId 
    *   Represents the current report id
    * @param ReportedObjectName 
    *   Represents the current object reported name
    * @param CurrentStepTime 
    *   Represents the current step time
    */
    -->
  <xsl:template name="PrintAnalysis">
    <xsl:param name="Date"/>
    <xsl:param name="SimulationID"/>
    <xsl:param name="ReportedObjectName"/>
    <xsl:param name="ReportName"/>
    <xsl:param name="CurrentStepTime"/>
    <!-- Current analysis name -->
    <xsl:variable name="AnalysisName">
      <xsl:value-of select="./@Type"/>
    </xsl:variable>
    <!-- Go through every results -->
    <xsl:for-each select="./Results/Result">
      <!-- Create a line for each result -->
      <xsl:variable name="ResultLine" >
        <!-- Output the Date & Time -->
        <xsl:value-of select="$Date"/>
        <xsl:text>	</xsl:text>
        <!-- Output the Simulation ID -->
        <xsl:value-of select="$SimulationID"/>
        <xsl:text>    </xsl:text>
        <xsl:value-of select="$AnalysisName"/>
        <xsl:text>	</xsl:text>
        <!-- Output all Parameters -->
        <xsl:for-each select="../../Parameters/Parameter">
          <xsl:value-of select="./@Name"/>
          <xsl:value-of select="./Value"/>
          <xsl:value-of select="./Unit"/>
          <xsl:if test="not(position()=last())">
            <xsl:text> / </xsl:text>
          </xsl:if>
        </xsl:for-each>
        <!-- Output the Result -->
        <xsl:text>	</xsl:text>
        <xsl:value-of select="./@Name"/>
        <xsl:text>	</xsl:text>
        <xsl:value-of select="./Value"/>

        <xsl:text>	</xsl:text>
        <!-- Output the ReportedObject Name -->
        <xsl:value-of select="$ReportedObjectName"/>
        <xsl:text>	</xsl:text>
        <!-- Output the Report Name -->
        <xsl:value-of select="$ReportName"/>
        <xsl:text>	</xsl:text>
        <!-- Output the Simulation Time -->
        <xsl:text>Simulation time: </xsl:text>
        <xsl:value-of select="$CurrentStepTime"/>
      </xsl:variable>
      <xsl:text>
     </xsl:text>
     <xsl:value-of select="$ResultLine"/>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
