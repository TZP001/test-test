<?xml version = "1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/TR/WD-xsl"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns="http://www.w3.org/TR/REC-html40"
	result-ns="">

<!-- feuille de style -->
<!-- =================================================================== -->
	<xsl:template match="/">
			<HTML>
			<BODY link="#0000FF" vlink="#800080" background="Cke_paterne.gif">
				<STYLE>
				    .Entete {font: 40 pt bold; color: blue; text-align: center}
					.Menu {font: 20 pt; text-align: right; text-align: bottom}
					.Normal {font: 10pt bold;	text-align: left;color: red; text-align: bottom}
					.Normal2 {font: 20pt bold;	text-align: left; color: green; text-align: bottom} 
					.Parameter {font: 14pt; color:red; text-align: left;font-style:italic}
				</STYLE>
				<BR/><BR/>
				<HR/>
				<xsl:apply-templates/>
				</BODY>
			</HTML>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="CheckReport">
		<IMG src="Cke_ds_logo.gif" BORDER="0"/>
		<DIV class="Entete">
		Check Report
		</DIV>
		<IMG BORDER="0" ALIGN="CENTER" WIDTH="80%" HEIGHT="80%">
			<xsl:attribute name="SRC">
			<xsl:value-of select="@Image"/>
			</xsl:attribute>
		</IMG>
		<OL>
			<DIV class="Menu">
			<a name = "top"></a>
			<xsl:for-each select= "CheckAdvisor | CheckExpert"> 
			<LI><A>
				<xsl:attribute name="HREF">
				#<xsl:value-of select="@Name"/>
			</xsl:attribute>
				<xsl:value-of select="@Name"/>
			</A>
			</LI>
			<BR/>
			</xsl:for-each>   
			</DIV>
		</OL>
		<TABLE BORDER="0" CELLSPACING = "0" CELLPADDING = "1" ALIGN="CENTER" WIDTH="70%">
		<CAPTION><EM><U>%Failed per Check</U></EM></CAPTION>
		<xsl:for-each select="CheckExpert"> 
			<TR><TD BGCOLOR="#FFFFCC" WIDTH="20%" ALIGN="CENTER"><xsl:value-of select="@Name"/></TD>
				<TD BGCOLOR="red" ALIGN="CENTER"><xsl:attribute name="COLSPAN"><xsl:value-of select="@nbCol"/></xsl:attribute></TD><xsl:value-of select="@nbObj"/> KO<TD><xsl:value-of select="@nbPourcent"/>%</TD>
			</TR>
			<TR></TR>
		</xsl:for-each>   
		</TABLE>
		<HR/>
		<xsl:apply-templates/>
	</xsl:template>
<!-- =================================================================== -->
	<xsl:template match="CheckAdvisor">
		<A>
			<xsl:attribute name="name"><xsl:value-of select="@Name"/></xsl:attribute>
		</A>
	  	<BR/> 
		<DIV class="Normal2">
		Check advisor: 
			 <TD>
				<xsl:value-of select="@Name" /> 
			</TD>
		</DIV>
		<TABLE BORDER = "1" CELLSPACING = "0" ALIGN="CENTER" WIDTH="50%">
		<CAPTION>Body</CAPTION>		
			 <TD>
				<xsl:value-of select="@Body" /> 
			</TD>
		</TABLE>
		<BR/>  
		<B>
		This check operate on : 
		</B>
		<UL>
		<xsl:apply-templates/>
		</UL>
		<xsl:if test="@Commentaire[.!='']">     
		<B>
		commentaire : 
		</B>
		<xsl:value-of select="@Commentaire" /> 
		<BR/>  
		</xsl:if>   
		<BR/>
		<HR/><a href = "#top">top</a>
	</xsl:template>
<!-- =================================================================== -->

	<xsl:template match="CheckExpert">

		<A>
		<xsl:attribute name="NAME"><xsl:value-of select="@Name"/></xsl:attribute>
		</A>
		<TABLE BORDER="1" CELLSPACING = "0" CELLPADDING = "10" ALIGN="CENTER" BGCOLOR="#FFFFCC" WIDTH="70%">
			<CAPTION>		
				<DIV class="Normal2">
				<xsl:choose>
				<xsl:when test="@Status[.='1']">     
					<IMG src="I_SmallCheckOK.bmp" BORDER="0" />
				</xsl:when>   
				<xsl:when test="@Status[.='0']">     
					<IMG src="I_SmallCheckKO.bmp" BORDER="0" />
				</xsl:when>   
				</xsl:choose>
					<xsl:value-of select="@Name" /> 
				</DIV>
			</CAPTION>
			<TR ALIGN="LEFT">
			<TH WIDTH="20%" ALIGN="CENTER">Comment</TH><TD>
				<xsl:attribute name="COLSPAN"><xsl:value-of select="@nbObj"/></xsl:attribute>
				<xsl:value-of select="@Commentaire"/></TD>
				<xsl:if test="@Status[.='0']">
					<TR ALIGN="CENTER"><TH>Input</TH><xsl:apply-templates select="ListObject" ></xsl:apply-templates></TR>
				</xsl:if>
			</TR>
		</TABLE>
	  	<BR/>
		<xsl:if test="@CorrectFunction[.!='']">
		<B>
		Correction information 
		</B><BR/>
		<xsl:value-of select="@CorrectFunction"/></xsl:if>
		<BR/>
		<xsl:apply-templates select="List">
		</xsl:apply-templates>   
		<BR/>
			You can also see : <BR/>
		<xsl:apply-templates select="ListURL">
		</xsl:apply-templates>   
		<HR/><a href = "#top">top</a>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="Parameter">
	<LI>
		<DIV class="Parameter">
		<xsl:value-of select="@Name" />
		<xsl:if test="@Value[.!='']"> = <xsl:value-of select="@Value"/></xsl:if>   
		</DIV>
		<xsl:if test="@Commentaire[.!='']"><xsl:value-of select="@Commentaire"/></xsl:if>
	</LI>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="List">
		<TABLE BORDER="1" CELLSPACING = "0" CELLPADDING = "10" ALIGN="CENTER" BGCOLOR="#FFFFCC" WIDTH="70%">
			<xsl:apply-templates/>
		</TABLE>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="Tuple">
		<TR><xsl:attribute name="COLSPAN"><xsl:value-of select="@SizeOfTuple"/></xsl:attribute>
		<TD VALIGN="CENTER" WIDTH="3%" HEIGHT="33" BGCOLOR="#FFFFCC">
			<xsl:choose>
			<xsl:when test="@Status[.='0']">   
				<IMG SRC="ansbad.gif" height="25" width="25"/>
			</xsl:when>
			<xsl:otherwise>   
				<IMG SRC="ansgood.gif" height="25" width="25"/>
			</xsl:otherwise>
			</xsl:choose>
		</TD>
		<xsl:apply-templates/></TR>
	</xsl:template>
<!-- =================================================================== -->

	<xsl:template match="TupleElement">
		 <TD ALIGN="CENTER">
			<xsl:value-of select="@Name" />
		</TD>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="ListObject">
			<xsl:apply-templates/>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="ObjectElement">
		 <TD ALIGN="CENTER">
		<xsl:value-of select="@Name" />
		</TD>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="ListURL">
			<xsl:apply-templates/>
	</xsl:template>

<!-- =================================================================== -->

	<xsl:template match="URL">
	 <A TARGET="_BLANK">
		<xsl:attribute name="HREF">
		<xsl:value-of select="@URLRef"/>
		</xsl:attribute>
			<xsl:value-of select="@NameURL"/>
	</A>
	<BR/>
	</xsl:template>

</xsl:stylesheet>
