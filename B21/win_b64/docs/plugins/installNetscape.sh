#!/bin/ksh

# This script installs automatically CATweb on the UNIX client machine.
# It only supposes that HOME is correctly set.
# Netscape should not be running.

NETSCAPE_HOME=$HOME/.netscape
TRUNAME=`uname`
if [ "$TRUNAME" = "IRIX64" ] ; then
	TRUNAME=IRIX
fi

if [ ! -w "$NETSCAPE_HOME" ] ; then
	echo You must use this script under the account on which you use Netscape
	exit 1
fi

cd `dirname $0`

if [ -z "$1" ] ; then
	UNAME=$TRUNAME
else
	UNAME=$1
fi

case $UNAME in
      AIX)
	      ;;
      HP-UX)
	      ;;
      IRIX)
	      ;;
      SunOS)
	      ;;
      *)
	      echo This OS $UNAME is not yet implemented.
	      echo Aborting this script.
	      exit 1
	      ;;
esac

getfssize() {
   if [ -d "$1" ] ; then
      fn="$1"
   else
      fn=/
   fi
   
   case $TRUNAME in
      AIX)
             df -k / >/dev/null 2>/dev/null && vk=-vk || vk=-v
             df $vk $fn |\
             awk 'NF>5 { v=$(NF-'$2') } END {print v}' |\
             sed s/^-$/99999/
             ;;
      HP-UX)
             bdf -i $fn |\
             awk 'NF>5 { v=$(NF-'$2') } END {print v}' |\
             sed s/^-1$/99999/
             ;;
      IRIX)
             df -ik $fn |\
             awk 'NF>5 { v=$(NF-'$2') } END {print v}' |\
             sed s/^-1$/99999/
             ;;
      SunOS)
             df -k $fn |\
             awk 'NF>5 { v=$(NF-'$2'*2/5) } END {print v}'
             ;;
      *)
      	     echo This OS $UNAME is not yet implemented.
      	     echo Aborting this script.
      	     exit 1
      	     ;;
   esac
}

KBS=`getfssize $NETSCAPE_HOME 5`

if [ $KBS -le 10000 ] ; then
	echo You need at least 10 Mb free on $NETSCAPE_HOME to install
	exit 1
fi

echo Your home directory is $HOME.
echo Your Netscape home directory is $NETSCAPE_HOME
echo You want to install the plug-in for the $UNAME Netscape client.
echo
echo "Do you agree [y/n] ?"

read input
if  [ "$input" != "y" ]
then
  echo You can choose your OS by re-running this script using one more parameter:
  echo "\t * IRIX for an IRIX machine"
  echo "\t * AIX for an AIX machine"
  echo "\t * SunOS for a SunOS machine"
  echo "\t * HP-UX for an HP-UX machine"
  exit
fi

PLUGINS="$NETSCAPE_HOME/plugins"
JDL="$NETSCAPE_HOME/java/download"
CACHE="$JDL/Dassault_Systemes/CATWeb"
mkdir -p "$CACHE" "$PLUGINS"

cp CATwebGL.jar "$JDL"

cp $UNAME/npCATwebGL.so "$PLUGINS"

echo This is CATweb > "$CACHE/ancre.txt"

chmod -R u+rwx "$PLUGINS" "$JDL"

echo The manual installation of CATweb is finished.
echo You can now run CATweb.
