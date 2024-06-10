<?xml version="1.0" encoding="UTF-8"?>
<!--Style Sheet to Convert XML file to Horizontal Bar Chart-->
<!--  
  ====================================================================== 
	Generating  a Horizontal bar graph (BusyTime)                                  
	Original Implementation 7/10/2004		Rakesh SG		DELMIA Corp
	
	Input - XML file from WSQ containing the Busytimes of Resources
  ====================================================================== 
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- ######################### Output Format################################-->
	<xsl:output method="html"/>
  <xsl:param name="NumRunsParam"/>
  
<!--  Initial Global Variable Definitions -->
	<xsl:variable name="height">300</xsl:variable>
	<xsl:variable name="width">550</xsl:variable>
	<xsl:variable name="margin">10</xsl:variable>
	<xsl:variable name="labelY">150</xsl:variable>
	<xsl:variable name="labelX">20</xsl:variable>
	<xsl:variable name="chartHeight" select="$height - (2 * $margin) - $labelX"/>
	<xsl:variable name="chartWidth" select="$width - (2 * $margin) - $labelY"/>
	<xsl:variable name="barHeight">0.8</xsl:variable>
	<xsl:variable name="horizontalRangeMax">
		<xsl:for-each select="/SystemStatistics/Run[@RunNumber=$NumRunsParam]//BUSY_PROCESSING">
			<xsl:sort order="descending" data-type="number" select="text()"/>
			<xsl:if test="position() = 1">
				<xsl:value-of select="."/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="verticalRangeMax" select="count(/SystemStatistics/Run[@RunNumber=$NumRunsParam]/Resources//BUSY_PROCESSING)"/>
	<xsl:variable name="horizontalScale">
		<xsl:value-of select="$chartWidth div $horizontalRangeMax"/>
	</xsl:variable>
	<xsl:variable name="verticalScale">
		<xsl:value-of select="$chartHeight div $verticalRangeMax"/>
	</xsl:variable>


	<!--  #######################################################################                        
						SystemStatistics Template 
		  #######################################################################
	-->

	<xsl:template match="SystemStatistics">
		<svg width="100%" height="100%">
			<xsl:comment>
				Horizontal range max = <xsl:value-of select="$horizontalRangeMax"/>
			</xsl:comment>
			<xsl:comment>
				Vertical range max = <xsl:value-of select="$verticalRangeMax"/>
			</xsl:comment>
			<xsl:comment>
				Horizontal scale = <xsl:value-of select="$horizontalScale"/>
			</xsl:comment>
			<xsl:comment>
				Vertical scale = <xsl:value-of select="$verticalScale"/>
			</xsl:comment>
			<xsl:comment>
				Bar height = <xsl:value-of select="$barHeight"/>
			</xsl:comment>
			<g transform="matrix(1 0 0 -1 {$margin + $labelY} {$height - ($margin + $labelX)})">
				<xsl:call-template name="verticalGridlines">
					<xsl:with-param name="value">0</xsl:with-param>
					<xsl:with-param name="step">30</xsl:with-param>
				</xsl:call-template>
				<text transform="matrix(1 0 0 -1 150 -{$labelX + 20})" x="0" y="0" 
              style="text-anchor:middle;font-size:18;fill:black">
					Time in Seconds
				</text>
		
				<xsl:call-template name="horizontalGridlines">
					<xsl:with-param name="value">0</xsl:with-param>
					<xsl:with-param name="stephor">1</xsl:with-param>
				</xsl:call-template>
				
				<text transform="matrix(1 0 0 -1 150 -{$labelX + 20})" y="-{($verticalRangeMax * $verticalScale) + 20}" 
              x="0" style="text-anchor:middle;font-size:24;fill:black">
          Busy Time of Resources
        </text>
		
        <xsl:for-each select="Run[@RunNumber=$NumRunsParam]/Resources/*/*">
            <xsl:call-template name="Resource"/>
        </xsl:for-each>
			</g>
		</svg>
	</xsl:template>
			
	<!--  #######################################################################                        
						VerticalGridlines Template                    
		  #######################################################################
	-->
	<xsl:template name="verticalGridlines">
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="step"/>
		<line id="verticalGridline_{$value}" x1="{$value * $horizontalScale}" y1="-5" 
          x2="{$value * $horizontalScale}" y2="{$verticalRangeMax * $verticalScale}" 
          style="fill:none;stroke:grey;stroke-width:1"/>
		<text transform="matrix(1 0 0 -1 0 -{$labelX})" x="{$value * $horizontalScale}" y="0" 
          style="text-anchor:middle;font-size:12;fill:black">
			<xsl:value-of select="$value"/>
		</text>
		<xsl:if test="$value + $step &lt; $horizontalRangeMax">
			<xsl:call-template name="verticalGridlines">
				<xsl:with-param name="value">
					<xsl:value-of select="$value + $step"/>
				</xsl:with-param>
				<xsl:with-param name="step">
					<xsl:value-of select="$step"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!--  #######################################################################                        
						HorizontalGridlines Template                    
		  #######################################################################
	-->

	<xsl:template name="horizontalGridlines">
		<xsl:param name="value">0</xsl:param>
		<xsl:param name="stephor"/>
		<line id="horizontalGridline_{$value}" x1="-5" y1="{$value * $verticalScale}" 
          x2="{$horizontalRangeMax * $horizontalScale}" y2="{$value * $verticalScale}" 
          style="fill:none;stroke:grey;stroke-width:1"/>
		<text transform="matrix(1 0 0 -1 -{$margin} 0)" x="0" y="-{(($value + 0.4) * $verticalScale)}" 
          style="text-anchor:end;font-size:12;fill:black">
			<xsl:for-each select="Run[@RunNumber=$NumRunsParam]/Resources/Resources/Resource">
				<xsl:if test="($value+1) = position()">
					<xsl:value-of select="@Name"/>
				</xsl:if>
			</xsl:for-each>
		</text>

		<xsl:for-each select="Run[@RunNumber=$NumRunsParam]/Resources/Resources/Resource/StateTimes/BUSY_PROCESSING">
			<xsl:if test="($value+1) = position()">
				<xsl:variable  name="Btime" select="text()"/>
				<text transform="matrix(1 0 0 -1 {$Btime * $horizontalScale + 30} 0)" x="10" 
              y="-{(($value + 0.4) * $verticalScale)}" style="text-anchor:end;font-size:12;fill:black">
					<xsl:value-of select= 'format-number($Btime,"#.00")'/>
				</text>	
			</xsl:if>
		</xsl:for-each>

		<xsl:if test="$value + $stephor &lt; $verticalRangeMax">
			<xsl:call-template name="horizontalGridlines">
				<xsl:with-param name="value">
					<xsl:value-of select="$value + $stephor"/>
				</xsl:with-param>
				<xsl:with-param name="stephor">
					<xsl:value-of select="$stephor"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	

	<!--  #######################################################################                        
						Resource Template                    
		  #######################################################################
	-->
			<xsl:template name="Resource">
				<xsl:variable name="Busy_Time" select="text()"/>
				<xsl:variable name="label" select="@Name"/>
				<xsl:variable name="col" select="position() - 1"/>
				<xsl:for-each select="StateTimes">
					<rect id="{$label}-{position()}" x="0" y="{($col  * $verticalScale)}" 
                width="{./BUSY_PROCESSING * $horizontalScale}" height="{$barHeight * $verticalScale}" 
                rx="0" ry="0"
					 style="stroke-width:1;stroke:rgb(0,0,0);fill:rgb(200,50,100)"/>
				</xsl:for-each>
		</xsl:template>

</xsl:stylesheet>
