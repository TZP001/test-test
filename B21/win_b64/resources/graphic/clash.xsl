<?xml version = "1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/">

		<HTML>
			<BODY>
				<STYLE>
				    .Entete {font: 40 pt bold; color: black; text-align: center}
					.ClashResult {font: 10 pt ; color: black; text-align: right; font-style:oblique}
					.Interference {font: 12pt arial; color: red; font-style:oblique}
					.Date {font: 10 pt ; color: red; text-align: right; font-style:oblique}
					.URLdef {font: 10 pt ; color = blue;text-decoration: underline;font-style:italic}
					.Normal {text-align: left;text-align: bottom}
					.SpecTitle {font: 20pt; color:black; text-align: left;font-style:italic}
				</STYLE>
				<xsl:apply-templates/>
				<BR/><BR/>
				<xsl:for-each select="ClashResult/ClashResultSpec/Interference">

				<xsl:element name="A">
					<xsl:attribute name="NAME"><xsl:value-of select="@NumInterf"/></xsl:attribute>
					<HR/>
				</xsl:element>

				<BR/><BR/>
				<DIV class="SpecTitle" ALIGN="LEFT">
				Result Description - <xsl:value-of select="@NumInterf"/>
				</DIV>
				<BR/><BR/><BR/><BR/>
				<TABLE BORDER="1" ALIGN="CENTER" BGCOLOR="#FFFFCC" WIDTH="90%">
					<CAPTION>Interference resume</CAPTION>
					<TBODY class="ClashResult">

				<TR ALIGN="CENTER">
					<TH>Product 1</TH>
					<TH>Product 2</TH>
					<TH>Type</TH>
					<TH>Value</TH>
					<TH>Status</TH>
					<TH>Clash Comment</TH>
				</TR>

		<TR ALIGN="CENTER">
			<TD><xsl:value-of select="@Product1Name"/></TD>
			<TD><xsl:value-of select="@Product2Name"/></TD>
			<TD><xsl:value-of select="@ResultType"/></TD>
			<TD><xsl:value-of select="@Value"/></TD>
			<TD ALIGN="RIGHT"><xsl:value-of select="@Status"/>
			
			<xsl:if test="@Status[.='Relevant']">
			<IMG src="I_RedLightXML.bmp" BORDER="0" />
			</xsl:if>

			<xsl:if test="@Status[.='Not inspected']">
			<IMG src="I_YellowLightXML.bmp" BORDER="0" />
			</xsl:if>
			<xsl:if test="@Status[.='Irrelevant']">
			<IMG src="I_GreenLightXML.bmp" BORDER="0" />
			</xsl:if>
			
			</TD>
			<TD><xsl:value-of select="Comment"/></TD>
		</TR>
</TBODY>
</TABLE>
<BR/><BR/><BR/>
<DIV class="URLdef" ALIGN="CENTER">
		<IMG BORDER="0">
					<xsl:attribute name="SRC">
					<xsl:value-of select="Picture/@HRef"/>
					</xsl:attribute>
					</IMG>

			<BR/><BR/><BR/><BR/>
		<A HREF="#MAIN">Return to global results</A>
			<BR/>
		</DIV>

					<BR/><BR/><BR/>
				</xsl:for-each>
				<HR/>
			</BODY>
		</HTML>
	</xsl:template>




	<xsl:template match="ClashResult">
		<DIV class="ClashResult">
			Created by
			<xsl:value-of select="@Responsible"/>
		</DIV>
		<DIV class="Date">
			<xsl:value-of select="Date/@Month"/> /
			<xsl:value-of select="Date/@Day"/> /
			<xsl:value-of select="Date/@Year"/>,
			<xsl:value-of select="Date/@Hour"/>:
			<xsl:value-of select="Date/@Minute"/>:
			<xsl:value-of select="Date/@Seconde"/>
			<HR/><BR/>
		</DIV>
		<DIV class="Normal">
			<A href="http://www.dassault-systemes.com"><IMG src="dslogo.GIF" BORDER="0" /></A>
			<BR/>
		</DIV>
		<DIV class="Entete">
			Clash Publish
			<BR/><BR/>
		</DIV>

		<DIV class="Interference">
		<DL>
		<xsl:apply-templates/>
		</DL>
		</DIV>
	</xsl:template>		


	<xsl:template match="ClashSpec">
			<DT class="SpecTitle">
				<xsl:value-of select="@Name"/>	
			</DT>
			<BR/>
			<BR/>
			<DD>
				<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="50%">
					<CAPTION> <xsl:value-of select="@TabTitle"/> </CAPTION>
					<TBODY class="ClashResult">
					<TR ALIGN="CENTER">
						<TH>Selection Mode</TH>
						<TH>Computation Mode</TH>
							<xsl:if test="@CaseOfCalc[.!='Clash + Contact']">
								<TH>Clearance Distance</TH>
							</xsl:if>
					</TR>
					<TR ALIGN="LEFT">
						<TD><xsl:value-of select="@SelectMode"/></TD>
						<TD><xsl:value-of select="@CaseOfCalc"/></TD>
							<xsl:if test="@CaseOfCalc[.!='Clash + Contact']">
								<TD><xsl:value-of select="@DistanceClearance"/></TD>
							</xsl:if>
					</TR>
					</TBODY>
				</TABLE>
			</DD>
			<BR/>
			<BR/>
				<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="50%">
					<CAPTION> <xsl:value-of select="@TabListTitle"/> </CAPTION>
					<TBODY class="ClashResult">
					<TR ALIGN="CENTER">
						<TH>Selection 1</TH>
						<TH>Selection 2</TH>
					</TR>
					<xsl:apply-templates/>
					</TBODY>
				</TABLE>
			<BR/>
				<A NAME="MAIN">	<BR/></A>
			<BR/>
	</xsl:template>		

	<xsl:template match="ClashResultSpec">
			<DT class="SpecTitle">
				 Computation Result 
			</DT>
			<BR/>
			<BR/>
			<DD>
			<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="90%">
				<CAPTION> <xsl:value-of select="@Chaine"/> </CAPTION>
				<TBODY class="ClashResult">
				<TR ALIGN="CENTER">
					<TH>Interference</TH>
					<TH>Product 1</TH>
					<TH>Product 2</TH>
					<TH>Type</TH>
					<TH>Value</TH>
					<TH>Status</TH>
					<TH>Clash Comment</TH>
				</TR>
				<xsl:apply-templates/>
				</TBODY>
			</TABLE>
			</DD>
		
	</xsl:template>				

	<xsl:template match="Interference">
		<TR ALIGN="LEFT">
			<TD class="URLDef" ALIGN="CENTER" BGCOLOR="WHITE" >
				<A><xsl:attribute name="HREF">
					#<xsl:value-of select="@NumInterf"/>
					</xsl:attribute>
					<IMG BORDER="0">
					<xsl:attribute name="SRC">
					<xsl:value-of select="Picture/@Preview"/>
					</xsl:attribute>
					</IMG>
				</A>


				</TD>
			<TD><xsl:value-of select="@Product1Name"/></TD>
			<TD><xsl:value-of select="@Product2Name"/></TD>
			<TD><xsl:value-of select="@ResultType"/></TD>
			<TD><xsl:value-of select="@Value"/></TD>
			<TD ALIGN="RIGHT"><xsl:value-of select="@Status"/>
			
			<xsl:if test="@Status[.='Relevant']">
			<IMG src="I_RedLightXML.bmp" BORDER="0" />
			</xsl:if>

			<xsl:if test="@Status[.='Not inspected']">
			<IMG src="I_YellowLightXML.bmp" BORDER="0" />
			</xsl:if>
			<xsl:if test="@Status[.='Irrelevant']">
			<IMG src="I_GreenLightXML.bmp" BORDER="0" />
			</xsl:if>
			
			</TD>
			<TD><xsl:value-of select="Comment"/></TD>
		</TR>
	</xsl:template>

	<xsl:template match="Product">
		<TR ALIGN="LEFT">
			<TD><xsl:value-of select="@Name1"/></TD>
			<TD><xsl:value-of select="@Name2"/></TD>
		</TR>
	</xsl:template>

</xsl:stylesheet>
