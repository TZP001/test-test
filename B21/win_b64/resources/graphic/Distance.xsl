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

				<HR/>
			</BODY>
		</HTML>
	</xsl:template>

	<xsl:template match="DistanceElement">
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
			Distance Publish
			<BR/><BR/>
		</DIV>

		<DIV class="Interference">
		<DL>
		<xsl:apply-templates/>
		</DL>
		</DIV>
	</xsl:template>		


	<xsl:template match="DistanceSpec">
			<DT class="SpecTitle">
				<xsl:value-of select="@Name"/>	
			</DT>
			<BR/>
			<BR/>
			<DD>
				<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="50%">
					<CAPTION>Distance Computation Specification</CAPTION>
					<TBODY class="ClashResult">
					<TR ALIGN="CENTER">
						<TH>Selection Mode</TH>
						<TH>Computation Mode</TH>
							<xsl:if test="@ComputationMode[.='DISTANCE_FIT_CHECK']">
								<TH>Accuracy</TH>
								<TH>Minimum Distance</TH>
								<TH>Maximum Distance</TH>
							</xsl:if>
					</TR>
					<TR ALIGN="LEFT">
							<xsl:if test="@SelectionMode[.='DISTANCE_2LISTS']">
								<TD> Between two selections </TD>
							</xsl:if>
							<xsl:if test="@SelectionMode[.='DISTANCE_INSIDE']">
								<TD> Inside one selection </TD>
							</xsl:if>
							<xsl:if test="@SelectionMode[.='DISTANCE_OUTSIDE']">
								<TD> Selection against all </TD>
							</xsl:if>

							<xsl:if test="@ComputationMode[.='DISTANCE_FIT_CHECK']">
								<TD> Band analysis </TD>
							</xsl:if>
							<xsl:if test="@ComputationMode[.='DISTANCE_VECTOR']">
								<TD> Distance along a vector </TD>
							</xsl:if>
							<xsl:if test="@ComputationMode[.='DISTANCE_OUTSIDE']">
								<TD> Minimum distance </TD>
							</xsl:if>

							<xsl:if test="@ComputationMode[.='DISTANCE_FIT_CHECK']">
								<TD><xsl:value-of select="@Accuracy"/></TD>
								<TD><xsl:value-of select="@MinimalDist"/></TD>
								<TD><xsl:value-of select="@MaximalDist"/></TD>
							</xsl:if>
					</TR>
					</TBODY>
				</TABLE>
			</DD>
			<BR/>
			<BR/>
				<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="50%">
					<CAPTION>Products Selected</CAPTION>
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

	<xsl:template match="DistanceResult">
			<DT class="SpecTitle">
				 Computation Result 
			</DT>
			<BR/>
			<BR/>
			<DD>
			<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="90%">
				<CAPTION> Geometrical Computation </CAPTION>
				<TBODY class="ClashResult">
				<TR ALIGN="CENTER">
					<TH>Minimum Distance Value</TH>
					<TH>Distance Comment</TH>
				</TR>
				<TR ALIGN="LEFT">
					<TD><xsl:value-of select="@MinimalDistance"/></TD>
					<TD><xsl:value-of select="Comment/@DistComment"/></TD>
				</TR>
				</TBODY>
			</TABLE>
			<BR/>
			<xsl:apply-templates/>
			</DD>

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
		
	</xsl:template>	

	<xsl:template match="GeometricAspect">
				<BR/>
			<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="90%">
				<CAPTION> Points Realising the Minimum Distance </CAPTION>
				<TBODY class="ClashResult">
				<TR ALIGN="CENTER">
					<TH> X </TH>
					<TH> Y </TH>
					<TH> Z </TH>
					<xsl:apply-templates/>
				</TR>
				</TBODY>
			</TABLE>
			<BR/>
	</xsl:template>	
					
	<xsl:template match="SelectedProducts">
	<BR/>
			<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="90%">
				<CAPTION> Computation Resume </CAPTION>
				<TBODY class="ClashResult">
				<TR ALIGN="CENTER">
					<TH>Product 1</TH>
					<TH>Product 2</TH>
				</TR>
				<xsl:apply-templates/>
				</TBODY>
			</TABLE>
	<BR/>
	</xsl:template>				

	<xsl:template match="Point">
				<TR ALIGN="LEFT">
		<TD><xsl:value-of select="@xMin"/></TD>
		<TD><xsl:value-of select="@yMin"/></TD>
		<TD><xsl:value-of select="@zMin"/></TD>
				</TR>
	</xsl:template>				

	<xsl:template match="ProductList">
		<TR ALIGN="LEFT">
			<xsl:if test="@Group[.='1']">
				<TD><xsl:value-of select="@ProdName"/></TD>
				<TD>No Product</TD>
			</xsl:if>
			<xsl:if test="@Group[.='2']">
				<TD>No Product</TD>
				<TD><xsl:value-of select="@ProdName"/></TD>
			</xsl:if>
		</TR>
	</xsl:template>

</xsl:stylesheet>
