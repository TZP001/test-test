<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:template match="/">
        <html>
            <head />
            <body>
                <a name="top_of_page">
                </a>
                <span style="border-bottom-color:#F28411; border-bottom-style:solid; border-bottom-width:medium; font-family:Verdana; font-size:x-large; ">Massive Import: Document result&#160;&#160; </span>
                <img border="0">
                    <xsl:attribute name="src"><xsl:text disable-output-escaping="yes">../3ds.bmp</xsl:text></xsl:attribute>
                </img>
                <br />
                <br />
                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Document:</span>
                <xsl:for-each select="FileReport">
                    <span style="font-family:Verdana;margin-left:0.5cm; ">
                        <xsl:value-of select="@Object" />
                    </span>
                </xsl:for-each>
                <br />
                <br/>
                <span style="font-family:Verdana; font-weight:bold; margin-left:1cm; text-decoration:underline; ">Report:</span>
                <br />
                <br />
                <xsl:for-each select="FileReport/Type">
                    <b>
                        <span style="font-family:Verdana;margin-left:1.5cm; ">
                            <xsl:value-of select="@Name"/>
                        </span>:
                    </b>
                    <br />
                    <br />
                    <!-- Début traitement des features -->
                    <xsl:if test="count(Feature) &gt; 0">
	                    <table border="0" cellspacing="1" cellpadding="1" bgcolor="Black" style="font-family:Verdana;margin-left:1.5cm;">
	                       <tr bgcolor="#F28411">
	                          <td>Name</td>
                              <td>Application</td>
                           </tr>
                           <xsl:for-each select="Feature">
                           <xsl:sort select="@Application" />
                          <tr bgcolor="white">
                             <td>
           						<xsl:value-of select="@Name"/>
           				     </td>
                             <td>
		                		<xsl:value-of select="@Application"/>
		                	 </td>
                          </tr>
                          </xsl:for-each>
                        </table>
                    </xsl:if>
                    <xsl:if test="count(Env) &gt; 0">
                        <xsl:for-each select="Env">
                            <table border="0" cellspacing="0" cellpadding="1" bgcolor="Black" style="font-family:Verdana;margin-left:1.5cm;">
                                <tr>
                                    <td bgcolor="#3f0077" style="font-family:Verdana">
						<span style="color:white; font-family:Verdana; font-weight:bold; ">

		                	<xsl:value-of select="@Name"/>
		                	</span>
		                	</td>
                                </tr>
                                <tr>
                                    <td bgcolor="white" style="font-family:Verdana" align="center">
                    		<xsl:call-template name="WriteTable"/>
                    	</td>
                                </tr>
                            </table>
                            <br/>
                            <br/>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
				<br />
                <xsl:if test="count(FileReport/InstanceList/Instance) &gt; 0">
                <span style="font-family:Verdana;margin-left:1.5cm; "><b>Instance:</b></span>
                <br />
                <br />
                <xsl:for-each select="FileReport/InstanceList">
                   <table border="0" cellspacing="1" cellpadding="2" bgcolor="Black" style="font-family:Verdana;margin-left:1.5cm;">
                      <tr>
                         <td bgcolor="#F28411" style="font-family:Verdana">
		                	Instance Name
		                </td>
                    </tr>
                    <xsl:for-each select="Instance">
                    	<tr bgcolor="white">
                    		<td>
                    			<xsl:value-of select="@Name" />
							</td>
                    	</tr>
                    </xsl:for-each>
                	</table>
                </xsl:for-each>
                </xsl:if>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="WriteLine">
        <tr>
            <td bgcolor="#FFFFFF">
        		<xsl:for-each select="@ObjectName"> 
            		<span style="font-family:Verdana; ">
                		<xsl:value-of select="." />
            		</span>
        		</xsl:for-each>
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
        <table border="0" cellspacing="1" cellpadding="2" bgcolor="black" style="font-family:Verdana; ">
            <thead>
                <tr bgcolor="#F28411">
                    <td bgcolor="#F28411">
					Object name
				</td>
                    <xsl:for-each select="Obj/attributes">
                        <xsl:if test="position() &lt; 4">
                            <td>
						<xsl:value-of select="@Name" />
					</td>
                        </xsl:if>
                    </xsl:for-each>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="Obj">
                    <tr>
                        <td bgcolor="white" style="font-family:Verdana">
					<xsl:value-of select="@Name"/>
				</td>
                        <xsl:for-each select="attributes">
                            <xsl:sort select="@Index" data-type="number" />
                            <td bgcolor="white" style="font-family:Verdana">
						<xsl:value-of select="@Value" />
					</td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
