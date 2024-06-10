<html>

<head>
<title>Generation of a shell</title>


<script language="javascript">
function noemptyfields (formulaire)
{
if (document.formulaire.DTT.value=="" && document.formulaire.FTT.value=="")

alert ('Warning!!! You do not treat any component.\nPlease enter a path for a directory or a file to treat');
else
formulaire.submit();
}

function valid()
{
if (document.formulaire.area.value=="")
{
document.formulaire.area.value=(document.formulaire.area.value + document.formulaire.FTT.value);}
else
{document.formulaire.area.value=(document.formulaire.area.value + "\n" + document.formulaire.FTT.value);
}
}

</script>

</head>

<body background="images/CATDDFBuilder_background.gif">

<body>

<p align="center"><b><font face="ARIAL" size="6" color="#FF0000">CATDMUBuilder: Automatic
Generation of a Shell</font></b></p>
<form method="POST" action="CATDDFBuilder_Generate_shell.php" name="formulaire">
  <!--webbot bot="SaveResults" U-File="fpweb:///_private/form_results.txt"
  S-Format="TEXT/CSV" S-Label-Fields="TRUE" -->
  
  <p><b><font size="4" color="#0000FF">Creation
  of your parameters:</font></b></p>
  
<p>Local Cache Directory: <input type="file" name="LC" size="50"></p>
  <p>&nbsp;</p>

<p>Release Cache Directory : <input type="file" name="RC" size="50"></p>
  <p>&nbsp;</p>
  

<p>Directory : <input type="radio" value="directory"  name="directory">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;File :<input type="radio" value="file" name="directory" checked></p><br>

<p>Directory to treat : <input type=file name=DTT size=40></p>
  
<p>&nbsp;</p>
 
 <p>File to treat : <input type=file name=FTT size="50">

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<input type="button" value="Valid" name=adding onClick=valid()></p>
  
 <p><textarea name=area rows="5" cols="100"></textarea></p>

  <p><b><font color="#0000FF" size="4">Options you want to apply:</font></b></p>
  
<p>Check Timestamp : <input type=checkbox name=CTS value="on" checked></p>
  
<p>Copy the cgr in a directory : <input type="checkbox" name="CCGR" value="ON" checked>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  Directory where cgr will be copied : <input type="file" name="DCGR" size="50"></p>
  
<p>Generate a CATProduct: <input type="checkbox" name="GCP" value="ON" checked>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  Directory where the CATProduct will be generated : <input type="file" name="DCP" size="50"></p>
  <p>&nbsp;</p>
  
<p><input type="button" value="Submit" name="B1" onClick="noemptyfields(this.form)"><input type="reset" value="Reset" name="B2"></p>

</form>
<p>&nbsp;</p>
</body>
</html>
