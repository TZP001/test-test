<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:template match="/">
        <html>
            <head />
            <body><a name="top_of_page"></a>
                <span style="border-bottom-color:#F28411; border-bottom-style:solid; border-bottom-width:medium; font-family:Verdana; font-size:x-large; ">Massive Import result&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </span>
                <img border="0">
                    <xsl:attribute name="src"><xsl:text disable-output-escaping="yes">3ds.bmp</xsl:text></xsl:attribute>
                </img>
                <br />
                <br />
                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Choosen parameters:</span>
                <br />
                <table>
                    <tbody>
                        <tr>
                            <td width="273">
                                <span style="font-family:Verdana; margin-left:2cm; ">Object</span>
                            </td>
                            <td width="12">:</td>
                            <td width="466">
                                <xsl:for-each select="MassiveImport">
                                    <xsl:for-each select="@Object">
                                        <span style="font-family:Verdana; ">
                                            <xsl:value-of select="." />
                                        </span>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </td>
                        </tr>
                        <tr>
                            <td width="273">
                                <span style="font-family:Verdana; margin-left:2cm; ">User</span>
                            </td>
                            <td width="12">:</td>
                            <td width="466">
                                <xsl:for-each select="MassiveImport">
                                    <xsl:for-each select="@User">
                                        <span style="font-family:Verdana; margin-left:#cm; ">
                                            <xsl:value-of select="." />
                                        </span>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </td>
                        </tr>
                        <tr>
                            <td width="273">
                                <span style="font-family:Verdana; margin-left:2cm; ">Import mode</span>
                            </td>
                            <td width="12">:</td>
                            <td width="466">
                                <xsl:choose>
                                    <xsl:when test="MassiveImport/@Mode  = &quot;1&quot;">
                                        <span style="font-family:Verdana; ">V5 Master / VPM Slave</span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span style="font-family:Verdana; ">V5 Slave / VPM Master</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                        <tr>
                            <td width="273">
                                <span style="font-family:Verdana; margin-left:2cm; ">Update in work object</span>
                            </td>
                            <td width="12">:</td>
                            <td width="466">
                                <xsl:choose>
                                    <xsl:when test="MassiveImport/@UpdateInWork  = &quot;1&quot;">
                                        <span style="font-family:Verdana; ">Not overwriting inwork object if exists</span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span style="font-family:Verdana; ">Overwriting inwork object if exists</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <br />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Date:</span>
                <xsl:for-each select="MassiveImport">
                    <xsl:for-each select="@Date">
                        <span style="font-family:Verdana;">
                            <xsl:value-of select="."/>
                        </span>
                    </xsl:for-each>
                </xsl:for-each>
                <br/>
                <br/>
                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Overall result:</span>
                <span style="font-family:Verdana;"> Massive Import </span>
                <xsl:choose>
                    <xsl:when test="MassiveImport/@Status  = &quot;Succeeded&quot;">
                        <xsl:for-each select="MassiveImport">
                            <span style="font-family:Verdana; ">
                                <xsl:for-each select="@Status">
                                    <span style="color:lime; font-family:Verdana; font-weight:bold; ">
                                        <xsl:value-of select="." />
                                    </span>
                                </xsl:for-each>
                            </span>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="MassiveImport">
                            <xsl:for-each select="@Status">
                                <span style="color:red; font-family:Verdana; font-weight:bold; ">
                                    <xsl:value-of select="." />
                                </span>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                <span style="font-family:Verdana; ">!</span>
                <br />
                <br />
                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Documents results:</span>
                <br />
                <br />
                <xsl:variable name="result" select="MassiveImport/@Status"></xsl:variable>
                <xsl:if test="count(  MassiveImport/CATProduct  )&gt; 0">
                    <xsl:for-each select="MassiveImport">
                        <xsl:for-each select="CATProduct">
                            <xsl:if test="count(Report) &gt; 0">
                                <!-- CATProduct -->
                                <span style="font-family:Verdana; margin-left:2cm; text-decoration:underline; ">CATProduct:</span>
                                <br />
                                <br />
	                                <xsl:call-template name="WriteTable">
	                                <xsl:with-param name="result" select="$result"></xsl:with-param>
	                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
               </xsl:if>
                <!-- CATPart -->
                <xsl:if test="count(   MassiveImport/CATPart )">
                    <xsl:for-each select="MassiveImport">
                        <xsl:for-each select="CATPart">
                            <xsl:if test="count(Report) &gt; 0">
                                <span style="font-family:Verdana; margin-left:2cm; text-decoration:underline; ">CATPart:</span>
                                <br />
                                <br />
	                                <xsl:call-template name="WriteTable">
	                                <xsl:with-param name="result" select="$result"></xsl:with-param>
	                                </xsl:call-template>
                           </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="count(  MassiveImport/CATDrawing  )">
                    <xsl:for-each select="MassiveImport">
                        <xsl:for-each select="CATDrawing">
                            <xsl:if test="count(Report) &gt; 0">
                                <span style="font-family:Verdana; margin-left:2cm; text-decoration:underline; ">CATDrawing:</span>
                                <br />
                                <br />
	                                <xsl:call-template name="WriteTable">
	                                <xsl:with-param name="result" select="$result"></xsl:with-param>
	                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:if>
                <!-- Other -->
                <xsl:if test="count(  MassiveImport/Other)">
                    <xsl:for-each select="MassiveImport">
                        <xsl:for-each select="Other">
                            <xsl:if test="count(Report) &gt; 0">
                                <span style="font-family:Verdana; margin-left:2cm; text-decoration:underline; ">Other types:</span>
                                <br />
                                <br />
	                                <xsl:call-template name="WriteTable">
	                                <xsl:with-param name="result" select="$result"></xsl:with-param>
	                                </xsl:call-template>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:if>
                <!-- Errors -->
               <xsl:if test="count(  MassiveImport/Error   )">
	                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Error(s):</span>
	                <br/>
	                <br/>
                    <xsl:for-each select="MassiveImport">
                        <a name="ListOfErrors"></a>
                        <table border="0" cellspacing="1" cellpadding="4" bgcolor="black" style="font-family:Verdana; font-weight:bold; margin-left:1cm;">
                            <thead>
                                <tr bgcolor="#F28411">
                                    <td align="center">
                                            <span style="font-family:Verdana; font-weight:bold; "><xsl:value-of select="Error/@ErrorType" /></span>
                                        </td>
                                    <td align="center">
                                            <span style="font-family:Verdana; font-weight:bold; ">Documents</span>
                                        </td>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="Error">
                                    <tr>
                                        <td bgcolor="red" style="font-family:Verdana" align="center">
               		 						<xsl:value-of select="@ErrorMsg" />
										</td>
                                        <td bgcolor="red" style="font-family:Verdana" align="center">
               		 						<xsl:value-of select="@Document" />
										</td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </xsl:for-each>
                </xsl:if>
				<!-- Connection errors -->
	            <xsl:if test="count(  MassiveImport/ConnectionError   )">
                    <xsl:for-each select="MassiveImport">
	                    <xsl:for-each select="ConnectionError">
	                        <span style="color:black; font-family:Arial; margin-left:1cm; font-size:10pt; font-weight:bold;">
	 							<xsl:value-of select="@Problem" />:
	 						</span>
	 						<span style="color:red; font-family:Arial; font-size:10pt; font-weight:bold;">
	 							<xsl:value-of select="@ErrorMsg" />
		 					</span>
	                  	</xsl:for-each>
                  	</xsl:for-each>
	            </xsl:if>
                
                <br />
                <br />
            	<a>
                    <xsl:attribute name="href"><xsl:text disable-output-escaping="yes">#top_of_page</xsl:text></xsl:attribute>
                    <span style="color:black; font-family:Arial; font-size:10pt; font
                    -weight:bold; ">Go to top</span>
                </a>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="WriteLine">
        <tr>
            <td bgcolor="#FFFFFF">
              <xsl:variable name="lnk" select="@File"></xsl:variable>
	<xsl:if test="@Status = 'Succeeded'">
       <xsl:for-each select="@ObjectName"> 
            <span style="font-family:Verdana; ">
            	<a>
                    <xsl:attribute name="href">
                    	<xsl:value-of select="$lnk" />
					</xsl:attribute>
                    <span style="color:black; font-family:Arial; font-size:10pt; font-weight:bold; ">
                		<xsl:value-of select="." />
                	</span>
                </a>
            </span>
        </xsl:for-each>
	</xsl:if>	
	<xsl:if test="@Status != 'Succeeded'">
       <xsl:for-each select="@ObjectName"> 
        <span style="color:black; font-family:Arial; font-size:10pt; font-weight:bold; ">
    		<xsl:value-of select="." />
    	</span>
        </xsl:for-each>
	</xsl:if>	
    	</td>
            <xsl:choose>
                <xsl:when test="@Status  = &quot;Succeeded&quot;">
                    <td bgcolor="lime" style="font-family:Verdana" align="center">
		<xsl:value-of select="@Status" />
		</td>
                </xsl:when>
                <xsl:when test="@Status  = &quot;Failed&quot;">
                    <td bgcolor="red" style="font-family:Verdana" align="center">
		<a href="#ListOfErrors" ><xsl:value-of select="@Status" /></a>
		</td>
                </xsl:when>
                <xsl:otherwise>
                    <td bgcolor="#F28411" style="font-family:Verdana" align="center">
		<xsl:value-of select="@Status" />
		</td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>
    
    <xsl:template name="WriteTable">
    <xsl:param name="result"></xsl:param>
	    <table border="0" cellspacing="1" cellpadding="2" bgcolor="black" style="font-family:Verdana;margin-left:1.5cm;" >
	        <thead>
	            <tr bgcolor="#F28411">
	                <td align="center">
	                <span style="font-family:Verdana; font-weight:bold; ">Object Name</span>
	            </td>
	                <td align="center">
	                <span style="font-family:Verdana; font-weight:bold; ">Status</span>
	            </td>
	            </tr>
	        </thead>
	        <tbody>
	            <!-- Test if succeeded or not, for an optimized display -->
	            <xsl:if test="$result  = &quot;Succeeded&quot;">
	                <xsl:for-each select="Report">
	                    <xsl:sort select="@ObjectName"/>
	                    	<xsl:call-template name="WriteLine"/>
	                </xsl:for-each>
	            </xsl:if>
	            <xsl:if test="$result  = &quot;Failed&quot;">
	                <xsl:for-each select="Report">
	                    <xsl:sort select="@Num" data-type="number"/>
							 <xsl:call-template name="WriteLine"/>
	                </xsl:for-each>
	            </xsl:if>
	        </tbody>
	    </table>
	    <br />
	    <br />
   </xsl:template>
</xsl:stylesheet>
