<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">

   <xsl:output method="html" indent="yes" encoding="UTF-8"/>

   <!-- COPYRIGHT DASSAULT SYSTEMES 2005-2010 -->

   <!-- Modification History:              -->
   <!--   + On March 11th 2010     Objective: 1- Mapped object status is now based on length of PdmId attribute (not on number of PDM object in query result)                                                           -->
   <!--                                       2- Part with "Inherited" attribute set to "true" have to be displayed has Publication exposed what ever current storage mode (case of CATPart, CATIA V4 model or CATShape) -->

   <!--  Variable enabling to access to CATIA root installation directory -->
   <!--   * Path to CATIA download code -->

   <xsl:variable name="Instal_Dir"     select="//Options/@Instal_Dir" />

   <!--   * Session status values are: None, Compare, Compare&Execute or Execute -->

   <xsl:variable name="Session_Status" select="//Session/@Status" />

   <!--   * Capture current VPDM system on Session -->

   <xsl:variable name="Session_Env" select="//Session/@Env" />

   <!-- ============================================= -->
   <!--  Template corresponding to root Session node  -->
   <!-- ============================================= -->

   <xsl:template match="Session">

      <!-- 1- Initialization -->
      <!-- 1-1 Global initialization -->

      <!--   xsl:variable name="Instal_Dir" select="child::*/@Instal_Dir" / -->

      <!-- 1-2 HTML header -->

      <html>

         <!-- 1-3 style sheet for document -->

         <body link="#0000FF" vlink="#800080" BGCOLOR="white" background="{concat($Instal_Dir,'/resources/graphic/Rec_ReportBackground.gif')}">
            <style>
               .Entete {font: 40 pt bold; color: blue; text-align: center}
               .Menu {font: 20 pt; text-align: right; text-align: bottom}
               .Normal {font: 12pt bold;	text-align: left;color: red; text-align: bottom}
               .Normal2 {font: 20pt bold;	text-align: left; color: green; text-align: bottom}
               .Parameter {font: 14pt; color:red; text-align: left;font-style:italic}
               .Input { font-weight:bold;font-family="Arial";color:#314292;font-size=15;background-color: #D8D8D8;}
               .Comment { font-weight:bold;font-family="Arial";color:blue;font-size=15;background-color: #D8D8D8;}
               .hyperlink{font-weight:bold;font-family="Arial";color:blue;font-size=12}
            </style>

            <!--   1-4 Report title -->

            <img src="{concat($Instal_Dir,'/resources/graphic/Rec_DSLogo.gif')}" BORDER="0"/>
            <xsl:choose>
               <!-- Workpackage synchronization  -->

               <xsl:when test="$Session_Status='CompareForSynchronization'">
                  <div class="Entete">Workpackage Synchronization Report</div>
                  <br/>
               </xsl:when>

               <!-- Other case: Reconciliation -->

               <xsl:otherwise>
                  <div class="Entete">Reconciliator Report</div>
                  <br/>
               </xsl:otherwise>
            </xsl:choose>

            <!--   1-5 Current VPDM system -->

            <h1>
               VPDM System:
               <xsl:choose>
                  <xsl:when test="@Env='ENOVIA5'">ENOVIA V5 VPM</xsl:when>
                  <xsl:when test="@Env='VPM1'">ENOVIA VPM</xsl:when>
                  <xsl:when test="@Env='TeamPDM'">SmarTeam</xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="@Env"/>
                  </xsl:otherwise>
               </xsl:choose>
            </h1>

            <!-- 2- Table showing object to be reconciled status -->
            <!--   2-1 Table header & title -->

            <xsl:choose>
               <!-- Workpackage synchronization  -->

               <xsl:when test="$Session_Status='CompareForSynchronization'">
                  <h2>CATIA Objects to be synchronized:</h2>
               </xsl:when>

               <!-- Other case: Reconciliation -->

               <xsl:otherwise>
                  <h2>CATIA Objects to be reconciled:</h2>
               </xsl:otherwise>
            </xsl:choose>

            <table Id="Catia_View" style="Display:block" border="1" cellspacing="0" cellpadding="5" align="CENTER" bgcolor="#FFFFCC" width="70%">

               <tr>
                  <xsl:choose>
                     <!-- Workpackage synchronization  -->

                     <xsl:when test="$Session_Status='CompareForSynchronization'">
                        <th>Name</th>
                        <th>Type</th>
                        <th>Mode</th>
                        <th>File</th>
                     </xsl:when>

                     <!-- Do not display storage mode for SmarTeam Reconciliator report -->

                     <xsl:when test="$Session_Env='TeamPDM'">
                        <th>Name</th>
                        <th>Type</th>
                        <th>Rule</th>
                        <th>File</th>
                     </xsl:when>

                     <!-- other cases of Reconciliator report -->

                     <xsl:otherwise>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Storage Mode</th>
                        <th>Rule</th>
                        <th>File</th>
                     </xsl:otherwise>
                  </xsl:choose>
               </tr>

               <!--   2-2 Add information scanning Documents -->
               <!--      a- Document Information -->

               <xsl:for-each select='Document'>
                  <tr>
                     <xsl:choose>
                        <!--      a- Workpackage synchronization  -->

                        <xsl:when test="$Session_Status='CompareForSynchronization'">
                           <!--                 . Document name & type -->

                           <td>
                              <xsl:value-of select="@Name"/>
                           </td>
                           <td>
                              <xsl:value-of select="@Type"/>
                           </td>

                           <!--                 . Mode for synchronization -->

                           <td>
                              <xsl:call-template name="SynchronizationMode"/>
                           </td>

                           <!--                 . File definition -->

                           <td>
                              <xsl:value-of select="@File"/>
                           </td>
                        </xsl:when>

                        <!--       b- Do not display storage mode for SmarTeam Reconciliator report -->

                        <xsl:when test="$Session_Env='TeamPDM'">
                           <!--                 . Document name & type -->

                           <td>
                              <xsl:value-of select="@Name"/>
                           </td>
                           <td>
                              <xsl:value-of select="@Type"/>
                           </td>

                           <!--                 . Rule icons -->

                           <td>
                              <xsl:call-template name="RuleDocumentIcon"/>
                           </td>

                           <!--                 . File definition -->

                           <td>
                              <xsl:value-of select="@File"/>
                           </td>
                        </xsl:when>

                        <!--      c- other cases of Reconciliator report -->

                        <xsl:otherwise>
                           <!--                 . Document name & type -->

                           <td>
                              <xsl:value-of select="@Name"/>
                           </td>
                           <td>
                              <xsl:value-of select="@Type"/>
                           </td>

                           <!--                 . storage mode (Not to be displayed for TeamPDM) -->

                           <td>
                              <xsl:call-template name="StorageMode"/>
                           </td>

                           <!--                 . Rule icons -->

                           <td>
                              <xsl:call-template name="RuleDocumentIcon"/>
                           </td>

                           <!--                 . File definition -->

                           <td>
                              <xsl:value-of select="@File"/>
                           </td>
                        </xsl:otherwise>
                     </xsl:choose>
                  </tr>

                  <!--      b- Add information corresponding to child Parts -->

                  <xsl:for-each select="Part">
                     <tr>
                        <xsl:choose>
                           <!--        b-1 Workpackage synchronization  -->

                           <xsl:when test="$Session_Status='CompareForSynchronization'">
                              <!--                 . Part name  -->

                              <td align="RIGHT">
                                 <i>
                                    <xsl:value-of select="@Name"/>
                                 </i>
                              </td>
                              <td> . </td>
                              <td> . </td>
                              <td> . </td>
                           </xsl:when>

                           <!--        b-2 Do not display storage mode for SmarTeam Reconciliator report -->

                           <xsl:when test="$Session_Env='TeamPDM'">
                              <!--                 . Part name  -->

                              <td align="RIGHT">
                                 <i>
                                    <xsl:value-of select="@Name"/>
                                 </i>
                              </td>
                              <td> . </td>

                              <!--                 . Rule icons -->

                              <td>
                                 <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyUnknownStatusIcon.bmp')}" width="20" height="20"/>
                              </td>
                              <td> . </td>
                           </xsl:when>

                           <!--        b-3 other cases of Reconciliator report -->

                           <xsl:otherwise>
                              <!--                 . Part name  -->

                              <td align="RIGHT">
                                 <i>
                                    <xsl:value-of select="@Name"/>
                                 </i>
                              </td>
                              <td> . </td>

                              <!--                 . storage mode (Not to be displayed for TeamPDM) -->

                              <td>
                                 <xsl:call-template name="StorageMode"/>
                              </td>

                              <!--                 . Rule icons -->

                              <td>
                                 <xsl:call-template name="RulePartIcon"/>
                              </td>
                              <td> . </td>
                           </xsl:otherwise>
                        </xsl:choose>
                     </tr>
                  </xsl:for-each>
                  <!-- For Each of Part -->
               </xsl:for-each>
               <!-- For Each of Document -->

               <!--   2-3 Add information scanning Proxy-Documents in Publication exposed -->
               <!--      a- Proxy-document Information -->

               <xsl:for-each select='Proxy'>
                  <tr>
                     <xsl:choose>
                        <!--      a- Workpackage synchronization  -->

                        <xsl:when test="$Session_Status='CompareForSynchronization'">
                           <!--                 . Document name & type -->

                           <td>
                              <xsl:value-of select="@Name"/>
                           </td>
                           <td>
                              <xsl:value-of select="@Type"/>
                           </td>

                           <!--                 . Mode for synchronization -->

                           <td>
                              <xsl:call-template name="SynchronizationMode"/>
                           </td>

                           <!--                 . File definition -->

                           <td>
                              <xsl:value-of select="@File"/>
                           </td>
                        </xsl:when>

                        <!--       b- Do not display storage mode for SmarTeam Reconciliator report -->

                        <xsl:when test="$Session_Env='TeamPDM'">
                           <!--                 . Document name & type -->

                           <td>
                              <xsl:value-of select="@Name"/>
                           </td>
                           <td>
                              <xsl:value-of select="@Type"/>
                           </td>

                           <!--                 . Rule icons -->

                           <td>
                              <xsl:call-template name="RuleDocumentIcon"/>
                           </td>

                           <!--                 . File definition -->

                           <td>
                              <xsl:value-of select="@File"/>
                           </td>
                        </xsl:when>

                        <!--      c- other cases of Reconciliator report -->

                        <xsl:otherwise>
                           <!--                 . Document name & type -->

                           <td>
                              <xsl:value-of select="@Name"/>
                           </td>
                           <td>
                              <xsl:value-of select="@Type"/>
                           </td>

                           <!--                 . storage mode (Not to be displayed for TeamPDM) -->

                           <td>
                              <xsl:call-template name="StorageMode"/>
                           </td>

                           <!--                 . Rule icons -->

                           <td>
                              <xsl:call-template name="RuleDocumentIcon"/>
                           </td>

                           <!--                 . File definition -->

                           <td>
                              <xsl:value-of select="@File"/>
                           </td>
                        </xsl:otherwise>
                     </xsl:choose>
                  </tr>

                  <!--      b- Add information corresponding to child Parts -->

                  <xsl:for-each select="Part">
                     <tr>
                        <xsl:choose>
                           <!--        b-1 Workpackage synchronization  -->

                           <xsl:when test="$Session_Status='CompareForSynchronization'">
                              <!--                 . Part name  -->

                              <td align="RIGHT">
                                 <i>
                                    <xsl:value-of select="@Name"/>
                                 </i>
                              </td>
                              <td> . </td>
                              <td> . </td>
                              <td> . </td>
                           </xsl:when>

                           <!--        b-2 Do not display storage mode for SmarTeam Reconciliator report -->

                           <xsl:when test="$Session_Env='TeamPDM'">
                              <!--                 . Part name  -->

                              <td align="RIGHT">
                                 <i>
                                    <xsl:value-of select="@Name"/>
                                 </i>
                              </td>
                              <td> . </td>

                              <!--                 . Rule icons -->

                              <td>
                                 <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyUnknownStatusIcon.bmp')}" width="20" height="20"/>
                              </td>
                              <td> . </td>
                           </xsl:when>

                           <!--        b-3 other cases of Reconciliator report -->

                           <xsl:otherwise>
                              <!--                 . Part name  -->

                              <td align="RIGHT">
                                 <i>
                                    <xsl:value-of select="@Name"/>
                                 </i>
                              </td>
                              <td> . </td>

                              <!--                 . storage mode (Not to be displayed for TeamPDM) -->

                              <td>
                                 <xsl:call-template name="StorageMode"/>
                              </td>

                              <!--                 . Rule icons -->

                              <td>
                                 <xsl:call-template name="RulePartIcon"/>
                              </td>
                              <td> . </td>
                           </xsl:otherwise>
                        </xsl:choose>
                     </tr>
                  </xsl:for-each>
                  <!-- For Each of Part -->
               </xsl:for-each>
               <!-- For each of Proxy-Document -->
            </table>

            <!-- 3- Table showing the CATIA Properties and VPDM mapped part properties -->
            <!--   3-1 Table header & title -->

            <!-- <h2>VPDM tree view:</h2> -->

            <table id="VPDM_View" style="Display:none" BORDER="1" CELLSPACING = "0" CELLPADDING = "5" ALIGN="CENTER" BGCOLOR="#FFFFCC" WIDTH="70%">
               <!-- <tr><th width="1000" height="1"  colspan="11">VPDM VIEW</th></tr>  -->

               <tr>
                  <th width="37" height="1" rowspan="2">Name</th>
                  <th width="37" height="1" rowspan="2">Type</th>
                  <th width="29" height="1" rowspan="2">Storage Mode</th>
                  <th width="29" height="1" rowspan="2">Rule</th>
                  <th width="29" height="1" rowspan="2">Compare Status </th>
                  <th width="29" height="1" align="center" rowspan="2">File</th>
                  <th width="305" height="1" align="center" colspan="4">VPDM INFO</th>
               </tr>
               <tr>
                  <th width="23" height="34">Name</th>
                  <th width="27" height="34">Status</th>
                  <th width="23" height="34">Owner</th>
                  <th width="18" height="34">Modified Date</th>
               </tr>

               <!--   3-2 Display VPDM document information -->

               <xsl:apply-templates select="Document"/>

               <!--   3-3 Display VPDM Part information -->

               <xsl:apply-templates select="Document/Part"/>
            </table>

            <!-- 4- Table showing the CATIA Properties and VPDM mapped part properties -->
            <!--   4 -1 Table header & title -->

            <!-- <h2>VPDM Properties:</h2> -->

            <table id="VPDM_Properties" style="Display:none" BORDER="1" CELLSPACING = "0" CELLPADDING = "5" ALIGN="CENTER" BGCOLOR="#FFFFCC" WIDTH="70%">
               <tr>
                  <th width="700" height="1" align="center" colspan="8">VPDM PROPERTIES</th>
               </tr>

               <tr>
                  <th width="23" height="34">Name</th>
                  <th width="10" height="34">Status</th>
                  <th width="23" height="34">Owner</th>
                  <th width="18" height="34">Modified Date</th>
                  <th width="23" height="34">Created Date</th>
                  <th width="27" height="34">StandardPart</th>
                  <th width="23" height="34">Configured</th>
                  <th width="18" height="34">Project</th>
               </tr>
               <xsl:apply-templates select="Document/PdmObject"/>
               <xsl:apply-templates select="Document/Part/PdmObject"/>
            </table>

            <!-- 5- CATIA Instance tree -->

            <h2>Instance View</h2>

            <ul style="list-style-image:url({concat($Instal_Dir,'/resources/graphic/icons/Rec_TreeRoot.gif')})">
               <xsl:apply-templates select="Instance"/>
            </ul>

            <!-- 6- CATIA document tree (Only for Reconciliator Report) -->

            <xsl:choose>
               <!--      a- Synchronization report -->

               <xsl:when test="$Session_Status='CompareForSynchronization'">
               </xsl:when>

               <!--      b- Reconciliator report -->

               <xsl:otherwise>
                  <h2>Document View</h2>

                  <ul style="list-style-image:url({concat($Instal_Dir,'/resources/graphic/icons/Rec_TreeRoot.gif')})">
                     <xsl:apply-templates select="DocInstance"/>
                  </ul>
               </xsl:otherwise>
            </xsl:choose>

            <!-- 7- Table of legend  -->

            <h2>Legend:</h2>

            <table border="1" cellspacing= "0" cellpadding="5" align="CENTER" bgcolor="#FFFFCC" width="50%">
               <xsl:choose>
                  <!--      a- Synchronization report -->

                  <xsl:when test="$Session_Status='CompareForSynchronization'">
                     <tr>
                        <th>Comparison status</th>
                        <th>Definition</th>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyNewInstanceStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>New instance to be added.</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblySuppressInstanceStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance to be deleted.</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyIdenticalStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance not modified.</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceMovedStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance to be moved.</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceReplacedStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance where we need to do a replace component.</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceReplacedMovedStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance where we need to do a replace component and to changed position (moved).</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceVersionStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance where we need to do a replace on a new version.</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceVersionMovedStatusIcon.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Instance where we need to do a replace on a new version and to changed position (moved).</td>
                     </tr>
                     <tr>
                        <td align="center">
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphFilterObject.bmp')}" width="20" height="20"/>
                        </td>
                        <td>Indicates that assembly structure is Filtered (a expand capture has been defined).</td>
                     </tr>
                  </xsl:when>

                  <!--      b- Reconciliator for SmarTeam -->

                  <xsl:when test="$Session_Env='TeamPDM'">
                     <tr>
                        <th>Rules</th>
                        <th>Other Status </th>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNew.bmp')}" width="20" height="20"/> New Rule
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecIncompPartIcon.bmp')}" width="20" height="20"/> Object not mapped in SmarTeam
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Overwrite.bmp')}" width="20" height="20"/> Overwrite
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphObject.bmp')}" width="20" height="20"/>  SmarTeam object
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Reload.bmp')}" width="20" height="20"/> Reload
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_MaskVPDMObject.bmp')}" width="20" height="20"/> Rule not set
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_KeepExternalRef.bmp')}" width="20" height="20"/> Broken Link
                        </td>
                        <td>.</td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNewFrom.bmp')}" width="20" height="20"/> New From
                        </td>
                        <td>.</td>
                     </tr>
                  </xsl:when>

                  <!--      c- Reconciliator for ENOVIA VPM V4-->

                  <xsl:when test="$Session_Env='VPM1'">
                     <tr>
                        <th>Rules</th>
                        <th>Comparison Status </th>
                        <th>Other Status </th>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNew.bmp')}" width="20" height="20"/> New Rule
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyNewInstanceStatusIcon.bmp')}" width="20" height="20"/> New
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecDelegateDocIcon.bmp')}" width="20" height="20"/> Document Structure exposed
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Overwrite.bmp')}" width="20" height="20"/> Overwrite
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblySuppressInstanceStatusIcon.bmp')}" width="20" height="20"/> To be deleted
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecDelegatePartIcon.bmp')}" width="20" height="20"/> Part in publication exposed
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Reload.bmp')}" width="20" height="20"/> Reload
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyIdenticalStatusIcon.bmp')}" width="20" height="20"/> Identical
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecIncompPartIcon.bmp')}" width="20" height="20"/> Object not mapped
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_KeepExternalRef.bmp')}" width="20" height="20"/> Broken Link
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceMovedStatusIcon.bmp')}" width="20" height="20"/> Moved
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphObject.bmp')}" width="20" height="20"/> VPDM object
                        </td>
                     </tr>
                     <tr>
                        <td>.</td>
                        <td>.</td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_MaskVPDMObject.bmp')}" width="20" height="20"/> Rule not set
                        </td>
                     </tr>
                  </xsl:when>

                  <!--      d- Reconciliator for ENOVIA V5 VPM -->

                  <xsl:when test="$Session_Env='ENOVIA5'">
                     <tr>
                        <th>Rules</th>
                        <th>Comparison Status </th>
                        <th>Other Status </th>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNew.bmp')}" width="20" height="20"/> New Rule
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyNewInstanceStatusIcon.bmp')}" width="20" height="20"/> New
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecDelegateDocIcon.bmp')}" width="20" height="20"/> Document Structure exposed
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Overwrite.bmp')}" width="20" height="20"/> Overwrite
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblySuppressInstanceStatusIcon.bmp')}" width="20" height="20"/> To be deleted
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecDelegatePartIcon.bmp')}" width="20" height="20"/> Part in publication exposed
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Reload.bmp')}" width="20" height="20"/> Reload
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyIdenticalStatusIcon.bmp')}" width="20" height="20"/> Identical
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecIncompPartIcon.bmp')}" width="20" height="20"/> Object not mapped
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_KeepExternalRef.bmp')}" width="20" height="20"/> Broken Link
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceMovedStatusIcon.bmp')}" width="20" height="20"/> Moved
                        </td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphObject.bmp')}" width="20" height="20"/> VPDM object
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_RecNewVersion.bmp')}" width="20" height="20"/> New Version
                        </td>
                        <td>.</td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphFilterObject.bmp')}" width="20" height="20"/> Filtered VPDM object
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_RecNewRevision.bmp')}" width="20" height="20"/> New Revision
                        </td>
                        <td>.</td>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_MaskVPDMObject.bmp')}" width="20" height="20"/> Rule not set
                        </td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_OverwriteByDelta.bmp')}" width="20" height="20"/> Overwrite by delta
                        </td>
                        <td>.</td>
                        <td>.</td>
                     </tr>
                     <tr>
                        <td>
                           <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_NewVersionByDelta.bmp')}" width="20" height="20"/> New Version by delta
                        </td>
                        <td>.</td>
                        <td>.</td>
                     </tr>
                  </xsl:when>
                  <xsl:otherwise/>
               </xsl:choose>
            </table>

            <!-- 8- HTML epilog -->

         </body>
      </html>

   </xsl:template>
   <!-- End of 'Session' template -->

   <!-- ============================================= -->
   <!--  Document template                            -->
   <!-- ============================================= -->

   <xsl:template match="Document">

      <xsl:variable name="Instal_Dir" select="preceding-sibling::*/@Instal_Dir"></xsl:variable>
      <xsl:if test="@Mode='PUBLICATION_EXPOSED'">
         <tr>
            <td>
               <xsl:value-of select="@Name"/>
            </td>
            <td>
               <xsl:value-of select="@Type"/>
            </td>
            <td>Publication</td>

            <!--  * Rule icons -->

            <td>
               <xsl:call-template name="RuleDocumentIcon"/>
            </td>

            <td>
               <xsl:value-of select="@Compare"/>
            </td>
            <td>
               <xsl:value-of select="@File"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='V_ID']"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='V_status']"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='V_user']"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='C_modified']"/>
            </td>
         </tr>
      </xsl:if>
   </xsl:template>

   <!-- ============================================= -->
   <!--  Part template                                -->
   <!-- ============================================= -->

   <xsl:template match="Part">
      <xsl:variable name="Instal_Dir" select="parent::*/preceding-sibling::*/@Instal_Dir"></xsl:variable>
      <xsl:if test="@Mode='STRUCTURE_EXPOSED'">
         <tr>
            <td>
               <xsl:value-of select="@Name"/>
            </td>
            <td>CATProduct</td>
            <td>Structure Exposed</td>

            <!--  * Rule icons -->

            <td>
               <xsl:call-template name="RulePartIcon"/>
            </td>

            <!--  * Compare Status -->

            <td>
               <xsl:call-template name="CompareStatusIcon"/>
            </td>

            <td></td>
            <!-- To be kept blank for File path-->
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='V_ID']"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='V_status']"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='V_user']"/>
            </td>
            <td>
               <xsl:value-of select="PdmObject/PdmObjectAttr[@id='C_modified']"/>
            </td>
         </tr>
      </xsl:if>
   </xsl:template>

   <!-- ============================================= -->
   <!--   PdmObject template                          -->
   <!-- ============================================= -->

   <xsl:template match="PdmObject">
      <tr>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='V_ID']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='V_status']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='V_user']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='C_modified']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='C_created']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='V508_isStandardPart']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@id='V512_IsConfigured']"/>
         </td>
         <td>
            <xsl:value-of select="PdmObjectAttr[@ name='Project']"/>
         </td>
      </tr>
   </xsl:template>

   <!-- ============================================= -->
   <!--  Instance template                            -->
   <!-- ============================================= -->

   <!-- Session status values are: None, Compare, Compare&Execute or Execute -->

   <xsl:template match="Instance">

      <li>
         <xsl:choose>
            <!-- Comparaison status has been activated -->

            <xsl:when test="$Session_Status='Compare'">
               <xsl:call-template name="InstanceCompareStatusIcon"/>
            </xsl:when>

            <!-- Comparaison & Execute status has been activated -->

            <xsl:when test="$Session_Status='CompareAndExecute'">
               <xsl:call-template name="InstanceCompareStatusIcon"/>
            </xsl:when>

            <!-- Workpackage synchronization  -->

            <xsl:when test="$Session_Status='CompareForSynchronization'">
               <xsl:call-template name="InstanceCompareStatusIcon"/>
            </xsl:when>

            <!-- Other case: No icon is displayed -->

            <xsl:otherwise>
               <b>
                  <xsl:value-of select="@Name"/>
               </b>
            </xsl:otherwise>
         </xsl:choose>
      </li>

      <ul style="list-style-image:url({concat($Instal_Dir,'/resources/graphic/icons/Rec_TreeNode.gif')})">
         <xsl:apply-templates select="Instance"/>
      </ul>
   </xsl:template>

   <!-- ============================================= -->
   <!--  Document Instance template                   -->
   <!-- ============================================= -->

   <xsl:template match="DocInstance">

      <li>
         <b>
            <xsl:value-of select="@Name"/>
         </b>
      </li>

      <ul style="list-style-image:url({concat($Instal_Dir,'/resources/graphic/icons/Rec_TreeNode.gif')})">
         <xsl:apply-templates select="DocInstance"/>
      </ul>
   </xsl:template>

   <!-- =============================================== -->
   <!--  Template corresponding to Rule Icon selection  -->
   <!-- =============================================== -->

   <!-- 1- Icon selection for Part rule -->

   <xsl:template name="RulePartIcon">
      <xsl:choose>
         <xsl:when test="@Rule='PRODSTRUCTEXP_NEWOBJECT'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNew.bmp')}" width="20" height="20" title="New"/>
         </xsl:when>

         <xsl:when test="@Rule='PRODSTRUCTEXP_OVERWRITEINPDM'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Overwrite.bmp')}" width="20" height="20" title="Overwrite"/>
         </xsl:when>

         <xsl:when test="@Rule='PRODSTRUCTEXP_NEWVERSION'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_RecNewVersion.bmp')}" width="20" height="20" title="New version"/>
         </xsl:when>

         <xsl:when test="@Rule='PRODSTRUCTEXP_OVERWRITEBYDELTA'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_OverwriteByDelta.bmp')}" width="20" height="20" title="Overwrite by delta"/>
         </xsl:when>

         <xsl:when test="@Rule='PRODSTRUCTEXP_NEWVERSIONBYDELTA'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_NewVersionByDelta.bmp')}" width="20" height="20" title="New version by delta"/>
         </xsl:when>

         <xsl:when test="@Rule='DELEGATE'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecDelegatePartIcon.bmp')}" width="20" height="20" title="Publication exposed"/>
         </xsl:when>

         <xsl:when test="@Rule='UNKNOWN'">
            <!-- Validate if a PdmObject node exist to display icon for mapped object -->
            <xsl:choose>
               <xsl:when test="string-length(@PdmId)>0">
                     <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_MaskVPDMObject.bmp')}" width="20" height="20" title="No rule set"/>
               </xsl:when>
               <xsl:otherwise>
                  <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecIncompPartIcon.bmp')}" width="20" height="20" title="Mapping to be done"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

         <xsl:when test="@Rule='PRODSTRUCTEXP_RELOAD'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Reload.bmp')}" width="20" height="20" title="Reload from VPDM"/>
         </xsl:when>

         <xsl:otherwise>
            .
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- 2- Icon selection for Part rule -->

   <xsl:template name="RuleDocumentIcon">
      <xsl:choose>
         <xsl:when test="@Rule='PUBEXP_RELOADFRMPDM'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Reload.bmp')}" width="20" height="20"  title="Reload from VPDM"/>
         </xsl:when>

         <xsl:when test="@Rule='PUBEXP_OVERWRITEINPDM'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_Overwrite.bmp')}" width="20" height="20" title="Overwrite"/>
         </xsl:when>

         <xsl:when test="@Rule='PUBEXP_NEWREVISION'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_RecNewRevision.bmp')}" width="20" height="20" title="New revision"/>
         </xsl:when>

         <xsl:when test="@Rule='PUBEXP_NEWVERSION'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_RecNewVersion.bmp')}" width="20" height="20" title="New version"/>
         </xsl:when>

         <xsl:when test="@Rule='PUBEXP_NEWOBJECT'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNew.bmp')}" width="20" height="20" title="New"/>
         </xsl:when>

         <xsl:when test="@Rule='PUBEXP_NEWFROM'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_SaveAsNewFrom.bmp')}" width="20" height="20" title="New From"/>
         </xsl:when>

         <xsl:when test="@Rule='PUBEXP_EXTERNALREFERENCE'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_KeepExternalRef.bmp')}" width="20" height="20" title="Keep as external reference"/>
         </xsl:when>

         <xsl:when test="@Rule='DELEGATE'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecDelegateDocIcon.bmp')}" width="20" height="20" title="Structure exposed"/>
         </xsl:when>

         <xsl:when test="@Rule='UNKNOWN'">
            <!-- Validate if a PdmObject node exist to display icon for mapped object -->
            <xsl:choose>
               <xsl:when test="string-length(@PdmId)>0">
                  <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_MaskVPDMObject.bmp')}" width="20" height="20" title="No rule set"/>
               </xsl:when>
               <xsl:otherwise>
                  <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecIncompDocIcon.bmp')}" width="20" height="20" title="Mapping to be done"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

         <xsl:otherwise>
            .
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- 3- Icon for Compare status -->

   <xsl:template name="CompareStatusIcon">
      <xsl:choose>
         <xsl:when test="@Compare='New'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyNewInstanceStatusIcon.bmp')}" width="15" height="15" title="Instance to be added."/>
         </xsl:when>
         <xsl:when test="@Compare='To be suppressed'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblySuppressInstanceStatusIcon.bmp')}" width="15" height="15" title="Instance to be deleted."/>
         </xsl:when>
         <xsl:when test="@Compare='Identical'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyIdenticalStatusIcon.bmp')}" width="15" height="15" title="Identical instance."/>
         </xsl:when>
         <xsl:when test="@Compare='Moved'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceMovedStatusIcon.bmp')}" width="15" height="15" title="Instance moved."/>
         </xsl:when>
         <xsl:when test="@Compare='Replaced'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceReplacedStatusIcon.bmp')}" width="15" height="15" title="Component replaced."/>
         </xsl:when>
         <xsl:when test="@Compare='Replaced with move'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceReplacedMovedStatusIcon.bmp')}" width="15" height="15" title="Component replaced with instance moved."/>
         </xsl:when>
         <xsl:when test="@Compare='Versioned'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceVersionStatusIcon.bmp')}" width="15" height="15" title="Component versionned."/>
         </xsl:when>
         <xsl:when test="@Compare='Versioned with move'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceVersionMovedStatusIcon.bmp')}" width="15" height="15" title="Component versionned with instance moved."/>
         </xsl:when>
         <xsl:when test="@Compare='Representation modified'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceVersionStatusIcon.bmp')}" width="15" height="15" title="Component versionned with instance moved."/>
         </xsl:when>
         <xsl:when test="@Compare='Representation modified with move'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyInstanceVersionMovedStatusIcon.bmp')}" width="15" height="15" title="Component versionned with instance moved."/>
         </xsl:when>
         <xsl:when test="@Compare='VPDM object'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphObject.bmp')}" width="15" height="15" title="Assembly structure filtered."/>
         </xsl:when>
         <xsl:when test="@Compare='VPDM filtered object'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphFilterObject.bmp')}" width="15" height="15" title="Assembly structure filtered."/>
         </xsl:when>
         <xsl:when test="@Compare='VPDM filtered object'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphFilterObject.bmp')}" width="15" height="15" title="Assembly structure filtered."/>
         </xsl:when>
         <xsl:when test="@Compare='Active filter'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_VPMGraphFilterObject.bmp')}" width="15" height="15" title="Assembly structure filtered."/>
         </xsl:when>
         <xsl:when test="@Compare='Modified'">
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_MaskModifiedObject.bmp')}" width="15" height="15" title="Assembly structure filtered."/>
         </xsl:when>
         <xsl:otherwise>
            <img border="0" src="{concat($Instal_Dir,'/resources/graphic/icons/normal/I_ScmRecAssemblyUnknownStatusIcon.bmp')}" width="15" height="15" title="No status."/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- 4- Storage mode -->
   <!--   a- Storage mode for Reconciliator reports -->

   <xsl:template name="StorageMode">
      <xsl:choose>
         <xsl:when test="@Mode='PUBLICATION_EXPOSED'">
            Publication exposed
         </xsl:when>
         <xsl:when test="@Inherited='true'">
            Publication exposed
         </xsl:when>
         <xsl:otherwise>
            Structure exposed
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--   b- Storage mode for Workpackage synchronization reports -->

   <xsl:template name="SynchronizationMode">
      <xsl:choose>
         <xsl:when test="@Mode='PUBLICATION_EXPOSED'">
            Standard document
         </xsl:when>
         <xsl:otherwise>
            Product View Result
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- 5- Manage case of comparison for instance or AR -->

   <xsl:template name="InstanceCompareStatusIcon">
      <xsl:call-template name="CompareStatusIcon"/>
      <b>
         <xsl:value-of select="@Name"/>
      </b>

      <xsl:if test="@Rule='INSTANCE_DO_NOTHING'">
         <i>  (Standard behaviour will not be applied.)</i>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
