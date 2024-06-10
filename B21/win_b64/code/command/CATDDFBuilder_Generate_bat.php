<?php

$fp = fopen("files/builder_NT.bat","wb"); 

fputs($fp, "\n");

fwrite($fp,stripslashes("set Localcache=$LC \n")); 
fputs($fp,stripslashes("set ReleaseCache=$RC \n")); 
fputs($fp,"set WorkingFile=C:\\tmp\DocToprocess.txt \n"); 


if ($directory=="directory") 
{
fputs($fp,stripslashes("set Location=$DTT \n"));
}

if ($directory=="file")
{
$dest=explode("\n",$area);

fputs($fp,stripslashes("echo $dest[0] > %WorkingFile% \n"));
foreach ( $dest as $dest )
{ 
fputs($fp,stripslashes("echo $dest >> %WorkingFile% \n"));
}
}
unset ($dest[0]);

if ($CTS) 
{
fputs($fp,"set timestamp=-tscheck\n");
}
else
{
fputs($fp,"set timestamp=-notscheck \n");
}



if ($CCGR) 
{
fputs($fp,stripslashes("set copycgr=-replacebycgr $DCGR \n"));
}
else
{
fputs($fp,"set copycgr= \n");
}

if ($GCP) 
{
fputs($fp,stripslashes("set outputdata=-product $DCP \n"));
}
else
{
fputs($fp,"set outputdata= \n");
}

fputs($fp, "\n");
fputs($fp, "\n");

fputs($fp,"CATDMUCACHESettings %timestamp% -u %Localcache% \n");
fputs($fp, "\n");

if ($directory=="directory") 
{
fputs($fp,"CATDMUBuilder %Location% %outputdata% %copycgr% \n");
}
else
{
fputs($fp,"CATDMUBuilder %WorkingFile% %outputdata% %copycgr% \n");

}

ereg_replace("dest[1]"," ",$dest);


fclose($fp);  

#header("Content-Type: application/force-download");
#header("Content-Disposition: filename=builder_NT.bat");
#readfile("/usr/local/apache/htdocs/CATDMUBuilder/files/builder_NT.bat");

?>


<html>
<head>
<title>Generation of a shell</title>
</head>

<body background="images/CATDDFBuilder_background.gif">
<body>
<?php

if ($directory=="directory") 
{
echo "You have chosen to treat this directory: " ;
echo  stripslashes("$DTT, \n");
}

if ($directory=="file")
{
echo "You have chosen to treat this" ;
$dest=explode ("\n",$area);
foreach( $dest as $dest )
{
 
echo  stripslashes("$dest, \n");
}
}
?> 
in this local cache :
<?php 
echo stripslashes("$LC");
 ?>

<p><p> <p><p><p><p><p><p>
<?php
$filename="builder_NT.bat";
$dir="/usr/local/apache/htdocs/CATDMUBuilder/files".$filename;
?>

<a href="CATDDFBuilder_Download_bat.php?dir=<?=$dir?>&filename=<?=$filename?>">download</a>


</body>
</html>


