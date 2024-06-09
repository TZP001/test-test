#!/bin/ksh
# ----------------------------------------------------------------------
# Nettoyage de l'environnement Adele 3.2, V5, Tck (pas mkmk, quand meme...)
# A lancer en .
# ATTENTION : toutes les variables ADLxxx, _ADLxxx et TCKxxx sont effacees.
# ----------------------------------------------------------------------
OS=$(uname -s)
case $OS in
	AIX)					
		_AWK=/bin/awk
		;;
	HP-UX)
		_AWK=/bin/awk
		;;
	IRIX | IRIX64)
		_AWK=/bin/nawk
		;;
	SunOS)
		_AWK=/bin/nawk
		;;
esac

RemoveFromPath()
{
	if [ $# -gt 0 ]
	then
		if [ "$OS" = "Windows_NT" ]
		then
			for dir in "$@"
			do
				dir=$(printf "%s" $dir | \sed 's+\\+\\\\+g') # -> Format pour le \sed
				PATH=$(printf "%s" $PATH | \sed -e "s?;$dir;?;?g" -e "s?^$dir;??g" -e "s?;$dir\$??g")
			done
		else
			for dir in "$@"
			do
				PATH=$(echo $PATH | \sed -e "s?:$dir:?:?g" -e "s?^$dir:??g" -e "s?:$dir\$??g")
			done
		fi
	fi
}

# * Nettoyage des chemins pour trouver les commandes
remove_done=true
while [ "$remove_done" = "true" ]
do
	remove_done=false
	for Cmd in admdbenv adl_build_profile adl_co adl_photo tck_list lsa
	do
		CmdDir=$(whence $Cmd)
		CmdDir=${CmdDir%/*}
		if [ ! -z "$CmdDir" ]
		then
			remove_done=true
			RemoveFromPath $CmdDir
		fi
	done
done

# * Nettoyage des variables d'environnement
env | $_AWK '(/^_ADL/ || /^ADL/ || /^TCK/) && ! /^ADL_MULTISITE/ && ! /^ADL_DEBUG/ && ! /^ADL_DIFF_/ { sub("=.*", ""); print "unset " $0; }' >/tmp/clean_env_$$
. /tmp/clean_env_$$

# * Nettoyage des fonctions
unset -f chlev
unset -f adl_ch_ws
unset -f tck_profile
