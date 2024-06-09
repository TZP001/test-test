#!/bin/ksh
# Donnez le nom de la base du report.
# Ou utiliser l'option -a pour lancer toutes les bases associees au User de travail.
# Utiliser -p pour ne pas promouvoir les actions du report SCM.
# -----------------------------------------------------------------------------

Bilan()
{
# -----------------------------------------------------------------------------
# Etablissement du Bilan.
# ----------------------------------------------------------------------------- 
for Base in $Liste3
do
  unset machine TREE2 TREE1 Base2 Base1 Ws2 Ws1 iflag tflag2 tflag1
  if [ -f $DirWork/${Base}_Param ]
  then
     awk -F\# '{print $1}' $DirWork/${Base}_Param > ${DirWork}/TempoFile${Name_Rep}
     while read flag Value
     do
        if [ -z "$flag" ]
        then
           continue
        fi
        case $flag in
           -lhost) machine=$Value;; 
           -ltree) TREE2=$Value;tflag2=1;;
           -rtree) TREE1=$Value;tflag1=1;;
           -lb) Base2=$Value;;
           -rb) Base1=$Value;;
#           -tck) Base1=$Value;Base2=$Value;;
           -lw) Ws2=$Value;;
           -rw) Ws1=$Value;;
           -import) iflag=1;;
        esac
     done < ${DirWork}/TempoFile${Name_Rep}
     if [ "$tflag2" = "1" ]
     then 
        Base2=${Base2}"_"$TREE2 
     fi
     if [ "$tflag1" = "1" ]
     then 
        Base1=${Base1}"_"$TREE1 
     fi
  else
     ligne=$(grep -w "$Base$" $Report_Liste | awk -F\; '{ print $1 }' | head -1)
     if [ -z "$ligne" ]
     then
#        echo "Le Report_ID ou le fichier PARAM $Base n'existe pas" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
        echo "The Report_ID or the Param file $Base doesn't exist" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
        continue
     else
        Base1=$(echo $ligne | awk '{ print $1 }')
        Base2=$(echo $ligne | awk '{ print $3 }') 
        Ws1=$(echo $ligne | awk '{ print $2 }') 
        Ws2=$(echo $ligne | awk '{ print $4 }') 
     fi
  fi 
  echo "===> Base : ${Base1}-${Base2}" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
  echo "===> See file : ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
  grep "^END_" ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} > /dev/null
  if [ $? -eq 0 ]
  then
     if [ "$FlagSimul" = "-s" ]
     then
        grep -E "adl_|KO:" ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} | grep -v "WNG:" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
     else
        grep -E "adl_detach|KO:|INFO:" ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
     fi 
  else
#     echo "KO: > Le process n'est pas termine ?????" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
     echo "KO: > the process is not finished ?????" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
     echo "$(tail -2 ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2})" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep} 
  fi
  echo "-----------------------------------------------------------------" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
done

echo "=== INFO adl_report_submit.sh = END : `date`" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
echo "-----------------------------------------------------------------" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++ The SCM TRANSFER is finished ++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++ The SCM TRANSFER is finished ++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++ The SCM TRANSFER is finished ++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

updatefile()
{
   if [ ! -f $1 ]
   then
      touch $1
   fi
   if [ ! -z "$COMPUTERNAME" ] || [ "$(uname)" = "IRIX" ] || [ "$(uname)" = "SunOS" ] || [ "$(uname)" = "IRIX64" ]
   then
      awk -F\; -v Ba="$2" -v Li="$3" -v Op="$4" '{  if ($1 != Ba) { print $0 } } END { if ( Op != "D" ) { print Li; } }' $1 > $1_tmp
   else
      awk -F\; -vBa="$2" -vLi="$3" -vOp="$4" '{ if ($1 != Ba) { print $0 } } END { if ( Op != "D" ) { print Li; } }' $1 > $1_tmp 
   fi
   mv $1_tmp $1 > /dev/null 2>&1 
}

sortie()
{
trap ' ' HUP INT QUIT TERM KILL

if [ $# -lt 1 ]
then
   rc=0
else
   rc=$1
   shift
fi

if [ $# -gt 0 ]
then
   echo "KO: $*"
else
   echo "$*"
fi

IFS=';'
while read v1 v2 v3 v4 v5 PID_rsh 
do 
   if [ ! -z "$PID_rsh" ]
   then
      kill $PID_rsh
   fi
done < ${DirWork}/Base_Send${Name_Rep}
IFS=' '

\rm -f ${DirWork}/Base_Send${Name_Rep}
\rm -f ${DirWork}/Host_use${Name_Rep}
\rm -f ${DirWork}/Host_Report${Name_Rep}
\rm -f ${DirWork}/GO_report_File${Name_Rep}

Bilan

\rm -f ${DirWork}/TempoFile${Name_Rep} > /dev/null

exit $rc
}


# -----------------------------------------------------------------------------
# DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT
# -----------------------------------------------------------------------------
export SHELL_ROOT_DIR=$(dirname $(whence $0))
trap 'sortie 1 "Interrupt Command" ' HUP INT QUIT TERM KILL
usage="\
       adl_report_submit.sh [-s ] [ -i ID ] [ -p ] [ -h ] [-a | Report_ID  ... | -l file]\n
       -h For help\n
       -s Simulation mode.\n
       -i Identifie the transfer process.\n
       ID : transfer name.\n 
       -p Without Promotion.\n 
       -a Submit all transfer declared in /adl_report_string file\n
       -l To identify a list file\n
       file : File with a list of transfer_ID found in /adl_report_string file\n
       Report_ID : is a transfer_ID". 

set -- $(getopt armpshl:i: $*) || sortie 1 "$usage"
if [ $? != 0 ]
then
   exit 1
fi

if [ ! -z "$ADL_DEBUG" ]
then
   set -x
fi

export PATH=/usr/xpg4/bin:/usr/bin:/usr/ucb:$PATH
. $SHELL_ROOT_DIR/variable_transfer.sh
R_PROFILE=$PROFILE_V3
L_PROFILE=$PROFILE_V5
R_TEMP="/tmp"
L_TEMP="/tmp"
Name_Rep=""

user=$(whoami)
#grep "^${user};" ${SHELL_ROOT_DIR}/adl_report_user_liste > /dev/null 2>&1
#if [ $? -ne 0 ]
#then
#   echo "User $user is not autorize to submit Report"
#   exit
#fi

if [ $(echo $(whoami) | wc -c) -lt 4 ]
then
   Sigle=$(whoami)
else
   Sigle=$(echo $(whoami) | cut -c 1-3)
fi

typeset -u Sigle
DirWork="${HOME}/REPORT_${Sigle}_RES"
if [ ! -d "$DirWork" ]
then
#   echo "Creez ce directory : $DirWork"
#   echo "et le fichier $DirWork/adl_report_string d'une ligne,"
#   echo "contenant la liste des reports a lancer."
#   echo "La liste des reports se trouvent dans le fichier"
#   echo "$DirWork/adl_report_Liste ou ${SHELL_ROOT_DIR}/adl_report_cga_liste"
#   echo "Pour creer le fichier $DirWork/adl_report_Liste voir comme"
#   echo "exemple le fichier ${SHELL_ROOT_DIR}/adl_report_cga_liste"  
   echo "You have to create this directory : $DirWork"
   echo "and the $DirWork/adl_report_string file, with the list"
   echo "of the transfer_ID separated by blank on one ligne."
   echo "The transfer liste find in $DirWork/adl_report_Liste file"
   echo "To create the $DirWork/adl_report_Liste file"
   echo "with ${SHELL_ROOT_DIR}/adl_report_cga_liste sample file"  
   exit
fi

FlagRatrapp=0
FlagPromote=""
while [ $1 != -- ]
do
   case $1 in
      -a) # Toutes les base
          if [ ! "1" = "$FlagListe" ]
          then
          if [ -f $DirWork/adl_report_string ]
          then 
             Liste=$(cat $DirWork/adl_report_string)
          elif [ -f $SHELL_ROOT_DIR/adl_report_${Sigle}_string ]
          then 
             Liste=$(cat $SHELL_ROOT_DIR/adl_report_${Sigle}_string)
          else
             Liste=""
          fi   
          fi;;
      -p) # Sans Promotion
          FlagPromote="-p";;
      -m) # Mode Maintenance 
          FlagRI="-m";;
      -s) # Mode Simulation 
          FlagSimul="-s";;
      -l) # Avec une liste de process 
          FlagListe=1
          Liste=$(cat $2)
          shift;; 
      -i) # Pour identifier le process lance
          Name_Rep="_$2"
          shift;; 
      -r) # Avec ratrapp 
          FlagRatrapp=1;;
      -h) # Aide 
          echo $usage
          exit;;
   esac    
   shift
done
shift

if [ -f ${DirWork}/Base_Send${Name_Rep} ] || [ -f ${DirWork}/Host_use${Name_Rep} ] || [ -f ${DirWork}/Host_Report${Name_Rep} ] || [ -f $DirWork/GO_report_File${Name_Rep} ]
then
   echo "- Si un Process est en cours d'execution, vous devez attendre la fin"
   echo "de l'execution" 
   echo ""
   echo "- Sinon vous devez effacer l'ensemble des fichiers suivants:"
   echo "${DirWork}/Base_Send${Name_Rep}"
   echo "${DirWork}/Host_use${Name_Rep}"
   echo "${DirWork}/Host_Report${Name_Rep}"
   echo "$DirWork/GO_report_File${Name_Rep}"
   exit 1 
fi

if [ ! "$FlagListe" = "1" ]
then
   Liste2=$*
   Liste=${Liste:-$Liste2}
fi
Liste2=$Liste
Liste3=$Liste

if [ -z "$Liste" ]
then
#   echo "Vous avez oublie de donner le nom de votre base."
#   echo "Ou la liste que vous avez referencee n'est pas correcte."
   echo "Your base name is not define"
   echo "Or your list is not correct (adl_report_string)"
   exit
fi

if [ -f $DirWork/adl_report_liste ]
then
   Report_Liste="$DirWork/adl_report_liste"
else
   Report_Liste="${SHELL_ROOT_DIR}/adl_report_cga_liste"
fi

touch $DirWork/GO_report_File${Name_Rep}
touch ${DirWork}/Host_use${Name_Rep}
\rm -f ${DirWork}/Bilan_${Sigle}${Name_Rep}

echo "-----------------------------------------------------------------" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep} 
echo "=== INFO adl_report_submit.sh = TRANSFER : `date`" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}
echo "-----------------------------------------------------------------" | tee -a ${DirWork}/Bilan_${Sigle}${Name_Rep}

# -----------------------------------------------------------------------------
# Lancement des premiers process avec determination des conflits.
# ----------------------------------------------------------------------------- 
while [ -f $DirWork/GO_report_File${Name_Rep} -a ! -z "$Liste2" ] 
do
   for Base in $Liste
   do
      ligne=""
      FlagBase1=0
      FlagBase2=0
      let "x = 1"
      unset iflag machine lpflag Level1 Level2 rpflag TREE2 TREE1 Base1 Base2 Ws1 Ws2 fflag tflag1 tflag2
      if [ -f $DirWork/${Base}_Param ]
      then
         awk -F\# '{print $1}' $DirWork/${Base}_Param > ${DirWork}/TempoFile${Name_Rep}
         while read flag Value
         do
            if [ -z "$flag" ]
            then
               continue
            fi
            case $flag in
               -lhost) machine=$Value;; 
               -rhost) if [ ! "$iflag" = "1" ]
                    then
                       ligne=$ligne" "$flag" "$Value
                    fi;;
               -ll) Level1=$Value
                    if [ ! "$iflag" = "1" ]
                    then 
                       ligne=$ligne" "$flag" "$Value 
                    fi
                    if [ ! "$lpflag" = "1" ]
                    then  
                       if [ "$Level1" = "3" ]
                       then 
                          L_PROFILE=$PROFILE_V3
                       else
                          L_PROFILE=$PROFILE_V5
                       fi
                    fi;;
               -rl) Level2=$Value
                    if [ ! "$iflag" = "1" ]
                    then
                       ligne=$ligne" "$flag" "$Value 
                    fi
                    if [ ! "$rpflag" = "1" ]
                    then
                       if [ "$Level2" = "3" ]
                       then 
                          R_PROFILE=$PROFILE_V3
                       else
                          R_PROFILE=$PROFILE_V5
                       fi
                    fi;;
               -ltree) TREE2=$Value;tflag2=1
                    ligne=$ligne" "$flag" "$Value;;  
               -rtree) TREE1=$Value;tflag1=1
                    if [ "$iflag" = "1" ]
                    then
                       ligne=$ligne" "$flag" "$Value
                    fi;;
               -lb) Base2=$Value
                    if [ ! "$iflag" = "1" ]
                    then
                       ligne=$ligne" "$flag" "$Value
                    else  
                       ligne=$ligne" "-tck" "$Value
                    fi;;
#               -tck) Base1=$Value;Base2=$Value
#                    ligne=$ligne" "$flag" "$Value;;
               -rb) Base1=$Value
                    if [ ! "$iflag" = "1" ]
                    then
                       ligne=$ligne" "$flag" "$Value
                    fi;;  
               -lw) Ws2=$Value
                    ligne=$ligne" "$flag" "$Value;;  
               -rw) Ws1=$Value
                    ligne=$ligne" "$flag" "$Value;;  
               -fw) fflag="1"
                    ligne=$ligne" "$flag" "$Value;;  
               -all_fw) fflag="1"
                    ligne=$ligne" "$flag" "$Value;;
               -rtmp) R_TEMP=$Value;;
               -ltmp) L_TEMP=$Value;;
               -rp) rpflag=1;R_PROFILE=$Value;;
               -lp) lpflag=1;L_PROFILE=$Value;;
               -import) iflag=1;; 
               *)   ligne=$ligne" "$flag" "$Value;;
            esac
         done < ${DirWork}/TempoFile${Name_Rep}
         if [ "$tflag2" = "1" ]
         then
            Base2=${Base2}"_"$TREE2
         fi
         if [ "$tflag1" = "1" ]
         then
            Base1=${Base1}"_"$TREE1
         fi
         if [ "$fflag" != "1" ] && [ "$iflag" = "1" ]
         then
            ligne=$ligne" -all_fw"
         fi
         if [ "$iflag" = "1" ]
         then
            ligne=$ligne" -p $L_PROFILE  -tid $Base" 
         else
            ligne=$ligne" -rp $R_PROFILE -lp $L_PROFILE -rtmp $R_TEMP -ltmp $L_TEMP -tid $Base" 
         fi
         if [ "$FlagPromote" != "-p" ]
         then
            ligne=$ligne" -l_publish -l_promote"
         fi
         if [ "$FlagSimul" = "-s" ]
         then
            if [ "$iflag" = "1" ]
            then
               ligne=$ligne" -simul_import"
            else 
               ligne=$ligne" -simul"
            fi
         fi
      else
         ligne=$(grep -w "$Base$" $Report_Liste | awk -F\; '{ print $1 }' | head -1)
         machine=$(grep -w "$Base$" $Report_Liste | awk -F\; '{ print $2 }' | head -1)
         if [ -z "$ligne" ]
         then
#            echo "La base $Base n'existe pas dans le fichier $Report_Liste"
            echo "The base $Base doesn't exist in $Report_Liste file"
            Liste=$(echo $Liste | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
            continue
         else
            Base1=$(echo $ligne | awk '{ print $1 }')
            Base2=$(echo $ligne | awk '{ print $3 }') 
            Ws1=$(echo $ligne | awk '{ print $2 }') 
            Ws2=$(echo $ligne | awk '{ print $4 }') 
            ligne=$(echo $ligne | awk -F\; '{ print $1 }' | awk '{ $5=""; print $0 }')
         fi
      fi
      if [ -f ${DirWork}/Base_Send${Name_Rep} ]
      then
         ligneB1=$(grep "^$Base1;" ${DirWork}/Base_Send${Name_Rep})
         if [ $? -eq 0 ]
         then
            LsoutVar=$(echo $ligneB1 | awk -F\; '{ print $2 }')
            if [ "$LsoutVar" = "1" ]
            then
               FlagBase1=0
            else
               FlagBase1=1
            fi  
         else
            FlagBase1=1
         fi      
         ligneB2=$(grep "^$Base2;" ${DirWork}/Base_Send${Name_Rep})
         if [ $? -eq 0 ]
         then
            EndVar=$(echo $ligneB2 | awk -F\; '{ print $4 }')
            if [ "$EndVar" = "1" ]
            then
               FlagBase2=0
            else
               FlagBase2=1
            fi
         else
            FlagBase2=1
         fi 
      else
         FlagBase1=1
         FlagBase2=1
      fi
      if [ "$FlagBase1" = "1" ] && [ "$FlagBase2" = "1" ]
      then
# -----------------------------------------------------------------------------
# Recherche d'une machine UNIX.
# ----------------------------------------------------------------------------- 
         if [ ! -f $DirWork/${Base}_Param ] 
         then
            if [ -f $SHELL_ROOT_DIR/adl_report_${Sigle}_host ]
            then
               let "x = 0"
               FlagMac=0 
               while [ "$FlagMac" = "0" ]
               do
                  let "x = x + 1" 
                  for machine in $(cat $SHELL_ROOT_DIR/adl_report_${Sigle}_host)  
                  do
                     LigneMa=$(grep "^${machine};" ${DirWork}/Host_use${Name_Rep})
                     if [ $? -eq 0 ]
                     then
                        UseVar=$(echo $LigneMa | awk -F\; '{ print $2 }')
                        if [ ! $x -gt $UseVar ]
                        then
                           continue
                        fi
                     fi  
                     if [ "$(uname)" = "IRIX" ] || [ "$(uname)" = "IRIX64" ]
                     then
                        echo rsh $machine echo "Connection test"
                        rsh $machine echo "Connection test" > /dev/null 2>&1
                     else
                        echo remsh $machine echo "Connection test"
                        remsh $machine echo "Connection test" > /dev/null 2>&1
                     fi
                     if [ $? -ne 0 ]
                     then
                        continue
                     fi
                     FlagMac=1
                     break
                  done
               done
            else
               if [ "$(uname)" = "IRIX" ] || [ "$(uname)" = "IRIX64" ]
               then
                  echo rsh $machine echo "Connection test"
                  rsh $machine echo "Connection test"
               else
                  echo remsh $machine echo "Connection test"
                  remsh $machine echo "Connection test"
               fi
               if [ $? -ne 0 ]
               then
                  echo "KO: $machine Connection Problem" > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
                  echo "ENDLSOUT_${Base2}" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
                  echo "END_${Base2}" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
                  Liste=$(echo $Liste | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
                  Liste2=$(echo $Liste2 | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
                  continue
               fi
            fi # Recherche machine 
         else 
            if [ "$(uname)" = "IRIX" ] || [ "$(uname)" = "IRIX64" ]
            then
               echo rsh $machine echo "Connection test"
               rsh $machine echo "Connection test"
            else
               echo remsh $machine echo "Connection test"
               remsh $machine echo "Connection test"
            fi
            if [ $? -ne 0 ]
            then
               echo "KO: $machine Connection Problem" > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
               echo "ENDLSOUT_${Base2}" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
               echo "END_${Base2}" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
               Liste=$(echo $Liste | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
               Liste2=$(echo $Liste2 | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
               continue
            fi
         fi # Non SCM V5 
         LigneMa=$(grep "^${machine};" ${DirWork}/Host_use${Name_Rep})
         if [ $? -eq 0 ]
         then
            UseVar=$(echo $LigneMa | awk -F\; '{ print $2 }')
            let "x = UseVar + 1"
         fi
         updatefile ${DirWork}/Host_use${Name_Rep} $machine "$machine;$x"
         updatefile ${DirWork}/Host_Report${Name_Rep} ${Base1}_${Ws1}_${Base2}_${Ws2} "${Base1}_${Ws1}_${Base2}_${Ws2};$machine"
# -----------------------------------------------------------------------------
# Lancement.
# ----------------------------------------------------------------------------- 
         # cp -f ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} ~dst/cga/report_${Base1}_${Ws1}_${Base2}_${Ws2}_$(date +%d-%m-%Y-%T) > /dev/null 2>&1
         mv -f ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}_old > /dev/null 2>&1

         if [ ! "$FlagRatrapp" = "1" ]
         then 
            if [ -f $DirWork/${Base}_Param ]
            then
               if [ "$iflag" = "1" ]
               then 
               echo "remsh $machine . $SHELL_ROOT_DIR/AdeleMultiSite_profile;adl_transfer_ws_v5.sh $ligne" | tee -a ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
               else
               echo "remsh $machine . $SHELL_ROOT_DIR/AdeleMultiSite_profile;adl_transfer_remote_ws.sh $ligne" | tee -a ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
               fi
            else
               echo "remsh $machine $SHELL_ROOT_DIR/adl_report_cga_base.sh $FlagRI $FlagPromote $FlagSimul traitement_global $ligne" | tee -a ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
            fi
         else
            echo "remsh $machine $SHELL_ROOT_DIR/adl_report_cga_ratrapp.sh $FlagRI $FlagPromote $FlagSimul traitement_global $ligne" | tee -a ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
         fi 
         if [ "$(uname)" = "IRIX" ] || [ "$(uname)" = "IRIX64" ]
         then
            if [ ! "$FlagRatrapp" = "1" ]
            then 
               if [ -f $DirWork/${Base}_Param ]
               then
                  if [ "$iflag" = "1" ]
                  then
                  rsh $machine ". $SHELL_ROOT_DIR/AdeleMultiSite_profile;adl_transfer_ws_v5.sh $ligne" > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 &
                  else
                  rsh $machine ". $SHELL_ROOT_DIR/AdeleMultiSite_profile;adl_transfer_remote_ws.sh $ligne" > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 &
                  fi
               else
                  rsh $machine $SHELL_ROOT_DIR/adl_report_cga_base.sh $FlagRI $FlagSimul $FlagPromote "traitement_global" $ligne > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 & 
               fi
            else
               rsh $machine $SHELL_ROOT_DIR/adl_report_cga_ratrapp.sh $FlagRI $FlagSimul $FlagPromote "traitement_global" $ligne > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 & 
            fi
         else
            if [ ! "$FlagRatrapp" = "1" ]
            then 
               if [ -f $DirWork/${Base}_Param ]
               then
                  if [ "$iflag" = "1" ]
                  then
                  remsh $machine ". $SHELL_ROOT_DIR/AdeleMultiSite_profile;adl_transfer_ws_v5.sh $ligne" > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 &
                  else
                  remsh $machine ". $SHELL_ROOT_DIR/AdeleMultiSite_profile;adl_transfer_remote_ws.sh $ligne" > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 &
                  fi
               else
                  remsh $machine $SHELL_ROOT_DIR/adl_report_cga_base.sh $FlagRI $FlagSimul $FlagPromote "traitement_global" $ligne > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 & 
               fi
            else
               remsh $machine $SHELL_ROOT_DIR/adl_report_cga_ratrapp.sh $FlagRI $FlagSimul $FlagPromote "traitement_global" $ligne > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 & 
            fi
         fi
         rc=$?
         PID_rsh=$!
# -----------------------------------------------------------------------------
# Pour effectuer des tests sur AIX HP ou SunOS.
#            remsh $machine $SHELL_ROOT_DIR/adl_report_cga_test.sh $FlagRI $FlagSimul $FlagPromote "traitement_global" $ligne > ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} 2>&1 & 
# -----------------------------------------------------------------------------
         if [ $rc -eq 0 ]
         then
            updatefile ${DirWork}/Base_Send${Name_Rep} $Base1 "$Base1;1;0;0;${Base1}_${Ws1}_${Base2}_${Ws2};$PID_rsh"
            updatefile ${DirWork}/Base_Send${Name_Rep} $Base2 "$Base2;0;0;1;${Base1}_${Ws1}_${Base2}_${Ws2};"
         else
            echo "KO: Remsh failed" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
            echo "ENDLSOUT_${Base2}" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
            echo "END_${Base2}" >> ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2}
            Liste2=$(echo $Liste2 | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
         fi
         Liste=$(echo $Liste | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
      fi
   done

# -----------------------------------------------------------------------------
# Recherche des process en attente pouvants debuter.
# ----------------------------------------------------------------------------- 
   for Base in $Liste2
   do
      unset machine TREE2 TREE1 Base1 Base2 Ws2 Ws1 tflag2 tflag1
      if [ -f $DirWork/${Base}_Param ]
      then
         awk -F\# '{print $1}' $DirWork/${Base}_Param > ${DirWork}/TempoFile${Name_Rep}
         while read flag Value
         do
            if [ -z "$flag" ]
            then
               continue
            fi
            case $flag in
               -lhost) machine=$Value;; 
               -ltree) TREE2=$Value;tflag2=1;;
               -rtree) TREE1=$Value;tflag1=1;;
#               -tck) Base1=$Value;Base2=$Value;;
               -lb) Base2=$Value;;
               -rb) Base1=$Value;;
               -lw) Ws2=$Value;;
               -rw) Ws1=$Value;;
            esac
         done < ${DirWork}/TempoFile${Name_Rep}
         if [ "$tflag2" = "1" ]
         then
            Base2=${Base2}"_"$TREE2
         fi
         if [ "$tflag1" = "1" ]
         then
            Base1=${Base1}"_"$TREE1
         fi
      else
         ligne=$(grep -w "$Base$" $Report_Liste | awk -F\; '{ print $1 }' | head -1)
         if [ -z "$ligne" ]
         then
#            echo "La base $Base n'existe pas dans le fichier $Report_Liste"
            echo "The base $Base doesn't exist in $Report_Liste file"
            Liste2=$(echo $Liste2 | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
            continue
         else
            Base1=$(echo $ligne | awk '{ print $1 }')
            Base2=$(echo $ligne | awk '{ print $3 }') 
            Ws1=$(echo $ligne | awk '{ print $2 }') 
            Ws2=$(echo $ligne | awk '{ print $4 }') 
         fi
      fi
      if [ ! -e ${DirWork}/Base_Send${Name_Rep} ]
      then
         break
      fi   
      ligneB1=$(grep "^$Base1;" ${DirWork}/Base_Send${Name_Rep})
      ligneB2=$(grep "^$Base2;" ${DirWork}/Base_Send${Name_Rep})
      lsoutB1=$(echo $ligneB1 | awk -F\; '{ print $2 }')
      PID_rsh=$(echo $ligneB1 | awk -F\; '{ print $6 }')
#        lsoutB2=$(echo $ligneB2 | awk -F\; '{ print $2 }')
#        EndB1=$(echo $ligneB1 | awk -F\; '{ print $4 }')
      EndB2=$(echo $ligneB2 | awk -F\; '{ print $4 }')
      if [ "$(echo $ligneB1 | awk -F\; '{ print $5 }')" = "${Base1}_${Ws1}_${Base2}_${Ws2}" ] && [ $lsoutB1 -ne 0 ]
      then
         grep "ENDLSOUT_${Base2}" ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} > /dev/null 2>&1
         if [ $? -eq 0 ]
         then
            updatefile ${DirWork}/Base_Send${Name_Rep} $Base1 "$Base1;0;0;0;${Base1}_${Ws1}_${Base2}_${Ws2};$PID_rsh"
         fi
      fi
      if [ "$(echo $ligneB2 | awk -F\; '{ print $5 }')" = "${Base1}_${Ws1}_${Base2}_${Ws2}" ] && [ ! "$EndB2" = "0" ]
      then
         grep "END_${Base2}" ${DirWork}/report_${Base1}_${Ws1}_${Base2}_${Ws2} > /dev/null 2>&1
         if [ $? -eq 0 ]
         then
            machine=$(grep "^${Base1}_${Ws1}_${Base2}_${Ws2};" ${DirWork}/Host_Report${Name_Rep} | awk -F\; '{ print $2 }')
            x=$(grep "^$machine;" ${DirWork}/Host_use${Name_Rep} | awk -F\; '{ print $2 }') 
            let "x = x - 1"
            updatefile ${DirWork}/Host_use${Name_Rep} $machine "$machine;$x"
            updatefile ${DirWork}/Host_Report${Name_Rep} ${Base1}_${Ws1}_${Base2}_${Ws2} " " "D"
            updatefile ${DirWork}/Base_Send${Name_Rep} $Base1 "$Base1;0;0;0;${Base1}_${Ws1}_${Base2}_${Ws2};"
            updatefile ${DirWork}/Base_Send${Name_Rep} $Base2 "$Base2;0;0;0;${Base1}_${Ws1}_${Base2}_${Ws2};"
            Liste2=$(echo $Liste2 | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
         fi
      fi
      if [ ! -z "$PID_rsh" ] && [ $(ps -p $PID_rsh | wc -l) -eq 1 ] && [ ! "$EndB2" = "0" ]
      then
         machine=$(grep "^${Base1}_${Ws1}_${Base2}_${Ws2};" ${DirWork}/Host_Report${Name_Rep} | awk -F\; '{ print $2 }')
         x=$(grep "^$machine;" ${DirWork}/Host_use${Name_Rep} | awk -F\; '{ print $2 }') 
         if [ ! -z "$x" ]
         then 
            let "x = x - 1"
         fi
         updatefile ${DirWork}/Host_use${Name_Rep} $machine "$machine;$x"
         updatefile ${DirWork}/Host_Report${Name_Rep} ${Base1}_${Ws1}_${Base2}_${Ws2} " " "D"
         updatefile ${DirWork}/Base_Send${Name_Rep} $Base1 "$Base1;0;0;0;${Base1}_${Ws1}_${Base2}_${Ws2};"
         updatefile ${DirWork}/Base_Send${Name_Rep} $Base2 "$Base2;0;0;0;${Base1}_${Ws1}_${Base2}_${Ws2};"
         Liste2=$(echo $Liste2 | awk '{ for (i=1;i<=NF;i++) { if ( $i=="'$Base'" ) { $i="" } } print $0 }')
      fi
   done 
done

\rm -f ${DirWork}/Base_Send${Name_Rep}
\rm -f ${DirWork}/Host_use${Name_Rep}
\rm -f ${DirWork}/Host_Report${Name_Rep}
\rm -f $DirWork/GO_report_File${Name_Rep}

Bilan

\rm -f $DirWork/TempoFile${Name_Rep} > /dev/null

exit
