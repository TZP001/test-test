// +---------------------------------------------------------------------------
// ! This is Javascript code for MessageArea / Written by PSC (04/11/2004)
// +---------------------------------------------------------------------------
// prereqs:
//	- CATJDialog.js

// --- load js file only once
if((typeof LOAD_MESSAGEAREA_JS) == "undefined") {
LOAD_MESSAGEAREA_JS = true;

function JdgMsgArea_displayMessage(areaid, formName, iconUrl, message, rank, hasDetails, isNew)
{
	var img = document.images["ICON@"+areaid];
	if(img) img.src = iconUrl;
	
	var span = document.getElementById("TEXT@"+areaid);
	if(span)
	{
		var html = "";
		if(hasDetails) html = "<a href=\"about:blank\" onclick=\"return submitHidden('"+areaid+"','Details/"+rank+"','"+formName+"');\">";
		html += encodeAsHTML(message, true);
		if(hasDetails) html += "</a>";
		span.innerHTML = html;
//		if(isNew)
//			fadeIn(span.id, 2000, null);
//			Jdg_expand(span.id, 2000);
	}
}

function JdgMsgArea_removeMessage(areaid, iconUrl)
{
	var img = document.images["ICON@"+areaid];
	if(img) img.src = iconUrl;
	
	var span = document.getElementById("TEXT@"+areaid);
	if(span) span.innerHTML = '';
}
function Jdg_expand(divid, duration)
{
	var div = document.getElementById(divid);
	if(!div) return;
	var table = getFatherNode("TABLE", div);
	if(!table) return;
	table.width="0";
	table.height="0";
	expandLoop(divid, 0, 1/10, duration/10);
}
function expandLoop(divid, ratio, step)
{
	var div = document.getElementById(divid);
	if(!div) return;
	var table = getFatherNode("TABLE", div);
	if(!table) return;
	if(ratio >= 1)
	{
		table.width="100%";
		table.height="100%";
		return;
	}
	var father = table.parentNode;
	table.width = father.offsetWidth * ratio;
	table.height = father.offsetHeight * ratio;
	setTimeout("expandLoop('"+divid+"',"+(ratio+step)+","+step+")", timestep);
}
function fadeIn(divid, duration, endclass)
{
	var div = document.getElementById(divid);
	// --- set opacity to 0
	if(document.all)
	{
		// IE
		div.style.width = "100%";
		if(div.filters.alpha)
			div.filters.alpha.opacity = 0;
		else
			div.style.filter = "alpha(opacity=0)";
	}
	else
	{
		// Mozilla
		div.myOpacity = 0;
		div.style.MozOpacity = 0;
	}
	
	// --- show div
	if(div.style.visibility == "hidden")
		div.style.visibility = "visible";

	fadeInLoop(divid, 100/20,duration/20, endclass);
}
function fadeInLoop(divid, opacitystep, timestep, endclass)
{
	var div = document.getElementById(divid);
	if(!div) return;
	var end = false;
	if(document.all)
	{
		// IE
		div.filters.alpha.opacity += opacitystep;
		if(div.filters.alpha.opacity >= 100)
			end = true;
	}
	else
	{
		// Mozilla
		if(!div.myOpacity) div.myOpacity = 0;
		div.myOpacity  += opacitystep/100;
		div.style.MozOpacity = div.myOpacity;
		if(div.myOpacity >= 1)
			end = true;
	}
	if(end)
	{
		if(endclass) div.className = endclass;
//		alert("done");
		return;
	}
	setTimeout("fadeInLoop('"+divid+"',"+opacitystep+","+timestep+","+(endclass ? '"+endclass+"' : "null")+")", timestep);
}

function moveIn(divid, duration)
{
	var div = document.getElementById(divid);
	var divH = div.offsetHeight;
	var finalPos = getAbsPos(div)[1];
	
	div.style.position = "absolute";
	div.style.top = -divH;
	moveInLoop(divid, finalPos, (divH+finalPos)/20,duration/20);
}
function moveInLoop(divid, finalPos, step, timestep)
{
	var div = document.getElementById(divid);
//alert("moveInLoop("+divid+", "+finalPos+", "+step+", "+timestep+") - top:"+div.style.top);
	var pos = parseInt(div.style.top);
	if(pos + step >= finalPos)
	{
		div.style.position = "static";
		div.style.top = 0;
		return;
	}
	else
	{
		div.style.top = pos+step;
	}
	setTimeout("moveInLoop('"+divid+"',"+finalPos+","+step+","+timestep+")", timestep);
}

} // --- end of js file load
