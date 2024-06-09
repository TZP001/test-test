#!/bin/ksh
#
FullShellName=$(whence "$0")
ShellName=${FullShellName##*/}
ShellDir=${FullShellName%/*}

# =====================================================================
Usage="$ShellName Filelist [-Z]

Filelist : File list name to migrate
"
# =====================================================================

# =====================================================================
# Out function
# =====================================================================
Out()
{
	trap ' ' HUP INT QUIT TERM
	ExitCode=$1
	if [ $# -ge 2 ]
	then
		shift
		echo "$*"
	fi
	rm -fr *_$$
	exit $ExitCode
}

trap 'Out 1 "Command interrupted" ' HUP INT QUIT TERM

OS=$(uname -s)
case $OS in
	AIX)					
		PING="/usr/sbin/ping -c 1"
		WHOAMI="/bin/whoami"
		MAIL="/bin/mail"
		_AWK=/bin/awk
		;;
	HP-UX)
		PING="/usr/sbin/ping -n 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/awk
		;;
	IRIX | IRIX64)
		PING="/usr/etc/ping -c 1"
		WHOAMI="/usr/bin/whoami"
		MAIL="/usr/bin/mail"
		_AWK=/bin/nawk
		;;
	SunOS)
		PING="/usr/sbin/ping"
		WHOAMI="/usr/ucb/whoami"
		MAIL="/bin/mailx"
		_AWK=/bin/nawk
		;;
esac

# =====================================================================
# Options treatment
# =====================================================================
if [ $# -gt 1 ]
then
	Out 3 "$Usage"
fi

_FILELIST="$1"
if [ -z "$_FILELIST" ]
then
	echo "$ShellName: name of the filelist is required."
	Out 3 "$Usage"
fi

# =====================================================================
# Begin treatment
# =====================================================================

$_AWK '\
BEGIN \
{
	rc_out = 0;
}
{
	if ($5 == "FRAMEWORK" || $5 == "MODULE" || $5 == "DATA")
	{
		if (NF != 7)
		{
			print "!!! KO : The line " $0 " should contain 7 elements and not " NF;
			rc_out = 3;
			exit;
		}
		print $0 " 1"; # On ajoute le fait qu il s agit d un repertoire
	}
	else if ($5 == "DIR_ELEM")
	{
		print "!!! KO : The DIR_ELEM type was not supported"
		rc_out = 3;
		exit;
	}
	else
	{
		if (NF != 10)
		{
			print "!!! KO : The line " $0 " should contain 10 elements and not " NF;
			rc_out = 3;
			exit;
		}
		folder_id = $2;
		nb = split($3, dir_array, "/");
		if (nb < 2)
			# Pas de repertoire
			name = $3;
		else
		{
			# * Creation des repertoires intermediaires
			nb2 = split($4, dir2_array, "/") - nb; # -> Uniquement les morceaux jusqu a la conf
			full_path = dir2_array[1];
			for (cnt1 = 2; cnt1 <= nb2; cnt1++)
				full_path = full_path "/" dir2_array[cnt1];

			for (cnt1 = 1; cnt1 < nb; cnt1++)
			{
				dir_name = dir_array[cnt1];
				dir_id = folder_id "/" dir_name;
				full_path = full_path "/" dir_name;
				print dir_id " " folder_id " " dir_name " " full_path " DIR_ELEM 1";
				folder_id = dir_id;
			}

			name = dir_array[nb];
		}

		if ($6 == "true")
			txt = 1;
		else
			txt = 0;
		if ($7 == "true")
			exec = 1;
		else
			exec = 0;
		print $1 " " folder_id " " name " " $4 " FILE_ELEM 0 " txt " 0 0 " exec " " $8 " " $9 " " $10 " " $5;
	}
}
END \
{
	if (rc_out != 0)
		exit rc_out;
}' $_FILELIST >$_FILELIST.new

if [ $? -ne 0 ]
then
	grep "!!! KO :" $_FILELIST.new
	Out 3 "The migration failed"
fi

sort -o $_FILELIST.new -k 4 -u $_FILELIST.new

if [ $? -ne 0 ]
then
	grep "!!! KO :" $_FILELIST.new
	Out 3 "The migration failed"
fi

mv -f $_FILELIST $_FILELIST.save
mv -f $_FILELIST.new $_FILELIST

Out 0

