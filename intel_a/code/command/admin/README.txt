Copyright Dassault Systemes - May 2001

AdeleMultiSite product - Version 5700

0) Contents
============
AdeleMultiSite is composed by two different tools: One-way Replacation Tool 
and Two-way Replication tool which use same components.

One-way Replication Tool: 
	This tool permits to replicate a list of framework from a one Adele site to
another. Modifications can be made just on the reference site. No modification 
should be made on the replicated site

Two-way Replication Tool:
	This tool permits to share a list of framework between a Master Site and a 
Slave Site. Modifications can be made on both sites, but it will be able to launch 
only on the Master site. Merge can occured and have to be resolved on the master
site too.

I) Installation procedure
==========================

To start the installation procedure, run AdeleMultiSiteInstall.sh file.

This script asks you the following questions:

1) Give the Adele V3 profile path of your Adele installation:
2) Give the directory where you have downloaded AdeleMultiSite product:
3) Give the directory where you want to install AdeleMultiSite product:
4) Give the directory where you want to archive all AdeleMultiSite data transfers
   Note that all users who have to run a data transfer will write a record in this file:
5) Do you require an AIX version of AdeleMultiSite product : [y/n]
6) Do you require an SOLARIS version of AdeleMultiSite product : [y/n]
7) Do you require an HPUX version of AdeleMultiSite product : [y/n]
8) Do you require an IRIX version of AdeleMultiSite product : [y/n]

Give to each question the right answer. Each of them will be controlled.

Each installation step will display a message when it begins and a status code when it finishes.


Example:
--------
Start the installation phase.
Adele V3 profile path                : ~adl/adl_profile
AdeleMultiSite downloaded directory  : /u/users/ygd/tmp/AdeleMultiSite/TAPE
AdeleMultiSite installation directory: /u/users/ygd/tmp/AdeleMultiSite/INST
AdeleMultiSite log directory         : /u/users/ygd/tmp/AdeleMultiSite_Log

>>> Installing AIX version of AdeleMultiSite product
Installation of AIX version of AdeleMultiSite product successfully completed

>>> Installing SOLARIS version of AdeleMultiSite product
Installation of SOLARIS version of AdeleMultiSite product successfully completed

>>> Installing HP-UX version of AdeleMultiSite product
Installation of HP-UX version of AdeleMultiSite product successfully completed

>>> Installing IRIX version of AdeleMultiSite product
Installation of IRIX version of AdeleMultiSite product successfully completed

>>> Creation of the AdeleMultiSite_profile
Installation of the AdeleMultiSite_profile file successfully completed.

>>> Copy of the AdeleMultiSite README
Installation of README file of AdeleMultiSite product successfully completed

All installation steps have been successfully completed.


II) Prepare a data transfer 
============================

What you have to know for the One-way Replication Tool:
---------------------------------------------------------
- This tool is an Adele V3 and Adele V5 add-in product. So it is not integrated into Adele V3 nor into Adele V5 but it is installed in a third directory
- It runs only on Unix platform
- In the destination database, no modification should occured by handself. Only the data transfer tool have to make modifications.
- It should be launched and surveyed by somebody on your site
- We support it like other Adele commands
- You will have ONE data transfer per couple "source database / destination database". 
- To have the tool in the path, you'll have to run: ". $ADL_MULTISITE_INSTALL/AdeleMultiSite_profile" (don't forget the dot at the begining)
- To have a sample to help you to parameter it, please take a look in the file $(whence Sample_v3_v3.sh) after having run the AdeleMultiSite_profile

Notes: In the data transfer terminology, REMOTE database is the SOURCE database, and LOCAL database is the TARGET database.
The transfer is always launched in the target database (or Local site in the case of multi-site database)

To parametrize a data transfer, refer to the file README_ONE_WAY_TRANSFER.txt

What you have to know for the Two-way Replication Tool:
---------------------------------------------------------
- This tool is an Adele V5 add-in product.
- It runs only on Unix platform
- It should be launched and surveyed by somebody on your site
- We support it like other Adele commands
- You will have ONE data transfer per TREE
- To have the tool in the path, you'll have to run: ". $ADL_MULTISITE_INSTALL/AdeleMultiSite_profile" (don't forget the dot at the begining)

To parametrize a data transfer, refer to the file README_TWO_WAY_TRANSFER.txt


