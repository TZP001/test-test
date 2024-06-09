Copyright Dassault Systemes - May 2001

AdeleMultiSite product - Version 5700

1) What's new?
==============
2000/08/08 - Correction of bugs: lsa from local mode to server mode)
2000/08/07 - Add functionality : filter local lsout even no framework list has been provided to take in account that a destination workspace can contain more than the contents of the source workspace (new frameworks for example)
2001/01/25 - Add a complete documentation on the product
2001/03/26 - Add functionilies: options -rsite, -lsite, -rimage, -limage, -rtree, -no_update_cr

II) Prepare a data transfer 
============================

About the recommended process you have to put in place:
--------------------------------------------------------

1) Verify in your destination Adele database that no framework to transfer already exist 
2) Create the target workspace in it with the same owner as workspace owner in source database
3) Touch in the target workspace of the data transfer, a directory named 
	- if target database is Adele V3: $ADL_W_DIR/.Adele/MultiSite/$TID/0Lsout.current.Reference
	- if target database is Adele V5: $ADL_IMAGE_DIR/ToolsData/MultiSite/$TID/0Lsout.current.Reference
4) Create one shell script to encapsulate the data transfer tool and its parameters per data transfer (take a look to the Sample_v3_v3.sh file)
5) If you want, you can call us to verify all parameters of your data transfer parameter file
6) To start the data transfer, run the encapsulation script. 


Here is the help of the main shell script adl_transfer_remote_ws.sh
--------------------------------------------------------------------
adl_transfer_remote_ws.sh -tid TransferId [-mail [addr...]] [-http HttpServer] [-simul] [-trace_adl_cmd]
        [-keep_trace n] -rhost RemoteHost
        [-rsite SiteName] -rl AdeleLevel -rp AdeleProfile -rb Base [-rproj Project] -rw Ws [-rimage image] [-rtree ws_tree] -rtmp TmpDir -rmaint
        [-fw Fw... | -lfw Filename]
        [-lsite SiteName] -ll AdeleLevel -lp AdeleProfile -lb Base [-lproj Project] -lw Ws [-limage image] [-ltree ws_tree] -ltmp TmpDir
        [-r_collect] [-r_sync] [-r_publish] [-r_promote]
        [-l_collect WSi ... ] [-l_sync]
        [-l_publish] [-l_promote WSi ... ] [-l_cr CRi ... ]
        [-no_update_cr]
        [-keep_trace n]

Golbal parameters:
-tid TransferId  : TransferId (example: ENO, DSA, DSP, ...
-mail [addr...]  : Results will be sent by mail to specified addresses; if no address is specified, the mail will be sent to people declared in $MAIL_ADDR_LIST list
     (example: export MAIL_ADDR_LIST="ygd@soleil apa@soleil")
-http HttpServer : Address of the http server which be able to display generated HTML page
             (example: http://herrero:8016)
-simul           : To simulate the data transfer. Adele command will be displayed but won't be launched
-trace_adl_cmd   : To display Adele command traces on terminal
-keep_trace n    : Number of trace directories to keep ; the trace directories are created into the wlocal workspace directory ws_dir
    Adele V3: <ws_dir>/.Adele/MultiSite/<TransferId>/Tracexxx
    Adele V5: <ws_dir>/ToolsData/MultiSite/<TransferId>/Tracexxx

REMOTE parameters of the data transfer:
-rhost RemoteHost: Remote host name (example: centaur.deneb.com)
-rsite SiteName  : Name of the remote site (If Adele V5, this name must the same name as returned by adl_ls_site command)
-rl AdeleLevel   : Level of remote Adele tool ('3' for Adele V3 and '5' for Adele V5)
-rp AdeleProfile : Path of the Adele profile to find adele installation
-rb Base         : Base in Adele V3, tck in Adele V5
-rw Ws           : Workspace name
-rimage image    : Image name (For Adele V5 purpose only)
-rtree ws_tree   : Workspace tree in case of multitree ws (optional for Adele V5 workspace)
-rproj Project   : Project in base (For Adele V3 test purpose only)
-rmaint          : Maintenance mode is activated on base
-rtmp TmpDir     : Temporary directory to store file to be copied

-fw Fw...        : Frameworks to consider
-lfw Filename    : Filename containing a list of Frameworks to consider (one framework name per line)
     (if neither -fw option, nor -lfw option precised, all frameworks are considered)

-r_photo         : To check-in all files and freeze the remote workspace BEFORE the transfer
-r_collect       : To collect remote workspace
-r_sync          : To synchronize remote workspace
-r_publish       : To publish remote workspace
-r_promote       : To publish and promote remote workspace

LOCAL parameters of the data transfer:
-rsite SiteName  : Name of the local site (If Adele V5, this name must the same name as returned by adl_ls_site command)
-ll AdeleLevel   : Level of local Adele tool ('3' for Adele V3 and '5' for Adele V5)
-lp AdeleProfile : Path of the Adele profile to find adele installation
-lb Base         : Base in Adele V3, tck in Adele V5
-lw Ws           : Workspace name
-limage image    : Image name (For Adele V5 purpose only)
-ltree ws_tree   : Workspace tree for the new frameworks (mandatory for Adele V5 workspace)
-lproj Project   : Project in base (For Adele V3 test purpose only)
-C               : Maintenance mode is activated on base
-ltmp TmpDir     : Temporary directory to store file to be copied

-l_collect WSi ... : To run adl_collect into the local workspace BEFORE the transfer for all promoted workspace or only for the specified ones
-l_sync          : To synchronize the local workspace BEFORE the transfer
   This option is recommended in order to avoid merges.

-l_publish       : To publish local workspace AFTER the transfer
-l_promote WSi...: To publish and promote local workspace to the parent workspace in Adele V3 or to the specified workspace(s) in Adele V5
-l_cr CRi...     : To precise change request number list with local workspace promotion
-no_update_cr    : To disconnect update change request phase

