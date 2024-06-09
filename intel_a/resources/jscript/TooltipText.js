// +---------------------------------------------------------------------------
// ! This is Javascript code supporting formatted tooltip text / Written by PSC (25/03/2003)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js
//  - Popupwindow.js

// --- load js file only once
if((typeof LOAD_TOOLTIPTEXT_JS) == "undefined") {
LOAD_TOOLTIPTEXT_JS = true;

var TOOLTIP_TIME = 1000;
var TOOLTIP_SRC;
var TOOLTIP_TEXT;
var TOOLTIP_WIN;

function initTooltip(source, htmlText)
{
	if(TOOLTIP_SRC == source)
		return false;
	if(TOOLTIP_SRC)
		stopTooltip();
	TOOLTIP_SRC = source;
	TOOLTIP_TEXT = htmlText;
	setTimeout("displayTooltip()", TOOLTIP_TIME);
	return true;
}
function displayTooltip()
{
	if(TOOLTIP_WIN || !TOOLTIP_SRC)
		return;
	var scrollContainer = getScrollContainer(TOOLTIP_SRC);
	TOOLTIP_WIN = new PopupWindow(scrollContainer);
	TOOLTIP_WIN.win.className="Tooltip";
	TOOLTIP_WIN.setContent(TOOLTIP_TEXT);
	var pos = getAbsPos(TOOLTIP_SRC, scrollContainer);
	// --- show tooltip under source element
	TOOLTIP_WIN.move(pos[0]+3, pos[1]+TOOLTIP_SRC.offsetHeight+3);
//	TOOLTIP_WIN.fitOnScreen(true, true);
	TOOLTIP_WIN.setVisibility(true);
	if(!isVisible(TOOLTIP_WIN.win, true, 1))
		// --- show tooltip above source element
		TOOLTIP_WIN.move(pos[0]+3, pos[1]-TOOLTIP_WIN.win.offsetHeight-3);
}
function stopTooltip()
{
	if(TOOLTIP_WIN)
		TOOLTIP_WIN.close();
	TOOLTIP_SRC = null;
	TOOLTIP_TEXT = null;
	TOOLTIP_WIN = null;
	return true;
}

} // --- end of js file load
