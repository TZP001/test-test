<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:decimal-format name="european" decimal-separator="," grouping-separator="."/>

<!-- Style sheet for Run Stats Reporting -->
<!-- 
	XSLT Style sheet developed for Reporting
	created:	7/04/01	rsh			DEVELOPMENT

	Purpose:
			For creating a html view of the Selected Activity / All activities. This works on the ActivityLog.xml adhereing to ActivityLog.xsd Schema.
			Any modifications please refer to the Schema document and make changes with respect to it.
			
			INPUT:	Parameter - Activity Name  or key word "Process"
				If the user gives the Activity Name as a parmeter then all the executions of the given cycle are reported in detail.
				If the user gives "Process" as a parameter then all the executions of all the processes on all the resources are reported in detail

			useage on Command line:
				java -cp "......\xalan.jar;....\xercer.jar;

	Modification History
	Date		Trigram			Change

	
		
-->
<!-- The Parameter that is input to the Style Sheet - should be the Resource Name or keyword "ResourceList"  If used with DPM  when user selects the activity then this is automatically
	passed in. Or if the user selects the Resource list node  then it will send in "ResourceList" as parameter-->
<xsl:param name="FirstParam" select="Resource"/>
<!-- <xsl:param name="SecondParam" select="Machine"/> -->
  <xsl:param name="NumRunsParam"/>

	<xsl:template match="/">
		<html>
			<head>
				<!--  Style Sheet for the HTML File generated . This is the class definitions used in vairous tags -->
				<STYLE TYPE='text/css'>
					A:hover{color:blue}
					span.TitleStyle{text-decoration:none;color:black;background-color:#99CCFF;font-weight:bold;font-size:9pt;font-family:Arial,sans-serif}
					span.AverageStyle{text-decoration:none;color:white;background-color:#000099;font-weight:bold;font-size:10pt;font-family:Arial,sans-serif}
					TD.menu{background-color:#000099;color:white;font-weight:bold;font-family:Arial,sans-serif;font-size:9pt;text-	align:right}
					.sans{font-family:Arial,Verdana,sans-serif;font-size:10pt}
					.sansb{font-family:Arial,Verdana,sans-serif;font-size:10pt;font-weight:bold}
					.browsers{display:inline;font-family:sans-serif;font-size:9pt;font-weight:bold}
					.latest{border:1px black solid; padding:5;font-family:Arial,Verdana,sans-serif;font-size:10pt}
				</STYLE>
				<h1>Statistics</h1>
			</head>	
			<body>
				<xsl:apply-templates  select="SystemStatistics"/>
			</body>	
		</html>
	</xsl:template>	
	
	<!-- SystemStatistics Template -->		
	<xsl:template match="SystemStatistics">
		<xsl:apply-templates select="Run[@RunNumber=$NumRunsParam]"/>			
	</xsl:template>
	
	<!-- Run Template -->
	<xsl:template match="Run">
		<xsl:choose>
			<xsl:when test="$FirstParam='ALL'">
				<xsl:apply-templates select="Resources/*"/>
			</xsl:when>
			<xsl:when test="$FirstParam='AllMachines'">
				<xsl:apply-templates select="Resources/Machines/*"/>
			</xsl:when>
			<xsl:when test="$FirstParam='AllSources'">
				<xsl:apply-templates select="Resources/Sources/*"/>
			</xsl:when>
			<xsl:when test="$FirstParam='AllSinks'">
				<xsl:apply-templates select="Resources/Sinks/*"/>
			</xsl:when>
			<xsl:when test="$FirstParam='AllBuffers'">
				<xsl:apply-templates select="Resources/Buffers/*"/>
			</xsl:when>
			<xsl:when test="$FirstParam='AllLabors'">
				<xsl:apply-templates select="Resources/Labors/*"/>
			</xsl:when>
			<xsl:when test="$FirstParam='AllSubResources'">
				<xsl:apply-templates select="Resources/Sub_Resource/*"/>
			</xsl:when>
			<xsl:otherwise>
        <xsl:for-each select="Resources/*/*">
          <xsl:if test="@Name=$FirstParam">
            <xsl:call-template name="Resource"/>
          </xsl:if>
        </xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Resource Template -->
	<xsl:template name="Resource">
						
		<!-- Write the Resource Name and the Process Name -->
		<div>
			<span class="AverageStyle" >Resource : 
				<xsl:value-of select="@Name"/>
			</span>
			<br/>
		</div>
		
		<!-- Create the table to display the statistics -->
		<xsl:text disable-output-escaping="yes">&lt;table border="0" width="100%"&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;tbody&gt;</xsl:text>				
		
		<tr>
			<td>Busy-Processing Time</td>
			<td >
				<xsl:value-of select="format-number(./StateTimes/BUSY_PROCESSING, '0,00' , 'european' )"/>
			</td>
		</tr>
    <tr>
      <td>Idle Time</td>
      <td >
        <xsl:value-of select="format-number(./StateTimes/IDLE, '0,00' , 'european' )"/>
      </td>
    </tr>

    <xsl:text disable-output-escaping="yes">&lt;/tbody&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
		<br/>
					
	</xsl:template>			
</xsl:stylesheet>
