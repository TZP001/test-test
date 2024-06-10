#!/bin/ksh
#############################################################################
#                                                                           #
#                                                                           #
# COPYRIGHT DASSAULT SYSTEMES 1998                                          #
# CATIA V5 for UNIX                                                         #
# Licensed Material Program Property of IBM                                 #
#                                                                           #
#       Component Class : Shell Script command to start CATDMUDistribute    #
#                                                                           #
#       Component Name  : LauchDistribution                                 #
#                                                                           #
#                                                                           #
#############################################################################
#
# set -x	
#-------------------------------------------------------------------------#
# Initialization
#-------------------------------------------------------------------------#
 OutputFile=""
 UserTransfert=""
 PwdTransfert=""
 ExtTransfert="cgr"
 ModeTransfert="ftp"
 TypeTransfert="binary"
 TargetMachine=""
 TargetCache=""
 TargetUser=""
 TargetPwd=""
 Server=""
 cmdParam=""
 opt_file=0
 opt_user=0
 opt_pwd=0  
 opt_coid=0
 opt_compid=0
 opt_caenv=0
 opt_catab=0
 opt_ch=0
 opt_csbzone=0
 opt_csbmode=0
 opt_extension=0
 opt_machine=0
 opt_cache=0
 opt_dtu=0
 opt_dtp=0
 opt_dtm=0
 opt_svn=0
#-------------------------------------------------------------------------#
# Read parameters
#-------------------------------------------------------------------------#
for opt in "$@"
 do
  case "$opt" in
       '-file'  )
	   	   opt_file=1;;
        '-user' )
           opt_user=1;;
	     '-pwd' )
           opt_pwd=1;;
         '-coid' )
           opt_coid=1;;
         '-compid' )
           opt_compid=1;;
         '-caenv' )
           opt_caenv=1;;
         '-catab' )
           opt_catab=1;;
         '-ch' )
           opt_ch=1;;
         '-csbzone' )
           opt_csbzone=1;;
         '-csbmode' )
           opt_csbmode=1;;
         '-extension' )
           opt_extension=1;;
         '-machine' )
           opt_machine=1;;
         '-cache' )
           opt_cache=1;; 
         '-dtu' )
           opt_dtu=1;; 
         '-dtp' )
           opt_dtp=1;; 
 		  '-dtm' )
           opt_dtm=1;; 
          '-svn' )
           opt_svn=1;; 
  	* ) # other options #
          if [ $opt_file = 1 ]
          then
             OutputFile=$opt
     		 cmdParam=$cmdParam" -file "$OutputFile
             opt_file=0
          elif [ $opt_user = 1 ]
          then
    		 TargetUser=$opt
	         cmdParam=$cmdParam" -user "$TargetUser
             opt_user=0
          elif [ $opt_pwd = 1 ]
          then
             TargetPwd=$opt
             cmdParam=$cmdParam" -pwd "$TargetPwd
	         opt_pwd=0  
          elif [ $opt_coid = 1 ]
          then 
	         cmdParam=$cmdParam" -coid "$opt
             opt_coid=0
          elif [ $opt_compid = 1 ]
          then 
             cmdParam=$cmdParam" -compid "$opt
             opt_compid=0
          elif [ $opt_caenv = 1 ]
          then 
             cmdParam=$cmdParam" -caenv "$opt
             opt_caenv=0
          elif [ $opt_catab = 1 ]
          then 
             cmdParam=$cmdParam" -catab "$opt
             opt_catab=0
          elif [ $opt_ch = 1 ]
          then 
             cmdParam=$cmdParam" -ch "$opt
             opt_ch=0
          elif [ $opt_csbzone = 1 ]
          then 
             cmdParam=$cmdParam" -csbzone "$opt
             opt_csbzone=0
          elif [ $opt_csbmode = 1 ]
          then
             cmdParam=$cmdParam" -csbmode "$opt
             opt_csbmode=0
          elif [ $opt_extension = 1 ]
          then 
             ExtTransfert=$opt
             opt_extension=0
          elif [ $opt_machine = 1 ]
          then 
             TargetMachine=$opt
             opt_machine=0
          elif [ $opt_cache = 1 ]
          then 
             TargetCache=$opt
             opt_cache=0
          elif [ $opt_dtu = 1 ]
          then 
             UserTransfert=$opt
             opt_dtu=0
          elif [ $opt_dtp = 1 ]
          then 
             PwdTransfert=$opt
             opt_dtp=0
          elif [ $opt_dtm = 1 ]
          then 
             ModeTransfert=$opt
             opt_dtm=0
          fi  
 	      elif [ $opt_svn = 1 ]
          then 
             Server=$opt
             opt_svn=0
          fi  
        esac
done
 cmdParam=$cmdParam" -savemode MODELS"
 cmdDir=`dirname $OutputFile`
 cmdBas=`basename $OutputFile`
 
#-------------------------------------------------------------------------#
# Build .log file
#-------------------------------------------------------------------------#
 cmdTmp=`echo $cmdBas | cut -d'.' -f1`	
 cmdLog=$cmdDir/$cmdTmp".log"	
 if [ -f "$cmdLog" ]
  then
	chmod 777 $cmdLog
  else
    touch $cmdLog
    chmod 777 $cmdLog
 fi	

#-------------------------------------------------------------------------#
# Build input temporaly  file
#-------------------------------------------------------------------------#
 cmdInt=`echo $cmdBas | cut -d'_' -f2-`	
 cmdTmp=$cmdDir/input_$cmdInt
 touch $cmdTmp
 chmod 777 $cmdTmp
 echo AT0EXPND" "$cmdParam > $cmdTmp

#-------------------------------------------------------------------------#
# start VPM environment initialization 
#-------------------------------------------------------------------------#
 cd $vpm_directory_start
 if [ -n "$vpm_shell_start" ]
 then
   . ./$vpm_shell_start
 else
   . ./VPMWsUser.sh
 fi

#-------------------------------------------------------------------------#
# start VPM Program AT0EXPND 
#-------------------------------------------------------------------------#
 AT0EXPND $cmdParam
 rc=$?
 if [ $rc -ne 0 ]
  then
    echo "ERROR AT0EXPND Program aborted" >&2
    echo "ERROR AT0EXPND Program failed witch RC=$rc" > $cmdLog
	echo "      AT0EXPND Parameters : $cmdParam" > $cmdLog
 fi
 rm $cmdTmp

#-------------------------------------------------------------------------#
# start DMU Program CATDMUExtract 
#-------------------------------------------------------------------------#
 CATDMUExtract $OutputFile $ExtTransfert $TargetUser $TargetPwd $Server
 rc=$?
 if [ $rc -ne 0 ]
  then
    echo "ERROR CATDMUCopy Program aborted" >&2
	echo "ERROR CATDMUCopy Program failed witch RC=$rc" > $cmdLog
	echo "      CATDMUCopy Parameter : $cmdFile" > $cmdLog
  fi

#-------------------------------------------------------------------------#
# Distribute temporary files 
#-------------------------------------------------------------------------#
 cmdTmp=`echo $cmdBas | cut -d'.' -f1`	
 SourceFileCgr=$cmdDir/$cmdTmp"_cgr"	
 SourceFile3dmap=$cmdDir/$cmdTmp"_3dmap"


#-------------------------------------------------------------------------#
# Cgr Distribution 
#-------------------------------------------------------------------------#

if [ ! -s $SourceFileCgr ] ;
  then
    echo "WARNING file ($cmdDistCgr) does not exist or is empty" > $cmdLog
  else
    ReturnOKTransfert=0
    ReturnK0Transfert=0
    for file in $(<$SourceFileCgr) ; do
	   TransfertFileName=$(basename $file) 
       if [ $ModeTransfert = ftp ]
         then
           TargetFile=$TargetCache/cgr/$TransfertFileName
           DataTransfertFTP.sh $TargetMachine $UserTransfert $PwdTransfert $file $TargetFile
           ReturnCode=$?

       elif [ $ModeTransfert = rdist ]
         then
           rdist "-c "$file" "$UserTransfert"@"$TargetMachine":"$TargetCache/cgr/
           ReturnCode=$?
       fi
 	   if [ ReturnCode -ne 0 ] ; 
         then
           ReturnKOTransfert=`expr $ReturnKOTransfert+1`
       else 
           ReturnOKTransfert=`expr $ReturnOKTransfert+1`
       fi
    done
    echo "INFO  $ReturnOKTransfert cgr file(s) sucessfully transfered" > $cmdLog 
    if [ $ReturnKOTransfert -ne 0 ] ; 
      then
	    echo "INFO  $ReturnKOTransfert cgr file(s) not transfered" > $cmdLog 
    fi
fi

#-------------------------------------------------------------------------#
# 3dmap Distribution 
#-------------------------------------------------------------------------#
if [ ! -s $SourceFile3dmap ] ; 
  then
    echo "WARNING file ($cmdDist3dmap) does not exist or is empty" > $cmdLog
  else
    ReturnKOTransfert=0
    ReturnOKTransfert=0
    for file in $(<$SourceFile3dmap) ; do
	   TransfertFileName=$(basename $file) 
       if [ $ModeTransfert = ftp ]
         then
           TargetFile=$TargetCache/3dmap/$TransfertFileName
           DataTransfertFTP.sh $TargetMachine $UserTransfert $PwdTransfert $file $TargetFile
           ReturnCode=$?
	   elif [ $ModeTransfert = rdist ]
         then
		   rdist "-c "$file" "$UserTransfert"@"$TargetMachine":"$TargetPath/3dmap/  
           ReturnCode=$?
       fi
       if [ ReturnCode -ne 0 ] ; 
         then
           ReturnKOTransfert=`expr $ReturnKOTransfert+1`
         else 
           ReturnOKTransfert=`expr $ReturnOKTransfert+1`
       fi
    done
    echo "INFO  $ReturnOKTransfert 3dmap file(s) sucessfully transfered" > $cmdLog 
    if [ $ReturnKOTransfert -ne 0 ] ; 
      then
        echo "INFO  $ReturnKOTransfert 3dmap file(s) not transfered" > $cmdLog
    fi 
fi

exit 0	 
























