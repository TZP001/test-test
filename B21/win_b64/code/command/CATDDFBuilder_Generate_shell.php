<?php

$fp = fopen("files/builder_unix.sh","wb"); 
chmod("files/builder_unix.sh", 0777);
fputs($fp, "#!/bin/ksh \n"); 
fputs($fp, "\n");

fwrite($fp,stripslashes("Localcache=$LC \n")); 
fputs($fp,stripslashes("ReleaseCache=$RC \n")); 
fputs($fp,"WorkingFile=/u/users/thi/Pages_HTML/DocToprocess.txt \n"); 


if ($directory=="directory") 
{
fputs($fp,stripslashes("Location=$DTT \n"));
}

if ($directory=="file")
{
$dest=explode("\n",$area);

fputs($fp,stripslashes("echo $dest[0] > \$WorkingFile \n"));
foreach ( $dest as $dest )
{ 
fputs($fp,stripslashes("echo $dest >> \$WorkingFile \n"));
}
}
unset ($dest[0]);

if ($CTS) 
{
fputs($fp,"timestamp=-tscheck\n");
}
else
{
fputs($fp,"timestamp=-notscheck \n");
}



if ($CCGR) 
{
fputs($fp,stripslashes("copycgr='-replacebycgr $DCGR' \n"));
}
else
{
fputs($fp,"copycgr= \n");
}

if ($GCP) 
{
fputs($fp,stripslashes("outputdata='-product $DCP' \n"));
}
else
{
fputs($fp,"outputdata= \n");
}

fputs($fp, "\n");
fputs($fp, "\n");

fputs($fp,"CATDMUCacheSettings \$timestamp -u \$Localcache\n");
fputs($fp, "\n");

if ($directory=="directory") 
{
fputs($fp,"CATDMUBuilder \$Location \$outputdata \$copycgr \n");
}
else
{
fputs($fp,"CATDMUBuilder \$WorkingFile \$outputdata \$copycgr \n");

}

ereg_replace(" "," ",$dest);


fclose($fp);

#header("Content-Type: application/force-download");
#header("Content-Disposition: filename=builder_unix.sh");
#readfile("files/builder_unix.sh");


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
$filename="builder_unix.sh";
$dir="/usr/local/apache/htdocs/CATDMUBuilder/".$filename;
?>

<a href="CATDDFBuilder_Download_shell.php?dir=<?=$dir?>&filename=<?=$filename?>">download</a>


</body>
</html>

