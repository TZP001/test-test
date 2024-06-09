#!/bin/ksh
# Donnez une liste d'identificateur de Report,
# ou utiliser l'option -a pour lancer toutes les bases associees au User de travail.
# -----------------------------------------------------------------------------
sortie()
{
trap ' ' HUP INT QUIT TERM KILL STOP TSTP CHLD

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
while read lig PID_batch last 
do 
   if [ ! -z "$PID_batch" ]
   then
      kill $PID_batch
   fi
done < $DirWork/adl_comp_pid${Name_Rep} 
IFS=''

rm -f $DirWork/adl_comp_pid${Name_Rep} 
exit $rc
}

# -----------------------------------------------------------------------------
# DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT - DEBUT
# -----------------------------------------------------------------------------
export SHELL_ROOT_DIR=$(dirname $(whence $0))
if [ ! -z "$ADL_DEBUG" ]
then 
   set -x
fi
trap 'sortie 1 "Interrupt Command" ' HUP INT QUIT TERM KILL STOP TSTP CHLD

usage="\
       adl_report_comp.sh [ -c ] [ -h ] [-a | Report_ID  ... | -l file] [-i ID]\n
       -c Pour ne pas lancer la comparaison du contenu des fichiers entre les deux bases (Valide seulement avec l'ancien report ADELEV3).\n
       -h For help\n
       -i Identifie the comparison process.\n
       ID : comparison process name.\n
       -a Submit all transfer declared in /adl_report_string file\n
       -l To identify a list file\n
       file : File with a list of transfer_ID found in /adl_report_string file\n
       Report_ID : is a list of transfer_ID".

set -- $(getopt ahl:ci: $*) || sortie 1 "$usage"
export PATH=/usr/xg4/bin:/usr/bin:/usr/ucb:$PATH
. $SHELL_ROOT_DIR/variable_transfer.sh
R_PROFILE=$PROFILE_V3
L_PROFILE=$PROFILE_V5
Name_Rep=""
Sigle=$(echo $(whoami) | cut -c 1-3)
typeset -u Sigle
DirWork="${HOME}/REPORT_${Sigle}_RES"
if [ ! -d "$DirWork" ]
then
#   echo "Creez ce directory : $DirWork"
#   echo "et le fichier $DirWork/adl_report_string d'une ligne,"
#   echo "contenant la liste des reports a lancer."
#   echo "La liste des reports se trouvent dans le fichier"
#   echo "$DirWork/adl_report_liste ou ${SHELL_ROOT_DIR}/adl_report_cga_liste"
#   echo "Pour creer le fichier $DirWork/adl_report_liste voir comme"
#   echo "exemple le fichier ${SHELL_ROOT_DIR}/adl_report_cga_liste"  
   echo "You have to create this directory : $DirWork"
   echo "and the $DirWork/adl_report_string file, with the list"
   echo "of the transfer_ID separated by blank on one ligne."
   echo "The transfer liste find in $DirWork/adl_report_Liste file"
   echo "To create the $DirWork/adl_report_Liste file"
   echo "with ${SHELL_ROOT_DIR}/adl_report_cga_liste sample file"  
   exit
fi

FlagComp=""
while [ $1 != -- ]
do
   case $1 in
      -a) # Toutes les base
          if [ -f $DirWork/adl_report_string ]
          then
             Liste=$(cat $DirWork/adl_report_string)
          elif [ -f $SHELL_ROOT_DIR/adl_report_${Sigle}_string ]
          then
             Liste=$(cat $SHELL_ROOT_DIR/adl_report_${Sigle}_string)
          else
             Liste=""
          fi;;
      -i) # Pour identifier le process lance
          Name_Rep="_$2"
          shift;; 
      -l) # Avec une liste de process
          FlagListe=1
          Liste=$(cat $2)
          shift;;
      -c) # Sans step de comparaison du contenu des fichiers  
          FlagComp="-c";;
      -h) # Aide
          echo $usage
          exit;;
   esac
   shift
done
shift

if [ ! "$FlagListe" = "1" ]
then
   Liste2=$*
   Liste=${Liste:-$Liste2}
fi
Liste2=$Liste
Liste3=$Liste

if [ -z "$Liste" ]
then
#   echo "La liste des identificateurs de report est incorrecte"
   echo "The identifier list of transfer is incorrect"
   exit
fi

if [ -f $DirWork/adl_report_liste ]
then
   Report_Liste="$DirWork/adl_report_liste"
else
   Report_Liste="${SHELL_ROOT_DIR}/adl_report_cga_liste"
fi

. $SHELL_ROOT_DIR/AdeleMultiSite_profile

for Base in $Liste
do
   ligne=""
   unset machine Level1 lpflag Level2 rpflag Base1 Base2 Ws2 Ws1 iflag fflag tflag1 TREE1 tflag2 TREE2 cflag
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
            -ll) Level1=$Value
                 ligne=$ligne" "$flag" "$Value
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
                 ligne=$ligne" "$flag" "$Value
                 if [ ! "$rpflag" = "1" ]
                 then
                    if [ "$Level2" = "3" ]
                    then
                       R_PROFILE=$PROFILE_V3
                    else
                       R_PROFILE=$PROFILE_V5
                    fi
                 fi;;
#            -tck) Base1=$Value;Base2=$Value;;
            -lb) Base2=$Value
                 ligne=$ligne" "$flag" "$Value;;  
            -rb) Base1=$Value
                 ligne=$ligne" "$flag" "$Value;;  
            -lw) Ws2=$Value
                 ligne=$ligne" "$flag" "$Value;;  
            -rw) Ws1=$Value
                 ligne=$ligne" "$flag" "$Value;;  
            -rp) rpflag=1;R_PROFILE=$Value;;
            -lp) lpflag=1;L_PROFILE=$Value;;
            -rl) ligne=$ligne" "$flag" "$Value;;
            -ll) ligne=$ligne" "$flag" "$Value;;
            -import) iflag=1;ligne=$ligne" -rl 5 -ll 5";;
            -fw) if [ ! -z "$Value" ]
                 then  
                    fflag=1
                    FW_LIST1=$Value
#                    ligne=$ligne" "$flag" "$Value
                 fi;;
            -rtree) tflag1=1;TREE1=$Value;;
            -ltree) TREE2=$Value;tflag2=1;;
            -fw_cmp) cflag=1;FW_LIST2=$Value;; 
         esac
      done < ${DirWork}/TempoFile${Name_Rep}
      rm ${DirWork}/TempoFile${Name_Rep}
      if [ "$tflag2" = "1" ]
      then
         Base2=${Base2}"_"$TREE2
      fi
      if [ "$tflag1" = "1" ]
      then
         Base1=${Base1}"_"$TREE1
      fi
      if [ "$cflag" = "1" ]
      then
         ligne=$ligne" -fw "$FW_LIST2
      elif [ "$fflag" = "1" ] 
      then
         ligne=$ligne" -fw "$FW_LIST1
      else
         ligne=$ligne" -rtree "$TREE1
      fi

      if [ -z "${Name_Rep}" ] || [ "$iflag" = "1" ]
      then
         ligne=$ligne" -rp $R_PROFILE -lp $L_PROFILE" 
      else
         ligne=$ligne" -rp $R_PROFILE -lp $L_PROFILE -tid ${Base}" 
      fi 

      if [ -z "$ligne" ]
      then
#         echo "Le fichier ${Base}_Param est vide ou les parametres sont incorrectes"
         echo "the ${Base}_Param file is empty or the params is incorrect"
      else
         if [ -f ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} ]
         then 
            mv -f ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep}_old
         fi
         echo "adl_compare_workspaces.sh $ligne"
         echo ""
         adl_compare_workspaces.sh $ligne > ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} < /dev/null&
#         adl_compare_workspaces.sh $ligne > ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep}
         echo "2;$!;${Base1};${Ws1};${Base2};${Ws2}" >> $DirWork/adl_comp_pid${Name_Rep}
      fi
   else
      ligne=$(grep ";$Base$" $Report_Liste | awk -F\; '{ print $1 }' | head -1)
      if [ -z "$ligne" ]
      then
#         echo "Ce Report_ID : $Base n'existe pas dans le fichier $Report_Liste"
         echo "This Transfer_ID : $Base doesn't exist in $Report_Liste file"
      else
         $SHELL_ROOT_DIR/adl_report_cga_diff.sh $FlagComp $ligne& 
         Ligne=$(echo $ligne | awk '{print $1";"$2";"$3";"$4}')
         echo "1;$!;${Ligne}" >> $DirWork/adl_comp_pid${Name_Rep}
      fi
   fi
done

rm -f $DirWork/Bilan_Comp${Name_Rep}
echo " ----------------------------------------------------------------- " | tee -a $DirWork/Bilan_Comp${Name_Rep} 
echo `date`" > Start Comparison" | tee -a $DirWork/Bilan_Comp${Name_Rep} 
echo " ----------------------------------------------------------------- " | tee -a $DirWork/Bilan_Comp${Name_Rep}
FlagProc=0
IFS=";"
while [ "$FlagProc" = "0" ]
do
   FlagProc=1
   while read Ver PID Last
   do
      ps -p $PID > /dev/null 2>&1
      if [ $? -eq 0 ]
      then
         FlagProc=0
      fi
   done < $DirWork/adl_comp_pid${Name_Rep}
   sleep 30
done
unset IFS

IFS=";"
while read Ver Pid Base1 Ws1 Base2 Ws2
do
   if [ "$Ver" = "1" ]
   then
      echo "===> Transfer : $Base1 $Ws1 $Base2 $Ws2"  | tee -a $DirWork/Bilan_Comp${Name_Rep}
      echo "===> See file : ${DirWork}/0Result_${Base1}_${Base2}_${Ws2}"  | tee -a $DirWork/Bilan_Comp${Name_Rep}
      grep "Comparison failed" $DirWork/0Result"_"$Base1"_"$Base2"_"$Ws2  | tee -a $DirWork/Bilan_Comp${Name_Rep} 
      echo " ----------------------------------------------------------------- " | tee -a $DirWork/Bilan_Comp${Name_Rep}
   else
      echo "===> Transfer : $Base1 $Ws1 $Base2 $Ws2"  | tee -a $DirWork/Bilan_Comp${Name_Rep}
      echo "===> See file : ${DirWork}/0Result_${Base1}_${Base2}_${Ws2}"  | tee -a $DirWork/Bilan_Comp${Name_Rep}
      if grep "!!!!!!! Here is the list of files which" ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} > /dev/null 
      then
         tail +$(grep -n "!!!!!!! Here is the list of files which" ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} | head -1 |  awk -F\: '{print $1}') ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} | tee -a $DirWork/Bilan_Comp${Name_Rep}
      else
         tail ${DirWork}/0Result_${Base1}_${Ws1}_${Base2}_${Ws2}${Name_Rep} | tee -a $DirWork/Bilan_Comp${Name_Rep} 
      fi
      echo " ----------------------------------------------------------------- " | tee -a $DirWork/Bilan_Comp${Name_Rep}
   fi
done < $DirWork/adl_comp_pid${Name_Rep}
unset IFS
echo `date`" > End Comparison" | tee -a $DirWork/Bilan_Comp${Name_Rep}
echo " ----------------------------------------------------------------- " | tee -a $DirWork/Bilan_Comp${Name_Rep}

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++ The SCM comparison is finished ++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++ The SCM comparison is finished ++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+++++++++++++++ The SCM comparison is finished ++++++++++++++++++"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

rm -f $DirWork/adl_comp_pid${Name_Rep}
exit
