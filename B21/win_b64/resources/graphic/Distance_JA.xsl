<?xml version = "1.0" encoding="utf-8"?>
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
		<DIV class="ClashResult" xml:lang="ja">
			作成される
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
		<DIV class="Entete" xml:lang="ja">
			距離を公開
			<BR/><BR/>
		</DIV>

		<DIV class="Interference" xml:lang="ja">
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
					<CAPTION xml:lang="ja">距離計算仕様</CAPTION>
					<TBODY class="ClashResult">
					<TR ALIGN="CENTER">
						<TH xml:lang="ja">選択モード</TH>
						<TH xml:lang="ja">計算モード</TH>
							<xsl:if test="@ComputationMode[.='DISTANCE_FIT_CHECK']">
								<TH xml:lang="ja">精度</TH>
								<TH xml:lang="ja">最小距離</TH>
								<TH xml:lang="ja">最大距離</TH>
							</xsl:if>
					</TR>
					<TR ALIGN="LEFT">
							<xsl:if test="@SelectionMode[.='DISTANCE_2LISTS']">
								<TD xml:lang="ja"> 2つの選択の間 </TD>
							</xsl:if>
							<xsl:if test="@SelectionMode[.='DISTANCE_INSIDE']">
								<TD xml:lang="ja"> 1つの選択内 </TD>
							</xsl:if>
							<xsl:if test="@SelectionMode[.='DISTANCE_OUTSIDE']">
								<TD xml:lang="ja"> すべてを選択 </TD>
							</xsl:if>

							<xsl:if test="@ComputationMode[.='DISTANCE_FIT_CHECK']">
								<TD xml:lang="ja"> バンド分析 </TD>
							</xsl:if>
							<xsl:if test="@ComputationMode[.='DISTANCE_VECTOR']">
								<TD xml:lang="ja"> 距離は、ベクトルに沿って </TD>
							</xsl:if>
							<xsl:if test="@ComputationMode[.='DISTANCE_OUTSIDE']">
								<TD> 最小距離 </TD>
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
					<CAPTION xml:lang="ja">製品選択</CAPTION>
					<TBODY class="ClashResult">
					<TR ALIGN="CENTER">
						<TH xml:lang="ja">選択1</TH>
						<TH xml:lang="ja">選択2</TH>
					</TR>
					<xsl:apply-templates/>
					</TBODY>
				</TABLE>
			<BR/>
				<A NAME="MAIN">	<BR/></A>
			<BR/>
	</xsl:template>		

	<xsl:template match="DistanceResult">
			<DT class="SpecTitle" xml:lang="ja">
				 計算結果 
			</DT>
			<BR/>
			<BR/>
			<DD>
			<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="90%">
				<CAPTION xml:lang="ja"> 幾何学的計算 </CAPTION>
				<TBODY class="ClashResult">
				<TR ALIGN="CENTER">
					<TH xml:lang="ja">最小距離値</TH>
					<TH xml:lang="ja">距離コメント</TH>
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
		<A HREF="#MAIN" xml:lang="ja">世界的な結果に戻る</A>
			<BR/>
		</DIV>
		
	</xsl:template>	

	<xsl:template match="GeometricAspect">
				<BR/>
			<TABLE BORDER="1" BGCOLOR="#FFFFCC" WIDTH="90%">
				<CAPTION xml:lang="ja"> ポイントは、最短距離を実現する </CAPTION>
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
				<CAPTION xml:lang="ja"> 計算を再開 </CAPTION>
				<TBODY class="ClashResult">
				<TR ALIGN="CENTER">
					<TH xml:lang="ja">製品1</TH>
					<TH xml:lang="ja">製品2</TH>
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
				<TD >No Product</TD>
				<TD><xsl:value-of select="@ProdName"/></TD>
			</xsl:if>
		</TR>
	</xsl:template>

</xsl:stylesheet>
