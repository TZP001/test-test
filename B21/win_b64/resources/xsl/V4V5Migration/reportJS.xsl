<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="report">
		<html>
			<head>
				<script language="JavaScript">
					function showhide(obj,chaine) {
					
					chaine = "b" + chaine;
					if (document.getElementById(chaine).style.display=='none') { 
						document.getElementById(chaine).style.display='';
						obj.innerHTML='-';} 
					else { 
						document.getElementById(chaine).style.display='none';
						obj.innerHTML='+';} }
				</script>

			</head>
			<body>
				<h3>Interoperability Report</h3>
        GlobalInformation:
        <br />
        <xsl:apply-templates select="globalInfo" />
        <br />
        <xsl:apply-templates select="tree" />
        <br />
        <xsl:apply-templates select="endComment" />
    </body>
  </html>
</xsl:template>

<xsl:template match="endComment">
  <xsl:value-of select="." />
  <br />
</xsl:template>

<xsl:template match="globalInfo">
  <xsl:value-of select="." />
  <br />
</xsl:template>
  
	<xsl:template match="tree">

		<!-- Définition du nom de la balise DIV -->
		<xsl:variable name="num">
			<xsl:number level="any" from="/" />
		</xsl:variable>
		<xsl:variable name="count1" select="concat('div', $num )" />
		<div>
			<xsl:attribute name="id">
				<xsl:value-of select="$count1" />
			</xsl:attribute>
			<table>
				<tr bgcolor="#eeeeee">
          <xsl:apply-templates select="ElemTitle"/>
					<xsl:choose>
						<xsl:when test="./tree">
						<td width='20' align="right" bgcolor="white" onClick="showhide(this,this.parentElement.parentElement.parentElement.parentElement.id)">
						+</td>
						</xsl:when>
						<xsl:otherwise>
						<td width='20' align="right" bgcolor="white" >
						
						</td>
						</xsl:otherwise>
					</xsl:choose>

						
					<td width='300'>
						<xsl:apply-templates select="sourceData" />
            <xsl:value-of select="sourceData/name" />
            <xsl:if test="sourceData/id!=''">
              ,
            </xsl:if>
						<xsl:value-of select="sourceData/id" />
            <xsl:if test="sourceData/mainType!=''">
              (
            </xsl:if>
						<xsl:value-of select="sourceData/mainType" />
            <xsl:if test="sourceData/secondaryType!=''">
              ,
            </xsl:if>
						<xsl:value-of select="sourceData/secondaryType" />
            <xsl:if test="sourceData/mainType!=''">
              )
            </xsl:if>
					</td>
					<xsl:choose>
						<xsl:when test="@nodeStatus = 4">
							<td width='100' bgcolor="tomato" align="center">
								<B>KO</B>
							</td>
						</xsl:when>
            <xsl:when test="@nodeStatus = 3">
              <td width='100' bgcolor="tomato" align="center">
                <B>Unknown</B>
              </td>
            </xsl:when>
            <xsl:when test="@nodeStatus = 2">
              <td width='100' bgcolor="BlanchedAlmond" align="center">
                <B>Partial</B>
              </td>
            </xsl:when>
						<xsl:when test="@nodeStatus = 1">
							<td width='100' bgcolor="BlanchedAlmond" align="center">
								<B>Warning</B>
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td width='100' align="center">
								<B>OK</B>
							</td>
						</xsl:otherwise>
					</xsl:choose>
					<td width='200'>
						<xsl:for-each select="resultData">
							<xsl:value-of select="name" />
							<br />
						</xsl:for-each >
					</td>
					<td>
						<table>
							<xsl:for-each select="information">
								<tr>
									<td width='200'>
										<xsl:value-of select="type" />
										:
										<xsl:choose>
                      <xsl:when test="status = 4">
                        <font color="tomato">
                          <b>KO</b>
                        </font>
                      </xsl:when>
											<xsl:when test="status = 2">Partial</xsl:when>
											<xsl:when test="status = 1">Warning</xsl:when>
                      <xsl:when test="status = 0"><b>OK</b></xsl:when>
                        <xsl:otherwise>
                          <font color="tomato">
                            <b>Unknown</b>
                          </font>
											</xsl:otherwise>
										</xsl:choose>

										<br />
										<xsl:for-each select="commentHigh">
											<font color="red">
												<xsl:value-of select="." />
												<br />
											</font>
										</xsl:for-each >
										<xsl:for-each select="commentMedium">
											<font color="orange">
												<xsl:value-of select="." />
												<br />
											</font>
										</xsl:for-each >

										<xsl:for-each select="commentLow">
											<font color="green">
												<xsl:value-of select="." />
												<br />
											</font>
										</xsl:for-each >
									</td>
								</tr>

							</xsl:for-each >
						</table>
					</td>
				</tr>
			</table>
		</div>

		<!-- Définition du nom de la balise DIV -->
		<xsl:variable name="count2" select="concat('bdiv', $num )" />
		<div style="display:none">
			<xsl:attribute name="id">
				<xsl:value-of select="$count2" />
			</xsl:attribute>

			<xsl:apply-templates select="tree" />
		</div>

	</xsl:template>
	<xsl:template match="sourceData">
		<xsl:text> _ </xsl:text>
		<xsl:apply-templates select="../../sourceData" />
	</xsl:template>

</xsl:stylesheet>
