<?xml version="1.0"?>
<!--
**********************************************************************************************************
 To use this stylesheet to display an XML file in the browser, the following conditions must be met:
 1. The XML file must be based on ReportTable.dtd, that is, it should be valid against that DTD file.
    It should look something like this:

      <ReportTable>
      <Table_Title>...</Table_Title>
      <Table_Row>
      <Table_Column>...</Table_Column>
      </Table_Row>
      ...
      </ReportTable>

 2. The following line should be inserted in the beginning of the XML file:

      <?xml-stylesheet type="text/xsl" href="ReportTable_Sample.xsl"?>

 This stylesheet displays the data in the table format.
**********************************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html"/>
<xsl:template match="/">
  <html>
  <HEAD>
  <TITLE><xsl:value-of select="//Table_Title"/></TITLE>
  </HEAD>
  <body>
    <h2 style="color:Navy"><xsl:value-of select="//Table_Title"/></h2>
    <table border="1">
      <!-- Header row -->
      <tr style="background-color:Navy; color:White; font:Bold">
         <xsl:apply-templates select="//Table_Row[position()=1]/Table_Column"/>
      </tr>
      <!-- Data rows -->
      <xsl:for-each select="//Table_Row[position()!=1]">
        <tr style="background-color:Silver; color:Navy">
           <xsl:apply-templates select="Table_Column"/>
        </tr>
      </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>

<xsl:template match="Table_Column">
  <td><xsl:value-of select="."/></td>
</xsl:template>

</xsl:stylesheet>
