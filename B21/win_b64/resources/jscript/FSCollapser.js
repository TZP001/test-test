FSPosition = null;
FSWidth = null;

function JdgCollapse_collapse(evt)
{
	// --- retreive parent rows and cols framesets
	var rowsFS = null;
	var colsFS = getFatherNode("FRAMESET", frameElement);
	if(colsFS == null)
	{
		alert("Could not find parent FrameSet Object!");
		return;
	}
	if(colsFS.rows)
	{
		rowsFS = colsFS;
		colsFS = getFatherNode("FRAMESET", rowsFS.parentNode);
		if(colsFS == null)
		{
			alert("Could not find cols FrameSet Object! ("+rowsFS.parentNode+")");
			return;
		}
	}
	
	// --- change divs visibility
	var expDiv = document.getElementById("ExpandDiv");
	var collDiv = document.getElementById("CollapseDiv");
//	var icon = document.images["CollapseIcon"];
//	var icon = window.event ? window.event.srcElement : evt.target;
//	var width = icon ? icon.width : 17;
	var width = expDiv.offsetWidth;
	expDiv.style.visibility = "visible";
	collDiv.style.visibility = "hidden";

	// --- on IE, hide native comboboxes
	if(browserClass == IE_BROWSER_CLASS)
	{
		var cbs = document.getElementsByTagName("SELECT");
		for(var i=0; i<cbs.length; i++)
		{
			cbs[i].style.visibility = "hidden";
//				cbs[i].style.position = "absolute";
//				cbs[i].style.clip = "rect(0 10 10 0)";
		}
	}
	
	// --- if rowsFS, enlage the first frame (this) to 100%
	if(rowsFS)
	{
		// --- store 'rows' and 'frameSpacing'
		rowsFS.ROWS_SAVE = rowsFS.rows;
		rowsFS.SPACING_SAVE = rowsFS.frameSpacing;
		// --- collapse area
		rowsFS.rows = '100%,*';
		rowsFS.frameSpacing = 0;
	}
	
	// --- store 'cols' and 'frameSpacing'
	colsFS.COLS_SAVE = colsFS.cols;
	colsFS.SPACING_SAVE = colsFS.frameSpacing;
	// --- collapse area
	colsFS.cols = ''+width+',*';
	if(isIECompat)
		colsFS.frameSpacing = 0;
	else
		colsFS.setAttribute("border", 0);
	
	// --- forbid resize
	if(isIECompat)
		frameElement.noResize = true;
	else
		frameElement.setAttribute("noresize", true);
}
function JdgCollapse_expand(evt)
{
	// --- retreive parent rows and cols framesets
	var rowsFS = null;
	var colsFS = getFatherNode("FRAMESET", frameElement);
	if(colsFS == null)
	{
		alert("Could not find parent FrameSet Object!");
		return;
	}
	if(colsFS.rows)
	{
		rowsFS = colsFS;
		colsFS = getFatherNode("FRAMESET", rowsFS.parentNode);
		if(colsFS == null)
		{
			alert("Could not find cols FrameSet Object! ("+rowsFS.parentNode+")");
			return;
		}
	}

	// --- allow resize
	if(isIECompat)
		frameElement.noResize = false;
	else
		frameElement.removeAttribute("noresize");
	
	// --- change divs visibility
	var expDiv = document.getElementById("ExpandDiv");
	var collDiv = document.getElementById("CollapseDiv");
//	var icon = document.images["CollapseIcon"];
	var icon = window.event ? window.event.srcElement : evt.target;
	var width = icon ? icon.width : 17;
	expDiv.style.visibility = "hidden";
	collDiv.style.visibility = "visible";

	// --- on IE, show native comboboxes
	if(browserClass == IE_BROWSER_CLASS)
	{
		var cbs = document.getElementsByTagName("SELECT");
		for(var i=0; i<cbs.length; i++)
		{
			cbs[i].style.visibility = "visible";
//				cbs[i].style.position = "absolute";
//				cbs[i].style.clip = "rect(0 10 10 0)";
		}
	}
	
	// --- if rowsFS, come back to saved value
	if(rowsFS)
	{
		// --- restore 'rows' and 'frameSpacing' values
		rowsFS.rows = rowsFS.ROWS_SAVE ? rowsFS.ROWS_SAVE : '50%,50%';
		rowsFS.frameSpacing = rowsFS.SPACING_SAVE ? rowsFS.SPACING_SAVE : 3;
	}
	
	// --- restore 'rows' and 'frameSpacing' values
	colsFS.cols = colsFS.COLS_SAVE ? colsFS.COLS_SAVE : '30%,*';
	if(isIECompat)
		colsFS.frameSpacing = colsFS.SPACING_SAVE ? colsFS.SPACING_SAVE : 6;
	else
		colsFS.setAttribute("border", colsFS.SPACING_SAVE ? colsFS.SPACING_SAVE : 6);
}
