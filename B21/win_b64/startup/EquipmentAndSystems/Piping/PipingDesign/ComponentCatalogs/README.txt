In order to support various PDM's (Enovia LCA, VPM, SmarTeam), 
the Piping catalog must be resolved.
What this means is the Piping parts that normally reference a design table 
to declare a different size for each row will now be a part for each row.
Because of the large amount of data the catalogs and parts have been stored
in the zip file PipingResolvedCatalogs.zip.  When unzipped it will put the 
catalogs and parts in to a directory called Resolved.
The master catalog must be split to sub catalogs because it is 
not possible to save large catalogs into a PDM.

Catalogs:
PipingParts-Resolved.catalog    
    - This is the main parts catalog that should be referenced in PRM.  It
      references the catalogs below:

Piping-FR-Branch-Olet.catalog
Piping-FR-Branch-ReducingTee.catalog
Piping-FR-Branch-Tee.catalog
Piping-FR-BranchWeld.catalog
Piping-FR-Elbows-Elbow.catalog
Piping-FR-Fitting-Cap.catalog
Piping-FR-Fitting-ConcReducer.catalog
Piping-FR-Fitting-EccReducer.catalog
Piping-FR-Fitting-Sleeve.catalog
Piping-FR-Flanges-BlindFlange.catalog
Piping-FR-Flanges-Flange.catalog
Piping-FR-Gasket.catalog
Piping-FR-InLineWeld.catalog
Piping-FR-Pipes-Pipe.catalog
Piping-FR-Pipes-PipeWithBends.catalog
Piping-FR-Valve-BallValve.catalog
Piping-FR-Valve-ButterflyValve.catalog
Piping-FR-Valve-CheckValve.catalog
Piping-FR-Valve-GateValve.catalog
Piping-FR-Valve-GlobeValve.catalog
Piping-FR-Valve-PlugValve.catalog
Piping-FR-Valve-PressureSafety.catalog

==============================================================================
Enovia LCA installation instructions
==============================================================================
Save all of the catalogs into the Enovia vault by first saving
these catalogs.
Piping-FR-Branch-Olet.catalog
Piping-FR-Branch-ReducingTee.catalog
Piping-FR-Branch-Tee.catalog
Piping-FR-BranchWeld.catalog
Piping-FR-Elbows-Elbow.catalog
Piping-FR-Fitting-Cap.catalog
Piping-FR-Fitting-ConcReducer.catalog
Piping-FR-Fitting-EccReducer.catalog
Piping-FR-Fitting-Sleeve.catalog
Piping-FR-Flanges-BlindFlange.catalog
Piping-FR-Flanges-Flange.catalog
Piping-FR-Gasket.catalog
Piping-FR-InLineWeld.catalog
Piping-FR-Pipes-Pipe.catalog
Piping-FR-Pipes-PipeWithBends.catalog
Piping-FR-Valve-BallValve.catalog
Piping-FR-Valve-ButterflyValve.catalog
Piping-FR-Valve-CheckValve.catalog
Piping-FR-Valve-GateValve.catalog
Piping-FR-Valve-GlobeValve.catalog
Piping-FR-Valve-PlugValve.catalog
Piping-FR-Valve-PressureSafety.catalog

Next save the master catalog PipingParts-Resolved.catalog

Update your Project Resource Management file (PRM) to 
point to the master catalog.  Sample PRM file is in 
intel_a\startup\EquipmentAndSystems\ProjectData\Project.xml

For example:
   <Resource Name="PipingPartsCatalog" Description="Piping Parts Catalog" Visible="no">
       <ID  Type="Catia" Driver="EnoviaV5" Location="PipingParts-Resolved"/>
   </Resource>


Save the Piping Lines catalog into the vault.
A sample is in intel_a\startup\EquipmentAndSystems\Piping\SampleData\PipingLines\CATTubPipingLine.catalog

Update your PRM file to point to the catalog.
For example:
   <Resource Name="PipingLinesCatalog" Description="Piping Lines Share Catalog" Visible="no">
       <ID  Type="Catia" Driver="EnoviaV5" Location="CATTubPipingLine"
          Access="RW"/>
   </Resource>

Document assembly structure: Must use work packages (black box)
PRC
  - WorkPackage1
      - Piping run
      - Piping part

==============================================================================
Enovia VPM installation instructions
==============================================================================
Save all of the catalogs into the VPM vault by first saving
these catalogs:
Piping-FR-Branch-Olet.catalog
Piping-FR-Branch-ReducingTee.catalog
Piping-FR-Branch-Tee.catalog
Piping-FR-Elbows-Elbow.catalog
Piping-FR-Fitting-Cap.catalog
Piping-FR-Fitting-ConcReducer.catalog
Piping-FR-Fitting-EccReducer.catalog
Piping-FR-Fitting-Sleeve.catalog
Piping-FR-Flanges-BlindFlange.catalog
Piping-FR-Flanges-Flange.catalog
Piping-FR-Gasket.catalog
Piping-FR-Valve-BallValve.catalog
Piping-FR-Valve-ButterflyValve.catalog
Piping-FR-Valve-CheckValve.catalog
Piping-FR-Valve-GateValve.catalog
Piping-FR-Valve-GlobeValve.catalog
Piping-FR-Valve-PlugValve.catalog
Piping-FR-Valve-PressureSafety.catalog

Next save the master catalog PipingParts-Resolved.catalog

DO NOT SAVE the following catalog into VPM because the parts generated will be unique:
Piping-FR-BranchWeld.catalog
Piping-FR-InLineWeld.catalog
Piping-FR-Pipes-Pipe.catalog
Piping-FR-Pipes-PipeWithBends.catalog

Once the master catalog has been saved into VPM the links for all non-unique parts 
should point to parts in VPM.  For parts that are unique it will point to a 
part on your file disk server.  Now save the following onto a disk server directory:
Piping-FR-BranchWeld.catalog
Piping-FR-InLineWeld.catalog
Piping-FR-Pipes-Pipe.catalog
Piping-FR-Pipes-PipeWithBends.catalog 

Update your Project Resource Management file (PRM) to 
point to the master catalog.  Sample PRM file is in 
aix_a/startup/EquipmentAndSystems/ProjectData/Project.xml

For example:
   <Resource Name="PipingPartsCatalog" Description="Piping Parts Catalog" Visible="no">
       <ID  Type="Catia" Driver="File" Location="/Server/PipingDesign/PipingParts/Resolved/PipingParts-Resolved.catalog"/>
   </Resource>

DO NOT save the Piping Lines catalog into VPM.  Reference the one on disk.
When saving design documents that reference a Piping Line do not save the Piping
Line into VPM.  Keep it pointing to the one on disk.  You may need to set your
Document Search Order to point to the Piping Lines directory.

Document assembly structure: Must use work packages (black box)
PRC
  - WorkPackage1
      - Piping run
      - Piping part

Save documents with publications exposed.

==============================================================================
SmarTeam installation instructions
==============================================================================
Save all of the catalogs into the SmarTeam vault by first saving
these catalogs:
Piping-FR-Branch-Olet.catalog
Piping-FR-Branch-ReducingTee.catalog
Piping-FR-Branch-Tee.catalog
Piping-FR-BranchWeld.catalog
Piping-FR-Elbows-Elbow.catalog
Piping-FR-Fitting-Cap.catalog
Piping-FR-Fitting-ConcReducer.catalog
Piping-FR-Fitting-EccReducer.catalog
Piping-FR-Fitting-Sleeve.catalog
Piping-FR-Flanges-BlindFlange.catalog
Piping-FR-Flanges-Flange.catalog
Piping-FR-Gasket.catalog
Piping-FR-InLineWeld.catalog
Piping-FR-Pipes-Pipe.catalog
Piping-FR-Pipes-PipeWithBends.catalog
Piping-FR-Valve-BallValve.catalog
Piping-FR-Valve-ButterflyValve.catalog
Piping-FR-Valve-CheckValve.catalog
Piping-FR-Valve-GateValve.catalog
Piping-FR-Valve-GlobeValve.catalog
Piping-FR-Valve-PlugValve.catalog
Piping-FR-Valve-PressureSafety.catalog

Next save the master catalog PipingParts-Resolved.catalog

Update PRM:
1.	Copy the script TeamPDM_URL.bs  
  a.	FROM located in your CATIA intallation \intel_a\startup\SmarTeam\scripts\TeamPDM_URL.bs
  b.	TO the SMARTEAM installation \\SmarTeam\script directory
2.	Launch SMARTEAM Script Maintenance
  a.	Start / Programs / SMARTEAM/ Administrative Tools/ SmartBasic Script Maintenance
  b.	Under CATIA Class / User Defined tab, add the TEAM PDM URL command
       · Save the Changes
       · Exit From Script Maintenance
3.	Launch Menu Editor
  a.	Start / Programs / SMARTEAM/ Administrative Tools/ Menu Editor
  b.	Create a TEAM PDM URL command through Start Menus/Menu Commands/Default/User Defined Commands and New User Defined Commands
  c.	Select the TEAM PDM URL command and Press OK.
  d.	Add the TEAM PDM URL command to the default profiles through Start 
      Menus/Menu Profiles/System Profiles/System/Default/Pop-Up Menus/Grid Popup/User Defined Tools and New Menu Item
4.	Launch SMARTEAM 
  a.	Search the CATIA document that needs to be referenced by PRM
  b.	Through Contextual Menu Launch TEAM PDM URL
  c.	Retrieve the information displayed and put it in the PRM File with the TeamPDM driver

The URL is always like the following: 
	TeamPDM://DBExtractor?CLASSID.EQ.xxx.AND.OBJECTID.EQ.xxx.AND.Vers.EQ.1
	The only values to modify are the numbers for classid and objected.

Edit the PRM xml file and set:
  ·	the Driver to TeamPDM
  ·	the Location to TeamPDM://DBExtractor?CLASSID.EQ.xxx.AND.OBJECTID.EQ.xxx.AND.Vers.EQ.1

For example:
   <Resource Name="PipingPartsCatalog" Description="Piping Parts Catalog" Visible="no">
       <ID  Type="Catia" Driver="TeamPDM" Location="TeamPDM://DBExtractor?CLASSID.EQ.682.AND.OBJECTID.EQ.965.AND.Vers.EQ.1"/>
   </Resource>
