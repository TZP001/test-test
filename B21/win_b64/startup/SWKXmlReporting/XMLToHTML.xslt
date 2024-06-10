<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Autor : Patrick Filion  FHV
Date : 2006/07/18
Description : This xslt file converts a xml report file into html
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- Sets the type of output file to html -->
<xsl:output method="html" indent="yes" />
<!--  
/**
* This is the *main* template. 
**/
-->
<xsl:template match="/">                          
    <html>

        <!-- Head of the HTML file -->
        <head>
            <header>
                <title>Report Result</title>
            </header>
            <!-- Link the style sheet -->
            <LINK REL="stylesheet" HREF="style.css" TYPE="text/css" />
        </head>
        
        <!-- Main Table -->
        <table class="table" cellspacing="0" cellpadding="0" >
            
            <!-- Concat report date and time -->
            <xsl:variable name="DateReport" >
                <xsl:value-of select="/Report/Simulation/Time/Year"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="/Report/Simulation/Time/Month"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="/Report/Simulation/Time/Day"/>
                <xsl:text>    </xsl:text>
                <xsl:value-of select="/Report/Simulation/Time/Hour"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="/Report/Simulation/Time/Minute"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="/Report/Simulation/Time/Second"/>
            </xsl:variable>
            
            <!-- Print report header -->
            <xsl:call-template name="PrintReportHeader">
            <xsl:with-param name="ReportName"><xsl:value-of select="/Report/@Name"/></xsl:with-param>
            <xsl:with-param name="Date"><xsl:value-of select="$DateReport"/></xsl:with-param>
            </xsl:call-template>
            
            <!-- Go through each simulation -->
            <xsl:for-each select="Report/Simulation">
                
                <!-- Concat simulation date and time -->
                <xsl:variable name="DateSimulation" >
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
              
                <!-- Print simulation header -->
                <xsl:call-template name="PrintSimHeader">
                    <xsl:with-param name="SimId"><xsl:value-of select="./@Id"/></xsl:with-param>
                    <xsl:with-param name="Date"><xsl:value-of select="$DateSimulation"/></xsl:with-param>
                </xsl:call-template>
                
                <xsl:variable name="SimId"><xsl:value-of select="./@Id"/></xsl:variable>
                
                <xsl:for-each select="./Step[1]/ReportedObject" >
                    <xsl:variable name="ObjectName"><xsl:value-of select="./@Name"/></xsl:variable>
                    
                    <xsl:for-each select="/Report/Simulation[@Id=$SimId]/Step/ReportedObject[@Name=$ObjectName]" >
                        <!-- Print object header if first analysis -->
                        <xsl:if test="position() = 1">
                            <xsl:call-template name="PrintObjectHeader">
                                <xsl:with-param name="ReportedObjectType"><xsl:value-of select="./@Type"/></xsl:with-param> 
                                <xsl:with-param name="ReportedObjectName"><xsl:value-of select="./@Name"/></xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                        <!-- Print analysis related to this step time -->
                        <xsl:call-template name="PrintReportAnalysis">
                            <xsl:with-param name="ReportedObjectName"><xsl:value-of select="$ObjectName"/></xsl:with-param>
                            <xsl:with-param name="CurrentStepTime"><xsl:value-of select="../@Time"/></xsl:with-param>
                        </xsl:call-template>        
                    </xsl:for-each>
                
                    <!-- Print empty line after the object report section -->
                    <tr>
                        <td style="border: solid 0 #000;border-top-width: 2px;">&#160;</td>
                        <td style="border: solid 0 #000;border-top-width: 2px;">&#160;</td>
                        <td style="border: solid 0 #000;border-top-width: 2px;">&#160;</td>
                    </tr>
                </xsl:for-each>
            </xsl:for-each>
        </table>
    </html>
</xsl:template>

<!-- 
/** 
* This prints headers info about the current report :
* - Report Name
* - Date
* @param ReportName 
*   Represents the current report name
* @param Date 
*   Represents the current report date
*/
-->
<xsl:template name="PrintReportHeader">
    <xsl:param name="ReportName"/>
    <xsl:param name="Date"/>
    <tr>
        <td class="tdReportTitle" colspan="3" width="100%" valign="middle">
            <h2 class="title">Report Identification</h2>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="100%" border="1" rules="rows" frame="hsides">
                <tr>
                    <td width="280" class="reportHeader"><font size="4">Date :</font></td><td><xsl:value-of select="$Date"/></td>
                </tr>
                <tr>
                    <td class="reportHeader">Name :</td><td><xsl:value-of select="$ReportName"/></td>
                </tr>
            </table>
        </td>
    </tr>
</xsl:template>

<!-- 
/** 
* This prints simulation header info about the current report :
* - SimId
* - Date
* @param SimId 
*   Represents the current report id
* @param Date 
*   Represents the current report date
*/
-->
<xsl:template name="PrintSimHeader">
    <xsl:param name="SimId"/>
    <xsl:param name="Date"/>
    <tr>
        <td class="tdSimTitle" colspan="3" width="100%" valign="middle">
            <h2 class="title">Simulation Identification</h2>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="100%" border="1" rules="rows" frame="hsides">
                <tr>
                    <td width="280" class="reportHeader"><font size="4">Date :</font></td><td><xsl:value-of select="$Date"/></td>
                </tr>
                <tr>
                    <td class="reportHeader">Id :</td><td><xsl:value-of select="$SimId"/></td>
                </tr>
            </table>
        </td>
    </tr>
</xsl:template>

<!-- 
/** 
* This prints header info about the reported object :
* - Object reported type
* - Object reported name
* @param ReportedObjectType 
*   Represents the current object reported type
* @param ReportedObjectName 
*   Represents the current object reported name
*/
-->
<xsl:template name="PrintObjectHeader">
    <xsl:param name="ReportedObjectType"/>
    <xsl:param name="ReportedObjectName"/>
    <tr>
        <td class="tdObjectTitle" colspan="3" width="100%" valign="middle">
            <h2 class="title">Object Identification</h2>
        </td>
    </tr>
    <tr>
        <td colspan="3">
            <table width="100%" border="1" rules="rows" frame="hsides">
                <tr>
                    <td width="280"  class="reportHeader">Type :</td><td><xsl:value-of select="$ReportedObjectType"/></td>
                </tr>
                <tr>
                    <td width="280"  class="reportHeader">Name :</td><td><xsl:value-of select="$ReportedObjectName"/></td>
                </tr>
            </table>
        </td>
    </tr>
</xsl:template>

<!--
/** 
* Prints every analysis at current time step according to the object name passed as parameter.
* @param ReportedObjectName 
*   Represents the current object reported name
* @param CurrentStepTime 
*   Represents the current report id
*/
-->
<xsl:template name="PrintReportAnalysis">
    <xsl:param name="ReportedObjectName"/>
    <xsl:param name="CurrentStepTime"/>
    
    <!-- Go though every analysis -->
    <xsl:for-each select="./Analysis">
        <!-- Current analysis name -->
        <xsl:variable name="AnalysisName"><xsl:value-of select="./@Type"/></xsl:variable>
            <tr>
                <td class="tdAnalysisTitle" colspan="3" bgcolor="#3c1f81" width="700" valign="middle">
                    <h2 class="title"><xsl:value-of select="$AnalysisName"/></h2>
                    <div class="title">Time : <xsl:value-of select="$CurrentStepTime"/> s</div>
                    <xsl:if test="./Status != ''">
                        <div class="title">Status : <xsl:value-of select="./Status"/></div>
                    </xsl:if>
                </td>
            </tr>
        <!-- Gets the results and parameters size -->
        <xsl:variable name="RowSizeResult"><xsl:value-of select="count(./Results/Result)"/></xsl:variable>
        <xsl:variable name="RowSizeParams"><xsl:value-of select="count(./Parameters/Parameter)"/></xsl:variable>
        
        <!-- Choose the longer list of element, between results and parameters
        Iterate through it and prints the results in a table row -->
        <xsl:choose>
            <xsl:when test="$AnalysisName = 'Vision Analysis'">
                <!-- Since Vision analysis has a different layout, do a special print row for it -->
                <xsl:call-template name="PrintVisionRow">
                  <xsl:with-param name="Param"><xsl:value-of select="Results/Result[1]/@Name"/></xsl:with-param>
                  <xsl:with-param name="Value"><xsl:value-of select="Results/Result[1]/Value"/></xsl:with-param>
                  <xsl:with-param name="Unit"><xsl:value-of select="Results/Result[1]/Unit"/></xsl:with-param>
                  <xsl:with-param name="ImgSrc"><xsl:value-of select="Results/Result[2]/Value"/></xsl:with-param>
                  <xsl:with-param name="Width"><xsl:value-of select="Results/Result[2]/Value/@Width"/></xsl:with-param>
                  <xsl:with-param name="Height"><xsl:value-of select="Results/Result[2]/Value/@Height"/></xsl:with-param>
                  <xsl:with-param name="ImgSrc2"><xsl:value-of select="Results/Result[3]/Value"/></xsl:with-param>
                  <xsl:with-param name="Width2"><xsl:value-of select="Results/Result[3]/Value/@Width"/></xsl:with-param>
                  <xsl:with-param name="Height2"><xsl:value-of select="Results/Result[3]/Value/@Height"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$RowSizeResult &gt; $RowSizeParams">
                <!-- Print header title : -->
                <tr>
                    <td class="tdDesc">Description</td>
                    <td class="tdParam">Parameters</td>
                    <td class="tdValue">Value</td>
                </tr>
                <xsl:for-each select="Results/Result">    
                <tr>
                    <xsl:if test="position()=1">
                        <xsl:call-template name="PrintDescription">
                            <xsl:with-param name="RowSpanSize"><xsl:value-of select="$RowSizeResult"/></xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>
                    <xsl:call-template name="PrintRowMoreResult">
                        <xsl:with-param name="AnalysisName"><xsl:value-of select="$AnalysisName"/></xsl:with-param>
                        <xsl:with-param name="Position"><xsl:value-of select="position()"/></xsl:with-param>
                    </xsl:call-template>
                </tr>           
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise> 
                <tr class="row">
                    <td class="tdDesc">Description</td>
                    <td class="tdParam">Parameters</td>
                    <td class="tdValue">Value</td>
                </tr>
                <xsl:for-each select="Parameters/Parameter">
                    <tr class="trAnalysisBody">
                        <xsl:if test="position() = 1 ">
                            <xsl:call-template name="PrintDescription">
                                <xsl:with-param name="RowSpanSize"><xsl:value-of select="$RowSizeParams"/></xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="PrintRowMoreParams">
                            <xsl:with-param name="AnalysisName"><xsl:value-of select="$AnalysisName"/></xsl:with-param>
                            <xsl:with-param name="Position"><xsl:value-of select="position()"/></xsl:with-param>
                        </xsl:call-template>
                    </tr>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
</xsl:template>
<!--
/**
* Prints the current analysis description
* and rowspan the cell according to the
* number of results found in this analsysis.
*
* @param RowSpanSize
*       Represents the number of row to span
*/
-->
<xsl:template name="PrintDescription">
    <xsl:param name="RowSpanSize"/>
 
    <td class="tdDescBody" valign="top">
        <xsl:attribute name="rowspan">
            <xsl:value-of select="$RowSpanSize" />
        </xsl:attribute>
        <ul>
        <!-- For each parameter creates a bullet-point containing the information -->
            <xsl:for-each select="../../Parameters/Parameter">
                <li><xsl:value-of select="./@Name"/>
                <xsl:if test = "./Value != ''">
                <xsl:value-of select="./Value"/></xsl:if>
                <xsl:if test = "./Unit != ''">
                <xsl:value-of select="./Unit"/></xsl:if></li>
            </xsl:for-each>
        </ul>
    </td>
</xsl:template>   
<!--
/**
* Prints the analysis results in the case where
* the amount of result is bigger than the amount
* 
*/
-->
<xsl:template name="PrintRowMoreResult">
    <xsl:param name="AnalysisName"/>
    <xsl:param name="Position"/>
    
    <xsl:call-template name="PrintTableCell">
        <xsl:with-param name="CurrentPosition"><xsl:value-of select="$Position mod 2"/></xsl:with-param>
        <xsl:with-param name="CellType"><xsl:value-of select="'rParam'"/></xsl:with-param>
        <xsl:with-param name="Value"><xsl:value-of select="./@Name"/></xsl:with-param>
        <xsl:with-param name="Unit"><xsl:value-of select="./Unit"/></xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="PrintTableCell">
        <xsl:with-param name="CurrentPosition"><xsl:value-of select="$Position mod 2"/></xsl:with-param>
        <xsl:with-param name="CellType"><xsl:value-of select="'rValue'"/></xsl:with-param>
        <xsl:with-param name="Value"><xsl:value-of select="./Value"/></xsl:with-param>
        <xsl:with-param name="Color"><xsl:value-of select="./Color"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>
<!--
/**
*
*
*
*/
-->
<xsl:template name="PrintRowMoreParams">
    <xsl:param name="AnalysisName"/>
    <xsl:param name="Position"/>
    
    <xsl:call-template name="PrintTableCell">
        <xsl:with-param name="CurrentPosition"><xsl:value-of select="$Position mod 2"/></xsl:with-param>
        <xsl:with-param name="CellType"><xsl:value-of select="'rParam'"/></xsl:with-param>
        <xsl:with-param name="Value"><xsl:value-of select="../../Results/Result[$Position]/@Name"/></xsl:with-param>
        <xsl:with-param name="Unit"><xsl:value-of select="../../Results/Result[$Position]/Unit"/></xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="PrintTableCell">
        <xsl:with-param name="CurrentPosition"><xsl:value-of select="$Position mod 2"/></xsl:with-param>
        <xsl:with-param name="CellType"><xsl:value-of select="'rValue'"/></xsl:with-param>
        <xsl:with-param name="Value"><xsl:value-of select="../../Results/Result[$Position]/Value"/></xsl:with-param>
        <xsl:with-param name="Color"><xsl:value-of select="../../Results/Result[$Position]/Color"/></xsl:with-param>
    </xsl:call-template>
</xsl:template>
<!--
/**
*
*
*
*/
-->
<xsl:template name="PrintVisionRow">
    <xsl:param name="Param"/>
    <xsl:param name="Value"/>
    <xsl:param name="Unit"/>
    <xsl:param name="ImgSrc"/>
    <xsl:param name="Width"/>
    <xsl:param name="Height"/>
    <xsl:param name="ImgSrc2"/>
    <xsl:param name="Width2"/>
    <xsl:param name="Height2"/>
    
    <tr>
        <td class="tdImageTitle" colspan="3" align="center"><b>Images</b></td>
    </tr>
    <tr>   
        <td class="tdImage" colspan="3" height="135" align="center" valign="center">
            <img border="1">
                <xsl:attribute name="Width">
                  <xsl:value-of select="$Width" />
                </xsl:attribute>
                <xsl:attribute name="Height">
                  <xsl:value-of select="$Height" />
                </xsl:attribute>
                <xsl:attribute name="src">
                  <xsl:value-of select="$ImgSrc" />
                </xsl:attribute>
            </img>
            <img border="1">
                <xsl:attribute name="Width">
                  <xsl:value-of select="$Width2" />
                </xsl:attribute>
                <xsl:attribute name="Height">
                  <xsl:value-of select="$Height2" />
                </xsl:attribute>
                <xsl:attribute name="src">
                  <xsl:value-of select="$ImgSrc2" />
                </xsl:attribute>
            </img>
        </td>
    </tr>
    <tr align="center">
        <td class="tdDesc">Description</td>
        <td class="tdParam">Parameters</td>
        <td class="tdValue">Value</td>
    </tr>
    <tr>
        <td class="tdDescBody">&#160;</td>
        <xsl:call-template name="PrintTableCell">
            <xsl:with-param name="CurrentPosition"><xsl:value-of select="1"/></xsl:with-param>
            <xsl:with-param name="CellType"><xsl:value-of select="'rParam'"/></xsl:with-param>
            <xsl:with-param name="Unit"><xsl:value-of select="$Unit"/></xsl:with-param>
            <xsl:with-param name="Value"><xsl:value-of select="$Param"/></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="PrintTableCell">
            <xsl:with-param name="CurrentPosition"><xsl:value-of select="1"/></xsl:with-param>
            <xsl:with-param name="CellType"><xsl:value-of select="'rValue'"/></xsl:with-param>
            <xsl:with-param name="Value"><xsl:value-of select="$Value"/></xsl:with-param>
        </xsl:call-template>
    </tr>
</xsl:template> 

<!--
/** Returns the correct color depending on the
* row position. We alternate colors through rows.
* @param CurrentPosition 
*   Represents the current row position
*/
-->
<xsl:template name="PrintTableCell">
    <xsl:param name="CurrentPosition"/>
    <xsl:param name="CellType"/>
    <xsl:param name="Value"/>
    <xsl:param name="Unit"/>
    <xsl:param name="Color"/>

    <xsl:choose>
        <!-- Is this a color cell ( rula ) -->
        <xsl:when test="$Color != ''">
            <td class="{$Color}">
                <b><xsl:value-of select="$Value"/></b>
            </td>
        </xsl:when>
        <!-- Does it contains a value -->
        <xsl:when test="$Value != ''">
            <td class = "{concat($CellType,$CurrentPosition)}" >
                <xsl:value-of select="$Value"/>
            </td>
        </xsl:when>
        <xsl:otherwise>
            <!-- Print an empty cell -->
            <xsl:choose>
                <xsl:when test="$CellType = 'rParam'">       
                    <td class="tdParamEmpty">
                        <span xml:space="preserve">&#160;</span>
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td class="tdValueEmpty">
                        <span xml:space="preserve">&#160;</span>
                    </td>
                </xsl:otherwise>
            </xsl:choose> 
        </xsl:otherwise>
    </xsl:choose>   
</xsl:template>
</xsl:stylesheet>
