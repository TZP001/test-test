#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

CmdLine="$*"
# =====================================================================
Usage="$ShellName -rhost RemoteHost [-u User]

-rhost RemoteHost : Remote host name (example: centaur.deneb.com)
-u User : Username whih will be used to connect to the remote site (by default, the same as local) ; beware: the connection can't require a password

This script permits to test the line between the local station and the specified remote station
"
# =====================================================================

export DISPLAY=""

OS=$(uname -s)
case $OS in
	AIX)
		PING="/usr/sbin/ping -c 1"
		PING2=""
		RSH="/usr/bin/rsh"
		WHOAMI="/bin/whoami"
		_AWK=/bin/awk
		;;
	HP-UX)
		PING="/usr/sbin/ping"
		PING2=" -n 1"
		RSH="/bin/remsh"
		WHOAMI="/usr/bin/whoami"
		_AWK=/bin/awk
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		PING2=""
		RSH="/usr/bsd/rsh"
		WHOAMI="/usr/bin/whoami"
		_AWK=/bin/nawk
		;;
	SunOS)
		PING="/usr/sbin/ping"
		PING2=""
		RSH="/bin/rsh"
		WHOAMI="/usr/ucb/whoami"
		_AWK=/bin/nawk
		;;
esac

# =====================================================================
# Out function
# =====================================================================
Out()
{
	#set -x
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	shift
	if [ $# -ge 1 ]
	then
		echo "$*"
	fi

	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM
# =====================================================================
# Options treatment
# =====================================================================
typeset -L1 OneChar
CheckOptArg()
{
	# Usage : CheckOptArg opt arg
	OneChar="$2"
	if [ "$2" = "" -o "$OneChar" = "-" ]
	then
		Out 3 "Option $1: one argument is required"
	fi
}

unset _R_NODE
unset _R_USER

while [ $# -ge 1 ]
do
	case "$1" in
		-h ) #-------------------> HELP NEEDED
			echo "$Usage"
			exit 0
			;;
		-rhost ) #-------------------> REMOTE NODE
			CheckOptArg "$1" "$2"
			_R_NODE=$2
			shift 2
			;;
		-u ) #-------------------> REMOTE USERNAME
			CheckOptArg "$1" "$2"
			_R_USER=$2
			shift 2
			;;
		* ) echo "Unknown option: $1" 1>&2
			Out 3 "$Usage"
			;;
	esac
done

if [ -z "$_R_NODE" ]
then
	echo "$ShellName: Missing mandatory remote node parameter." 1>&2
	Out 3 "$Usage"
fi

# ----------------------------------------------------------------------
# On teste la ligne du site distant
# ----------------------------------------------------------------------
_LNODE=$(hostname)
if [ -z "$_R_USER" ]
then
	_R_USER=$($WHOAMI)
fi
CurrentDate=$($ShellDir/adl_get_current_date.sh)
echo "____________________________________________________________"
echo "$CurrentDate - Testing line between local site: $_LNODE and remote site: $_R_NODE with user $_R_USER"
NbPingMax=20
printf "Testing 'ping' to '$_R_NODE' (At most $NbPingMax ping commands will be executed every 10 seconds)..."
rc=1
NbPing=0
while [ $rc -ne 0 -a $NbPing -lt $NbPingMax ]
do
    $PING $_R_NODE $PING2 >/dev/null
    rc=$?
    let "NbPing=NbPing + 1"
    if [ $rc -ne 0 ]
    then
        echo "ping number $NbPing to $_R_NODE failed!. A new one will be retry in 10 seconds."
        sleep 10 
    fi
done
if [ $rc -ne 0 ] 
then
	printf " ----> KO\n"
	Out 3 "ping to $_R_NODE failed!"
else
	printf " After $NbPing test ping is OK\n"
fi

printf "Testing 'rsh' to '$_R_NODE'...
"
NBRshMax=30
NbRSH=0
rcsh=1
while [ $rcsh -ne 0 -a $NbRSH -lt $NBRshMax ]
do
	$RSH $_R_NODE -l $_R_USER uname -s > /tmp/RnodeOS_$$
	rcsh=$?
	let "NbRSH=NbRSH + 1"
	 if [ $rcsh -ne 0 ]
	then
		echo "rsh number $NbRSH to $_R_NODE failed!. A new one will be retry in 10  seconds."
		sleep 10 
	fi
done
if [ $rcsh -ne 0 ] 
then
	printf " ----> KO\n"
	Out 3 "rsh to $_R_NODE to get remote node OS failed!"
else
	printf "After $NbRSH test rsh is OK\n"
fi
export _R_NODE_OS=$(cat /tmp/RnodeOS_$$)
rm -f /tmp/RnodeOS_$$

Out 0
