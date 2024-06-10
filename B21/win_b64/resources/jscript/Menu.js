// +---------------------------------------------------------------------------
// ! This is Javascript code for Menus management / Written by PSC (30/07/2002)
// ! Works with IE (4 & 5), Netscape (4 & 6)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js

// --- load js file only once
if((typeof LOAD_MENU_JS) == "undefined") {
LOAD_MENU_JS = true;

/**********************************************************************
 * JDialog specific code
 **********************************************************************/
/**
 * Function called when Menu is required by a user event
 */
function showCtxMenu( source, widget, contextID, params, evt, formName )
{
//	var frameName = window.name;
	var x, y;
	if(isNS4 || isGeckoCompat) {
		x = evt.pageX;
		y = evt.pageY;
	} else {
		x = event.x + window.document.body.scrollLeft;
		y = event.y + window.document.body.scrollTop;
	}
	
//HTML_REDESIGN	params["ID"] = document.forms[formName].name;
	params[JDG_FRAMEID_NAME] = jdgGetFrameID(formName);
	params[JDG_FORMNAME_NAME] = formName;
	params["Widget"] = widget;
	params["ItemID"] = contextID;
	params["x"] = x;
	params["y"] = y;
//HTML_REDSEIGN	params["ParentWindow"] = window.name;
	executeRequest(ctxMenuServletURI, params);
}

/**
 * Function called when a Menu item has been selected
 */
function MenuCommand( widget, formName, contextID, cmd )
{
	setWaitingCursor(true);
	var params = new Array();
//HTML_REDESIGN		params["ID"] = document.forms[formName].name;
	params[JDG_FRAMEID_NAME] = jdgGetFrameID(formName);
	params[JDG_FORMNAME_NAME] = formName;
	params["Widget"] = widget;
	params["ItemID"] = contextID;
	params["Command"] = cmd;
//HTML_REDSEIGN	params["ParentWindow"] = window.name;
	executeRequest(ctxMenuServletURI, params);
}
/**
 * Function called by JDialog Toolbar
 */
function JdgToolbar_raisePopup(evt, menuArray)
{
	// --- global variable for caching windows (DIV or Layer)
	globalFreeWindows = new Array();
	
	var popup = new MenuWindow(null, null, null, menuArray, window, 0);
	var src = window.event ? window.event.srcElement : evt.target;
	var pos = getAbsPos(src);
	popup.show(pos[0], pos[1]+src.offsetHeight);
}
/**********************************************************************
 * General menu management code
 **********************************************************************/
/* Menu Array structure:
 * [ <all items description> ]
 *
 * separator:
 *  [ ... 0 ... ]
 *
 * standard item:
 *  [ ... 1, <text>, <icon>, <id> ... ]
 *
 * disabled item:
 *  [ ... 3, <text>, <icon>, <id> ... ]

 * sub-menu:
 *  [ ... 2, <text>, <icon>, <id>, <sub array> ... ]
 */

/**
 * This is the function that raises popup
 * @param menuAr an array defining the menu to manage
 * @param evtOrWin can be either EVENT or WINDOW
 * @param x (only when 2nd arg is WINDOW) X coordinate where the menu should be built
 * @param y (only when 2nd arg is WINDOW) Y coordinate where the menu should be built
 */
function raisePopUp(widgetName, formName, contextID, menuArray, evtOrWin, x, y)
{
	// --- global variable for caching windows (DIV or Layer)
	globalFreeWindows = new Array();
	
	var menuWidow;
	if(x) {
		// --- second arg is WINDOW
		menuWindow = evtOrWin;
		var popup = new MenuWindow(widgetName, formName, contextID, menuArray, menuWindow, 0);
	} else {
		// --- second arg is EVENT
		menuWindow = window;
		if(isNS4 || isGeckoCompat) {
			x = evtOrWin.pageX;
			y = evtOrWin.pageY;
		} else {
			x = evtOrWin.x + menuWindow.document.body.scrollLeft;
			y = evtOrWin.y + menuWindow.document.body.scrollTop;
		}
		// --- place popup under mouse
		var popup = new MenuWindow(widgetName, formName, contextID, menuArray, menuWindow, 0);
	}
	popup.show(x-5, y-5, x+5);
}

/**
 * Called when popup is finished
 */
function closePopUp()
{
	if(!getMenuWindow(0))
	{
		// --- already closed
		return;
	}
	
	// --- close root window (recursive child close)
	closeMenuWindow(0);
	
	// --- empty the windows cache array
	if(isIECompat)
	{
		for(i=0; i<globalFreeWindows.length; i++)
		{
			globalFreeWindows[i].removeNode(true);
		}
	}
	globalFreeWindows = null;
}

// --- global variable containing MenuWindows
globalMenuWindows = new Array();

function getMenuWindow(level)
{
	return globalMenuWindows[level];
}

function closeMenuWindow(level)
{
	var popup = globalMenuWindows[level];
	if(popup)
	{
		popup.close();
		globalMenuWindows[level] = null;
	}
}

function setMenuWindow(level, popupWin)
{
	closeMenuWindow(level);
	globalMenuWindows[level] = popupWin;
}

// --- global variable containing unused "windows" (DIV or Layer)
function setFreeWindow(win)
{
	globalFreeWindows.push(win);
}

function getOrCreateFreeWindow(win)
{
	var div;
	if(globalFreeWindows.length > 0) {
		div = globalFreeWindows.pop();
		return div;
	}

	if(browserClass == IE_BROWSER_CLASS && browserVersion < 5) {
		// --- IE4
		var divCode = "<DIV ID=\"PW"+this.level+" STYLE='position:absolute;visibility:hidden'></DIV>";
		win.document.body.insertAdjacentHTML("BeforeEnd",divCode);
		div = eval("PW"+this.level);
	} else if(isIECompat || isGeckoCompat) {
		div = win.document.createElement("DIV");
		div.style.visibility = "hidden";
		div.style.position = "absolute";
	    div.className="PopupMenu";
	    win.document.body.appendChild( div );
	} else if(isNS4) { // NS4
		div = new Layer(0, win);
		div.visibility = "hide";
	}
	
	return div;
}

// ================================================
// ! class MenuWindow
// ================================================
/**
 * Constructor
 * @param menuArray: an array that defines the menu (and sub-menus)
 * @param win: window object were MenuWindow is created
 */
function MenuWindow(widgetName, formName, contextID, menuArray, win, level)
{
	// --- attributes
	this.widgetName = widgetName;
	this.formName = formName;
	this.contextID = contextID;
	this.menu = menuArray;
	this.win = win;
	this.div = null;
	this.level = level;
	
	// --- methods
	this.show = show;
	this.close = close;
	this.closeChild = closeChild;
	this.makeChild = makeChild;
	
	// --- build MenuWindow
	this.div = getOrCreateFreeWindow(win);
	if (isIECompat || isGeckoCompat) {
		var htmlCode = renderMenu(widgetName, formName, contextID, this.menu, this.level);
		this.div.innerHTML = htmlCode;
	} else if (isNS4) { // NS4
		var htmlCode = renderMenuNS4(this.menu, this.level);
		this.div.document.write(htmlCode);
		this.div.document.close();
	}
	setMenuWindow(level, this);
}

/**
 * Show popup window at location (relative to parent window)
 * @param x X-coord for upper-left corner
 * @param y Y-coord for upper-left corner
 * @param x2 (optional) X-coord for upper-right corner if (x,y) doesn't fit in the window
 */
function show(x, y, x2)
{
	// --- adjust position so that the menu is in the window
	var pageX, pageY, pageWidth, pageHeight;
	if(isNS4 || isGeckoCompat) {
		pageX = this.win.pageXOffset;
		pageY = this.win.pageYOffset;
		pageWidth = this.win.innerWidth;
		pageHeight = this.win.innerHeight;
	} else {
		pageX = this.win.document.body.parentElement.scrollLeft;
		pageY = this.win.document.body.parentElement.scrollTop;
		pageWidth = this.win.document.body.clientWidth;
		pageHeight = this.win.document.body.clientHeight;
		y += pageY;     // IOD : y is relative, we want absolute => add scrollTop
	}
//alert("window: offset: "+pageX+", "+pageY+" - inner size: "+pageWidth+", "+pageHeight);

	var popupWidth, popupHeight;
	if(isNS4) {
		popupWidth = this.div.clip.width;
		popupHeight = this.div.clip.height;
	} else { // IE & NS6
		popupWidth = this.div.offsetWidth;
		popupHeight = this.div.offsetHeight;
	}
//alert("popup size: "+popupWidth+", "+popupHeight);
	
	// --- if menu higher than window size: resize and show scrollbars
	if(popupHeight > pageHeight)
	{
		this.div.style.height = pageHeight;
		if(isGeckoCompat)
		{
			// --- Mozilla
			this.div.style.overflow = '-moz-scrollbars-vertical';
		}
		else
		{
			// --- Internet Explorer
			this.div.style.overflowY = 'auto';
			this.div.style.overflowX = 'hidden';
			popupWidth = popupWidth+15;
			this.div.style.width = popupWidth;
		}
		popupHeight = pageHeight;
	}

	var realX = x;
	var realY = y;
	var fits = fitsInto(x, y, popupWidth, popupHeight, pageX, pageY, pageWidth, pageHeight);
	
	// --- X position
	if((fits & 1) != 0 ) {
		realX = pageX;
	} else if((fits & 2) != 0 ) {
		// --- problem in the width: try x2
		if(x2) {
			var fits2 = fitsInto(x2 - popupWidth, y, popupWidth, popupHeight, pageX, pageY, pageWidth, pageHeight);
			realX = x2 - popupWidth;
			if((fits2 & 1) != 0 ) {
				realX = pageX;
			} else if((fits2 & 2) != 0 ) {
				// --- adjust x
				realX = Math.max(0, pageX + pageWidth - popupWidth);
			}
		} else {
			// --- adjust x
			realX = Math.max(0, pageX + pageWidth - popupWidth);
		}
	}

	// --- Y position
	if((fits & 4) != 0 ) {
		realY = pageY;
	} else if((fits & 8) != 0 ) {
		realY = Math.max(0, pageY + pageHeight - popupHeight);
	}
	
	// --- place window and show it
//alert("Show popup: ("+x+", "+y+", "+x2+") -> ("+realX+", "+realY+")");
	if (isNS4) {
		this.div.left = realX;
		this.div.top = realY;
		// --- events
		this.div.onmouseout = outMenu;
		this.div.onmouseover = inMenu;
		// --- show
		this.div.visibility = "show";
	} else { // IE
	    this.div.style.left = realX+"px";
	    this.div.style.top = realY+"px";
		// --- events
		this.div.onmouseout = outMenu;
		this.div.onmouseover = inMenu;
		// --- show
		this.div.style.visibility = "visible";
	}
}

function close()
{
	this.closeChild();
	if(this.div)
	{
		if(isIECompat || isGeckoCompat)
		{
			this.div.style.visibility = "hidden";
// not supported by NS6			this.div.removeNode(true);
			setFreeWindow(this.div);
		} else if (isNS4) {
			this.div.visibility = "hide";
			setFreeWindow(this.div);
		}
		this.div = null;
	}
}

function closeChild()
{
	closeMenuWindow(this.level+1);
}

function makeChild(sourceItem, index)
{
//	var menuToMake = this.menu[index][3];
	var menuToMake = this.menu[index][4];
	var curChild = getMenuWindow(this.level+1);
	if(curChild && curChild.menu == menuToMake)
	{
		curChild.closeChild();
		return;
	}
	
	this.closeChild();
	
	this.child = new MenuWindow(this.widgetName, this.formName, this.contextID, menuToMake, this.win, this.level+1);
	
	var x1=0, y1=0, x2=0;
	if(isNS4)
	{
		x1 = this.div.left + this.div.clip.width;
		y1 = this.div.y + sourceItem.y;
		x2 = this.div.left;
	} else { // IE & NS6
		x1 = this.div.offsetLeft + this.div.offsetWidth;
		y1 = this.div.offsetTop + sourceItem.offsetTop;
		x2 = this.div.offsetLeft;
	}
	this.child.show(x1, y1, x2);
}


// ===========================================================================
// ! static functions
// ===========================================================================

/**
 * returns the HTML code for the menu
 */
function renderMenu(widgetName, formName, contextID, menuArray, level)
{
	var htmlCode = "<TABLE class=Menu name='MENUWIN@"+level+"' cellspacing=0>\n";
	
	for(iItem=0; iItem<menuArray.length; iItem++)
	{
		var item = menuArray[iItem];
		if(item == 0)
		{
			// separator
			htmlCode += "<TR class=Menu><TD name='MENUSEP@"+iItem+"' colspan=3><HR></TD></TR>\n";
		}
		else
		{
			var typeItem = item[0];
			var textItem = item[1];
			var iconItem = item[2];
			var itemID = item[3];
			
			// --- start TR
			htmlCode += "<TR";
//			htmlCode += " name='MENUITEM@"+itemID+"'";

			if(typeItem == 3)
			{
				// --- disabled menu item (added by BRH)
				htmlCode += " class=MenuDisabled";
			}
			else
			{
				htmlCode += " class=Menu";
				if(typeItem == 1)
				{
					// --- standard item
					htmlCode += " onmouseover=\"this.className='MenuHighlight'; getMenuWindow("+level+").closeChild();\"";
					htmlCode += " onmouseout=\"this.className='Menu';\"";
					if(item.length >= 5 && item[4])
						var clickCode = "closePopUp();"+item[4];
					else
						var clickCode = "closePopUp(); MenuCommand('"+widgetName+"','"+formName+"','"+contextID+"','"+itemID+"');";
					htmlCode += " onclick=\""+clickCode+"\"";
					htmlCode += " oncontextmenu=\""+clickCode+"\"";
				}
				else
				{
					// --- sub-menu
					htmlCode += " onmouseover=\"this.className='MenuHighlight'; getMenuWindow("+level+").makeChild(this, "+iItem+");\"";
					htmlCode += " onmouseout=\"this.className='Menu';\"";
					// --- for WinRunner
					htmlCode += " onclick=\"getMenuWindow("+level+").makeChild(this, "+iItem+");\"";
				}
			}
			// --- close TR
			htmlCode += ">";
			
			// --- image
			htmlCode += "<TD name='MENUITEM_ICON@"+itemID+"' valign=middle>";
			if(iconItem)
				htmlCode += "<IMG align=middle SRC='"+iconItem+"' oncontextmenu='return false;'>"; //JJY
			else
				htmlCode += "&nbsp;";
			htmlCode += "</TD>";
			
			if(typeItem == 1 || typeItem == 3)	// BRH
			{
				// --- standard item
				htmlCode += "<TD name='MENUITEM@"+itemID+"' class=Menu NOWRAP colspan=2 valign=middle>";
				htmlCode += textItem;
				htmlCode += "</TD>";
			}
			else if(typeItem == 2)
			{
				// --- sub-menu
				// --- text
				htmlCode += "<TD name='MENUITEM@"+itemID+"' class=Menu NOWRAP valign=middle>";
				htmlCode += textItem;
				htmlCode += "</TD>";
	
				// --- arrow icon
				htmlCode += "<TD name='MENUITEM_SUB@"+itemID+"' valign=middle>";
				htmlCode += "<IMG align=right SRC='"+popupExpandIcon+"'>";
				htmlCode += "</TD>";
			}
			
			// --- end of line
			htmlCode += "</TR>\n";
		} // --- end loop on items
	}
	htmlCode += "</TABLE>\n";
//alert("html: "+htmlCode);
	return htmlCode;
}

/**
 * returns the HTML code for the menu (for Netscape 4)
 */
function renderMenuNS4(menuArray, level)
{
	var htmlCode = "<TABLE class=Menu cellspacing=0>\n";
	
	for(i=0; i<menuArray.length; null)
	{
		var typeItem = menuArray[i++];
		if(typeItem == 0)
		{
			// separator
			htmlCode += "<TR class=Menu><TD colspan=3><HR></TD></TR>\n";
		}
		else
		{
			var textItem = menuArray[i++];
			var iconItem = menuArray[i++];

			var eventCode = "";
			if(typeItem == 1)
			{
				// item
				var actionItem = menuArray[i++];
				eventCode += " onmouseover=\"this.className='MenuHighlight'; getMenuWindow("+level+").closeChild();\"";
				eventCode += " onmouseout=\"this.className='Menu';\"";
				var clickCode = "closePopUp();";
				if(actionItem)
					clickCode += " " + actionItem;
				eventCode += " onclick=\""+clickCode+"\"";
				eventCode += " oncontextmenu=\""+clickCode+"\"";
			}
			else
			{
				// sub-menu
				eventCode += " onmouseover=\"this.className='MenuHighlight'; getMenuWindow("+level+").makeChild(this, "+i+");\"";
				i++;
				eventCode += " onmouseout=\"this.className='Menu';\"";
			}
			
			htmlCode += "<TR class=Menu>";
			htmlCode += "<TD class=Menu NOWRAP align=justify valign=middle>";
			htmlCode += "<A class=MenuLink HREF=# "+eventCode+">";

			// --- 1: image
			if(iconItem)
				htmlCode += "<IMG align=middle SRC='"+iconItem+"'>&nbsp;";
			else
				htmlCode += "&nbsp;&nbsp;&nbsp;";

			// --- 2: text
			htmlCode += textItem;

			// --- 3: arrow if sub-menu
			if(typeItem != 1)
				htmlCode += "&nbsp;<IMG align=middle SRC='"+popupExpandIcon+"'>";

			htmlCode += "</TD>";
			htmlCode += "</A>";

			// --- end of line
			htmlCode += "</TR>\n";
		}
	}
	htmlCode += "</TABLE>\n";
	return htmlCode;
}
var Jdg_Menu_Counter = 0;

function inMenu()
{
	Jdg_Menu_Counter++;
}

function outMenu()
{
	setTimeout("closeIfNotInMenu('"+Jdg_Menu_Counter+"')", 500);
}

function closeIfNotInMenu(counter)
{
	if(counter != Jdg_Menu_Counter) return;
	Jdg_Menu_Counter = 0;
	closePopUp();
}

/**
 * Tests if object1 (x1, y1, w1, h1) fits into object2 (x2, y2, w2, h2)
 * @returns a bitwise combination
 *  0: fits (OK)
 *  1: left border is out
 *  2: right border is out
 *  4: top border is out
 *  8: bottom border is out
 */
function fitsInto(x1, y1, w1, h1, x2, y2, w2, h2)
{
	var rc = 0;
	if(x1 < x2) rc |= 1;
	if(x1 + w1 > x2 + w2) rc |= 2;
	if(y1 < y2) rc |= 4;
	if(y1 + h1 > y2 + h2) rc |= 8;
	
	return rc;
}

} // --- end of js file load
