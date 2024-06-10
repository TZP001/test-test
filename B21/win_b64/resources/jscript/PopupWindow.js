// +---------------------------------------------------------------------------
// ! This is Javascript code for Popup windows management / Written by PSC (20/03/2003)
// ! Works with IE (4 & 5), Netscape (4 & 6)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js

// --- load js file only once
if((typeof LOAD_POPUPWINDOW_JS) == "undefined") {
LOAD_POPUPWINDOW_JS = true;

function PopupWindow(container)
{
	// --- attributes
	this.closeOnClickOut = false;
	
	// --- methods
	this.setVisibility = PopupWindow_setVisibility;
	this.move = PopupWindow_move;
	this.fitOnScreen = PopupWindow_fitOnScreen;
	this.setSize = PopupWindow_setSize;
	this.getSize = PopupWindow_getSize;
	this.setScrolls = PopupWindow_setScrolls;
	this.close = PopupWindow_close;
	this.closeOnExit = PopupWindow_closeOnExit;
	this.closeOnClickOutside = PopupWindow_closeOnClickOutside;
	this.setContent = PopupWindow_setContent;

	// --- make window
	this.win = document.createElement("DIV");
	this.win.style.visibility = "hidden";
	this.win.style.position = "absolute";
    this.win.className="PopupMenu";
	// --- get the first container parent
	if(!container)
		container = document.body;
	container.appendChild(this.win);
	
	this.win.popupObj = this;

	return this;
}

function PopupWindow_closeOnClickOutside(closeCall)
{
	this.closeOnClickOut = true;
	this.closeCall = closeCall;
}

function PopupWindow_closeOnExit(closeCall)
{
	this.closeCall = closeCall;
	this.win.onmouseout = outPopup;
	this.win.onmouseover = inPopup;
}

function PopupWindow_setVisibility(visible)
{
	if(_curPopupWin != null && _curPopupWin != this)
		// --- another popup window is already opened: close it
		_curPopupWin.close();

	this.win.style.visibility = visible ? "visible" : "hidden";
	
	//fix for DIV over applet issue
	if(visible)
		showIFrame(this.win);
	else
		hideIFrame(this.win);

	_curPopupWin = visible ? this : null;
	
	if(this.closeOnClickOut)
	{
		if(visible)
			setTimeout("Jdg_addEventHandler(document.body, 'mousedown', closePopupOnClickOutside)", 400);
		else
			Jdg_removeEventHandler(document.body, "mousedown", closePopupOnClickOutside);
	}
}

function PopupWindow_move(x, y)
{
//ERROR		if(x) this.win.offsetLeft = x;
//ERROR		if(y) this.win.offsetTop = y;
	if(x) this.win.style.left = x + "px";
	if(y) this.win.style.top = y + "px";
}

function PopupWindow_setSize(w, h)
{
    if(w) this.win.style.width = w + "px";
    if(h) this.win.style.height = h + "px";
}

function PopupWindow_getSize()
{
	return [this.win.offsetWidth, this.win.offsetHeight];
}

function PopupWindow_fitOnScreen(horizontal, vertical)
{
	var scrollContainer = getScrollContainer(this.win.parentNode);
//	var scrollContainer = window.document.body;
	var popupPos = getAbsPos(this.win, scrollContainer);
	
	// --- adjust position so that the popupwindow is in the window
	var pageX = scrollContainer.scrollLeft;
	var pageY = scrollContainer.scrollTop;
	var pageWidth = scrollContainer.clientWidth;
	var pageHeight = scrollContainer.clientHeight;
//alert("scrollContainer ("+scrollContainer.nodeName+"): scroll pos: "+pageX+", "+pageY+" - size: "+pageWidth+", "+pageHeight);

	var popupWidth = this.win.offsetWidth;
	// --- Mozilla Fix: the offsetWidth of the DIV is only the visible width
	if(isGeckoCompat && this.win.firstChild && this.win.firstChild.offsetWidth > popupWidth)
		popupWidth = this.win.firstChild.offsetWidth+2;
	var popupHeight = this.win.offsetHeight;
    var popupX = popupPos[0];
    var popupY = popupPos[1];
//alert("popup: pos: "+popupX+", "+popupY+" - size: "+popupWidth+", "+popupHeight);
	
	// --- X position
	if(horizontal)
	{
		if(popupX < pageX) {
			popupX = pageX;
			this.move(popupX, null);
		} else if(popupX + popupWidth > pageX + pageWidth) {
			popupX = Math.max(0, pageX + pageWidth - popupWidth);
			this.move(popupX, null);
		}
	}
	
	// --- Y position
	if(vertical)
	{
		if(popupY < pageY) {
			popupY = pageY;
			this.move(null, popupY);
		} else if(popupY + popupHeight > pageY + pageHeight) {
			popupY = Math.max(0, pageY + pageHeight - popupHeight);
			this.move(null, popupY);
		}
	}
}
// --- policies:
// ---  0: no scrollbar
// ---  1: auto
// ---  2: show
function PopupWindow_setScrolls(hPolicy, vPolicy)
{
	if(hPolicy == vPolicy)
	{
		this.win.style.overflow = hPolicy == 0 ? "hidden" : (hPolicy == 2 ? "scroll" : "auto");
		return;
	}
	if(isGeckoCompat)
	{
		// --- Mozilla
		var hShow = hPolicy == 0 ? false : (hPolicy == 2 ? true : (this.win.scrollWidth > this.win.offsetWidth));
		var vShow = vPolicy == 0 ? false : (vPolicy == 2 ? true : (this.win.scrollHeight > this.win.offsetHeight));
//alert("this.win.scrollHeight="+this.win.scrollHeight+", this.win.offsetHeight="+this.win.offsetHeight+", this.win.clientHeight="+this.win.clientHeight);
		if(hShow)
		{
			if(vShow)
				this.win.style.overflow = '-moz-scrollbars-vertical';
			else
				this.win.style.overflow = '-moz-scrollbars-horizontal';
		}
		else
		{
			if(vShow)
				this.win.style.overflow = '-moz-scrollbars-vertical';
			else
				this.win.style.overflow = 'hidden';
		}
	}
	else
	{
		this.win.style.overflowX = hPolicy == 0 ? "hidden" : (hPolicy == 2 ? "scroll" : "auto");
		this.win.style.overflowY = vPolicy == 0 ? "hidden" : (vPolicy == 2 ? "scroll" : "auto");
	}
}


function PopupWindow_close()
{
	if(this.win.parentNode == null)
		return;

	this.setVisibility(false);
	//fix for DIV over applet issue
	removeIFrame(this.win);
	this.win.parentNode.removeChild(this.win);
}

function PopupWindow_setContent(htmlCode)
{
    this.win.innerHTML = htmlCode;
}

// -------------------------------------------
// --- to handle popup close on exit
// --- NON CLASS METHODS
// -------------------------------------------
var _curPopupWin;
var _isInPopup = true;

function inPopup(evt)
{
//alert("inPopup()");
	_isInPopup = true;
}

function outPopup(evt)
{
	_isInPopup = false;
	setTimeout("closeIfNotInPopup()", 15);
}

function closeIfNotInPopup(closeCall)
{
	if(_isInPopup) return;
	// TODO: close popup
	if(!_curPopupWin) return;
	var popup = _curPopupWin;
	if(popup.closeCall)
		eval(popup.closeCall);
	popup.close();
}

function closePopupOnClickOutside(evt)
{
	if(!_curPopupWin) return;
	var popup = _curPopupWin;
	var srcObj = window.event ? event.srcElement : evt.target;
//alert("click on '"+srcObj.nodeName+"' check if out...");
	
	if((isIECompat && srcObj.nodeName == "BODY") || srcObj.nodeName == "DIV")
	{
		// --- that can be a scrolling gesture
		if(srcObj.clientWidth < srcObj.scrollWidth)
		{
			var y = window.event ? event.y : evt.clientY;
			if(y > srcObj.clientHeight)
				// --- this is a horizontal scroll gesture
				return;
		}
		if(srcObj.clientHeight < srcObj.scrollHeight)
		{
			var x = window.event ? event.x : evt.clientX;
			if(x > srcObj.clientWidth)
				// --- this is a vertical scroll gesture
				return;
		}
	}
	while(srcObj)
	{
		if(srcObj == popup.win)
		{
			// --- we are in
//alert("click in");
			return;
		}
		srcObj = srcObj.parentNode;
	}
//alert("click out");
	if(popup.closeCall)
		eval(popup.closeCall);
	popup.close();
}

} // --- end of js file load
