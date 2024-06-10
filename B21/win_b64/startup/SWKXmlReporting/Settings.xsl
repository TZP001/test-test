<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Edited with XML Spy v4.2 -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/">
	<xsl:element name="Settings">
		<xsl:variable name="ForceLoadScore">Force Load Score</xsl:variable>
		<xsl:variable name="ForeArmScore">ForeArm Score</xsl:variable>
		<xsl:variable name="GlobalScore">Global Score</xsl:variable>
		<xsl:variable name="LegScore">Leg Score</xsl:variable>
		<xsl:variable name="MuscleScore">Muscle Score</xsl:variable>
		<xsl:variable name="NeckScore">Neck Score</xsl:variable>
		<xsl:variable name="NeckTrunkAndLegScore">Neck Trunk And Leg Score</xsl:variable>
		<xsl:variable name="PostureAScore">Posture A Score</xsl:variable>
		<xsl:variable name="PostureBScore">Posture B Score</xsl:variable>
		<xsl:variable name="TrunkScore">Trunk Score</xsl:variable>
		<xsl:variable name="UpperArmScore">Upper Arm Score</xsl:variable>
		<xsl:variable name="WristAndArmScore">Wrist And Arm Score</xsl:variable>
		<xsl:variable name="WristScore">Wrist Score</xsl:variable>
		<xsl:variable name="WristTwistScore">Wrist Twist Score</xsl:variable>
		<xsl:variable name="Threshold">Threshold</xsl:variable>
		<xsl:variable name="IntervalX">10</xsl:variable>
		
		<xsl:variable name="SelectMan"><xsl:value-of select="/Report/Manikin[1]/@Name"/></xsl:variable>
		<xsl:variable name="SelectSim"><xsl:value-of select="/Report/Manikin[1]/Simulation[1]/@Id"/></xsl:variable>
		<xsl:variable name="SelectAnal"><xsl:value-of select="/Report/Manikin[1]/Simulation[1]/Step[1]/Analysis[1]/@Type"/></xsl:variable>
		<!-- ** Default Setting, can be changed by the program ** -->
		<Dimensions>
			<Position>
				<X>5</X>
				<Y>0</Y>
			</Position>
			<Size>
				<X>600</X>
				<Y>380</Y>
			</Size>
			<Step><xsl:value-of select="$IntervalX"/></Step>
			<Lines>0.5</Lines>
		</Dimensions>
		<Selections>
			<Manikin><xsl:value-of select="$SelectMan"/></Manikin>
			<Simulation><xsl:value-of select="$SelectSim"/></Simulation>
			<Analysis><xsl:value-of select="$SelectAnal"/></Analysis>
			<Score><xsl:value-of select="$GlobalScore"/></Score>
		</Selections>
		<Scores>
			<Analysis Type="RULA">
				<Score><xsl:value-of select="$GlobalScore"/></Score>
				<Score><xsl:value-of select="$Threshold"/></Score>
			</Analysis>
			<Analysis Type="RULADetails">
				<Score><xsl:value-of select="$ForceLoadScore"/></Score>
				<Score><xsl:value-of select="$ForeArmScore"/></Score>
				<Score><xsl:value-of select="$GlobalScore"/></Score>
				<Score><xsl:value-of select="$LegScore"/></Score>
				<Score><xsl:value-of select="$MuscleScore"/></Score>
				<Score><xsl:value-of select="$NeckScore"/></Score>
				<Score><xsl:value-of select="$NeckTrunkAndLegScore"/></Score>
				<Score><xsl:value-of select="$PostureAScore"/></Score>
				<Score><xsl:value-of select="$PostureBScore"/></Score>
				<Score><xsl:value-of select="$TrunkScore"/></Score>
				<Score><xsl:value-of select="$UpperArmScore"/></Score>
				<Score><xsl:value-of select="$WristAndArmScore"/></Score>
				<Score><xsl:value-of select="$WristScore"/></Score>
				<Score><xsl:value-of select="$WristTwistScore"/></Score>
				<Score><xsl:value-of select="$Threshold"/></Score>
			</Analysis>
		</Scores>
		<Offsets>
			<Analysis Type="RULA">
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$Threshold"/></xsl:attribute>
					<xsl:text>0</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>
					<xsl:text>1</xsl:text>
				</xsl:element>
			</Analysis>
			<Analysis Type="RULADetails">
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$Threshold"/></xsl:attribute>
					<xsl:text>0</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>
					<xsl:text>1</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$ForceLoadScore"/></xsl:attribute>
					<xsl:text>2</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$ForeArmScore"/></xsl:attribute>
					<xsl:text>3</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$LegScore"/></xsl:attribute>
					<xsl:text>4</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$MuscleScore"/></xsl:attribute>
					<xsl:text>5</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$NeckScore"/></xsl:attribute>
					<xsl:text>6</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$NeckTrunkAndLegScore"/></xsl:attribute>
					<xsl:text>7</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$PostureAScore"/></xsl:attribute>
					<xsl:text>8</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$PostureBScore"/></xsl:attribute>
					<xsl:text>9</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$TrunkScore"/></xsl:attribute>
					<xsl:text>10</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$UpperArmScore"/></xsl:attribute>
					<xsl:text>11</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$WristAndArmScore"/></xsl:attribute>
					<xsl:text>12</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$WristScore"/></xsl:attribute>
					<xsl:text>13</xsl:text>
				</xsl:element>
				<xsl:element name="Offset">
					<xsl:attribute name="Name"><xsl:value-of select="$WristTwistScore"/></xsl:attribute>
					<xsl:text>14</xsl:text>
				</xsl:element>
			</Analysis>
		</Offsets>
		<Colors>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$ForceLoadScore"/></xsl:attribute>
				<xsl:text>148,0,211</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$ForeArmScore"/></xsl:attribute>
				<xsl:text>254,20,140</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>
				<xsl:text>254,254,0</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$LegScore"/></xsl:attribute>
				<xsl:text>34,139,34</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$MuscleScore"/></xsl:attribute>
				<xsl:text>176,48,96</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$NeckScore"/></xsl:attribute>
				<xsl:text>165,42,42</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$NeckTrunkAndLegScore"/></xsl:attribute>
				<xsl:text>85,107,47</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$PostureAScore"/></xsl:attribute>
				<xsl:text>72,61,139</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$PostureBScore"/></xsl:attribute>
				<xsl:text>70,130,180</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$TrunkScore"/></xsl:attribute>
				<xsl:text>64,224,208</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$UpperArmScore"/></xsl:attribute>
				<xsl:text>254,215,0</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$WristAndArmScore"/></xsl:attribute>
				<xsl:text>0,254,0</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$WristScore"/></xsl:attribute>
				<xsl:text>0,0,254</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$WristTwistScore"/></xsl:attribute>
				<xsl:text>216,191,216</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name"><xsl:value-of select="$Threshold"/></xsl:attribute>
				<xsl:text>200,200,200</xsl:text>
			</xsl:element>
			<xsl:element name="Color">
				<xsl:attribute name="Name">Background</xsl:attribute>
				<xsl:text>254,254,254</xsl:text>
			</xsl:element>
		</Colors>
		<Visibility>
			<Grid>
				<X>false</X>
				<Y>true</Y>
			</Grid>
			<Axis>
				<X>true</X>
				<Y>true</Y>
			</Axis>
			<Point>
				<X>false</X>
				<Y>false</Y>
			</Point>
			<Lines>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$ForceLoadScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$ForeArmScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$LegScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$MuscleScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$NeckScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$NeckTrunkAndLegScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$PostureAScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$PostureBScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$TrunkScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$UpperArmScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$WristAndArmScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$WristScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$WristTwistScore"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$Threshold"/></xsl:attribute>
					<xsl:text>true</xsl:text>
				</xsl:element>
			</Lines>
		</Visibility>
		<Thickness>
			<Lines>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$ForceLoadScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$ForeArmScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$LegScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$MuscleScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$NeckScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$NeckTrunkAndLegScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$PostureAScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$PostureBScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$TrunkScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$UpperArmScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$WristAndArmScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$WristScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$WristTwistScore"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
				<xsl:element name="Line">
					<xsl:attribute name="Name"><xsl:value-of select="$Threshold"/></xsl:attribute>
					<xsl:text>0.5</xsl:text>
				</xsl:element>
			</Lines>
		</Thickness>
		<!-- ** Default Axis ** -->
		<Axis>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$ForceLoadScore"/></xsl:attribute>
				<Y Score="0">0</Y>		<!-- Green -->
				<Y Score="1">3</Y>		<!-- Yellow -->
				<Y Score="2">5</Y>		<!-- Orange -->
				<Y Score="3">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->				
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$ForeArmScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">3</Y>		<!-- Yellow -->
				<Y Score="3">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">5</Y>		<!-- Orange -->
				<Y Score="6">6</Y>		<!-- Orange -->
				<Y Score="7">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$LegScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$MuscleScore"/></xsl:attribute>
				<Y Score="0">0</Y>		<!-- Green -->
				<Y Score="1">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$NeckScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$NeckTrunkAndLegScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">5</Y>		<!-- Orange -->
				<Y Score="6">6</Y>		<!-- Orange -->
				<Y Score="7">7</Y>		<!-- Red -->
				<Y Score="8">8</Y>		<!-- Red -->
				<Y Score="9">9</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$PostureAScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">5</Y>		<!-- Orange -->
				<Y Score="6">6</Y>		<!-- Orange -->
				<Y Score="7">7</Y>		<!-- Red -->
				<Y Score="8">8</Y>		<!-- Red -->
				<Y Score="9">9</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$PostureBScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">5</Y>		<!-- Orange -->
				<Y Score="6">6</Y>		<!-- Orange -->
				<Y Score="7">7</Y>		<!-- Red -->
				<Y Score="8">8</Y>		<!-- Red -->
				<Y Score="9">9</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$TrunkScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$UpperArmScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$WristAndArmScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">2</Y>		<!-- Green -->
				<Y Score="3">3</Y>		<!-- Yellow -->
				<Y Score="4">4</Y>		<!-- Yellow -->
				<Y Score="5">5</Y>		<!-- Orange -->
				<Y Score="6">6</Y>		<!-- Orange -->
				<Y Score="7">7</Y>		<!-- Red -->
				<Y Score="8">8</Y>		<!-- Red -->
				<Y Score="9">9</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->			
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$WristScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">3</Y>		<!-- Yellow -->
				<Y Score="3">5</Y>		<!-- Orange -->
				<Y Score="4">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$WristTwistScore"/></xsl:attribute>
				<Y Score="1">1</Y>		<!-- Green -->
				<Y Score="2">7</Y>		<!-- Red -->
				<Y Score="Bads">10</Y>	<!-- Red -->
			</xsl:element>
			<xsl:element name="YAxis">
			<xsl:attribute name="Name"><xsl:value-of select="$Threshold"/></xsl:attribute>
				<xsl:element name="Y">
				<xsl:attribute name="Score">Bads</xsl:attribute>
				<xsl:attribute name="Invert">false</xsl:attribute>
					<xsl:text>5</xsl:text>
				</xsl:element>
			</xsl:element>
			<!-- Create Xaxis -->
			<xsl:element name="XAxis">
				<xsl:variable name="NBStep"><xsl:value-of select="count(/Report/Manikin[@Name=$SelectMan]/Simulation[@Id=$SelectSim]//Step/Analysis[@Type=$SelectAnal])"/></xsl:variable>
				<xsl:variable name="FirstTime"><xsl:value-of select="/Report/Manikin[@Name=$SelectMan]/Simulation[@Id=$SelectSim]/Step[1]/Analysis[@Type=$SelectAnal]/./../@Time"/></xsl:variable>
				<xsl:variable name="LastTime"><xsl:value-of select="/Report/Manikin[@Name=$SelectMan]/Simulation[@Id=$SelectSim]/Step[round($NBStep)]/Analysis[@Type=$SelectAnal]/./../@Time"/></xsl:variable>
				<xsl:variable name="MidTime"><xsl:value-of select="(round($LastTime - $FirstTime - 1)) div 2"/></xsl:variable>
				<xsl:attribute name="Min"><xsl:value-of select="$FirstTime"/></xsl:attribute>
				<xsl:attribute name="Max"><xsl:value-of select="$LastTime"/></xsl:attribute>
				<xsl:attribute name="Interval"><xsl:value-of select="$MidTime"/></xsl:attribute>
				<X><xsl:value-of select="$FirstTime"/></X>				
				<X><xsl:value-of select="$FirstTime + $MidTime"/></X>
				<X><xsl:value-of select="$FirstTime + $MidTime + $MidTime"/></X>
				<X><xsl:value-of select="$LastTime"/></X>					
			</xsl:element>
		</Axis>
		<Graphs>
		<!-- For each Manikin in the Report -->
		<xsl:for-each select="/Report/Manikin">
			<xsl:variable name="CurManikin"><xsl:value-of select="./@Name"/></xsl:variable>
			<xsl:element name="Manikin">
				<xsl:attribute name="Name"><xsl:value-of select="$CurManikin"/></xsl:attribute>
				<!-- For each Simulation under the manikin -->
				<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation">
					<xsl:variable name="CurSimulation"><xsl:value-of select="./@Id"/></xsl:variable>
					<xsl:element name="Simulation">
						<xsl:attribute name="Id"><xsl:value-of select="$CurSimulation"/></xsl:attribute>
						<!-- Create all lines for RUlA-->
						<xsl:variable name="Rula">RULA</xsl:variable>
						<xsl:if test="0 != count(/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]//Step/Analysis[@Type=$Rula])">
						<xsl:element name="Analysis">
							<xsl:attribute name="Type"><xsl:value-of select="$Rula"/></xsl:attribute>
							<!-- Create each line -->
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$Rula]//Result[@Name=$GlobalScore]">
									<xsl:call-template name="CreatePoint"/>							
								</xsl:for-each>
							</xsl:element>
						</xsl:element>
						</xsl:if>
						<!-- Create all lines for RULADetails-->
						<xsl:variable name="RulaD">RULADetails</xsl:variable>
						<xsl:if test="0 != count(/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]//Step/Analysis[@Type=$RulaD])">
						<xsl:element name="Analysis">
							<xsl:attribute name="Type"><xsl:value-of select="$RulaD"/></xsl:attribute>
							<!-- Create each line -->
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$GlobalScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$GlobalScore]">
									<xsl:variable name="Pos"><xsl:value-of select="position()"/></xsl:variable>
									<xsl:call-template name="CreatePoint"/>    
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$UpperArmScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$UpperArmScore]">
									<xsl:call-template name="CreatePoint"/>       
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$ForeArmScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$ForeArmScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$WristScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$WristScore]">
									<xsl:call-template name="CreatePoint"/>         
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$WristTwistScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$WristTwistScore]">
									<xsl:call-template name="CreatePoint"/>      
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$PostureAScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$PostureAScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$MuscleScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$MuscleScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$ForceLoadScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$ForceLoadScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$WristAndArmScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$WristAndArmScore]">
									<xsl:call-template name="CreatePoint"/>       
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$NeckScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$NeckScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$TrunkScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$TrunkScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$LegScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$LegScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$PostureBScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$PostureBScore]">
									<xsl:call-template name="CreatePoint"/>       
								</xsl:for-each>
							</xsl:element>
							<xsl:element name="Line">
								<xsl:attribute name="Name"><xsl:value-of select="$NeckTrunkAndLegScore"/></xsl:attribute>			
								<xsl:for-each select="/Report/Manikin[@Name=$CurManikin]/Simulation[@Id=$CurSimulation]/Step/Analysis[@Type=$RulaD]//Result[@Name=$NeckTrunkAndLegScore]">
									<xsl:call-template name="CreatePoint"/>        
								</xsl:for-each>
							</xsl:element>	
						</xsl:element><!--/Analysis -->
						</xsl:if>
					</xsl:element><!--/Simulation -->
				</xsl:for-each>
			</xsl:element><!--/Manikin -->
		</xsl:for-each>			
	</Graphs>
    </xsl:element>
</xsl:template>
<xsl:template name="CreatePoint">
	<xsl:element name="Point">
		<xsl:element name="X">
			<xsl:value-of select="./../../../@Time"/>
		</xsl:element>
		<xsl:element name="Y">
			<xsl:value-of select="./Value"/>
		</xsl:element>
	</xsl:element>
</xsl:template>
<xsl:template name="CreateTimeLine">
	<xsl:param name="CurMan"/>
	<xsl:param name="CurSim"/>
	<xsl:param name="CurAnal"/>
	<xsl:for-each select="/Report/Manikin[@Name=$CurMan]/Simulation[@Id=$CurSim]//Step/Analysis[@Type=$CurAnal]">
		<xsl:element name="Time">
			<xsl:value-of select="./../@Time"/>
		</xsl:element>      
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
