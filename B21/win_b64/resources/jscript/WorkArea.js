// +---------------------------------------------------------------------------
// ! This is Javascript code for WorkArea (maximize / restore)
// ! Works with IE (4 & 5), Netscape (4 & 6)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js

// --- load js file only once
if((typeof LOAD_WORKAREA_JS) == "undefined") {
LOAD_WORKAREA_JS = true;

// --- dynamically set variables:
// WA_RESTORE_ICON_URL: url to the 'restore window' icon
// WA_MAXIMIZE_ICON_URL: url to the 'maximize window' icon
// WA_OTHER_NAME
// WA_INDEX
// WA_PREFERED_HEIGHT

//var WA_COLLAPSE_HEIGHT = 8;
//var WA_MIN_PERCENT = 20;
//var WA_MIN_HEIGHT = 150;

function wa_setVisibility(formName, waPath, visible)
{
	if(visible && wa_isCollapsed())
		wa_restore(formName, waPath);
	else if(!visible && !wa_isCollapsed())
		wa_minimize(formName, waPath);
}
function wa_maximizeOrRestore(formName, waPath, evt)
{
	if(wa_isMaximized())
		wa_restore(formName, waPath);
	else
		wa_maximize(formName, waPath);
}
function wa_getOtherWindow()
{
	return parent.frames[WA_OTHER_NAME];
}
function wa_isCollapsed(win)
{
	if(!win) win = window;
//requires document.body which is not always ready
//	var winHeight = getFrameVisibleSize(win)[1];
//	return (winHeight < WA_COLLAPSE_HEIGHT);
	var rows = parent.document.getElementById('WorkAreaFS').rows;
	var thisRow;
	var idx = rows.indexOf(',');
	if(win.WA_INDEX == 1) {
		thisRow = rows.substr(0, idx);
//		otherRow = rows.substr(idx+1);
	} else {
		thisRow = rows.substr(idx+1);
//		otherRow = rows.substr(0, idx);
	}
//alert("isCollapsed('"+win.name+"'): "+(thisRow == "0")+" (height="+thisRow+")");
//	if(thisRow == "*") return false;
	return (thisRow == "0");
}
function wa_isMaximized()
{
	return wa_isCollapsed(wa_getOtherWindow());
}
function wa_updateIcon(formName, waPath)
{
    var icon = document ? document.images["MAXMIN@"+waPath] : null;
    if(icon != null) icon.src = wa_isMaximized() ? WA_RESTORE_ICON_URL : WA_MAXIMIZE_ICON_URL;
}
function wa_restore(formName, waPath)
{
//	alert("restore areas");
   	var otherWin = wa_getOtherWindow();
 	// --- other area is empty: do nothing
//	if(!otherWin || !otherWin.WA_PREFERED_HEIGHT)
//		return;

	// --- compute an appropriate pos
//    var newpos = '50%,50%';
	var area1, area2;
	if(WA_INDEX == 1) {
		area1 = window;
		area2 = otherWin;
	} else {
		area2 = window;
		area1 = otherWin;
	}
	// --- first algo: show hidden area with pref size
/*
	var h1 = getFrameVisibleSize(area1)[1];
	var h2 = getFrameVisibleSize(area2)[1];
	if(h1 < WA_COLLAPSE_HEIGHT)
	{
		var contH = area1.WA_PREFERED_HEIGHT;
alert("area1 collapsed. height: "+contH+" (avail: "+(h1+h2)+")");
		if(contH < WA_MIN_HEIGHT) contH = WA_MIN_HEIGHT;
		if((contH+WA_MIN_HEIGHT) < (h1+h2))
			newpos = ''+(contH+2)+',*';
	}
	else if(h2 < WA_COLLAPSE_HEIGHT)
	{
		var contH = area2.WA_PREFERED_HEIGHT;
alert("area2 collapsed. height: "+contH+" (avail: "+(h1+h2)+")");
		if(contH < WA_MIN_HEIGHT) contH = WA_MIN_HEIGHT;
		if((contH+WA_MIN_HEIGHT) < (h1+h2))
			newpos = '*,'+(contH+2);
	}
*/
	// --- second algo: show both areas dividing space based on pref sizes
	var prefH1 = area1.WA_PREFERED_HEIGHT;
	if(!prefH1 || prefH1 < WA_MIN_HEIGHT) prefH1 = WA_MIN_HEIGHT;
	var prefH2 = area2.WA_PREFERED_HEIGHT;
	if(!prefH2 || prefH2 < WA_MIN_HEIGHT) prefH2 = WA_MIN_HEIGHT;
	var perc = Math.round(100*prefH1/(prefH1+prefH2));
	if(perc < WA_MIN_PERCENT) perc = WA_MIN_PERCENT;
	else if(perc > 100 - WA_MIN_PERCENT) perc = 100 - WA_MIN_PERCENT;
	var newpos = ''+perc+'%,'+(100-perc)+'%';
//alert("new pos: "+newpos+" pref1="+prefH1+" pref2="+prefH2);
	
	// --- change frameset position
//    if(typeof parent.WA_RESTORE_POSITION=='undefined')
//    	parent.WA_RESTORE_POSITION='50%,50%';
	var frameset = parent.document.getElementById('WorkAreaFS');
    frameset.rows = newpos;
    frameset.frameSpacing = 4;
    frameset.border = 4;

    // --- update icons
    var icon = document ? document.images["MAXMIN@"+waPath] : null;
   	if(icon) icon.src = WA_MAXIMIZE_ICON_URL;
    var othericon = otherWin.document ? otherWin.document.images["MAXMIN@"+waPath] : null;
   	if(othericon) othericon.src = WA_MAXIMIZE_ICON_URL;
}
function wa_maximize(formName, waPath, win)
{
	if(!win)
	{
		win = window;
//		alert("maximize area "+WA_INDEX);
	}
    // --- update icon
    var icon = win.document ? win.document.images["MAXMIN@"+waPath] : null;
   	if(icon) icon.src = WA_RESTORE_ICON_URL;

	// --- change frameset position
	var frameset = parent.document.getElementById('WorkAreaFS');
   	if(win.WA_INDEX == 1)
	    frameset.rows = '100%,0';
    else
    	frameset.rows = '0,100%';
    frameset.frameSpacing = 0;
    frameset.border = 0;
}
function wa_minimize(formName, waPath)
{
//	alert("minimize area "+WA_INDEX);
	wa_maximize(formName, waPath, wa_getOtherWindow());
}

} // --- end of js file load
