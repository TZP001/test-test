ChgSetting ()
{
fileN=$1
filetmp=$1_$$

sed "1,\$s/<SingleUser></<SingleUser>tacr</"  < $fileN > $filetmp
mv $filetmp $fileN
sed "1,\$s/<SinglePassword></<SinglePassword>-2099106621a-1235625806a695310684a-948132480</" < $fileN > $filetmp
mv $filetmp $fileN
sed "1,\$s/<Authentication>System</<Authentication>Server</" < $fileN > $filetmp
mv $filetmp $fileN
}

Migre ()
{
  filem=$1
	dirname $filem
  dirn=`dirname $filem`
export CATUserSettingPath=$dirn
export CATReferenceSettingPath=$dirn
export ENOVIA_SINGLE_USER=OFF
rm -f $PWD/CATDBSERVER.xml
CATDBSRV -exp $PWD/CATDBSERVER.xml

ChgSetting $PWD/CATDBSERVER.xml
export ENOVIA_SINGLE_USER=ON
mv $dirn/CATDbServers.CATSettings $dirn/CATDbServers.CATSettingsbeforeABE
CATDBSRV -imp $PWD/CATDBSERVER.xml

echo 
echo "MIGRATION OF " $dirn"/CATDbServers.CATSettings"  "  DONE "
}

FileList ()
{
while [ $1 ] ; do
filemigr=$1

if [ -w $filemigr ] ; then
	echo "MIGRATION OF " $filemigr
    Migre $filemigr
else
	echo "FAILED MIGRATION NO WRITE PERMIT ON " $filemigr
fi 

shift

done
}
if [ $1 ] ; then
   echo 
   echo "this shell search all files CATDbServers.CATSettings"
   echo "from current directory"
   echo "and it translate to new format if write is allowed on the file"
   echo 
fi
find $PWD -name CATDbServers.CATSettings -print > $PWD/listeset$$
FileList `cat $PWD/listeset$$`
rm $PWD/listeset$$



