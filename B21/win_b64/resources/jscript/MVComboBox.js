// +---------------------------------------------------------------------------
// ! This is Javascript code for MultiLineCombos / Written by BRH (03/08/2005)
// ! Works with IE, Mozilla
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js
//  - Popupwindow.js

// --- load js file only once
if((typeof LOAD_MVCOMBO_JS) == "undefined") {
LOAD_MVCOMBO_JS = true;

var CUR_MVCOMBO_FIELD;
var MVCOMBO_ITEMS_NB = 12;

function initMVCombo(formName, comboName, editable, isTranslated, values, selValues, submitOnSelect, className)
{
//TODO: manage UP and DOWN keys?
	var combo = document.forms[formName].elements[comboName];
	if(!combo)
		return;

	combo.combo_editable = editable;
	combo.combo_items = values;
	combo.combo_translated = isTranslated;
    var selFlags = new Array();
	for(var i=0; i<values.length; i++)
		selFlags[i] = ( indexOfElt(selValues,values[i]) >= 0 );
	combo.combo_selFlags = selFlags;
	combo.combo_submit = submitOnSelect;
	combo.classname = className ? className : "MVCombo";
/*
//	var arrow = document.images[comboName+ARROW_SUFFIX];
//	arrow.onmousedown = touchCombo;
	if(editable)
	{
		combo.onmousedown = hideCombo;
	}
	else
	{
		combo.contentEditable = false;
		combo.onmousedown = touchCombo;
		combo.style.cursor="default";
	}
*/
}

function touchMVCombo(evt, formName, inputName)
{
//alert("touch combo: "+inputName);
	var combo = inputName ? document.forms[formName].elements[inputName] : (window.event ? event.srcElement : evt.target);
	if(!combo)
		return;
	// --- if combo already open
	if(CUR_MVCOMBO_FIELD)
	{
		// --- is it the same?
		if(combo == CUR_MVCOMBO_FIELD)
		{
			// --- yes: close
			hideMVCombo();
			return;
		}
		else
		{
			// --- no: clean previous combo and continue
			hideMVCombo();
		}
	}
	// --- open combo
	CUR_MVCOMBO_FIELD = combo;

	var scrollContainer = getScrollContainer(CUR_MVCOMBO_FIELD);
	var comboContainer = getFatherNode("TABLE", CUR_MVCOMBO_FIELD);
	CUR_MVCOMBO_FIELD.combo_win = new PopupWindow(scrollContainer);

	var htmlCode = renderMVComboItems(CUR_MVCOMBO_FIELD.combo_translated, CUR_MVCOMBO_FIELD.combo_items, CUR_MVCOMBO_FIELD.classname);
//alert("generated html for popup win="+htmlCode);
	CUR_MVCOMBO_FIELD.combo_win.setContent(htmlCode);
	var table = CUR_MVCOMBO_FIELD.combo_win.win.getElementsByTagName("TABLE")[0];

//	var table = makeComboItems(CUR_MVCOMBO_FIELD.combo_translated, CUR_MVCOMBO_FIELD.combo_items, CUR_MVCOMBO_FIELD.classname);
//	CUR_MVCOMBO_FIELD.combo_win.win.appendChild(table);

	var popupWidth = comboContainer.offsetWidth;
	var popupHeight = CUR_MVCOMBO_FIELD.combo_win.win.offsetHeight;
	var popupVScroll = false;

	// --- resize drop down list if more items than MVCOMBO_ITEMS_NB
	var nbItems = CUR_MVCOMBO_FIELD.combo_translated ? (CUR_MVCOMBO_FIELD.combo_items.length / 2) : CUR_MVCOMBO_FIELD.combo_items.length;
	if(nbItems > MVCOMBO_ITEMS_NB)
	{
		var firstHiddenRowPos = getAbsPos(table.rows[MVCOMBO_ITEMS_NB], table);
		popupHeight = firstHiddenRowPos[1];
		popupVScroll = true;
	}
	// --- place drop down list
	var comboPos = getAbsPos(comboContainer, scrollContainer);
	// 1: try under the comboContainer
	var heightUnder = scrollContainer.scrollTop + scrollContainer.clientHeight - comboContainer.offsetHeight - comboPos[1] - 3;
//alert("required="+popupHeight+", scrollContainer.clientHeight="+scrollContainer.clientHeight+", scrollContainer.scrollTop="+scrollContainer.scrollTop+", comboContainer.offsetTop="+comboContainer.offsetTop+", comboContainer.scrollTop="+comboContainer.scrollTop+", comboContainer.clientTop="+comboContainer.clientTop+", combo top/scroll="+comboPos[1]+", abs combo top="+comboAbsPos[1]+", page Y="+pageY+", page visible height="+pageHeight);
//alert("available under="+heightUnder);
	if(heightUnder >= popupHeight)
	{
		// enought room under
		CUR_MVCOMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] + comboContainer.offsetHeight);
	}
	else
	{
		// 2: try above
		var heightAbove = comboPos[1] - scrollContainer.scrollTop -3;
//alert("available above="+heightAbove);
		if(heightAbove >= popupHeight)
		{
			// enought room above
			CUR_MVCOMBO_FIELD.combo_win.move(comboPos[0], comboPos[1]-popupHeight);
//alert("showing above");
		}
		else
		{
			// 3: display in place with most room and add scrollbars
			popupVScroll = true;
			if(heightAbove > heightUnder)
			{
				// place above
				popupHeight = heightAbove;
				CUR_MVCOMBO_FIELD.combo_win.move(comboPos[0], comboPos[1]-popupHeight);
//alert("showing above (scrolled)");
			}
			else
			{
				// place under
				popupHeight = heightUnder;
				CUR_MVCOMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] + comboContainer.offsetHeight);
//alert("showing below (scrolled)");
			}
		}
	}

	// --- resize drop down list
	CUR_MVCOMBO_FIELD.combo_win.setSize(popupWidth, popupHeight);
	if(popupVScroll)
		CUR_MVCOMBO_FIELD.combo_win.setScrolls(0, 2);

	// --- highlight and scroll to current selection
	//if(table && (typeof CUR_MVCOMBO_FIELD.combo_selidx != 'undefined') && table.rows[CUR_MVCOMBO_FIELD.combo_selidx])
	if(table && (typeof CUR_MVCOMBO_FIELD.combo_selidx != 'undefined') && CUR_MVCOMBO_FIELD.combo_selidx >= 0 && CUR_MVCOMBO_FIELD.combo_selidx < table.rows.length && table.rows[CUR_MVCOMBO_FIELD.combo_selidx])
	{
		highlightMVComboSelection(table.rows[CUR_MVCOMBO_FIELD.combo_selidx].cells[0]);
		CUR_MVCOMBO_FIELD.combo_win.win.scrollTop = table.rows[CUR_MVCOMBO_FIELD.combo_selidx].offsetTop;
//		table.cells[CUR_MVCOMBO_FIELD.combo_selidx].scrollIntoView(true);
	}

	// --- hide combo if click in page
	CUR_MVCOMBO_FIELD.combo_win.closeOnClickOutside("hideMVCombo()");

	// --- show combo popup
	CUR_MVCOMBO_FIELD.combo_win.setVisibility(true);
}
function hideMVCombo()
{
	if(!CUR_MVCOMBO_FIELD)
		return;
	if(CUR_MVCOMBO_FIELD.combo_win)
	{
		CUR_MVCOMBO_FIELD.combo_win.close();
		CUR_MVCOMBO_FIELD.combo_win = null;
	}
	CUR_MVCOMBO_FIELD = null;
}

function highlightMVComboItem(cellObj)
{
    // Save the original colors in order to restore them later.
	cellObj.origLeftColor   = cellObj.style.borderLeftColor;
	cellObj.origRightColor  = cellObj.style.borderRightColor;
	cellObj.origTopColor    = cellObj.style.borderTopColor;
	cellObj.origBottomColor = cellObj.style.borderBottomColor;
//	var cellObj = window.event ? window.event.srcElement : evt.target;
	cellObj.style.borderColor = treeSelectedBackground;
}
function unhighlightMVComboItem(cellObj)
{
    // Restore the original colors.
	cellObj.style.borderLeftColor   = cellObj.origLeftColor;
	cellObj.style.borderRightColor  = cellObj.origRightColor;
	cellObj.style.borderTopColor    = cellObj.origTopColor;
	cellObj.style.borderBottomColor = cellObj.origBottomColor;
}
function highlightMVComboSelection(cellObj)
{
	//var rowObj = getFatherNode("TR", cellObj);
	//var tableObj = getFatherNode("TABLE", cellObj);
	//rowObj.cells[0].className = CUR_MVCOMBO_FIELD.classname+'H';
	cellObj.className = CUR_MVCOMBO_FIELD.classname+'H';
}
function unhighlightMVComboSelection(cellObj)
{
	//var rowObj = getFatherNode("TR", cellObj);
	//var tableObj = getFatherNode("TABLE", cellObj);
	//rowObj.cells[0].className = CUR_MVCOMBO_FIELD.classname;
	cellObj.className = CUR_MVCOMBO_FIELD.classname;
}
function selectMVComboItem(evt,cellObj)
{
//	var cellObj = window.event ? window.event.srcElement : evt.target;
	if(!CUR_MVCOMBO_FIELD)
		return;
	var combo = CUR_MVCOMBO_FIELD;
	var selidx = cellObj.parentNode.rowIndex;
	if( combo.combo_selFlags[selidx] ) {
		// undo selection - unhighlight the row
		combo.combo_selFlags[selidx] = false;
		unhighlightMVComboSelection(cellObj);
	} else {
		// add selection - highlight the row
		combo.combo_selFlags[selidx] = true;
		highlightMVComboSelection(cellObj);
	}
	combo.focus();
	var selList = "";
	var firstData = true;
	for(var i=0; i<combo.combo_items.length; i++) {
		if( combo.combo_selFlags[i] ) {
			if(!firstData) selList = selList + "\r\n";
			selList = selList + combo.combo_items[i];
			firstData=false;
		}
	}
	combo.value = selList;
	if(!evt.ctrlKey) {
		hideMVCombo();
		if(combo.combo_submit) sendData(combo.form.name);
	}
}
function renderMVComboItems(isTranslated, values, className)
{
//TODO: tooltip for items longer than view
//alert("render combo list ("+values.length+"): "+values);
	var htmlCode = "";
	htmlCode = htmlCode + "<TABLE name='COMBOITEMS' CELLSPACING=0 width=100% class="+className+">";
//	htmlCode = htmlCode + "<TABLE name='COMBOITEMS' CELLSPACING=0 width=100%>";
	for(var i=0; i<values.length; i++)
	{
		var rowCellClass = className;
		if( CUR_MVCOMBO_FIELD.combo_selFlags[i] ) rowCellClass = className + "H"; 
		htmlCode = htmlCode + "<TR>"
		htmlCode = htmlCode + "<TD NOWRAP style='cursor:default' class="+rowCellClass
		htmlCode = htmlCode + " name='COMBOITEM@"+i+"'";
		htmlCode = htmlCode + " onMouseOver=\"highlightMVComboItem(this);\"";
		htmlCode = htmlCode + " onMouseOut=\"unhighlightMVComboItem(this);\"";
		htmlCode = htmlCode + " onClick=\"selectMVComboItem(event,this)\"";
		htmlCode = htmlCode + " UNSELECTABLE=on";
		htmlCode = htmlCode + ">"
		if(isTranslated)
			i++;
		if (values[i]=="")
			htmlCode = htmlCode + "&nbsp;";
		else
			htmlCode = htmlCode + encodeAsHTML(values[i], true);
		htmlCode = htmlCode + "</TD></TR>";
	}
	htmlCode = htmlCode + "</TABLE>";
	return htmlCode;
}

} // --- end of js file load
