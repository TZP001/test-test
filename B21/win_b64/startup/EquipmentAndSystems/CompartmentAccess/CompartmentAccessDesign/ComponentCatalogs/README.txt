In order to support various PDM's (Enovia LCA, VPM, SmarTeam), 
the Compartment Access catalog must be resolved.
What this means is the CNA parts that normally reference a design table 
to declare a different size for each row will now be a part for each row.
Because of the large amount of data the catalogs and parts have been stored
in the zip file CNAResolvedCatalogs.zip.  When unzipped it will put the 
catalogs and parts in to a directory called Resolved.
The master catalog must be split to sub catalogs because it is 
not possible to save large catalogs into a PDM.

Catalogs:
CNAResolvedParts.catalog  
    - This is the main parts catalog that should be referenced in PRM.  It
      references the catalogs below:

EV5_Doors.catalog
EV5_Hatches.catalog
EV5_Inclined-Ladders.catalog
EV5_Scuttles.catalog
EV5_Vertical-Ladders.catalog
EV5_Windows.catalog

For information on how to install catalogs in your PDM, consult your
PDM documentation.

