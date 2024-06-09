Copyright Dassault Systemes - May 2001

AdeleMultiSite product - Version 5700

I) What's new?
==============
2001/05/04 - Correct bugs concerning options: -display, -rimage, -limage, -rtmp, -ltmp
2001/05/04 - Add new functionalities: Support adl_attach framework in the data transfer workspace on the master site

II) Prepare a data transfer 
============================

About the recommended process you have to put in place:
--------------------------------------------------------

1) Verify in your slave Adele site that no framework to transfer already exist 
2) Give rsh right (.rhost file) to the master transfer workspace owner on the .rhost file of the slave root workspace owner.
3) Create one shell script to encapsulate the data transfer tool and its parameters per data transfer (take a look to the Sample_2way_v5_v5.sh file)
4) Start the first data transfer with the option -first_transfer_by_push
5) If you want, you can call us to verify all parameters of your data transfer parameter file
6) To start the data transfer, run the encapsulation script. 


Here is the help of the main shell script adl_two_way_transfer.sh
--------------------------------------------------------------------
adl_two_way_transfer.sh -tid TransferId [-mail [addr...]] [-http HttpServer] [-simul] [-trace_adl_cmd]
  [-keep_trace n] -rhost RemoteHost [-ru username]
  -rl AdeleLevel -rp AdeleProfile -rb Base [-rproj Project] -rw Ws [-rtree tree_mk_fw] [-rimage image] -rtmp TmpDir -rmaint
  -ll AdeleLevel -lp AdeleProfile -lb Base [-lproj Project] -lw Ws [-ltree tree_mk_fw] [-limage image] -ltmp TmpDir 
  [-r_collect] [-r_sync] [-r_publish] [-r_promote] 
  [-l_collect WSi ... ] [-l_sync] [-l_publish] [-l_promote WSi ... ] [-l_cr CRi ... ]
  [-no_update_cr]
  [-keep_trace n]
  [-r_TransferToolProfile]
  [-display display]
  [-first_transfer_by_push]

Global parameters:
-tid TransferId  : TransferId (example: ENO, DSA, DSP, ...
-mail [addr...]  : Results will be sent by mail to the specified addresses; if no address is specified, the mail will be sent to people declared in $MAIL_ADDR_LIST list
     (example: export MAIL_ADDR_LIST="ygd@soleil apa@soleil")
-http HttpServer : Address of the http server being able to display generated HTML pages
     (example: http://herrero:8016)
-simul           : To simulate the data transfer. Adele command will be displayed but won't be launched
                   Note that local or distant collect/sync/promote commands will be performed
-trace_adl_cmd   : To display Adele command traces on terminal
-keep_trace n    : Number of trace directories to keep; the trace directories are created into the local workspace directory ws_dir
    Adele V3: <ws_dir>/.Adele/MultiSite/<TransferId>/Tracexxx
    Adele V5: <ws_dir>/ToolsData/MultiSite/<TransferId>/Tracexxx

REMOTE parameters of the data transfer:
-rhost RemoteHost: Remote host name (example: centaur.deneb.com)
-rl AdeleLevel   : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp AdeleProfile : Path of the Adele profile to find Adele installation
-rb Base         : Base in Adele V3, TCK in Adele V5
-rw Ws           : Workspace name
-rimage image    : Remote workspace image name (for ADLV5 purpose only)
-rtree tree_mk_fw: Workspace tree for the new frameworks (mandatory for 2way transfers and for Adele V5 workspace)
-rproj Project   : Project in base (For Adele V3 test purpose only)
-rmaint          : Maintenance mode is activated on base
-rtmp TmpDir     : Temporary directory to store file to be copied (or received)
-ru username     : login name of remote workspace owner

-r_photo         : To check-in all files and freeze the remote workspace BEFORE the transfer
-r_collect       : To collect remote workspace
-r_sync          : To synchronize remote workspace
-r_publish       : To publish remote workspace
-r_promote       : To publish and promote remote workspace

-r_TransferToolProfile: path to the profile to execute to access transfer tools

LOCAL parameters of the data transfer:
-ll AdeleLevel   : Level of local Adele tool ('3' for Adele V3 and '5' for Adele V5)
-lp AdeleProfile : Path of the Adele profile to find Adele installation
-lb Base         : Base in Adele V3, TCK in Adele V5
-lw Ws           : Workspace name
-limage image    : Local workspace image name (for ADLV5 purpose only)
-ltree tree_mk_fw: Workspace tree for the new frameworks (mandatory for Adele V5 workspace)
-lproj Project   : Project in base (For Adele V3 test purpose only)
-C               : Maintenance mode is activated on base
-ltmp TmpDir     : Temporary directory to store file to be copied (or received)

-l_collect WSi ... : To run adl_collect into the local workspace BEFORE its synchronization and for all promoted workspace or only for the specified ones
-l_sync          : To synchronize the local workspace (MANDATORY for 2 way transfer)
-l_publish       : To publish local workspace AFTER the transfer
-l_promote WSi...: To publish and promote local workspace to the parent workspace in Adele V3 or to the specified workspace(s) in Adele V5
-l_cr CRi...     : To precise change request number list with local workspace promotion
-no_update_cr    : To disconnect update change request phase

-first_transfer_by_push: only for the first transfer if all data exist only in local site 
                         and must be sent to the remote site.

-display <display>: To specify a screen in case of merging files

