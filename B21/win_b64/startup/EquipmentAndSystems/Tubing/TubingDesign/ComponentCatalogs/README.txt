In order to support various PDM's (Enovia LCA, VPM, SmarTeam), 
the Tubing catalog must be resolved.
What this means is the tubing parts that normally reference a design table 
to declare a different size for each row will now be a part for each row.
Because of the large amount of data the catalogs and parts have been stored
in the zip file TubingResolvedCatalogs.zip.  When unzipped it will put the 
catalogs and parts in to a directory called Resolved.
The master catalog must be split to sub catalogs because it is 
not possible to save large catalogs into a PDM.

Catalogs:
TubingPartsResolved.catalog    
    - This is the main parts catalog that should be referenced in PRM.  It
      references the catalogs below.

TubingBranchResolved.catalog   
TubingElbowsResolved.catalog
TubingFittingResolved.catalog
TubingTubesResolved.catalog
TubingValveResolved.catalog

==============================================================================
Enovia LCA installation instructions
==============================================================================
Save all of the catalogs into the Enovia vault by first saving
these catalogs.
TubingBranchResolved.catalog   
TubingElbowsResolved.catalog
TubingFittingResolved.catalog
TubingTubesResolved.catalog
TubingValveResolved.catalog

Next save the master catalog TubingPartsResolved.catalog

Update your Project Resource Management file (PRM) to 
point to the master catalog.  Sample PRM file is in 
intel_a\startup\EquipmentAndSystems\ProjectData\Project.xml

For example:
   <Resource Name="TubingPartsCatalog" Description="Tubing Parts Catalog" Visible="no">
       <ID  Type="Catia" Driver="EnoviaV5" Location="TubingPartsResolved"/>
   </Resource>


Save the Tubing Lines catalog into the vault.
A sample is in intel_a\startup\EquipmentAndSystems\Tubing\SampleData\TubingLines\CATTubTubingLine.catalog

Update your PRM file to point to the catalog.
For example:
   <Resource Name="TubingLinesCatalog" Description="Tubing Lines Share Catalog" Visible="no">
       <ID  Type="Catia" Driver="EnoviaV5" Location="CATTubTubingLine"
          Access="RW"/>
   </Resource>

Document assembly structure: Must use work packages (black box)
PRC
  - WorkPackage1
      - Tubing run
      - Tubing part

==============================================================================
Enovia VPM installation instructions
==============================================================================
Save all of the catalogs into the VPM vault by first saving
these catalogs.
TubingBranchResolved.catalog   
TubingElbowsResolved.catalog
TubingFittingResolved.catalog
TubingValveResolved.catalog
Next save the master catalog TubingPartsResolved.catalog

DO NOT SAVE TubingTubesResolved.catalog this catalog into VPM.  The parts generated 
will be unique.  

Once the master catalog has been saved into VPM the links for all non-unique parts 
should point to parts in VPM.  For parts that are unique it will point to a 
part on your file disk server.  Now save the TubingTubesResolved.catalog 
on a disk server directory.  This is the one that will be used by PRM.

Update your Project Resource Management file (PRM) to 
point to the master catalog.  Sample PRM file is in 
aix_a/startup/EquipmentAndSystems/ProjectData/Project.xml

For example:
   <Resource Name="TubingPartsCatalog" Description="Tubing Parts Catalog" Visible="no">
       <ID  Type="Catia" Driver="File" Location="/Server/TubingDesign/ComponentCatalogs/Resolved/TubingPartsResolved.catalog"/>
   </Resource>

DO NOT save the Tubing Lines catalog into VPM.  Reference the one on disk.
When saving design documents that reference a Tubing Line do not save the Tubing
Line into VPM.  Keep it pointing to the one on disk.  You may need to set your
Document Search Order to point to the Tubing Lines directory.

Document assembly structure: Must use work packages (black box)
PRC
  - WorkPackage1
      - Tubing run
      - Tubing part

Save documents with publications exposed.

==============================================================================
SmarTeam installation instructions
==============================================================================
Save all of the catalogs into the SmarTeam vault by first saving
these catalogs.
TubingBranchResolved.catalog   
TubingElbowsResolved.catalog
TubingFittingResolved.catalog
TubingValveResolved.catalog
TubingTubesResolved.catalog
Next save the master catalog TubingPartsResolved.catalog

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
   <Resource Name="TubingPartsCatalog" Description="Tubing Parts Catalog" Visible="no">
       <ID  Type="Catia" Driver="TeamPDM" Location="TeamPDM://DBExtractor?CLASSID.EQ.682.AND.OBJECTID.EQ.965.AND.Vers.EQ.1"/>
   </Resource>
