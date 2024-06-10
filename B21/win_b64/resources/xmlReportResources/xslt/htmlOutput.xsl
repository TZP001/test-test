<?xml version="1.0" encoding="UTF-8"?>
<!-- XML Conversion Report transformation file -->
<!-- HTML Output -->
<!-- Date de création : Mai 2009 -->
<!-- Auteur : Marie-Line Bergeonneau -->
<!-- Modifs :  -->

<!-- Definition de l'espace et du retour chariot -->
<!-- afin de faciliter la mise en page par la suite -->
<!DOCTYPE stylesheet [
  <!ENTITY space "<xsl:text> </xsl:text>">
  <!ENTITY cr "<xsl:text>
</xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output 
     method="html"
     encoding="UTF-8"
     doctype-public="-//W3C//DTD HTML 4.01//EN"
     doctype-system="http://www.w3.org/TR/html4/strict.dtd"
     indent="yes" />
  <xsl:strip-space elements="*" />


  <!-- Creation de la page XHTML -->
  <xsl:template match="/report">
    <!--html xmlns="http://www.w3.org/1999/xhtml"-->
    <html>
      <head>
        <title>
          <xsl:value-of select="@title" />
        </title>
        <link href="main.css" rel="stylesheet" type="text/css" />
        <link href="tabRecap.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="common.js" />
      </head>
      <body onload="load();">
        <table>
          <tr>
            <td>
              <img src="logocatia.png" alt="CATIA Logo" />
            </td>
            <td>
              <br />
              <h2>
                <xsl:value-of select="@title" />
              </h2>
            </td>
          </tr>
        </table>
        <xsl:apply-templates select="FileInfoSection" />
        <xsl:apply-templates select="GlobalResultSection" />
        <hr />
        <table>
          <tr>
            <td>
              <h3>
                <xsl:value-of select="@reviewTitle" />
              </h3>
            </td>
          </tr>
        </table>
        <div class="ReviewHeader">
          <tr>
            <td class="recap">
              <xsl:value-of select="@operation" />
            </td>
          </tr>
          <table class="recap" border="1" cellpadding="2" cellspacing="2">
            <tbody>
              <tr>
                <td>
                  <input type="checkbox" id="Ignored" checked="true" onclick="HideShowMessagesStatus(this,'Ignored','{@name}');" />
                </td>
                <td style="color: rgb(255, 102, 0);">
                  <xsl:value-of select="@titleCheckIgnoredAreas" />
                </td >
                <td>
                  <input type="checkbox" id="OKAreas" checked="true" onclick="HideShowMessagesStatus(this,'OKAreas','{@name}');" />
                </td>
                <td style="color: rgb(0, 153, 0);">
                  <xsl:value-of select="@titleCheckOkAreas" />
                </td>
                <td>
                  <input type="checkbox" id="KOAreas" checked="true" onclick="HideShowMessagesStatus(this,'KOAreas','{@name}');" />
                </td>
                <td style="color: rgb(255, 0, 0);">
                  <xsl:value-of select="@titleCheckKOAreas" />
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <tr>
        </tr>
        <br />
        <xsl:apply-templates select="Group" />
        <div class="LargeView" id="LargeViewID">
          <!-- div class="InternalLargeView" id="InternalLargeViewID"-->
          <img id="LargeViewImage" src="logocatia.png" alt="LargeViewError" style="width:100%; height:100%"/>
          <br/>
          <br/>
          <img onclick="HideLargeViewDIV()" src="close.png" alt="ClosePopup" align="left"/>
          <!--/div-->
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- Gestion de la section des infos fichier -->
  <xsl:template match="FileInfoSection">
    <hr />
    <table>
      <tr>
        <td>
          <h3>
            <xsl:value-of select="@title" />
          </h3>
        </td>
      </tr>
    </table>
    <table>
      <tr>
        <td>
          <table>
            <xsl:apply-templates select="message" />
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>

  <!-- Template qui parcours les messages de la section File Info -->
  <xsl:template match="message">
    <tr>
      <td>
        <xsl:value-of select="@title" />
      </td>
      <td>
        <xsl:value-of select="@value" />
      </td>
    </tr>
  </xsl:template>

  <!-- Gestion de la section du recapitulatif global (tableau) -->
  <xsl:template match="GlobalResultSection">
    <hr />
        <h3>
          <xsl:value-of select="@title" />
        </h3>
    <table>
      <tr>
        <td>
          <table class="recap" border="1" cellpadding="2" cellspacing="2">
            <thead class="recap">
                <xsl:apply-templates select="summaryRow" /> 
            </thead>
            <tbody class="recap">
              <tr class="recap">
                <td class="recap">
                  <xsl:value-of select="@GroupsTotal" />
                </td>
                <td class="recap">
                  <xsl:value-of select="@IgnoredTotal" />
                </td>
                <td class="recap">
                  <xsl:value-of select="@KOTotal" />
                </td>
                <td class="recap">
                  <xsl:value-of select="@OKTotal" />
                </td>
              </tr>
            </tbody>
          </table>
          <div class="Warning">
            <a name="AllGroupAreNotInspected" class="Warning">
              <xsl:value-of select="@AllGroupAreNotInspected" />
            </a>
          </div>
        </td>
      </tr>
    </table>
    <br />
  </xsl:template>

  <!-- Template qui parcours et ajoute les lignes de bilan global -->
  <xsl:template match="summaryRow">
      <tr class="recap">
        <th class="recap">
          <xsl:value-of select="@GroupsTotal" />
        </th>
        <th class="recap">
          <xsl:value-of select="@nbIgnoredGroup" />
        </th>
        <th class="recap">
          <xsl:value-of select="@nbKO" />
        </th>
        <th class="recap">
          <xsl:value-of select="@nbOK" />
        </th>
      </tr>
  </xsl:template>

  <!-- Gestion des elements des groupes de zones-->
  <xsl:template match="Group">
    <ul>
      <xsl:element name="li">
        <xsl:attribute name="class">Group</xsl:attribute>
        <xsl:attribute name="id">
          LI_<xsl:value-of select="@name" />
        </xsl:attribute>
        <xsl:attribute name="onclick">
          HideShowDIV('<xsl:value-of select="@name" />');
        </xsl:attribute>
        <xsl:element name="span">
          <!--xsl:attribute name="title">#<xsl:value-of select="@id" /></xsl:attribute-->
          <xsl:choose>
            <xsl:when test="@statusID = '0'">
              <xsl:attribute name="class">NotInsp</xsl:attribute>
            </xsl:when>
            <xsl:when test="@statusID = '1'">
              <xsl:attribute name="class">OKAreas</xsl:attribute>
            </xsl:when>
            <xsl:when test="@statusID = '2'">
              <xsl:attribute name="class">KOAreas</xsl:attribute>
            </xsl:when>
            <xsl:when test="@statusID = '3'">
              <xsl:attribute name="class">Ignored</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:value-of select="@name" />
        </xsl:element>
      </xsl:element>
      <!--  Chaque Group est mis dans un DIV qui a comme ID le nom du groupementde zones -->
      <xsl:element name="li">
        <xsl:attribute name="style">list-style: none</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:choose>
            <xsl:when test="@statusID = '0'">
              LI_NotInsp_
            </xsl:when>
            <xsl:when test="@statusID = '1'">
              LI_OKAreas_
            </xsl:when>
            <xsl:when test="@statusID = '2'">
              LI_KOAreas_
            </xsl:when>
            <xsl:when test="@statusID = '3'">
              LI_Ignored_
            </xsl:when>
          </xsl:choose>
          <xsl:value-of select="@name" />
        </xsl:attribute>
        <div class="AreaBorder">
          <xsl:element name="div">
            <xsl:attribute name="id">
              <xsl:value-of select="@name" />
            </xsl:attribute>
            <xsl:value-of select="@comment" />
            <xsl:apply-templates select="Camera" />
            <xsl:apply-templates select="AnnotationSet" />
          </xsl:element>
        </div>
      </xsl:element>
    </ul>
  </xsl:template>

  <!-- Gestion des images d'un groupement de zones-->
  <xsl:template match="Camera">
    <ul>
      <xsl:element name="li">
        <xsl:attribute name="class">Camera</xsl:attribute>
        <xsl:attribute name="id">
          LI_<xsl:value-of select="@name" />
        </xsl:attribute>
        <xsl:attribute name="onclick">
          HideShowDIV('<xsl:value-of select="@name" />');
        </xsl:attribute>
        <xsl:element name="span">
          <xsl:value-of select="@name" />
        </xsl:element>
        <!--  Chaque Camera est mis dans un DIV qui a comme ID le nom de la Camera -->
        <!--  ShowLargeViewDIV('<xsl:value-of select="@Image1Path" />');-->
        <xsl:element name="li">
          <xsl:attribute name="style">list-style: none</xsl:attribute>
          <div class="CameraBorder">
            <xsl:element name="div">
              <xsl:attribute name="id">
                <xsl:value-of select="@name" />
              </xsl:attribute>
              <table>
                <tr>
                  <td>
                  <xsl:element name="img">
                    <xsl:attribute name="src">
                      <xsl:value-of select="@Image1Path" />
                    </xsl:attribute>
                    <xsl:attribute name="width">400</xsl:attribute>
                    <xsl:attribute name="height">300</xsl:attribute>
                    <xsl:attribute name="onclick">
                      ShowLargeViewDIV('<xsl:value-of select="@Image1Path" />');
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                      <xsl:value-of select="@ViewOnModel1Name" />:
                      <xsl:value-of select="ancestor::Group/@maximumDeviationText" /> : <xsl:value-of select="ancestor::Group/@maxDistance" />
                  </xsl:attribute>
                  </xsl:element>
                  </td>
                  <td>
                  <xsl:element name="img">
                    <xsl:attribute name="src">
                      <xsl:value-of select="@Image2Path" />
                    </xsl:attribute>
                    <xsl:attribute name="width">400</xsl:attribute>
                    <xsl:attribute name="height">300</xsl:attribute>
                    <xsl:attribute name="onclick">
                      ShowLargeViewDIV('<xsl:value-of select="@Image2Path" />');
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                     <xsl:value-of select="@ViewOnModel2Name" />:
                     <xsl:value-of select="ancestor::Group/@maximumDeviationText" /> : <xsl:value-of select="ancestor::Group/@maxDistance" />
                   </xsl:attribute>
                  </xsl:element>
                  </td>
                </tr>
               </table>
            </xsl:element>    
          </div>
        </xsl:element>
      </xsl:element>
    </ul>
  </xsl:template>

  <!-- Gestion de l'ensemble des annotations d'un groupement de zones -->
  <xsl:template match="AnnotationSet">
    <ul>
      <xsl:element name="li">
        <xsl:attribute name="class">AnnotationSet</xsl:attribute>
        <xsl:attribute name="id">
          LI_<xsl:value-of select="@name" />_<xsl:value-of select="ancestor::Group/@name" />
        </xsl:attribute>
        <xsl:attribute name="onclick">
          HideShowDIV('<xsl:value-of select="@name" />_<xsl:value-of select="ancestor::Group/@name" />');
        </xsl:attribute>
        <xsl:element name="span">
          <xsl:value-of select="@name" />
        </xsl:element>
        <!--  Chaque Annotation Set est mis dans un DIV qui a comme ID le nom de la section -->
        <xsl:element name="li">
          <xsl:attribute name="style">list-style: none</xsl:attribute>
          <!--div class="AnnotationSetBorder" -->
            <xsl:element name="div">
              <xsl:attribute name="id">
                <xsl:value-of select="@name" />_<xsl:value-of select="ancestor::Group/@name" />
              </xsl:attribute>
              <table border="on">
                <xsl:apply-templates select="AnnotationClass" />
              </table>
            </xsl:element>
          <!--/div-->
        </xsl:element>
      </xsl:element>
    </ul>
  </xsl:template>
   
  
  <!-- Gestion des type d'annotations pour groupement de zones-->
  <xsl:template match="AnnotationClass">
      <xsl:attribute name="class">AnnotationClass</xsl:attribute>
         <tr>
            <td>
              <xsl:element name="img">
                <xsl:attribute name="src">
                  <xsl:value-of select="@imageAnnotationClass" />
                </xsl:attribute>
                <xsl:attribute name="alt">Annotation type</xsl:attribute>
              </xsl:element>
            </td>
            <td>
             <xsl:apply-templates select="AnnotationElement" />
            </td>
          </tr>
  </xsl:template>

  <!-- Gestion des annotations par type -->
  <xsl:template match="AnnotationElement">
    <ul>
      <xsl:element name="li">
        <xsl:attribute name="class">AnnotationElement</xsl:attribute>
        <xsl:element name="span">
          <xsl:value-of select="@name" />
        </xsl:element>
        <!--  Chaque annotation est mis dans un DIV qui a comme ID le nom du texte de l'annotation -->
        <xsl:element name="li">
          <xsl:attribute name="style">list-style: none</xsl:attribute>
          <div class="AnnotationBorder">
            <xsl:element name="div">
              <xsl:attribute name="id">
                <xsl:value-of select="@name" />
              </xsl:attribute>
            </xsl:element>
          </div>
        </xsl:element>
      </xsl:element>
    </ul>
  </xsl:template>
</xsl:stylesheet>
