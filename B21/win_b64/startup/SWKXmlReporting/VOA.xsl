<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output version="1.0" method="html" indent="no" encoding="UTF-8"/>
	<xsl:variable name="XML1" select="/"/>
	<xsl:template match="/">
		<html>
			<head>
        <title>VOA Report</title>
				<style type="text/css">
					<xsl:comment>@import  url("D:\temp\Reporting-XML\style.css");
ProjectHeader { background-color:#6e74bf;
border:solid 0 #000;
border-bottom-width:2x;
border-left-width:2x;
border-right-width:2x;
border-top-width:2x;
 }</xsl:comment>
				</style>
			</head>
			<body>
				<xsl:for-each select="$XML1">
					<br/>
					<h1 style="background-color:#7f95b7; border:solid 0 #000; border-bottom-width:thin; border-left-width:thin; border-right-width:thin; border-top-width:thin; color:white; ">
						<span style="background-color:solid 0 #000; border:solid 0 #000; ">
							<xsl:text>Report Identification</xsl:text>
						</span>
					</h1>
					<table border="0" width="100%">
						<tbody>
							<tr>
								<td width="65">
									<span>
										<xsl:text>Date:</xsl:text>
									</span>
								</td>
								<td>
									<span>
                    <xsl:for-each select="Report">
                      <xsl:value-of select="./@Date"/>
                    </xsl:for-each>
                  </span>
									<br/>
								</td>
							</tr>
                <tr>
								<td width="65">
									<span>
										<xsl:text>Name:</xsl:text>
									</span>
								</td>
								<td>
                  <xsl:for-each select="Report">
                    <xsl:value-of select="./@Name"/>
                  </xsl:for-each>
								</td>
							</tr>
						</tbody>
					</table>
          <!-- Test if there are any packages -->
          <xsl:if test="count(  /Report/Package  ) >= 1">
            <br/>
            <h1 style="background-color:#6e74bf; border:solid 0 #000; border-bottom-width:thin; border-left-width:thin; border-right-width:thin; border-top-width:thin; color:white; ">
						<span>
							<xsl:text>Object Identification</xsl:text>
						</span>
					</h1>
					<table border="0" width="100%">
						<tbody>
							<tr bgcolor="#2400c0">
								<td width="13">
									<span style="color:white; ">
										<xsl:text>Packages</xsl:text>
									</span>
								</td>
								<td style="color:white; ">
									<span>
										<xsl:value-of select="count(  /Report/Package  )"/>
									</span>
									<span style="color:white; ">
										<xsl:text> Package(s)</xsl:text>
									</span>
									<br/>
								</td>
							</tr>
							<tr>
								<td colspan="2" width="735">

									<br/>
									<table border="0">
										<tbody>
											<tr>
												<td bgcolor="#bfc7dd">
													<span>
														<xsl:text>Dimensions \ Packages</xsl:text>
													</span>
												</td>
												<xsl:for-each select="Report">
													<xsl:for-each select="Package">
														<xsl:choose>
															<xsl:when test="position() mod 2">
																<td bgcolor="#d9eafb">
																	<xsl:for-each select="Name">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</xsl:when>
															<xsl:otherwise>
																<td bgcolor="#bfc7dd">
																	<xsl:for-each select="Name">
																		<xsl:apply-templates/>
																	</xsl:for-each>
																</td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:for-each>
												</xsl:for-each>
												<td/>
											</tr>
											<tr>
												<xsl:for-each select="Report">
													<xsl:for-each select="Package">

														<xsl:choose>
															<xsl:when test="position() = 1">
																<td bgcolor="#d9eafb">
																	<table border="0">
																		<tbody>
																			<xsl:for-each select="Dimension">
																				<tr>
																					<td>
																						<xsl:for-each select="Name">
																							<xsl:apply-templates/>
																						</xsl:for-each>
																					</td>
																				</tr>
																			</xsl:for-each>
																		</tbody>
																	</table>
																</td>
																<td bgcolor="#bfc7dd">
																	<table border="0">
																		<tbody>
																			<xsl:for-each select="Dimension">
																				<tr>
																					<td>
																						<xsl:for-each select="Value">
																							<xsl:apply-templates/>
																						</xsl:for-each>
																					</td>
																				</tr>
																			</xsl:for-each>
																		</tbody>
																	</table>
																</td>


															</xsl:when>
															<xsl:otherwise>
																<xsl:choose>
																<xsl:when test="position() mod 2">
																<td bgcolor="#bfc7dd">
																	<table border="0">
																		<tbody>
																			<xsl:for-each select="Dimension">
																				<tr>
																					<td>
																						<xsl:for-each select="Value">
																							<xsl:apply-templates/>
																						</xsl:for-each>
																					</td>
																				</tr>
																			</xsl:for-each>
																		</tbody>
																	</table>
																</td>
																</xsl:when>
																<xsl:otherwise>
																<td bgcolor="#d9eafb">
																	<table border="0">
																		<tbody>
																			<xsl:for-each select="Dimension">
																				<tr>
																					<td>
																						<xsl:for-each select="Value">
																							<xsl:apply-templates/>
																						</xsl:for-each>
																					</td>
																				</tr>
																			</xsl:for-each>
																		</tbody>
																	</table>
																</td>
																</xsl:otherwise>
																</xsl:choose>
															</xsl:otherwise>
														</xsl:choose>

													</xsl:for-each>
												</xsl:for-each>
												<td/>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
          <!-- End of if -->
          </xsl:if>
          <!-- Test if there are any packages -->
          <xsl:if test="count(  /Report/Position  ) >= 1">
          <br/>
					<br/>
					<h1 style="background-color:#6e74bf; border:solid 0 #000; border-bottom-width:thin; border-left-width:thin; border-right-width:thin; border-top-width:thin; color:white; ">
						<span>
							<xsl:text>Object Identification</xsl:text>
						</span>
					</h1>
					<table border="0" width="100%">
						<tbody>
							<tr bgcolor="#2400c0">
								<td style="color:white; ">
									<span>
										<xsl:text>Posture Prediction</xsl:text>
									</span>
								</td>
								<td style="color:white; " colspan="2">
									<span>
										<xsl:value-of select="count(  /Report/Position  )"/>
									</span>
									<span>
										<xsl:text> Posture Prediction(s)</xsl:text>
									</span>
								</td>
							</tr>
							<tr>
								<td/>
								<td/>
								<td/>
							</tr>
							<tr>
								<td colspan="3">
									<xsl:for-each select="Report">
										<xsl:for-each select="Position">
											<br/>
											<table border="0" width="100%">
												<tbody>
													<tr>
														<td bgcolor="#bfc7dd" width="35%">
															<span>
																<xsl:text>Posture Prediction Name</xsl:text>
															</span>
														</td>
														<td bgcolor="#d9eafb" colspan="2" width="65%">
															<xsl:for-each select="PositionName">
																<xsl:apply-templates/>
															</xsl:for-each>
														</td>
													</tr>
													<tr>
														<td bgcolor="#bfc7dd" width="35%">
															<span>
																<xsl:text>Manikins</xsl:text>
															</span>
														</td>
														<td colspan="2" width="65%">
															<table border="0">
																<thead>
																	<tr bgcolor="#bfc7dd">
																		<td width="50%">
																			<span>
																				<xsl:text>ManikinName</xsl:text>
																			</span>
																		</td>
																		<td width="240">
																			<span>
																				<xsl:text>InPosture</xsl:text>
																			</span>
																		</td>
																	</tr>
																</thead>
																<tbody>
																	<xsl:for-each select="Manikins">
																		<xsl:for-each select="Manikin">
																			<tr bgcolor="#d9eafb">
																				<td width="50%">
																					<xsl:for-each select="ManikinName">
																						<xsl:apply-templates/>
																					</xsl:for-each>
																				</td>
																				<td width="240">
																					<xsl:for-each select="InPosture">
																						<xsl:apply-templates/>
																					</xsl:for-each>
																				</td>
																			</tr>
																		</xsl:for-each>
																	</xsl:for-each>
																</tbody>
															</table>
														</td>
													</tr>
													<tr>
														<td bgcolor="#bfc7dd" width="35%">
															<span>
																<xsl:text>Package</xsl:text>
															</span>
														</td>
														<td bgcolor="#d9eafb" colspan="2" width="65%">
															<xsl:for-each select="Package">
																<xsl:apply-templates/>
															</xsl:for-each>
														</td>
													</tr>
													<tr>
														<td bgcolor="#bfc7dd" width="35%">
															<span>
																<xsl:text>Method</xsl:text>
															</span>
														</td>
														<td bgcolor="#d9eafb" colspan="2" width="65%">
															<xsl:for-each select="Method">
																<xsl:apply-templates/>
															</xsl:for-each>
														</td>
													</tr>
													<tr>
														<td bgcolor="#bfc7dd" width="35%">
															<span>
																<xsl:text>Seat</xsl:text>
															</span>
														</td>
														<td bgcolor="#d9eafb" colspan="2" width="65%">
															<xsl:for-each select="Seat">
																<xsl:apply-templates/>
															</xsl:for-each>
														</td>
													</tr>
												</tbody>
											</table>
										</xsl:for-each>
									</xsl:for-each>
								</td>
							</tr>
						</tbody>
					</table>
          <!-- End of if -->
          </xsl:if>
          <br/>
					<br/>
					<br/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
