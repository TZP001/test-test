// +---------------------------------------------------------------------------
// ! This is Javascript code for Scroller management / Written by GDE (10/2002)
// ! Works with IE (4 & 5)
// +---------------------------------------------------------------------------

// --- load js file only once
if((typeof LOAD_SCROLLER_JS) == "undefined") {
LOAD_SCROLLER_JS = true;

// =========== Variables ==============================================
// --- 0: arrows are both at the left
// --- 1: arrows are left and right
var SCROLLER_ARROWS_MODE = 1;
var SCROLLER_DIV_INDEX = SCROLLER_ARROWS_MODE == 0 ? 0 : 1;

// --- time before the autoscroll starts
var SCROLLER_FIRSTDELAY = 300;
// --- slice of time between 2 autoscrolls
var SCROLLER_DELAY = 15;
// --- pixel increment for autoscroll
var SCROLLER_INC = 5;

// --- current scroller ID
var SCROLLER_CUR_ID = null;
// --- current scrolling sign (+/-)
var SCROLLER_CUR_SIGN = 0;
// --- current scrolling has started autoscrolling?
var SCROLLER_CUR_FINE = false;

var SCROLLER_MIN_CONTENT_WIDTH = 100;
// ====================================================================
function Jdg_beforeResizeScroller(div)
{
	if(!div) return;
	div.style.width = JdgScroller_getMinWidth(div);
}
function Jdg_afterResizeScroller(scrollDiv)
{
	// --- resize scroll area
	var scrollCell = scrollDiv.parentNode;
	var scrollRow = scrollCell.parentNode;
	var scrollTable = scrollRow.parentNode;
	
	// --- now retreive available width (in content Table)
	var availableWidth = scrollTable.scrollWidth - 2;
	
//alert("check scroller ["+scrollDiv.id+"]: content="+JdgScroller_getContentWidth(scrollDiv)+" - available="+availableWidth);
	if(availableWidth < JdgScroller_getContentWidth(scrollDiv))
	{
		// --- scroller must be displayed
		if(JdgScroller_useRealScrollbar())
		{
			// --- Mozilla 1.4: display DIV scrollbar
			scrollDiv.style.overflow = '-moz-scrollbars-horizontal';
		}
		else
		{
			// --- IE and Mozilla 1.6
			if(scrollRow.cells.length == 1)
			{
				// --- make cell with arrow buttons, ...
				var prevCell, nextCell;
				if(SCROLLER_ARROWS_MODE == 0)
				{
					prevCell = scrollRow.insertCell(-1);
					prevCell.noWrap = true;
					nextCell = prevCell;
				}
				else
				{
					prevCell = scrollRow.insertCell(0);
					nextCell = scrollRow.insertCell(-1);
				}

				var prevArrow = document.createElement('IMG');
				prevArrow.name = "P_"+scrollDiv.id;
				prevArrow.id = "P_"+scrollDiv.id;
				prevArrow.src = previousArrowDisableTab;
				prevArrow.onmousedown = JdgScroller_startScroll;
				prevCell.appendChild(prevArrow);

				var nextArrow = document.createElement('IMG');
				nextArrow.name = "N_"+scrollDiv.id;
				nextArrow.id = "N_"+scrollDiv.id;
				nextArrow.src = nextArrowTab;
				nextArrow.onmousedown = JdgScroller_startScroll;
				nextCell.appendChild(nextArrow);
			}
		}
		
		// --- set scroller width to parent width (or min width)
//			var minw = JdgScroller_getMinWidth(scrollDiv);
		var w = scrollCell.scrollWidth-2;
		if(w < 0) w=0;// should not happen
		scrollDiv.style.width = w;

		// --- check if parent width changed
		var w2 = scrollCell.scrollWidth-2;
		if(w2 < 0) w2=0;// should not happen
		if(w2 != w)
			scrollDiv.style.width = w2;
		
		if(!JdgScroller_useRealScrollbar())
		{
			// --- adjust scrolling position
			if((scrollDiv.scrollLeft + w2) > JdgScroller_getContentWidth(scrollDiv))
				JdgScroller_setPos(scrollDiv, (JdgScroller_getContentWidth(scrollDiv) - w2));
		}
	}
    else
    {
		// --- scroller must be removed
		if(JdgScroller_useRealScrollbar())
		{
			// --- Mozilla 1.4: display DIV scrollbar
			scrollDiv.style.overflow = 'hidden';
			scrollDiv.style.width = JdgScroller_getContentWidth(scrollDiv);
		}
		else
		{
			// --- IE and Mozilla 1.6
			// IOD 2007/06/04 test added to avoid bug
			if(scrollRow.cells != null && scrollRow.cells.length > 1)
			{
				if(SCROLLER_ARROWS_MODE == 0)
				{
					scrollRow.removeChild(scrollRow.cells[1]);
				}
				else
				{
					scrollRow.removeChild(scrollRow.cells[2]);
					scrollRow.removeChild(scrollRow.cells[0]);
				}
			}
			// --- now set div width to content width
			scrollDiv.style.width = JdgScroller_getContentWidth(scrollDiv)+"px";
			JdgScroller_setPos(scrollDiv, 0);
		}
	}

//alert("Scroller size set.");
}
function Jdg_initScroller(id)
{
	var div = document.getElementById(id);
	if(!div) return;
	div.jdgBeforeResize = Jdg_beforeResizeScroller;
	div.jdgAfterResize = Jdg_afterResizeScroller;
//	Jdg_addEventHandler(window, "resize", Jdg_resizeDivs);
}


function JdgScroller_useRealScrollbar()
{
	// --- Mozilla 1.4 bug: impossible to set scrollLeft when scrollbars are hidden
	return isGeckoCompat && browserVersion <= 1.4;
}
// --- problem: in Mozilla 1.4 div.scrollWidth == 0
function JdgScroller_getContentWidth(div)
{
//	var w = div.scrollWidth;
//	if(w > 0) return w;
	return div.firstChild.scrollWidth;
}
function JdgScroller_getMinWidth(div)
{
	var w = JdgScroller_getContentWidth(div);
	if(w < SCROLLER_MIN_CONTENT_WIDTH)
		return w;
	return SCROLLER_MIN_CONTENT_WIDTH;
}
function JdgScroller_getContentNodes(div)
{
//    return div.firstChild.rows[0].cells[0].childNodes;
    return div.firstChild.childNodes;
}
function JdgScroller_setPos(div, w)
{
	div.scrollLeft = w;
//	div.style.clip.left = w;
}
function JdgScroller_startScroll(evt)
{
	var img = window.event ? window.event.srcElement : evt.target;
	var table = getFatherNode("TABLE", img);
	var div = table.rows[0].cells[SCROLLER_DIV_INDEX].firstChild;
	
	SCROLLER_CUR_ID = div.id;
	SCROLLER_CUR_FINE = false;// fine scrolling has not started yet
	SCROLLER_CUR_SIGN = (img.name.substr(0, 1) == 'P') ? -1 : 1;
	
	img.onmouseup = JdgScroller_stopScrolling;
	img.onmouseout = JdgScroller_stopScrolling;
	
	setTimeout("JdgScroller_doScroll()", SCROLLER_FIRSTDELAY);
}
function JdgScroller_stopScrolling(evt)
{
	if(!SCROLLER_CUR_ID)
		return;
	var img = window.event ? window.event.srcElement : evt.target;
	img.onmouseup = null;
	img.onmouseout = null;
	
	var type = window.event ? window.event.type : evt.type;
//alert("type: "+type);

	if(!SCROLLER_CUR_FINE && type == "mouseup")
	{
		// -- that was a click: shift displayed item
		JdgScroller_shiftItem(SCROLLER_CUR_ID, SCROLLER_CUR_SIGN);
	}
	
	// --- terminate scroll
	SCROLLER_CUR_ID = null;
}
function JdgScroller_doScroll()
{
	if(!SCROLLER_CUR_ID)
		return;
	
	var div = document.getElementById(SCROLLER_CUR_ID);

	JdgScroller_setPos(div, (div.scrollLeft + SCROLLER_CUR_SIGN * SCROLLER_INC));
	SCROLLER_CUR_FINE = true;// we are in fine scrolling
	JdgScroller_updateArrows(div, div.id);
	setTimeout("JdgScroller_doScroll()", SCROLLER_DELAY);
}
function JdgScroller_shiftItem(id, sign)
{
	// --- switch to next/previous child element
	var div = document.getElementById(id);
    var contentNodes = JdgScroller_getContentNodes(div);
    if(sign < 0)
    {
    	// --- shift left
		for( i= 0; i<contentNodes.length; i++ )
		{
			if(contentNodes[i].offsetLeft >= div.scrollLeft)
			{
				// --- item 'i' is first left visible item: shift to 'i-1'
				if(i == 0) break;
				JdgScroller_setPos(div, contentNodes[i-1].offsetLeft);
				JdgScroller_updateArrows(div, div.id);
				return;
			}
		}
	}
	else
	{
    	// --- shift right
		for( i= 0; i<contentNodes.length; i++ )
		{
			if(contentNodes[i].offsetLeft > div.scrollLeft)
			{
				JdgScroller_setPos(div, contentNodes[i].offsetLeft);
				JdgScroller_updateArrows(div, div.id);
				return;
			}
		}
	}
}

function JdgScroller_updateArrows(div, id)
{
	if(!div) div= document.getElementById(id);

//	var prevIcon= document.images["P_"+id];
	var prevIcon = document.getElementById("P_"+id);
	if(prevIcon)
		prevIcon.src = div.scrollLeft > 0 ? previousArrowTab : previousArrowDisableTab;

//	var nextIcon= document.images["N_"+id];
	var nextIcon = document.getElementById("N_"+id);
	if(nextIcon)
//		nextIcon.src = (div.firstChild.scrollWidth-div.scrollLeft) > div.offsetWidth ? nextArrowTab : nextArrowDisableTab;
		nextIcon.src = (JdgScroller_getContentWidth(div)-div.scrollLeft) > div.offsetWidth ? nextArrowTab : nextArrowDisableTab;
}

} // --- end of js file load
