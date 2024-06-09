#! /bin/ksh
# recoit dans l'ordre 
# une cle, un code couleur, un URL et un fichier 'trame'
# et 1/ genere un fichier html representant la trame sous forme de tableau
#       avec des couleurs pour chaque ligne
# et 2/ modifie la trame pour mettre le nouveau code couleur
# -> le fichier html produit est affiche sur output (le shell doit donc etre redirige vers un fichier)

# cle = premiere colonne de la trame
# cles reserves = STATUS
# code couleur = - (pas de code), G (green), O (orange), R (red) ou I (interrupted)
# info = - (pas d'info) ou le chemin d'acces a un fichier qui sera transforme en URL vers ce fichier
#
# Variable d'environnement :
# ADL_WORKING_DIR = repertoire relativement auquel les paths des fichiers de traces sont donnes
# ADL_TRACE_DIR = repertoire contenant tous les fichiers de traces

unalias mv
unalias rm

OS=$(uname -s)
if [ "$OS" = "Windows_NT" ]
then
	export _CALL_SH="sh +C -K "
	FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	ShellName="${FullShellName##*/}"
	cd "${FullShellName%/*}"
	ShellDir="$(pwd)"
	cd -

	DefaultTmpDir="$(printf "%s" "$TEMP" | sed 's+\\+/+g')"
	[ -z "$DefaultTmpDir" ] && DefaultTmpDir=C:/TEMP
	NULL=nul

else
	unset _CALL_SH
	FullShellName="$(whence "$0" | sed 's+\\+/+g')"
	FullShellName2=${FullShellName%\'}
	FullShellName=${FullShellName2##\'}
	ShellName="${FullShellName##*/}"
	ShellDir="${FullShellName%/*}"

	DefaultTmpDir=/tmp
	NULL=/dev/null
fi

dirtrame="$(dirname "$4")"
trametmp="$4"
trametmp="$DefaultTmpDir/${trametmp##*/}.$$"
rm -f "$trametmp" 2>$NULL
touch "$trametmp"
currentdate=$($_CALL_SH "$ShellDir/adl_get_current_date.sh")
# Debut de la page html
echo "<!doctype html public>
<html>
<head>
   <meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">
</head>
<body bgcolor="#D1CEEA">
<hr WIDTH=\"100%\">
<b><font size=+2>Intersite transfer execution reporting file: </font></b>
<td>"

# Lecture d'un fichier servant a decrire le transfert associe
if [ -f "$_ADL_WORKING_DIR/0Information.txt" ]
then
	\cat "$_ADL_WORKING_DIR/0Information.txt"
else
	echo "No information on current transfer"
fi

echo "</td>
</table>
<hr WIDTH=\"100%\">
"

# Le status global se trouve en premiere ligne de la trame
read key site color info description < "$4"

# On donne la date de generation de la page html + icone de rafraichissement + status global du transfert 
if [ "$key" = "STATUS" ] 
then
	if [ "$1" = "STATUS" ]
	then
		color=$2
		info=$3
	fi
	echo "$key $site $color $info $description" > $trametmp

	echo "<table COLS=4 NOSAVE >
	<td NOSAVE><a href=\"$_ADL_WORKING_DIR/follow_up.htm\"><img src=$ShellDir/update.gif alt='Reload this page' border=0></a></td>
	<td NOSAVE>Page generated on $currentdate</td>
	"

else
	# pour compatibilite ascendante
	color=$2

	echo "<table COLS=3 NOSAVE >
	<td NOSAVE>Page generated on $currentdate</td>
	"
fi

if [ "$color" = "i" ]
then
	echo "<td BGCOLOR=\"#FF0000\">Global status = interrupted</td>"
elif [ "$color" = "o" ]
then
	echo "<td BGCOLOR=\"#FFFF99\">Global status = running</td>"
elif [ "$color" = "r" ]
then
	echo "<td BGCOLOR=\"#FF0000\">Global status = failed</td>"
elif [ "$color" = "g" ]
then
	echo "<td BGCOLOR=\"#33FF33\">Global status = successful</td>"
else
	echo "<td>Global status = ?</td>"
fi

if [ "$key" = "STATUS" ] 
then
	echo "<td NOSAVE><a href=\"file:$_ADL_TRACE_DIR\">All traces</a></td>"
else
	# pour compatibilite ascendante
	echo "<td NOSAVE><a href=\"index.html\">All traces</a></td>"
fi

echo "
</table>
<hr WIDTH=\"100%\">
<br>In the table below...
<table COLS=4 WIDTH=\"100%\" NOSAVE >
<tr NOSAVE>
<td BGCOLOR=\"#33FF33\" NOSAVE>Green means \"finished successfully\"</td>

<td BGCOLOR=\"#CCCCCC\" NOSAVE>Grey means \"not (yet) used\"</td>

<td BGCOLOR=\"#FFFF99\" NOSAVE>Yellow means \"under way\"</td>

<td BGCOLOR=\"#FF0000\" NOSAVE>Red means \"failed\"</td>
</tr>
</table>
and any html link leads to traces associated with the corresponding transfer step.
All the steps appear from top to bottom in the order the transfer tool must go through.
<p>
"

# Debut du tableau
echo "
<table BORDER=2 COLS=2 WIDTH=\"100%\" BGCOLOR=\"#CCCCCC\" NOSAVE >
<tr NOSAVE>
<td ALIGN=LEFT VALIGN=TOP BGCOLOR=\"#999900\" NOSAVE>
<center><b><font size=+2>
Local site
</font></b></center></td>

<td ALIGN=LEFT VALIGN=TOP BGCOLOR=\"#999900\" NOSAVE>
<center><b><font size=+2>
Remote Site
</font></b></center></td>
</tr>
"

while read key site color info description
do
	# Deja traite au debut
	[ "$key" = "STATUS" ] && continue

	# Prise en compte du changement de couleur pour la cle
	if [ "$key" = $1 ] 
	then
		color=$2
		info=$3
	fi

	# Affectation du code couleur html
	if [ "$color" = "r" -o "$color" = "i" ]
	then
		colorhtml="#FF0000"
	elif [ "$color" = "o" ]
	then
		colorhtml="#FFFF99"
	elif [ "$color" = "g" ]
	then
		colorhtml="#33FF33"
    	else 
		colorhtml="#CCCCCC"
	fi

	interrupted=""
	[ "$color" = "i" ] && interrupted="<b><font size=+2>Command Interrupted</font></b>"

	if [ "$site" = "local" ]
	then
		if [ "$info" = "-" ]
		then
			echo "<tr><td BGCOLOR=\"$colorhtml\">$description$interrupted</td>
			<td bgcolor="#D1CEEA"></td>
			</tr>"
	    else
			echo "<tr><td BGCOLOR=\"$colorhtml\"><a href=$info>$description</a>$interrupted</td>
			<td bgcolor="#D1CEEA"></td>
			</tr>"
		fi
	else
		if [ "$info" = "-" ]
		then
			echo "<tr><td bgcolor="#D1CEEA"></td>
			<td BGCOLOR=\"$colorhtml\">$description$interrupted</td>
			</tr>"
		else
			echo "<tr><td bgcolor="#D1CEEA"></td>
			<td BGCOLOR=\"$colorhtml\"><a href=$info>$description</a>$interrupted</td>
			</tr>"
		fi
	fi

	# ecriture nouvelle trame
	echo "$key $site $color $info $description" >> $trametmp
	
done < "$4"

# Fin de la page html
echo "</table>

</body>
</html>
"

# remplacement de la trame recue en entree
mv -f "$trametmp" "$4" 2>$NULL
chmod 777 "$4" 2>$NULL

exit 0












