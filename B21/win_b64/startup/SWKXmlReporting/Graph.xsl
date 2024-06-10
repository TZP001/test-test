<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
This is how the report works for the graph part :
Catia copies the graph.xsl file from the startup directory to your temp directory and uses 
it to produce the Graph.svg file. The Graph.xsl file is doing a bridge 
between the settings.xml file and the SVG output(Graph.svg).

The temp directory looks like this : C:\Documents and Settings\<YOUR TRIGRAM>\Local Settings\Application Data\DassaultSystemes\CATTemp\

Note : To be able to see the SVG into Internet explorer,  you need a plugin
that can be found at : http://download.adobe.com/pub/adobe/magic/svgviewer/win/3.x/3.03/en/SVGView.exe

Tip : To be able to test the report without running Catia,  you can call directly java
since this is what Catia is doing after all.  Run first the simulation within Catia and create your 
report output into a file.  After doing modifications to this file (Graph.xsl),  you can update your
runtime view and then call java directly with this command :
C:\WINDOWS\system32\Java.exe -classpath "[WorkingDriveLetter]:\Workspace_FHV\PrereqCXR17relBin\intel_a\docs\Java\jxalan2.jar;" org.apache.xalan.xslt.Process 
-IN "C:\Documents and Settings\<YOUR TRIGRAM>\Local Settings\Application Data\DassaultSystemes\CATTemp\Settings.xml" 
-XSL "[WorkingDriveLetter]\Workspace_FHV\CNext_Workspace_V5R17rel\intel_a\startup\SWKXmlReporting\Graph.xsl" 
-OUT "C:\Documents and Settings\<YOUR TRIGRAM>\Local Settings\Application Data\DassaultSystemes\CATTemp\Graph.svg" 
-EDUMP "C:\Documents and Settings\<YOUR TRIGRAM>\Local Settings\Application Data\DassaultSystemes\CATTemp\Errors.txt"

You can check that command by adding a break point in the code also where Catia is calling Java.

This command will update the Graph.svg file and you can observe the changes directly into IE or Firefox. 
-->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="Manikin"><xsl:value-of select="/Settings/Selections/Manikin"/></xsl:variable>
<xsl:variable name="Simulation"><xsl:value-of select="/Settings/Selections/Simulation"/></xsl:variable>
<xsl:variable name="Analysis"><xsl:value-of select="/Settings/Selections/Analysis"/></xsl:variable>
<xsl:variable name="SScore"><xsl:value-of select="/Settings/Selections/Score"/></xsl:variable>
<xsl:variable name="Pixels">2</xsl:variable>
<xsl:variable name="Width"><xsl:value-of select="/Settings/Dimensions/Size/X"/></xsl:variable>
<xsl:variable name="Height"><xsl:value-of select="/Settings/Dimensions/Size/Y"/></xsl:variable>
<xsl:variable name="XPos"><xsl:value-of select="/Settings/Dimensions/Position/X"/></xsl:variable>
<xsl:variable name="YPos"><xsl:value-of select="/Settings/Dimensions/Position/Y"/></xsl:variable>
<!-- DeltaX = Lastpoint - FirstPointX -->
<xsl:variable name="FirstPointX"><xsl:value-of select="(/Settings/Axis//XAxis/X[1])"/></xsl:variable>
<xsl:variable name="LastPointX"><xsl:value-of select="(/Settings/Axis//XAxis/X[last()])"/></xsl:variable>
<xsl:variable name="DeltaX"><xsl:value-of select="($LastPointX - $FirstPointX)"/></xsl:variable>

<xsl:template match="/">
	<svg width="1500" height="100%" version="1.1" preserveAspectRatio="xMidYMid meet" style="overflow:visible;enable-background:new">		
		<!-- ** main graphique ** -->
		<xsl:element name="rect">
			<xsl:attribute name="x"><xsl:value-of select="$XPos"/></xsl:attribute>
			<xsl:attribute name="y"><xsl:value-of select="$YPos"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="$Width"/></xsl:attribute>
			<xsl:attribute name="height"><xsl:value-of select="$Height"/></xsl:attribute>
			<xsl:attribute name="style">
				<xsl:text>stroke-width:0.5; stroke:rgb(0,0,0); fill:rgb(</xsl:text>
				<xsl:value-of select="/Settings/Colors/Color[@Name='Background']"/>
				<xsl:text>)</xsl:text>
			</xsl:attribute>
		</xsl:element>
        
        <!-- ** Treshold ** -->
		<xsl:variable name="THy"><xsl:value-of select="(/Settings/Axis/YAxis[@Name='Threshold']/Y[@Score='Bads'])"/></xsl:variable>
		<xsl:if test="(/Settings/Visibility/Lines/Line[@Name='Threshold']!='false')">
			<xsl:element name="rect"><!-- ** gray ** -->
				<xsl:attribute name="x"><xsl:value-of select="$XPos"/></xsl:attribute>
				<xsl:attribute name="width"><xsl:value-of select="$Width"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="/Settings/Axis/YAxis[@Name='Threshold']/Y/@Invert = 'false'" >
						<xsl:attribute name="y"><xsl:value-of select="$YPos + ((11-$THy) * ($Height div 11))"/></xsl:attribute>
						<xsl:attribute name="height"><xsl:value-of select="$THy * ($Height div 11)"/></xsl:attribute>
					</xsl:when>
					<xsl:otherwise >
						<xsl:attribute name="y"><xsl:value-of select="$YPos"/></xsl:attribute>
						<xsl:attribute name="height"><xsl:value-of select="(11-$THy) * ($Height div 11)"/></xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				
				<xsl:attribute name="style">
					<xsl:text>stroke-width:0.5; stroke:rgb(0,0,0); fill:rgb(</xsl:text>
					<xsl:value-of select="/Settings/Colors/Color[@Name='Threshold']"/>
					<xsl:text>)</xsl:text>
				</xsl:attribute>
			</xsl:element>
		</xsl:if>
		
		<!--Creates the different score Zone -->
		<xsl:variable name="Offset"><xsl:value-of select="0"/></xsl:variable>
		<xsl:if test="(/Settings/Visibility/Grid/Y != 'false')">			
				<xsl:call-template name="Zone">
					<xsl:with-param name="Ty"><xsl:value-of select="$Offset + (0 * $Height div 11)"/></xsl:with-param>
				</xsl:call-template>
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
		
		<!-- Creates the X scale at the bottom of the graph -->
		<xsl:for-each select="/Settings/Axis/XAxis/X">
			<!--X scale -->
			<xsl:if test="(/Settings/Visibility/Axis/X !='false')">
				<xsl:if test="not((position() = last()) and ((current() mod /Settings/Dimensions/Step) != 0))">					
					<xsl:element name="text">
						<xsl:attribute name="x"><xsl:value-of select="($XPos - 3) + ((current()-$FirstPointX) * $Width div $DeltaX)"/></xsl:attribute>
						<xsl:attribute name="y"><xsl:value-of select="$YPos + $Height + 10"/></xsl:attribute>
						<xsl:attribute name="style">fill:rgb(0,0,0);font-size:12;font-family:arial;font-style:normal;font-weight:normal</xsl:attribute>
						<xsl:attribute name="transform">
							<xsl:text>rotate(90</xsl:text>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="($XPos - 3) + ((current()-$FirstPointX) * $Width div $DeltaX) "/>
							<xsl:text>,</xsl:text>
							<xsl:value-of select="$YPos + $Height + 10"/>
							<xsl:text>)</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="format-number(current(), '####.##')"/>
					</xsl:element>			
					<xsl:element name="line">
						<xsl:attribute name="x1"><xsl:value-of select="$XPos  + ((current()-$FirstPointX) * $Width div $DeltaX)"/></xsl:attribute>
						<xsl:attribute name="y1"><xsl:value-of select="$YPos + $Height - 5"/></xsl:attribute>
						<xsl:attribute name="x2"><xsl:value-of select="$XPos  + ((current()-$FirstPointX) * $Width div $DeltaX)"/></xsl:attribute>
						<xsl:attribute name="y2"><xsl:value-of select="$YPos + $Height + 5"/></xsl:attribute>
						<xsl:attribute name="style">stroke:rgb(0,0,0);stroke-width:0.2</xsl:attribute>
					</xsl:element>
				</xsl:if>
			</xsl:if>
			<!--X Grid -->
			<xsl:if test="(/Settings/Visibility/Grid/X != 'false')">
				<xsl:element name="line">
					<xsl:attribute name="x1"><xsl:value-of select="$XPos  + ((current()-$FirstPointX) * $Width div $DeltaX)"/></xsl:attribute>
					<xsl:attribute name="y1"><xsl:value-of select="$YPos + $Height"/></xsl:attribute>
					<xsl:attribute name="x2"><xsl:value-of select="$XPos  + ((current()-$FirstPointX) * $Width div $DeltaX)"/></xsl:attribute>
					<xsl:attribute name="y2"><xsl:value-of select="$YPos "/></xsl:attribute>
					<xsl:attribute name="style">stroke:rgb(0,0,0);stroke-width:0.2;stroke-dasharray:0.5,0.5</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
		<!-- This code process every score line for each analysis ( RULA, RULADetails or both depending on options). 
		For each score line,  the points are listed like this :  x,y x,y x,y etc... and ouputed to the Graph.svg file.  You can check the 
		output by looking at the source file of Graph.svg.  At the end of each score line, a style tag adds the color to the line.
		The lines of the graph are created here.
		-->
		<xsl:for-each select="/Settings/Scores/Analysis[@Type=$Analysis]/Score">
			<xsl:variable name="ScName"><xsl:value-of select="current()"/></xsl:variable>
			<xsl:if test="(/Settings/Visibility/Lines/Line[@Name=$ScName]!='false')">
				<xsl:element name="polyline">
					<xsl:attribute name="points">
						<xsl:for-each select="/Settings/Graphs/Manikin[@Name=$Manikin]/Simulation[@Id=$Simulation]/Analysis[@Type=$Analysis]/Line[@Name=$ScName]/Point">
							<xsl:choose>
								<!-- If x < FirstPointX-->
								<xsl:when test="./X &lt; $FirstPointX" >
									<xsl:if test="position() != last()"><!-- If Point.X != FirstPointX-->
										<xsl:variable name="NPIndex"><xsl:value-of select="position()+1"/></xsl:variable>
										<xsl:if test="./..//Point[round($NPIndex)]/X &gt;= $FirstPointX">	<!-- If NextPoint.x >= FirstPointX so pass here only one time-->
											<xsl:call-template name="LineEquation" >
												<xsl:with-param name="X1" ><xsl:value-of select="./..//Point[round($NPIndex)]/X"/></xsl:with-param>
												<xsl:with-param name="Y1" ><xsl:value-of select="./..//Point[round($NPIndex)]/Y"/></xsl:with-param>
												<xsl:with-param name="X2" ><xsl:value-of select="./X"/></xsl:with-param>
												<xsl:with-param name="Y2" ><xsl:value-of select="./Y"/></xsl:with-param>
												<xsl:with-param name="X" ><xsl:value-of select="$FirstPointX"/></xsl:with-param>
												<xsl:with-param name="ScnName" ><xsl:value-of select="$ScName"/></xsl:with-param>
											</xsl:call-template>
											<xsl:text> </xsl:text>
										</xsl:if>									
									</xsl:if>							
								</xsl:when>
								<!-- If x > LastpointX-->
								<xsl:when test="./X &gt; $LastPointX" >
									<xsl:if test="position() != 1"><!-- If Point.X != FirstPointX -->
										<xsl:variable name="PPIndex"><xsl:value-of select="position()-1"/></xsl:variable>
										<xsl:if test="./..//Point[round($PPIndex)]/X &lt;= $LastPointX">	<!-- If PrevPoint.x <= LastPointX so pass here only one time-->
											<xsl:call-template name="LineEquation" >
												<xsl:with-param name="X1" ><xsl:value-of select="./..//Point[round($PPIndex)]/X"/></xsl:with-param>
												<xsl:with-param name="Y1" ><xsl:value-of select="./..//Point[round($PPIndex)]/Y"/></xsl:with-param>
												<xsl:with-param name="X2" ><xsl:value-of select="./X"/></xsl:with-param>
												<xsl:with-param name="Y2" ><xsl:value-of select="./Y"/></xsl:with-param>
												<xsl:with-param name="X" ><xsl:value-of select="$LastPointX"/></xsl:with-param>
												<xsl:with-param name="ScnName" ><xsl:value-of select="$ScName"/></xsl:with-param>
											</xsl:call-template>
											<xsl:text> </xsl:text>
										</xsl:if>									
									</xsl:if>																
								</xsl:when>								
								<xsl:otherwise>
								
								<!-- The x value is inside the graph region -->
								
								<!-- This code is generating point per point a polyline on the graphic for each score line.
								     Since, we want the graph to look like stairs, each time the YScore change value,
								     we add an extra point to create the effect.
								     Exemple :
								               x3====x4
								               =
								               = 
								     x1===x2===o
								    
								    X's are the real points values we want to add and o's are there to create the "stairs effect".
								    From x1 to x2,  we only have to add the current point(x1). From x2 to x3, we need to 
								    add 2 points : x2 and the o before getting to x3.
								-->
								
								    <!-- Fix a bug IR 0528728 by FHV -->
									<xsl:variable name="NextXTime" ><xsl:value-of select="./..//Point[round(position()+1)]/X"/></xsl:variable>
									<xsl:variable name="NextYScore" ><xsl:value-of select="./..//Point[round(position()+1)]/Y"/></xsl:variable>
									<xsl:variable name="CurrentXTime" ><xsl:value-of select="./X"/></xsl:variable>
									<xsl:variable name="CurrentYScore" ><xsl:value-of select="./Y"/></xsl:variable>
									
									<!-- Add a point in the graphic at the current location -->
									<xsl:call-template name="AddPoint" >
										<xsl:with-param name="XTime" ><xsl:value-of select="$CurrentXTime"/></xsl:with-param>
										<xsl:with-param name="YScore" ><xsl:value-of select="$CurrentYScore"/></xsl:with-param>
										<xsl:with-param name="ScnName" ><xsl:value-of select="$ScName"/></xsl:with-param>
								    </xsl:call-template>
								    
									<xsl:choose>
										<xsl:when test="($CurrentYScore != $NextYScore) and (./X != $LastPointX) and ($NextYScore != '')">
									        <!-- If the level change, add the extra point that creates the stairs effect -->
										    <xsl:call-template name="AddPoint" >
											    <xsl:with-param name="XTime" ><xsl:value-of select="$NextXTime"/></xsl:with-param>
											    <xsl:with-param name="YScore" ><xsl:value-of select="$CurrentYScore"/></xsl:with-param>
											    <xsl:with-param name="ScnName" ><xsl:value-of select="$ScName"/></xsl:with-param>
										    </xsl:call-template>
										</xsl:when>			
									</xsl:choose>
									<xsl:text> </xsl:text>
								</xsl:otherwise>
							</xsl:choose>				
						</xsl:for-each>	
					</xsl:attribute>
					<!-- Sets the current color depending on the settings of the score line -->
					<xsl:attribute name="style">
						<xsl:text>fill:none;stroke-width:</xsl:text>
						<xsl:value-of select="/Settings/Thickness/Lines/Line[@Name=$ScName]"/>
						<xsl:text>;stroke:rgb(</xsl:text>
						<xsl:value-of select="/Settings/Colors/Color[@Name=$ScName]"/>
						<xsl:text>)</xsl:text>
					</xsl:attribute>
				</xsl:element>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:if test="(/Settings/Visibility/Point/X = 'true') or (/Settings/Visibility/Point/Y = 'true')">
			<xsl:for-each select="/Settings/Scores/Analysis[@Type=$Analysis]/Score">
				<xsl:variable name="ScName"><xsl:value-of select="current()"/></xsl:variable>			
				<xsl:for-each select="/Settings/Graphs/Manikin[@Name=$Manikin]/Simulation[@Id=$Simulation]/Analysis[@Type=$Analysis]/Line[@Name=$ScName]/Point">
					<xsl:if test="./X &gt;= $FirstPointX and ./X &lt;= $LastPointX">
						<xsl:variable name="YScore"><xsl:value-of select="./Y"/></xsl:variable>
						<xsl:variable name="Yvalue"><xsl:value-of select="(/Settings/Axis/YAxis[@Name=$ScName]/Y[@Score=$YScore])"/></xsl:variable>
						<xsl:variable name="RealX"><xsl:value-of select="((./X - $FirstPointX) div $DeltaX * $Width) + $XPos"/></xsl:variable>
						<xsl:variable name="RealY"><xsl:value-of select="($YPos + $Height) - ((($Yvalue ) * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScName]) * $Pixels)) - 3"/></xsl:variable>
						<xsl:call-template name="AddCoord" >
							<xsl:with-param name="XValue" ><xsl:value-of select="./X"/></xsl:with-param>
							<xsl:with-param name="YValue" ><xsl:value-of select="./Y"/></xsl:with-param>
							<xsl:with-param name="XCoord" ><xsl:value-of select="$RealX - 15"/></xsl:with-param>
							<xsl:with-param name="YCoord" ><xsl:value-of select="$RealY - 10"/></xsl:with-param>
						</xsl:call-template>
						<xsl:element name="circle">
							<xsl:attribute name="cx"><xsl:value-of select="$RealX"/></xsl:attribute>
							<xsl:attribute name="cy"><xsl:value-of select="$RealY"/></xsl:attribute>
							<xsl:attribute name="r">2</xsl:attribute>
							<xsl:attribute name="style">fill:rgb(0,0,0)</xsl:attribute>
						</xsl:element>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</svg>		
</xsl:template>

<!-- Creates the different zone on the graph -->
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

<xsl:template name="LineEquation">
	<xsl:param name="X1"/>
	<xsl:param name="Y1"/>
	<xsl:param name="X2"/>
	<xsl:param name="Y2"/>
	<xsl:param name="X"/>
	<xsl:param name="ScnName"/>	
	<xsl:choose>
		<xsl:when test="$Y1 = $Y2" >
			<xsl:call-template name="AddPoint" >
				<xsl:with-param name="XTime" ><xsl:value-of select="$X"/></xsl:with-param>
				<xsl:with-param name="YScore" >	<xsl:value-of select="$Y1"/></xsl:with-param>
				<xsl:with-param name="ScnName" ><xsl:value-of select="$ScnName"/></xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="M"><xsl:value-of select="($Y2 - $Y1) div ($X2 - $X1)"/></xsl:variable>
			<xsl:variable name="B"><xsl:value-of select="$Y1 - ($M * $X1)"/></xsl:variable>												
			<xsl:variable name="Y"><xsl:value-of select="($M * $X) + $B"/></xsl:variable>
			<xsl:variable name="RatioY"><xsl:value-of select="($Y - $Y1) div ($Y2 - $Y1)"/></xsl:variable>
			<xsl:variable name="Y1Score"><xsl:value-of select="(/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score=$Y1])"/></xsl:variable>
			<xsl:variable name="Y2ScoreTemp"><xsl:value-of select="(/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score=$Y2])"/></xsl:variable>
			
			<!-- 
			This is a bug fix,  the Wrist and Arm score wasn't generated proprely.
			
			If the second Y score value is equal to Nan,  it's impossible to generate the line equation.
			This case can happen for the first and last coordinate of the stroke.  This problem only appears
			if we change the interval not starting at 0.0s , for example  0.5s to 0.9s.
			To avoid this, if the second(last) Y value is NaN,  we replace it with the current (first) Y value.  -->
			
			<xsl:variable name="Y2Score">
            <xsl:choose>
            <xsl:when test="contains(number($Y2ScoreTemp),'NaN')">
            <xsl:value-of select="$Y1Score"/>
            </xsl:when>
            <xsl:otherwise>
            <xsl:value-of select="$Y2ScoreTemp"/>
            </xsl:otherwise>
            </xsl:choose>
            </xsl:variable>
			
			<!-- x value-->
			<xsl:text> </xsl:text>
			<xsl:value-of select="(($X - $FirstPointX) div $DeltaX * $Width) + $XPos"/>
			<xsl:text>,</xsl:text>	
	
			<!-- y value-->
			<xsl:choose>
				<xsl:when test="$Y1Score = 'NaN' and $Y2Score = 'NaN'" >
					<xsl:variable name="YValueAxis"><xsl:value-of select="/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score='bads']"/></xsl:variable>
					<xsl:value-of select="($YPos + $Height) - (($YValueAxis * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/>
				</xsl:when>
				<xsl:when test="$Y1Score = 'NaN' and $Y2Score != 'NaN'" >
					<xsl:variable name="YValueAxis"><xsl:value-of select="($RatioY * ($Y2Score - (/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score='bads']))) + (/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score='bads'])"/></xsl:variable>
					<xsl:value-of select="($YPos + $Height) - (($YValueAxis * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/>
				</xsl:when>
				<xsl:when test="$Y1Score != 'NaN' and $Y2Score = 'NaN'" >
					<xsl:variable name="YValueAxis"><xsl:value-of select="($RatioY * ((/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score='bads']) - $Y1Score)) + $Y1Score"/></xsl:variable>
					<xsl:value-of select="($YPos + $Height) - (($YValueAxis * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/>
				</xsl:when>
				<xsl:when test="$Y1Score = $Y2Score " >
					<xsl:variable name="YValueAxis"><xsl:value-of select="$Y1Score"/></xsl:variable>
					<xsl:value-of select="($YPos + $Height) - (($YValueAxis * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/>
				</xsl:when>
				<xsl:otherwise >
					<xsl:variable name="YValueAxis"><xsl:value-of select="($RatioY * ($Y2Score - $Y1Score)) + $Y1Score"/></xsl:variable>
					<xsl:value-of select="($YPos + $Height) - (($YValueAxis * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- This adds a point into the graph at the location( XTime, YScore) for the analysis specified
in the variable scnName ( ex : Wrist score ).
-->
<xsl:template name="AddPoint">
	<xsl:param name="XTime"/>
	<xsl:param name="YScore"/>
	<xsl:param name="ScnName"/>
	<xsl:variable name="Yvalue"><xsl:value-of select="(/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score=$YScore])"/></xsl:variable>
    <xsl:variable name="RealTestX"><xsl:value-of select="(($XTime - $FirstPointX) div $DeltaX * $Width) + $XPos"/></xsl:variable>
    
	<xsl:variable name="RealX">
	    <xsl:choose>
	    <xsl:when test="$RealTestX &gt; $Width">
	        <xsl:value-of select="$Width + 5"/>
	    </xsl:when>
	    <xsl:otherwise>
	        <xsl:value-of select="(($XTime - $FirstPointX) div $DeltaX * $Width) + $XPos"/>
	    </xsl:otherwise>
	    </xsl:choose>
	</xsl:variable>
	
	<xsl:choose>
		<!-- Peut causer des problemes si la node 'Score' contient pas un nombre (donc si ca contient une string)-->
        <xsl:when test="($Yvalue != 'NaN') and ($Yvalue != '')">
            <xsl:variable name="RealY"><xsl:value-of select="($YPos + $Height) - ((($Yvalue ) * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/></xsl:variable>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$RealX"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$RealY"/>
			<xsl:text> </xsl:text>		
        </xsl:when>
        <xsl:otherwise >
			<!-- Score non valide donc Yaxis ds la Score 10-->
            <xsl:variable name="RealY"><xsl:value-of select="($YPos + $Height) - (((/Settings/Axis/YAxis[@Name=$ScnName]/Y[@Score='Bads']) * ($Height div 11)) + ((/Settings/Offsets/Analysis[@Type=$Analysis]/Offset[@Name=$ScnName]) * $Pixels)) - 3"/></xsl:variable>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$RealX"/>
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$RealY"/>
			<xsl:text> </xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
<xsl:template name="AddCoord">
	<xsl:param name="XValue"/>
	<xsl:param name="YValue"/>
	<xsl:param name="XCoord"/>
	<xsl:param name="YCoord"/>
	<xsl:element name="text">
	<xsl:choose>
		<xsl:when test="(/Settings/Visibility/Point/X = 'true') and (/Settings/Visibility/Point/Y = 'false')">
				<xsl:attribute name="x"><xsl:value-of select="$XCoord"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$YCoord"/></xsl:attribute>
				<xsl:attribute name="style">fill:rgb(0,0,0);font-size:8</xsl:attribute>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="$XValue"/>
				<xsl:text>)</xsl:text>
		</xsl:when>
		
		<xsl:when test="(/Settings/Visibility/Point/X = 'false') and (/Settings/Visibility/Point/Y = 'true')">
				<xsl:attribute name="x"><xsl:value-of select="$XCoord"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$YCoord"/></xsl:attribute>
				<xsl:attribute name="style">fill:rgb(0,0,0);font-size:8</xsl:attribute>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="$YValue"/>
				<xsl:text>)</xsl:text>
		</xsl:when>
		
		<xsl:when test="(/Settings/Visibility/Point/X = 'true') and (/Settings/Visibility/Point/Y = 'true')">
				<xsl:attribute name="x"><xsl:value-of select="$XCoord"/></xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$YCoord"/></xsl:attribute>
				<xsl:attribute name="style">fill:rgb(0,0,0);font-size:8</xsl:attribute>
				<xsl:text>(</xsl:text>
				<xsl:value-of select="$XValue"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="$YValue"/>
				<xsl:text>)</xsl:text>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
</xsl:template>
</xsl:stylesheet>

