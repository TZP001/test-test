// --- load js file only once
if((typeof LOAD_CATJDIALOG_JS) == "undefined") {
LOAD_CATJDIALOG_JS = true;

// --- navigator initializations
isIECompat = false;
isGeckoCompat = false;
isNS4 = false;

IE_BROWSER_CLASS = "MSIE";
NS_BROWSER_CLASS = "Netscape";
MOZ_BROWSER_CLASS = "Mozilla";
OPERA_BROWSER_CLASS = "Opera";
ICE_BROWSER_CLASS = "ICEBrowser";

// --- browser name is a string
browserClass = "Unknown";
// --- browser version is a float
browserVersion = 0.0;

function readVersion(str, i)
{
	var ver = 0.0;
	var minorFactor=0;
	var c;
	// --- skip blanks
	while(i<str.length)
	{
		c = str.charAt(i);
		if(c == ' ')
			i++;
		else
			break;
	}

	while(i<str.length)
	{
		c = str.charAt(i++);
		if(c <= '9' && c >= '0')
		{
			ver = ver*10 + (c - '0');
			minorFactor = minorFactor*10;
		}
		else if(c == '.')
		{
			if(minorFactor == 0)
				// --- we were reading major version: swith to minor
				minorFactor = 1;
		}
		else
			// --- no digit neither '.': break
			break;
	}

	if(minorFactor > 0)
		ver = ver / minorFactor;

	return ver;
}

function initBrowser()
{
	var tmpidx;
	
	if(document.all) {
		// --- it may be any Internet Explorer, Opera or ICE Browser
		isIECompat = true;

		// --- Opera
		tmpidx = navigator.userAgent.indexOf("Opera");
		if(tmpidx > 0)
		{
			browserClass = OPERA_BROWSER_CLASS;
			browserVersion = readVersion(navigator.userAgent, tmpidx+5);
			return;
		}
		
		// --- ICE
		tmpidx = navigator.appVersion.indexOf("ICEBrowser");
		if(tmpidx > 0)
		{
			browserClass = ICE_BROWSER_CLASS;
// no version			browserVersion = readVersion(navigator.userAgent, tmpidx+5);
			return;
		}
		
		// --- IE
		browserClass = IE_BROWSER_CLASS;
		tmpidx = navigator.appVersion.indexOf("MSIE");
		if(tmpidx > 0)
		{
			browserVersion = readVersion(navigator.appVersion, tmpidx+4);
			return;
		}
	} else if(document.layers) {
		// --- only Netscape 4
		isNS4 = true;
		browserClass = NS_BROWSER_CLASS;
		browserVersion = readVersion(navigator.appVersion, 0);
		return;
	} else {
		// --- Mozilla, Netscape 6 or 7
		isGeckoCompat = true;
		
		// --- Netscape(s)
		tmpidx = navigator.userAgent.indexOf("Netscape");
		if(tmpidx > 0)
		{
			browserClass = NS_BROWSER_CLASS;
			// --- version is after the '/'
			var idxslash = navigator.userAgent.indexOf("/", tmpidx+8);
			browserVersion = readVersion(navigator.userAgent, idxslash+1);
			return;
		}
		
		// --- Mozilla
		tmpidx = navigator.userAgent.indexOf("rv:");
		if(tmpidx > 0)
		{
			browserClass = MOZ_BROWSER_CLASS;
			browserVersion = readVersion(navigator.userAgent, tmpidx+3);
			return;
		}
	}
}

// --- init browser
initBrowser();
//alert("Browser: "+browserClass+" version "+browserVersion);

// --- on Netscape 4, capture events
//if(isNS4) document.captureEvents(Event.KEYUP|Event.KEYDOWN);
if(isNS4) document.captureEvents(Event.KEYPRESS);

// --- each time CATJDialog.js is loaded, unset waiting cursor
//if(!isNS4)
//	setWaitingCursor(false);

/*********************************************************************
 * Static variables
 *********************************************************************/
if(typeof waitingText=='undefined'){var waitingText = "Please wait...";}

/*********************************************************************
 * Copy/Paste functions
 *********************************************************************/
/**
 * Copies data to clipboard
 */
function copyToClipboard(text)
{
	// --- 1: copy to clipboard
	if(window.clipboardData) 
	{
		// --- IE
		window.clipboardData.setData("Text", text);
	}
	else if(isGeckoCompat)//window.netscape) 
	{
		// --- Mozilla compatible browsers
		try {
			netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
		} catch(e) {
			// --- !!! javascript must be signed to work!
			return;
		}

		// get clipboard class
		var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
		if (!clip) return;
		
		// get transferable class
		var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
		if (!trans) return;
		
		// set data flavor
		trans.addDataFlavor('text/unicode');
		
//		var str = new Object();
//		var len = new Object();
//		var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
//		var copytext=meintext;
//		str.data=copytext;
//		trans.setTransferData("text/unicode",str,copytext.length*2);
		trans.setTransferData("text/unicode",text,text.length+1);

		var clipid=Components.interfaces.nsIClipboard;
		if (!clip) return false;
		clip.setData(trans,null,clipid.kGlobalClipboard);
	}
	else
		return;

	// --- 2: update the 'ClipboardChecksum' hidden input in the parent frame (menu / tree)
	if(parent.document && parent.document.forms[0] && parent.document.forms[0].elements["ClipboardChecksum"])
		parent.document.forms[0].elements["ClipboardChecksum"].value = getQuickChecksum(text);
}

function getClipboard()
{
	if(window.clipboardData)
	{
		// --- IE
		return window.clipboardData.getData('Text');
	}
	else if(isGeckoCompat)//window.netscape)
	{
		try {
			netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
		} catch(e) {
			// --- !!! javascript must be signed to work!
			return;
		}
		
		// --- get clipboard class
		var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
		if (!clip) return;
		
		// --- get transferable class
		var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
		if (!trans) return;
		
		// --- set data flavor
		trans.addDataFlavor('text/unicode');
		
		// --- get data
		clip.getData(trans,clip.kGlobalClipboard);

		var str = new Object();
		var len = new Object();
		try {
			trans.getTransferData('text/unicode',str,len);
		} catch(e) {
			return;
		}
	
		if (str) {
			// NS7
			if (Components.interfaces.nsISupportsWString)
				str=str.value.QueryInterface(Components.interfaces.nsISupportsWString);
			// Mozilla 1.2
			else if (Components.interfaces.nsISupportsString)
				str=str.value.QueryInterface(Components.interfaces.nsISupportsString);
			else
				str = null;
		}
	
		if(str)
			return(str.data.substring(0,len.value / 2));
	}
	
	return null;
}

/**
 * Checks the client clipboard and resends it if it changed
 */
function checkClipboard(formName)
{
	var newClipboardText = getClipboard();
	if(newClipboardText == null)
		return;
	var newClipboardChecksum = getQuickChecksum(newClipboardText);
	var oldClipboardChecksum = window.document.forms[formName].elements["ClipboardChecksum"].value;
	if(newClipboardChecksum != oldClipboardChecksum)
	{
//alert("Clipboard changed! old CS: ["+oldClipboardChecksum+"] new CS: ["+newClipboardChecksum+"]");
		var clipboardData= document.createElement( "INPUT" );
		clipboardData.name = "JdgClipboard";
		clipboardData.type = "hidden";
		clipboardData.value = newClipboardText;
		window.document.forms[formName].appendChild(clipboardData);
	}
}

function getQuickChecksum(text)
{
	// --- use [size].[first char hex code][middle char hex code][last char hex code]
	if(text == null)
		return "0";
	var len = text.length;
	var ret = ""+len;
	
	if(len >= 1)
	{
		ret = ret+".";
		ret = ret+getHex(text.charCodeAt(0),2);
		if(len >= 2)
		{
			ret = ret+getHex(text.charCodeAt(len/2),2);
			if(len >= 3)
				ret = ret+getHex(text.charCodeAt(len-1),2);
		}
	}
	return ret;
}
function getHex(value, size)
{
	var digits = "0123456789ABCDEF";
	var ret = "";
	var i = 0;
	while(value > 0)
	{
		ret = digits.charAt(value & 15) + ret;
		value = value >> 4;
		i++;
	}
	if(size)
	{
		while(i<size)
		{
			ret = "0"+ret;
			i++;
		}
	}
	return ret;
}

/*********************************************************************
 * bookmark function
 *********************************************************************/
// --- Adds a bookmark in the browser
function bookmark(url,name)
{
	if(isIECompat)
	{
		// --- Internet Explorer
		try {
			window.external.AddFavorite(url, name);
		} catch(e) {
		}
	}
	else if(isGeckoCompat)
	{
		// --- Gecko (NS 6, 7 and Mozilla)
		try {
		    window.sidebar.addPanel( name, url, '' );
		} catch(e) {
		}
	}
}

/*********************************************************************
 * Upload code
 *********************************************************************/
function submitUpload(extensionsArray, incFromURL)
{
	// On enleve le message dupload error car on fait un nouvel upload
	var diverror = document.getElementById('UploadError');
	if (diverror ) diverror .style.visibility="hidden"; 

	var filename = document.forms["UPLOAD"].elements["file"].value;
	if(!filename || filename.length == 0)
	{
//		alert("Please enter a file.");
		return false;
	}
	if(extensionsArray)
	{
		var idx = filename.lastIndexOf(".");
		if(idx < 0)
		{
			// --- file has no extension: return
//			alert("Please enter a file with extension.");
// READONLY			document.forms["UPLOAD"].elements["file"].value = "";
			var div = document.getElementById('ExtensionError');
			if (div) div.style.visibility="visible"; 
			return false;
		}
		
		var ext = filename.substr(idx+1).toLowerCase();
		
		for(var i=0; i<extensionsArray.length; i++)
		{
			if(extensionsArray[i].toLowerCase() == ext)
			{
				//if(isIECompat) document.body.style.cursor='wait';
				setWaitingCursor(true);
				if(incFromURL)
					document.forms["UPLOAD"].action += "/FromURL/"+top.location;
				document.forms["UPLOAD"].submit();
				return false;
			}
		}

//		alert("Please enter a file with expected extension.");
// READONLY			document.forms["UPLOAD"].elements["file"].value = "";
		var div = document.getElementById('ExtensionError');
		if (div) div.style.visibility="visible"; 
		return false;
	}
	else
	{
		//if(isIECompat) document.body.style.cursor='wait';
		setWaitingCursor(true);
		if(incFromURL)
			document.forms["UPLOAD"].action += "/FromURL/"+top.location;
		document.forms["UPLOAD"].submit();
	}
	return false;
}
/*********************************************************************
 * Upload2 code
 *********************************************************************/
function Jdg_sendDataInIframe(formName)
{
	var form = window.document.forms[formName];
	var params = new Array();
	params["JdgForm"] = formName;
	for(var i=0; i<form.elements.length; i++)
	{
		var input = form.elements[i];
		params[input.name] = input.value;
	}
	executeRequest(JDG_UPLOAD_URI, params);
}
function Jdg_processUpload(formName)
{
	// --- turn the form into a multipart form with file inputs
	var form = window.document.forms[formName];
	form.action = JDG_UPLOAD_URI; 
	form.method = "post";
	form.enctype="MULTIPART/FORM-DATA";
	form.encoding="MULTIPART/FORM-DATA";

	// --- send the window URL with an hidden input
	var input = window.document.createElement("INPUT");
	input.type="hidden";
	input.name="JdgWinURL";
	input.value=window.location.href;
	form.appendChild(input);
	
	// --- submit
	form.submit();
}

/*********************************************************************
 * formatted TextField code
 *********************************************************************/
if(typeof MonthNames=='undefined')
{
	var formatOKIconURI = "GreenLed.gif";
	var formatKOIconURI = "RedLed.gif";
}

function fillFormattedField(formName, textFieldName, text, regexpStr)
{
	var textField = document.forms[formName].elements[textFieldName];
	if(textField == null)
		return;
	
	textField.value = text,
	checkFormattedField(textField, regexpStr, text);
}

function checkFormattedField(textFieldObj, finalFormatRE, value)
{
	if(textFieldObj == null)
		return;

	var icon = document.images["REGEXP@"+textFieldObj.name]
//alert("checkFormattedField("+textFieldObj.value+", "+finalFormatRE+", "+value+") - icon: "+icon);
	if(icon == null)
		return;

	var re = new RegExp(finalFormatRE, "i");
	var matches = re.test(value);
	icon.src = matches ? formatOKIconURI : formatKOIconURI;
//	alert("post check ["+val+"] matches ["+format+"]: "+matches+" (icon "+textField.name+"_STAT"+": "+icon+")");
	return matches;
}

function postCheckFormat(evt, textFieldObj, finalFormatRE)
{
	if(textFieldObj == null)
		return;
	var value = textFieldObj.value;
	if(isNS4 && navigator.platform != "Win32")
	{
		// --- on Unix Netscape 4, value is not yet updated with last char
		value += String.fromCharCode(evt.which);
	}
	return checkFormattedField(textFieldObj, finalFormatRE, value);
}
function checkAndRestore(evt, field, ref)
{
	var re = new RegExp(ref, "i");
	var matches = re.test(field.value);
	if(matches)
		field.lastOK=field.value;
	else
		field.value = field.lastOK ? field.lastOK : "";
	return matches;
}
var CONTROL_KEYS=[0, 8 /*backspace*/, 9 /*tab*/, 13 /*return*/, 16 /*shift*/, 17 /*ctrl*/, 27, 37 /*arrow*/, 38 /*arrow*/, 39 /*arrow*/, 40 /*arrow*/, 46 /*del*/ ];
function checkNumber(evt, onReturnForm, onReturnInput, onReturnValue)
{
	var code = (window.event) ? window.event.keyCode : evt.which;
	if(onReturnInput && code == 13)
	{
		submitHidden(onReturnInput ,onReturnValue, onReturnForm);
		return false;
	}
	
	for(var i=0; i<CONTROL_KEYS.length; i++)
		if(code == CONTROL_KEYS[i])
			return true;
	
//	var key = String.fromCharCode(code);
//	return "0123456789".indexOf(key) >= 0;
	// --- digit keys
	if(code >= 48 && code <= 57)
		return true;
	// --- numpad keys
	if(code >= 96 && code <= 105)
		return true;
}
/*********************************************************************
 * Resizable Divs
 *********************************************************************/
/**
 * Used in Mozilla browsers to fix a bug in the DIV layout computing
 */
function Jdg_beforeResizeDiv(div)
{
	if(!div) return;
	div.style.width = div.jdgMinWidth ? div.jdgMinWidth : 0;
	div.style.height = div.jdgMinHeight ? div.jdgMinHeight : 0;
}
/**
 * Used in Mozilla browsers to fix a bug in the DIV layout computing
 */
function Jdg_afterResizeDiv(div)
{
	if(!div) return;

	var p = div.parentNode;
	// --- This mechanism is very tricky to tune with Mozilla!
	// --- ==> width must be set AFTER height (causes a bug on Mozilla 1.4 !!!)
//alert("Setting DIV ("+div.id+") size to: "+p.offsetWidth+"x"+p.offsetHeight);
	div.style.height = p.offsetHeight-2;

	div.style.width = p.offsetWidth-2;
//	div.style.width = '100%';

//alert("First Child ("+div.firstChild+") size: "+div.firstChild.offsetWidth+"x"+div.firstChild.offsetHeight+" ("+div.firstChild.width+","+div.firstChild.height+")");

	// --- adjust scroll position
	var maxScrollLeft = div.scrollWidth-div.offsetWidth;
	if(maxScrollLeft < 0) maxScrollLeft = 0;
	if(div.scrollLeft > maxScrollLeft) div.scrollLeft = maxScrollLeft;

	var maxScrollTop = div.scrollHeight-div.offsetHeight;
	if(maxScrollTop < 0) maxScrollTop = 0;
	if(div.scrollTop > maxScrollTop) div.scrollTop = maxScrollTop;
}
/**
 * Used in Mozilla browsers to fix a bug in the DIV layout computing
 */
function Jdg_initResizableDiv(id, minwidth, minheight)
{
	var div = document.getElementById(id);
	if(!div) return;
	div.style.position="relative";
	div.jdgBeforeResize = Jdg_beforeResizeDiv;
	div.jdgAfterResize = Jdg_afterResizeDiv;
	if(minwidth) div.jdgMinWidth = minwidth;
	if(minheight) div.jdgMinHeight = minheight;
//	Jdg_addEventHandler(window, "resize", Jdg_resizeDivs);
}
function Jdg_resizeDivs()
{
	var divs = document.getElementsByTagName("DIV");
	// --- hide divs
	for(var i=0; i<divs.length; i++)
	{
		if(divs[i].jdgBeforeResize)
			divs[i].jdgBeforeResize(divs[i]);
	}
//alert("before setting sizes");
	// --- give all divs its new size
	for(var i=0; i<divs.length; i++)
	{
		if(divs[i].jdgAfterResize)
			divs[i].jdgAfterResize(divs[i]);
	}
}
/*********************************************************************
 * Various
 *********************************************************************/
/**
 * Checks if str starts with sub
 */
function startsWith(str, sub)
{
	if(sub.length > str.length)
		return false;
	return str.substr(0, sub.length) == sub;
}
/*
 * Returns wether the object is visible or not
 * @param oObject: HTML entity
 * @param fullyVisible: (boolean) has the object to be fully or partially visible?
 * @param orientation: (int) has visibility to be checked vertically(1)/horizontally(2)/or both(0 or undefined)?
 */
function isVisible(oObject, fullyVisible, orientation)
{
	var oScrollCont = getScrollContainer(oObject.parentNode);
	var pos = getAbsPos(oObject, oScrollCont);
	
	if(orientation == null) orientation = 0;
	if(orientation == 0 || orientation == 2)
	{
		// --- visibility has to be checked horizontally
		var relLeft = pos[0] - oScrollCont.scrollLeft;
		var visible = fullyVisible ? (relLeft >= 0) && ((relLeft + oObject.offsetWidth) <= oScrollCont.clientWidth)
						           : ((relLeft + oObject.offsetWidth) >= 0) && (relLeft <= oScrollCont.clientWidth);
		if(!visible) return false;
	}
	if(orientation == 0 || orientation == 1)
	{
		// --- visibility has to be checked vertically
		var relTop = pos[1] - oScrollCont.scrollTop;
		var visible = fullyVisible ? (relTop >= 0) && ((relTop + oObject.offsetHeight) <= oScrollCont.clientHeight)
								   : ((relTop + oObject.offsetHeight) >= 0) && (relTop <= oScrollCont.clientHeight);
		if(!visible) return false;
	}
	return true;
}
function encodeAsHTML(str, nbsp)
{
	var ret = "";
	for(var i=0; i< str.length; i++)
	{
		var c = str.charAt(i);
		if(nbsp && c == ' ')
		{
			ret+="&nbsp;";
			continue;
		}
		switch(c)
		{
			case '\"':
				ret+="&quot;";
				break;
				break;
			case '\n':
				ret+="<br>";
				break;
			case '&':
				ret+="&amp;";
				break;
			case '>':
				ret+="&gt;";
				break;
			case '<':
				ret+="&lt;";
				break;
			default:
				ret+=c;
		}
	}
	return ret;
}
/*
 * Returns father node
 */
function getFatherNode(nodeType, node)
{
	var obj = node;
	while(obj != null && (obj.nodeName == null || obj.nodeName != nodeType))
			obj = obj.parentNode;
	return obj;
}
/*
 * Returns father node
 */
function getFatherNodeWithId(nodeType, node)
{
	var obj = node;
	while(obj != null)
	{
		if(obj.nodeName && obj.nodeName == nodeType && obj.id != null && obj.id != "")
			return obj;
		obj = obj.parentNode;
	}
	return obj;
}
/*
 * Returns the element index (-1 if not found)
 */
function indexOfElt(arr, elt)
{
	for(var i=0; i<arr.length; i++)
	{
		if(arr[i] == elt)
			return i;
	}
	return -1;
}
/**
 * executes a request
 */
function executeRequest(baseUrl, params)
{
	// --- 1: try with GET method
	var getUrl = baseUrl;
	// --- modif IOD 04/04/07 due to WSRP config
	var separ;
	if (baseUrl.indexOf("ResourceProxy?")>0)
	{
	    // --- try to find a "?" after the end of the URI => "&r=e"
	    var indexEndURI = baseUrl.indexOf("&r=e");
	    separ = (baseUrl.indexOf("?", indexEndURI) < 0) ? "?" : "&";
	}
	else
    	separ = (baseUrl.indexOf("?") < 0) ? "?" : "&";
    // --- end modif IOD
	for(var paramName in params)
	{
//		getUrl = getUrl+separ+paramName+"="+params[paramName];
		getUrl = getUrl+separ+paramName+"="+encodeURI(params[paramName]);
		if(separ == "?") separ = "&";
	}
//alert("Request GET url ("+getUrl.length+" len): "+getUrl);

	if(getUrl.length < 2048)
	{
		if(isNS4)
		{
			var win = window.open(getUrl,"jdgframe","toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1,height=1");
			win.close();
			return;
		}
		getHiddenIframe(window, "jdgframe").location.replace(getUrl);
		return;
	}

//alert("GET url too long ("+getUrl.length+"): using POST");
	// --- 2: GET url too long: use POST
	var newframe = getHiddenIframe(window, "jdgframe");

	var doc = null;
	if (newframe.contentDocument) {
		// For NS6
		doc = newframe.contentDocument; 
	} else if (newframe.contentWindow) {
		// For IE5.5 and IE6
		doc = newframe.contentWindow.document;
	} else if (newframe.document) {
		// For IE5
		doc = newframe.document;
	} else {
		return;
	}
	
	if(!doc.body)
		doc.appendChild(doc.createElement("BODY"));

	var form = doc.createElement( "FORM" );
//form.target = "postframe";
	form.action = baseUrl;
	form.method = "post";
	doc.body.appendChild(form);
	for(var paramName in params)
	{
		var input = doc.createElement( "INPUT" );
		input.type="hidden";
		input.name=paramName;
		input.value=params[paramName];
		form.appendChild(input);
	}
	// --- submit form
	form.submit();
	//form.removeNode(true);
}
/**
 * Retrieves or creates the hidden IFRAME named 'iframeName' in 'fatherWindow' frameset
 */
function getHiddenIframe(fatherWindow, iframeName)
{
	var iframe = fatherWindow.frames[iframeName];
	if(!iframe)
	{
		// --- make an invisible IFRAME
		iframe = fatherWindow.document.createElement("IFRAME");
		// for IE
		iframe.id = iframeName;
		// for NS
		iframe.name = iframeName;
		iframe.frameBorder = 0;
		iframe.border = 0;
		iframe.width = 0;
		iframe.height = 0;
//		iframe.style.visibility = "hidden";
		fatherWindow.document.body.appendChild(iframe);

		iframe = fatherWindow.frames[iframeName];// bug?
	}
	
	return iframe;
}
/*
 * Returns the absolute postion of obj in the page
 */
function getAbsPos(obj, relativeToObj)
{
	var topOffset = 0;
	var leftOffset = 0;
	if(relativeToObj == null) relativeToObj = document.body;
	if(browserClass == NS_BROWSER_CLASS && browserVersion < 7.0)
	{
		// --- netscape 4 & 6
		topOffset = obj.offsetTop;
		leftOffset = obj.offsetLeft;
		if(relativeToObj)
		{
			topOffset -= relativeToObj.offsetTop;
			leftOffset -= relativeToObj.offsetLeft;
		}
	}
	else
	{
		// --- IE, Netscape>=7, mozilla, ...
		while(true)
		{
//alert("obj: "+obj.nodeName+" (id "+obj.id+"), offsetLeft: "+obj.offsetLeft+", scrollLeft: "+obj.scrollLeft);
//			topOffset += obj.offsetTop-obj.scrollTop;
			topOffset += obj.offsetTop;
			leftOffset += obj.offsetLeft;
			if (obj.parentNode == relativeToObj) break; // IOD : the offsetParent can only be TD or TABLE ; the relativeToObj can be a DIV...
			obj = obj.offsetParent;
			if(!obj) break;
			if(relativeToObj && relativeToObj == obj) break;
			topOffset -= obj.scrollTop;
			leftOffset -= obj.scrollLeft;
		}
	}
	return [leftOffset, topOffset];
}

function getScrollContainer(obj)
{
//	var cont = obj.parentNode;
	var cont = obj;
	while(cont)
	{
//		if(cont.nodeName == "DIV" && (cont.style.overflow == "auto" || cont.style.overflow == "scroll"))
		if(cont.nodeName == "DIV")
			return cont;
		if(cont.nodeName == "BODY")
			return cont;
		cont = cont.parentNode;
	}
	return null;
}
/*
 * Updates the hidden input associated to a check input 
 */
function updateCheck(checkInput, hiddenInputName, formName)
{
	var hiddenInput = window.document.forms[formName].elements[hiddenInputName];
	if(checkInput.type == "radio")
	{
		hiddenInput.value="on";
	}
	else
	{
		// --- checkbox
	//	alert('checkInput.checked 2: '+checkInput.checked);
		if (checkInput.checked)
			hiddenInput.value="on";
		else
			hiddenInput.value="off";
	}
}

/*
 * Handles the event on a text field input,
 * and activates the associated button when RETURN pressed
 */
function activateButtonOnReturn(evt, butName, formName)
{
	if(!formName) formName = 0;
	var code = (window.event) ? window.event.keyCode : evt.which;
	if(code==13)
	{
		submitHidden(butName ,"Activate", formName);
		return false;
	}
	return true;
}
/*
 * Sets the value of the hidden input and submit the form
 */
function submitHidden(inputName, inputValue, formName)
{
	
	if(!formName) formName = 0;
	if(inputName && window.document.forms[formName].elements[inputName])
		window.document.forms[formName].elements[inputName].value = inputValue;
	sendData(formName);
	return false;
}
/*
 * Sets the value of the hidden input and submit the form
 */
/*
function submitHidden2(inputName, inputValue, inputName2, inputValue2, formName)
{
	if(!formName) formName = 0;
	window.document.forms[formName].elements[inputName].value = inputValue;
	window.document.forms[formName].elements[inputName2].value = inputValue2;
	sendData(formName);
	return false;
}
*/
var PAGE_IS_LOADING = false;
/*
 * Submits a JDialog command in a frame
 * Stores (and sends) scroll position
 */
function sendData(formName, win)
{
	if(!formName) formName = 0;
	if(!win) win = window;
	
	if(PAGE_IS_LOADING)
		return;
	
	// --- store window size
	var size = getFrameVisibleSize();
	if(document.forms[formName].elements["wWidth"])
		document.forms[formName].elements["wWidth"].value = size[0];
	if(document.forms[formName].elements["wHeight"])
		document.forms[formName].elements["wHeight"].value = size[1];

	// --- store scroll positions
	storeAllScrollPos(formName, win);
	
	// --- check clipboard data
	checkClipboard(formName);
	
	// --- set waiting cusor
	setWaitingCursor(true);
	
	if(typeof JDG_UPLOAD_URI != 'undefined')
	{
		// --- the form contains FILE input(s): the request 
		// --- has to be made from an hidden Iframe
		Jdg_sendDataInIframe(formName);
		return;
	}
	PAGE_IS_LOADING = true;

	// --- finally submit the main form
	win.document.forms[formName].submit();
}

/*
 * Returns true if access to frame is authorized (false otherwise)
 */
function authorizedAccess(frame)
{
	try {
		var locStr = ""+frame.location;
		return (locStr.length > 0);
	} catch(e) {
		return false;
	}
}
/*
 * shows / hides a waiting layer on given document
 */
function showWaitingMask(show, aWindow)
{
//alert(""+(show ? "show" : "hide")+" waiting mask on: "+getWindowHierarchy(aWindow));
	if(!aWindow.document || !aWindow.document.body)
		return;
	
	var mask = aWindow.document.getElementById("HourglassMask");

	if(show)
	{
		if(!mask)
		{
			mask = aWindow.document.createElement("DIV");
			mask.id = "HourglassMask";

			mask.style.position = "absolute";
			mask.style.left = 0;
			mask.style.top = 0;
//			mask.style.height = "100%";
//			mask.style.width = "100%";
			mask.style.cursor = "wait";
			mask.style.zIndex = 100;
			mask.style.backgroundColor = "white";
			mask.style.filter = "alpha(opacity=30)";
			mask.style.visibility = "hidden";

			aWindow.document.body.appendChild(mask);
		}
		var size = getFrameContentSize(aWindow);
		mask.style.height = size[1]-1;
		mask.style.width = size[0]-1;
		mask.style.visibility = "visible";
	}
	else
	{
		if(mask)
			mask.style.visibility = "hidden";
	}
}

/*
 * Sets/unsets the hourglass cursor in all frames of the browser
 */
function setWaitingCursor(wait, msg)
{
	if(authorizedAccess(top))
		top.status = wait ? waitingText : (msg ? msg : "");

/*
	if(authorizedAccess(top) && top.document && top.document.body)
		showWaitingMask(wait, top);
	
	for(var i=0; i<top.frames.length; i++)
	{
		var f = top.frames[i];
		if(authorizedAccess(f) && f.document && f.document.body)
			showWaitingMask(wait, f);
	}
*/
	// --- look for the highest frame with setWaitingCursor() support
	var wc = null;
	var wp = window;
	while(wp && authorizedAccess(wp) && wp.document && wp.document.body && wp.setWaitingCursor)
	{
		showWaitingMask(wait, wp);
		wc = wp;
		wp = wp.parent;
		// top.parent == parent: we have to check
		if(wp == wc) break;
	}
//	if(wc) showWaitingMask(wait, wc);
}

function getWindowHierarchy(win)
{
	if(!win)
		return null;
	var ret = "";
	while(true)
	{
		if(win == top)
			return "top"+ret;
		ret = "."+win.name+ret;
		win = win.parent;
	}
}

var HORIZONTAL_RESIZE = 1;
var VERTICAL_RESIZE = 2;
var RESIZE_GAP = 24;
/*
 * Checks if frame size has changed since last rendering
 * If the difference is greater than a threshold, the form is
 * submitted to render the frame again
 */
function reloadOnResize(formName, policy, doStore)
{
	var size = getFrameVisibleSize();
	var w = size[0];
	var h = size[1];

	// --- retrieve last (w,h)
	if(!formName) formName = 0;
	if(doStore)
	{
		document.forms[formName].elements["wHeight"].value = h;
		document.forms[formName].elements["wWidth"].value = w;
		return;
	}
//	if(h <= 0 || w <= 0)
//		return;
	
	// --- check if window has to be reloaded
	var lastw = document.forms[formName].elements["wWidth"].value;
	var lasth = document.forms[formName].elements["wHeight"].value;
	if( ( ((policy & VERTICAL_RESIZE) != 0) && (Math.abs(h - lasth) > RESIZE_GAP) )
	    || ( ((policy & HORIZONTAL_RESIZE) != 0) && (Math.abs(w - lastw) > RESIZE_GAP) ) )
	{
		document.forms[formName].elements["wHeight"].value = h;
		document.forms[formName].elements["wWidth"].value = w;
		sendData(formName);
		return;
	}
}
function sendWindowSize(formName)
{
	var size = getFrameVisibleSize();
	var w = size[0];
	var h = size[1];
	document.forms[formName].elements["wHeight"].value = h;
	document.forms[formName].elements["wWidth"].value = w;
	sendData(formName);
}

/*
 * Stores FRAME and DIVs scroll positions (before submitting)
 */
function storeAllScrollPos(formName, win)
{
	storeWinScrollPos(formName, win);
	win.document.forms[formName].elements["sDivPos"].value=getDivScrollPositions(win);
}

function storeWinScrollPos(formName, win)
{
	if(!win) win = window;
	var top, left;
	if(isIECompat)
	{
		top = win.document.body.scrollTop;
		left = win.document.body.scrollLeft;
	}
	else
	{
		top = win.pageYOffset;
		left = win.pageXOffset;
	}

	win.document.forms[formName].elements["sTop"].value=top;
	win.document.forms[formName].elements["sLeft"].value=left;
}

function updateDivScrollPos(divObj, formName)
{
	var divScrollPos = document.forms[formName].elements["sDivPos"].value;
	if(divScrollPos == null) return;
	
	var positions = divScrollPos.split(";");
	for(var i=0; i<positions.length; i=i+3)
	{
		if(divObj.id == positions[i])
		{
			positions[i+1] = divObj.scrollTop;
			positions[i+2] = divObj.scrollLeft;
			document.forms[formName].elements["sDivPos"].value = positions.join(";");
			return;
		}
	}
}
/*
 * Stores the frame's size (before submitting)
 */
function getWindowSizes(win)
{
	var size = getFrameVisibleSize(win);
	return "wHeight="+size[1]+"&wWidth="+size[0];
}
/*
 * Returns a string with FRAME scroll positions
 * example: "sTop=12&sLeft=581"
 */
function getFrameScrollPosition(win)
{
	var pos = getFrameScrollPos(win);
	return "sTop="+pos[1]+"&sLeft="+pos[0];
}
function getFrameVisibleSize(win)
{
	if(!win) win = window;
	if(isIECompat)
		return [win.document.body.clientWidth, win.document.body.clientHeight];

	return [win.innerWidth, win.innerHeight];
}
function getFrameContentSize(win)
{
	if(!win) win = window;
	if(isIECompat)
		return [win.document.body.scrollWidth, win.document.body.scrollHeight];
	return [win.innerWidth, win.innerHeight];
}
function getFrameScrollPos(win)
{
	if(!win) win = window;
	if(isIECompat)
		return [win.document.body.scrollLeft, win.document.body.scrollTop];

	return [win.pageXOffset, win.pageYOffset];
}

/*
 * Returns a string with div scroll positions
 * example: "divID1;12;0;divID2;0;45"
 */
function getDivScrollPositions(win)
{
	if(!win) win = window;
	var doc = win.document;

	// --- Get div name and scroll position for each div
	var divPos = "";
	var divs = doc.body.getElementsByTagName('div');
	if(divs == null) return;
	for(i=0; i<divs.length; i++)
	{
		if(divs[i].id != null && divs[i].id.length > 0 && divs[i].style.visibility != "hidden" && (divs[i].scrollTop > 0 || divs[i].scrollLeft > 0))
			divPos = divPos + divs[i].id +";"+ divs[i].scrollTop +";"+divs[i].scrollLeft+";";
	}
	
	return divPos;
}

/*
 * Restore scroll position from values stored in the form
 */
function setupScrolls(formName, win)
{
	if(!formName) formName = 0;
	if(!win) win = window;

	// --- 1: restore scroll positions for DIV elements
	var divPos = win.document.forms[formName].elements["sDivPos"].value;
	if(divPos != null)
	{
		var arrayOfStrings = divPos.split(";");
		
		var coll = win.document.body.getElementsByTagName('div');
		if(coll == null) return;

		for(i=0; i<coll.length; i++)
		{
			for(j=0; j<arrayOfStrings.length; j=j+3)
			{
				if(coll[i].id == arrayOfStrings[j])
				{
					coll[i].scrollTop = arrayOfStrings[j+1];
					coll[i].scrollLeft = arrayOfStrings[j+2];
				}
			}
		}
	}
	
	// --- 2: restore scroll positions for FRAME
	var top = win.document.forms[formName].elements["sTop"].value;
	var left = win.document.forms[formName].elements["sLeft"].value;
	if( top!=null )
	{
	win.scrollTo(left, top);
	}
}


function getCookie(name)
{
	var doc = document;
	var cookies = doc.cookie.split("; ");
	for( i=0; i<cookies.length; i++ )
	{
		var words= cookies[i].split("=");
		if(name==words[0])
		{
			return unescape(words[1]);
		}
	}
	return null;
}

var JDG_FRAMEID_NAME = "JdgFrame";
var JDG_FORMNAME_NAME = "JdgForm";
function jdgGetFrameID(formName)
{
	return window.document.forms[formName].elements[JDG_FRAMEID_NAME].value;
}
function Jdg_refreshFrame(topwin, path, url, sendDimAndPos)
{
	// --- find frame topwin[path]
	var frame = topwin ? topwin : top;
	var names = path.split('.');
	var i = 1;//skip first
	while(i<names.length)
	{
		frame = frame.frames[names[i]];
		if(!frame)
		{
			//alert("Jdg_refreshFrame("+win.name+", "+path+", "+url+", "+addArgs+", "+sendDimAndPos+"): frame ["+names[i]+"] not found!");
			return;
		}
		i++;
	}
	// --- add arguments (dimension, scroller positions, ...)
	if(sendDimAndPos && authorizedAccess(frame))
	{
		// --- add window sizes and scroll positions to URL params
		var sizesAndPosArg = getWindowSizes(frame)+"&"+getFrameScrollPosition(frame)+"&sDivPos="+getDivScrollPositions(frame);
		var argSepar = url.indexOf('?') > 0 ? '&' : '?';
		url = url+argSepar+sizesAndPosArg;
	}
	// --- have frame navigate on url
	if (url=='undefined' || url=='') url = frame.window.location;
	Jdg_redirect(url, frame);
}

function Jdg_redirect(url, win)
{
	if(!win) win = window;
	if(isIECompat)
		win.navigate(url);
	else
		win.location.replace(url);
}

function switchStackMode(switchUrl, stackMode, stackTitle)
{
	if(switchUrl)
	{
		// --- WPS mode
		if(stackMode)
		{
			switchUrl = switchUrl+"?STACKMODE=true&STACKTITLE="+stackTitle;
//alert("Switch to STACK mode with title ["+stackTitle+"]\nURL: "+url);
		}
		
		Jdg_redirect(switchUrl, top);
		return;
	}
	
	// --- EWV mode
	// --- 1: retreive Portlet Container window (the last before 'top')
	var win = window;
	while(win.parent != top)
		win = win.parent;

	// --- 2: change URL on Portlet Container window	
	var url = win.location.href;
	var idx = url.indexOf("?");
	if(idx > 0)
		url = url.substr(0, idx);
//	var appendArgChar = (idx > 0) ? "&" : "?";
	if(stackMode)
	{
		url = url+"?FrameID=PortletArea&STACKMODE=true&STACKTITLE="+stackTitle;
//alert("Switch to STACK mode with title ["+stackTitle+"]\nURL: "+url);
	}
	else
	{
		url = url+"?FrameID=PortletArea&STACKMODE=false";
//alert("Switch back from STACK mode\nURL: "+url);
	}
	
	win.location = url;
}


function resizeApplets()
{
	resizeAppletsFromArray(document.getElementsByTagName("APPLET"),"APPLET");
	resizeAppletsFromArray(document.getElementsByTagName("EMBED"),"EMBED");
//	resizeAppletsFromArray(document.getElementsByTagName("APPLET"));
//	resizeAppletsFromArray(document.getElementsByTagName("APPLET"));
}

function resizeAppletsFromArray(applets, tagName)
{
	if(!applets || applets.length==0)
		return;
	
	var containers = new Array();
	var directions = new Array();
	var innersHTML = new Array();
	
	
	// --- 1: save all applet attributes and delete
	for(var i=0; i<applets.length; i++)
	{
		var resizeDirs = applets[i].RESIZE_DIRS;
		if((typeof resizeDirs) == 'undefined') resizeDirs = getAppletResizeDirs(applets[i]);
		if (resizeDirs == 0) return;
		// --- get all attributes
		var mycontainer = new Object();
		for(var j=0;j<applets[i].attributes.length;j++){
      			if ( applets[i].attributes[j].specified){
	          		var attName = applets[i].attributes[j].nodeName;
				mycontainer[attName] = applets[i].attributes[j].nodeValue;
	      		}
		}
		
		// --- store father and attibutes
		var container = applets[i].parentNode;
		
		containers[container] = mycontainer;
		
		directions[container] = resizeDirs;
		
		innersHTML[container] = applets[i].innerHTML;
		
		// --- destroy applet
		container.removeChild(applets[i]);
	}
	
	// --- 2: recreate all applets
	for(var mycontainer in containers)
	{
		var attributes = containers[mycontainer];
		
		// --- create applet
		var myapplet = document.createElement(tagName);
		
		for (var attribName in attributes)
		{
			myapplet.setAttribute(attribName, attributes[attribName], 1);
		}

		var resizeDirs = directions[mycontainer];
		if((resizeDirs & HORIZONTAL_DIR) != 0)
			myapplet.width = container.offsetWidth-2;
		if((resizeDirs & VERTICAL_DIR) != 0)
			myapplet.height = container.offsetHeight-2;

		if (innersHTML[container])
			myapplet.innerHTML = innersHTML[mycontainer];
		
		myapplet.RESIZE_DIRS = resizeDirs;

		container.appendChild(myapplet);

	}
}

var HORIZONTAL_DIR = 1;
var VERTICAL_DIR = 2;

function getAppletResizeDirs(appletObj)
{
	var dirs = 0;
	if( appletObj.width.indexOf('%') >= 0 || (appletObj.RESIZE_DIRS & HORIZONTAL_DIR) != 0)
		dirs = dirs | HORIZONTAL_DIR;
	if( appletObj.height.indexOf('%') >= 0 || (appletObj.RESIZE_DIRS & VERTICAL_DIR) != 0)
		dirs = dirs | VERTICAL_DIR;
	return dirs;
}
function getResizeDirs(iNode)
{
	var dirs = HORIZONTAL_DIR | VERTICAL_DIR;
	var td = iNode;
	while((td=getFatherNode("TD", td)))
	{
		if((dirs & HORIZONTAL_DIR) != 0)
		{
			if(td.width.indexOf('%') < 0)
				dirs = dirs - HORIZONTAL_DIR;
		}
		if((dirs & VERTICAL_DIR) != 0)
		{
			if(td.height.indexOf('%') < 0)
				dirs = dirs - VERTICAL_DIR;
		}
		if(dirs == 0)
			return 0;
		td = td.parentNode;
	}
	return dirs;
}
function Jdg_addEventHandler(element, eventName, func)
{
	if(element.attachEvent)
	{
		element.detachEvent('on'+eventName, func);
		element.attachEvent('on'+eventName, func);
		return;
	}
	if(element.addEventListener)
	{
		element.addEventListener(eventName, func, false);
		return;
	}
}
function Jdg_removeEventHandler(element, eventName, func)
{
	if(element.attachEvent)
	{
		element.detachEvent('on'+eventName, func);
		return;
	}
	if(element.addEventListener)
	{
		element.removeEventListener(eventName, func, false);
		return;
	}
}
// --- used to reload top window in portal mode (WP and SPS)
function Jdg_smartReload(win)
{
	var form = win.document.createElement("Form");
	form.action = win.location;
	win.document.body.appendChild(form);
	form.submit();
}
/*********************************************************************
 * QuickBar functions
 *********************************************************************/
/**
 * Tells all quickbars that a new session starts
 * Passes them the quickbar servlet URL
 * Present QuickBars append their id to top.QUICKBAR_RESPONSE
 * If sendBackResponse is 'true', then this method immediatelly sends back the list of present QuickBars
 */
function Jdg_newQuickBarSession(quickbarServletUrl, sendBackResponse, formName, inputName)
{
	top.QUICKBAR_RESPONSE = "";
	top.QUICKBAR_MSG = quickbarServletUrl;
	if(document.all)
	{
		// --- IE
		top.status= 'QuickBar:NewSession';
		top.status= '';
	}
	else
	{
		// --- Mozilla
		var evt = top.document.createEvent("Events");
		evt.initEvent("qbsession", false, false);
		top.dispatchEvent(evt);
	}
	if(sendBackResponse)
	{
		var formObj = null;
		var inputObj = null;
		if(formName)
		{
			formObj = window.document.forms[formName];
			inputObj = formObj.elements[inputName];
		}
		else
		{
			formObj = window.document.createElement("FORM");
			formObj.action = window.location;
			formObj.method = "post";
			inputObj = document.createElement("INPUT");
			inputObj.type = "hidden";
			inputObj.name = inputName;
			formObj.appendChild(inputObj);
			window.document.body.appendChild(formObj);
		}
		inputObj.value = top.QUICKBAR_RESPONSE;
		formObj.submit();
	}
}

/*
function newQuickBarSession(quickbarServletUrl, sendBackList)
{
	if(document.all)
	{
		// --- IE
		top.status= 'QuickBar:NewSession';
		top.status= '';
	}
	else
	{
		// --- Mozilla
		var evt = top.document.createEvent("Events");
		evt.initEvent("qbsession", false, false);
		top.dispatchEvent(evt);
	}
}
*/
function sendQuickBarMessage(quickbarId, msg)
{
	if(document.all)
	{
		// --- IE
		top.QUICKBAR_MSG = quickbarId+":"+msg;
		top.status= 'QuickBar:Msg';
		top.status= '';
	}
	else
	{
		// --- Mozilla
		top.QUICKBAR_MSG = quickbarId+":"+msg;
		var evt = top.document.createEvent("Events");
		evt.initEvent("qbmessage", false, false);
		top.dispatchEvent(evt);
	}
}
/*
function checkQuickBarPresence(quickbarId, formName, inputName)
{
	//TODO: check if quick bar is here
	sendQuickBarMessage(quickbarId, "CheckPresence");

	if(!formName) formName = 0;
	if(inputName && window.document.forms[formName].elements[inputName])
	{
		if(top.QUICKBAR_RESPONSE && top.QUICKBAR_RESPONSE == quickbarId+"_ok")
		{
			// found
			window.document.forms[formName].elements[inputName].value = quickbarId+"_found";
		}
		else
		{
			window.document.forms[formName].elements[inputName].value = quickbarId+"_notfound";
		}
	}
	window.document.forms[formName].submit();
}
*/


} 

/*********************************************************************
 * Show/Hide/remove an IFrame behind a DIV (above applets or other native controls)
 *********************************************************************/
function showIFrame(div) {
	if(document.getElementById) {
		//alert("getElementById is true");
		if(!div.getAttribute("id")){
			div.setAttribute("id", "DIV"+Math.random());
		}
		divID = div.getAttribute("id");
		if(!div.style.zIndex || div.style.zIndex<1){
			div.style.zIndex = 99;	//a number high enough		
		}
		if(!document.getElementById(divID+"BGD")){
			ifrm = document.createElement("IFRAME");
			ifrm.setAttribute("id", divID+"BGD");
			ifrm.setAttribute("scroll", "no");
			ifrm.setAttribute("frameborder", "0");
			ifrm.style.position = "absolute";
			ifrm.style.filter='Alpha(opacity=0)';
			ifrm.style.width = div.style.width ? div.style.width : (div.offsetWidth + "px");
			ifrm.style.height = div.style.height ? div.style.height : (div.offsetHeight + "px");
			ifrm.style.left = div.style.left;
			ifrm.style.top = div.style.top;			
			ifrm.style.zIndex = div.style.zIndex-1;
			div.parentNode.appendChild(ifrm);
			//document.body.appendChild(ifrm);
		}
		ifrm.style.visibility = "visible";
	}
}

function removeIFrame(div) {
	if(document.getElementById) {
		divID = div.getAttribute("id");
		if(document.getElementById(divID+"BGD")){
			ifrm = document.getElementById(divID+"BGD");
			div.parentNode.removeChild(ifrm);
			//document.body.removeChild(ifrm);
		}
	}
} 

function hideIFrame(div) {
	if(document.getElementById) {
		divID = div.getAttribute("id");
		if(document.getElementById(divID+"BGD")){
			ifrm = document.getElementById(divID+"BGD");
			ifrm.style.visibility = "hidden";
		}
	} 
}

// Helper function for IE update KB912945 workaround 
function writehtml(htmlstr){
	document.write(htmlstr);
}

