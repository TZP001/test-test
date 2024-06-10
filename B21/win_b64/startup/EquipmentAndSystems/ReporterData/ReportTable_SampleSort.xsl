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

      <?xml-stylesheet type="text/xsl" href="ReportTable_SampleSort.xsl"?>

 This stylesheet displays the data in the table format with two sorted columns.
 The number of the column to sort is defined in the following statement:

      <xsl:variable name="ColumnToSort1" select="3"/>
   
 which means ColumnToSort1=3. That is, the following statement causes the 3rd column 
 to be sorted:

      <xsl:sort select="Table_Column[position()=$ColumnToSort1]"/> 

 xsl:sort statement has an option to sort data as a text(default) or as a number.
 To sort data as a number, use the following statement:

      <xsl:sort select="Table_Column[position()=$ColumnToSort1]" data-type="number"/> 

 Note: "number" data-type guarantees the result only for pure numbers, such as 6.4, 10, 2000.3.
 Numbers with some other characters, e.g. 10", 4.6mm, $100 won't be sorted correctly as numbers.
 
 Also, there is an option to sort data in either ascending(default) or descending order.
 To sort data in descending order, use the following statement:

      <xsl:sort select="Table_Column[position()=$ColumnToSort1]" order ="descending"/>

 To sort numbers in descending order, use the following:

      <xsl:sort select="Table_Column[position()=$ColumnToSort1]" order ="descending" data-type="number"/>

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
        <xsl:sort select="Table_Column[position()=$ColumnToSort1]"/>
        <xsl:sort select="Table_Column[position()=$ColumnToSort2]"/>
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

<!-- Columns to sort -->
<xsl:variable name="ColumnToSort1" select="3"/>
<xsl:variable name="ColumnToSort2" select="1"/>

</xsl:stylesheet>
