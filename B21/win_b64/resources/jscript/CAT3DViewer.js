function disableDetachOnIE()
{
  return true;
}

window.onerror=disableDetachOnIE

function detach(iName)
{
  document.embeds[0].detach();
}

function osfolder()
{
  var platform=navigator.platform.toUpperCase();
  if (platform.indexOf("WIN") >= 0) {
    return "intel_a";
  } else if (platform.indexOf("SUN") >= 0) {
    return "solaris_a";
  } else if (platform.indexOf("HP") >= 0) {
	return "hpux_b";
  } else if (platform.indexOf("AIX") >= 0) {
	return "aix_a";
  } else if (platform.indexOf("IRIX") >= 0) {
	return "irix_a";
  }
}

function viewerInit( iName )
{
	if (navigator.appName.indexOf("Microsoft") != -1)
	{
		var check="#";
		try
		{
	
			check=document.all.item(iName).ENOVIAWebProperties;
	  		if(check=="#")
	    		throw "Error : ActiveX not loaded";
	
			/*check=0;document.all.item(iName).ENOVIAWebProperties;
	  		if(check!="#")
	  			document.all.item(iName).SetVisuMode(iVisuMode);
	  		else
	    		throw "Error : ActiveX not loaded";*/
		}
	
		catch (err)
		{
			alert("You need advanced permissions to install ENOVIAWebViewer. Please contact your administrator...");
		}
	}
}
