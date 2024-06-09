// +---------------------------------------------------------------------------
// ! This is Javascript code for ComboBoxes / Written by PSC (25/03/2003)
// ! Works with IE (5 & 4), Netscape (4 & 6)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js
//  - Popupwindow.js

// --- load js file only once
if((typeof LOAD_COMBOBOX_JS) == "undefined") {
LOAD_COMBOBOX_JS = true;

var CUR_COMBO_FIELD;
var COMBO_ITEMS_NB = 12;

function initCombo(formName, comboName, editable, isTranslated, values, selIdx, submitOnSelect, className)
{
//TODO: manage UP and DOWN keys?
	var combo = document.forms[formName].elements[comboName];
	if(!combo)
		return;

	combo.combo_editable = editable;
	combo.combo_items = values;
	combo.combo_translated = isTranslated;
	combo.combo_selidx = selIdx;
	combo.combo_submit = submitOnSelect;
	combo.classname = className ? className : "Combo";
	
	if(isIECompat){
		combo.onfocusout = submitSelectionChange;
	}
	else{
		combo.onblur = submitSelectionChange;
	}
	combo.valueChanged = false;
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


/*
 * Handles the key events on the combo
 */
function keyPressed(evt, formName, inputName)
{	
	
	//alert("key down!");
	var combo = inputName ? document.forms[formName].elements[inputName] : (window.event ? event.srcElement : evt.target);
	if(!combo)
		return false;
		
	var keycode = -1;

	if (typeof window.event!='undefined')
		keycode = window.event.keyCode;
	else
		keycode = evt.keyCode;

	var nbitem = combo.combo_items.length;
	if(combo.combo_translated)
	{
		nbitem = combo.combo_items.length/2;
	}
	
	if ( keycode > 0)
	{
		// up arrow
		if (keycode==38)
		{
			if (combo.combo_selidx>0)
			{
				selectItem(combo, combo.combo_selidx-1);
				return true;
			}
			
		}
		// down arrow
		if (keycode==40)
		{
			if (combo.combo_selidx<nbitem-1)
			{
				selectItem(combo, combo.combo_selidx+1);
				return true;
			}
			
		}
		// page up/Home
		if (keycode==33 || keycode==36)
		{
			selectItem(combo, 0);
			return true;
		}
		// page down/End
		if (keycode==34 || keycode==35)
		{
			selectItem(combo, nbitem-1);
			return true;
		}
		if (keycode>=65&&keycode<=90) 
		{
			for (var idx=0;idx<nbitem;idx++)
			{
				var index = ( combo.combo_selidx + 1 + idx ) % nbitem;
				var value;
				if (combo.combo_translated){
					value = combo.combo_items[index*2 + 1];
				}else{
					value = combo.combo_items[index];
				}
				if (String.fromCharCode(keycode) == value.charAt(0).toUpperCase())
				{
					selectItem(combo, index);
					return true;
				}

			}
		}
	}
	return false;
}

/*
 * Update the combo text field with the selection
 */
function selectItem(combo, idx)
{
	if(combo.combo_selidx != idx){
		combo.valueChanged = true;
	}
	
	combo.combo_selidx = idx;

	if(combo.combo_translated)
	{
		combo.value = combo.combo_items[combo.combo_selidx*2+1];
		combo.form.elements[combo.name+"&Tag"].value = combo.combo_items[idx*2];
	}
	else
	{
		combo.value = combo.combo_items[idx];
	}
	combo.select();
	
	hilightItem(combo, idx);
}
/*
 * Hilight an item in the popup based on index
 */
function hilightItem(combo, idx)
{
	if(!CUR_COMBO_FIELD) return;
	var table = CUR_COMBO_FIELD.combo_win.win.getElementsByTagName("TABLE")[0];
	if(table && idx < table.rows.length && table.rows[idx])
	{
		
		highlightComboItem(table.rows[idx].cells[0]);
		CUR_COMBO_FIELD.combo_win.win.scrollTop = table.rows[CUR_COMBO_FIELD.combo_selidx].offsetTop;
	}
	
}

/*
 * When focus is moved out of the combo area, submit if needed.
 */
function submitSelectionChange(evt)
{
	
	var eventObj = window.event ? event : evt;
	var combo = window.event ? event.srcElement : evt.target;
	
	//alert("get here!");
	if(eventObj.toElement){ //IE
		if(eventObj.toElement.className == "PopupMenu"){
			//in IE, if focus moves to the popup, move it back to the text field.
			combo.focus();
			combo.select();
			return;
		}
	}
	else if(eventObj.explicitOriginalTarget){ //firefox
		if(eventObj.explicitOriginalTarget.nodeName == "IMG" &&
		   eventObj.explicitOriginalTarget.name.indexof(combo.name) != -1){ //need to be more specific here
			//in firefox, if focus moves to the dropdown arrow image, move it back to the text field.
			//by pass a firefox bug
			document.tempcombo = combo;
			setTimeout("document.tempcombo.focus();",1);
			return;
		}
	
	}

	
	if(!combo.valueChanged){
		return;
	}
	else{
		combo.valueChanged =false;
	}
	if(combo.combo_translated)
	{
		combo.value = combo.combo_items[combo.combo_selidx*2+1];
		combo.form.elements[combo.name+"&Tag"].value = combo.combo_items[combo.combo_selidx*2];
	}
	else
	{
		combo.value = combo.combo_items[combo.combo_selidx];
	}
	if(combo.combo_submit)
		sendData(combo.form.name);
	return true;
}

function touchCombo(evt, formName, inputName)
{
//alert("touch combo: "+inputName);
	var combo = inputName ? document.forms[formName].elements[inputName] : (window.event ? event.srcElement : evt.target);
	if(!combo)
		return;
	// --- if combo already open
	if(CUR_COMBO_FIELD)
	{
		// --- is it the same?
		if(combo == CUR_COMBO_FIELD)
		{
			// --- yes: close
			hideCombo();
			return;
		}
		else
		{
			// --- no: clean previous combo and continue
			hideCombo();
		}
	}
	// --- open combo
	CUR_COMBO_FIELD = combo;
	
	
	var scrollContainer = getScrollContainer(CUR_COMBO_FIELD);
	var comboContainer = getFatherNode("TABLE", CUR_COMBO_FIELD);
	CUR_COMBO_FIELD.combo_win = new PopupWindow(scrollContainer);

	var htmlCode = renderComboItems(CUR_COMBO_FIELD.combo_translated, CUR_COMBO_FIELD.combo_items, CUR_COMBO_FIELD.classname);
//alert("generated html for popup win="+htmlCode);
	CUR_COMBO_FIELD.combo_win.setContent(htmlCode);
	var table = CUR_COMBO_FIELD.combo_win.win.getElementsByTagName("TABLE")[0];

//	var table = makeComboItems(CUR_COMBO_FIELD.combo_translated, CUR_COMBO_FIELD.combo_items, CUR_COMBO_FIELD.classname);
//	CUR_COMBO_FIELD.combo_win.win.appendChild(table);

	var popupWidth = comboContainer.offsetWidth;
	var popupHeight = CUR_COMBO_FIELD.combo_win.win.offsetHeight;
	var popupVScroll = false;

	// --- resize drop down list if more items than COMBO_ITEMS_NB
	var nbItems = CUR_COMBO_FIELD.combo_translated ? (CUR_COMBO_FIELD.combo_items.length / 2) : CUR_COMBO_FIELD.combo_items.length;
	if(nbItems > COMBO_ITEMS_NB)
	{
		var firstHiddenRowPos = getAbsPos(table.rows[COMBO_ITEMS_NB], table);
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
		CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] + comboContainer.offsetHeight);
	}
	else
	{
		// 2: try above
		var heightAbove = comboPos[1] - scrollContainer.scrollTop -3;
//alert("available above="+heightAbove);
		if(heightAbove >= popupHeight)
		{
			// enought room above
			CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1]-popupHeight);
		}
		else
		{
			// 3: display in place with most room and add scrollbars
			popupVScroll = true;
			if(heightAbove > heightUnder)
			{
				// place above
				popupHeight = heightAbove;
				CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1]-popupHeight);
			}
			else
			{
				// place under
				popupHeight = heightUnder;
				CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] + comboContainer.offsetHeight);
			}
		}
	}

	// --- resize drop down list
	CUR_COMBO_FIELD.combo_win.setSize(popupWidth, popupHeight);
	if(popupVScroll)
		CUR_COMBO_FIELD.combo_win.setScrolls(0, 2);

	// --- highlight and scroll to current selection
	//if(table && (typeof CUR_COMBO_FIELD.combo_selidx != 'undefined') && table.rows[CUR_COMBO_FIELD.combo_selidx])
	if(table && (typeof CUR_COMBO_FIELD.combo_selidx != 'undefined') && CUR_COMBO_FIELD.combo_selidx >= 0 && CUR_COMBO_FIELD.combo_selidx < table.rows.length && table.rows[CUR_COMBO_FIELD.combo_selidx])
	{
		highlightComboItem(table.rows[CUR_COMBO_FIELD.combo_selidx].cells[0]);
		CUR_COMBO_FIELD.combo_win.win.scrollTop = table.rows[CUR_COMBO_FIELD.combo_selidx].offsetTop;
//		table.cells[CUR_COMBO_FIELD.combo_selidx].scrollIntoView(true);
	}

	// --- hide combo if click in page
	CUR_COMBO_FIELD.combo_win.closeOnClickOutside("hideCombo()");

	// --- show combo popup
	CUR_COMBO_FIELD.combo_win.setVisibility(true);
	
	//when the combo is opened, always focus on the combo to receive key events
	if(isGeckoCompat){
		//by pass a firefox bug
		document.tempcombo = combo;
		setTimeout("document.tempcombo.focus();",1);
	
	}
	else{
		combo.focus();
	}

/*
	if(isIECompat)
	{
//		table.focus();
//		table.onfocusout = hideCombo;
		CUR_COMBO_FIELD.combo_win.win.setActive();
		CUR_COMBO_FIELD.combo_win.win.onfocusout = hideCombo;
	}
*/
}
function hideCombo()
{
	if(!CUR_COMBO_FIELD)
		return;
	if(CUR_COMBO_FIELD.combo_win)
	{
		CUR_COMBO_FIELD.combo_win.close();
		CUR_COMBO_FIELD.combo_win = null;
	}
	CUR_COMBO_FIELD = null;
}

function highlightComboItem(cellObj)
{
//	var cellObj = window.event ? window.event.srcElement : evt.target;
	var rowObj = getFatherNode("TR", cellObj);
	var tableObj = getFatherNode("TABLE", cellObj);
	if(tableObj.highlighted_row)
		tableObj.highlighted_row.cells[0].className = CUR_COMBO_FIELD.classname;
	rowObj.cells[0].className = CUR_COMBO_FIELD.classname+'H';
	tableObj.highlighted_row = rowObj;
}
function unhighlightComboItem(cellObj)
{
//	var cellObj = window.event ? window.event.srcElement : evt.target;
	var rowObj = getFatherNode("TR", cellObj);
	var tableObj = getFatherNode("TABLE", cellObj);
	if(tableObj.highlighted_row)
		tableObj.highlighted_row.cells[0].className = CUR_COMBO_FIELD.classname;
	rowObj.cells[0].className = CUR_COMBO_FIELD.classname;
	tableObj.highlighted_row = rowObj;
}
function selectComboItem(cellObj)
{
//	var cellObj = window.event ? window.event.srcElement : evt.target;
	if(!CUR_COMBO_FIELD)
		return;
	var combo = CUR_COMBO_FIELD;
	hideCombo();
	combo.focus();
	combo.combo_selidx = cellObj.parentNode.rowIndex;
	if(combo.combo_translated)
	{
		combo.value = combo.combo_items[combo.combo_selidx*2+1];
		combo.form.elements[combo.name+"&Tag"].value = combo.combo_items[combo.combo_selidx*2];
	}
	else
	{
		combo.value = combo.combo_items[combo.combo_selidx];
	}
	if(combo.combo_submit)
		sendData(combo.form.name);
}
/* Unused
function makeComboItems(isTranslated, values, className)
{
//TODO: tooltip for items longer than view
	var table = document.createElement("TABLE");
	table.cellSpacing = 0;
	table.width = '100%';
	table.className = className;

	for(var i=0; i<values.length; i++)
	{
		var row = table.insertRow();
		var cell = row.insertCell();
		cell.noWrap = true;
		cell.style.cursor = 'default';
cell.height = 40;
		cell.className = className;
		cell.onmouseover = highlightComboItem;
		cell.onmousedown = selectComboItem;
		cell.onmouseup = selectComboItem;
		if(isTranslated)
			i++;
		cell.innerText = values[i];
	}
	return table;
}
*/
function renderComboItems(isTranslated, values, className)
{
//TODO: tooltip for items longer than view
//alert("render combo list ("+values.length+"): "+values);
	var htmlCode = "";
	htmlCode = htmlCode + "<TABLE name='COMBOITEMS' CELLSPACING=0 width=100% class="+className+">";
//	htmlCode = htmlCode + "<TABLE name='COMBOITEMS' CELLSPACING=0 width=100%>";
	for(var i=0; i<values.length; i++)
	{
		htmlCode = htmlCode + "<TR>"
		htmlCode = htmlCode + "<TD NOWRAP style='cursor:default' class="+className
		htmlCode = htmlCode + " name='COMBOITEM@"+i+"'";
		htmlCode = htmlCode + " onMouseOver=\"highlightComboItem(this);\"";
		htmlCode = htmlCode + " onMouseOut=\"unhighlightComboItem(this);\"";
		htmlCode = htmlCode + " onMouseDown=\"selectComboItem(this)\"";
		htmlCode = htmlCode + " onMouseUp=\"selectComboItem(this)\"";
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
