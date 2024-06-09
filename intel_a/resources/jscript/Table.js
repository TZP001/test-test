// +---------------------------------------------------------------------------
// ! This is Javascript code for Tables management / Written by JJY (14/09/2002)
// ! Works with IE (4 & 5)
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js

// --- load js file only once
if((typeof LOAD_TABLE_JS) == "undefined") {
LOAD_TABLE_JS = true;

var HEADER_ROWID = "_header_";
var NO_SELECTION_MODE = 0;
var CELL_SELECTION_MODE = 2;
var LINE_SELECTION_MODE = 1;

var tSTRING= 0;
var tIMAGE=  1;
var tCHECK=  2;
var tLINK=   4;
var tRADIO=  8;
var tEDITABLE=  16;

// --- this array centralizes tables settings
var _tableSettings = new Array();

/*********************************************************************
 * Table code
 *********************************************************************/
function getHeaderRow(tableObj)
{
  // --- header row is first or second row
  if(tableObj.rows[0].id == HEADER_ROWID)
    return tableObj.rows[0];
  return tableObj.rows[1];
}
/*
 * Returns the cell model column
 */
function getModelColumn(tableObj, colNb)
{
	if(!tableObj)
		tableObj = getFatherNodeWithId("TABLE", cellObj);
//	return tableObj.rows["_header_"].cells[colNb].id;
	return getHeaderRow(tableObj).cells[colNb].id;
}
/*
 * Returns the cell model column
 */
function getDisplayColumn(modelColumn, tableObj)
{
	if(!tableObj)
		tableObj = getFatherNodeWithId("TABLE", cellObj);
//	var header = tableObj.rows["_header_"];
	var header = getHeaderRow(tableObj);
	for(var i=0; i<header.cells.length; i++)
		if(header.cells[i].id == modelColumn)
			return i;
	return 0;
}
/*
 * Retrieves the cell ID
 */
function getCellId(tableObj, cellObj)
{
	var rowObj = getFatherNode("TR", cellObj);
	return getModelColumn(tableObj, cellObj.cellIndex)+"-"+rowObj.id;
}
/*
 * Retrieves the row object from its ID
 */
function getRowFromId(tableObj, rowId)
{
// not implemented	return tableObj.rows.nameItem(rowId);
	for(var i=0; i<tableObj.rows.length; i++)
	{
		if(tableObj.rows[i].id == rowId)
			return tableObj.rows[i];
	}
	return null;
}
/*
 * Retrieves the cell object from its ID
 */
function getCellFromId(tableObj, cellId)
{
	var idx = cellId.indexOf("-");
	var colNb = parseInt(cellId.substr(0, idx));
	var rowId = cellId.substr(idx+1);
	var rowObj = getRowFromId(tableObj, rowId);
	if(rowObj == null)
		return null;
//alert("get cell from id ["+cellId+"] ("+colNb+"/"+rowId+"): row="+rowObj.nodeName);
	return rowObj.cells[getDisplayColumn(colNb,tableObj)];
}
/*
 * initiates table
 *  - stores behavior info
 *  - updates selected items color
 */
function initTable(formName, tableId, selectionMode, multipleSel, submitOnSelect, hasCellAction, hasCtxMenu)
{
	_tableSettings[tableId] = new TableSettings(selectionMode, multipleSel, submitOnSelect, hasCellAction, hasCtxMenu, formName);
	if(isNS4)
		return;
	if(selectionMode != NO_SELECTION_MODE)
	{
		var tableObj = document.getElementById(tableId);
		if(tableObj)
		{
			updateTableColors(tableObj, formName, selectionMode);
		}
//		else alert("Undefined table object!!");
	}
}

function TableSettings(selectionMode, multipleSel, submitOnSelect, hasCellAction, hasCtxMenu, formName)
{
	this.mode = selectionMode;
	this.multipleSelection = multipleSel;
	this.submitOnSelect = submitOnSelect;
	this.hasCellAction = hasCellAction;
	this.hasCtxMenu = hasCtxMenu;
	this.formName = formName;
}

/*
 * Returns table settings
 */
function getTableSettings(tableObj)
{
	return _tableSettings[tableObj.id];
}

function updateTableColors(table, formName, selectMode)
{
	var tableName = table.id;
	var currentSelection = document.forms[formName].elements[tableName+"&Selection"].value;
	if(!currentSelection || currentSelection == "")
		return;

	if(selectMode == CELL_SELECTION_MODE)
	{
		// --- cell selection
		var arrayOfSelectedIDs = currentSelection.split(";");
		for(var i=0; i<arrayOfSelectedIDs.length; i++)
		{
			var cellObj = getCellFromId(table, arrayOfSelectedIDs[i]);
			if(cellObj)
				updateCellColor(cellObj, true);
		}
	}
	else
	{
		// --- line selection
		var arrayOfSelectedIDs = currentSelection.split(";");
		for(var i=0; i<table.rows.length; i++)
		{
		   	var rowObj = table.rows[i];
			if(table.rows[i].id && table.rows[i].id != null)
			{
				var selected = (indexOfElt(arrayOfSelectedIDs, table.rows[i].id) >= 0);
				updateRowColor(table.rows[i], selected);
			}
		}
	}
}

function saveOrigColors(cellObj)
{
	var rowObj = getFatherNode("TR", cellObj);
	if (rowObj.origLeftColor != null)
		return;
	rowObj.origLeftColor   = cellObj.style.borderLeftColor;
	rowObj.origRightColor  = cellObj.style.borderRightColor;
	rowObj.origTopColor    = cellObj.style.borderTopColor;
	rowObj.origBottomColor = cellObj.style.borderBottomColor;
	rowObj.origBackground  = cellObj.style.backgroundColor;
}
function restoreOrigBorderColors(cellObj)
{
	var rowObj = getFatherNode("TR", cellObj);
	if (rowObj.origLeftColor == null)
		return;
	cellObj.style.borderLeftColor = rowObj.origLeftColor;
	cellObj.style.borderRightColor = rowObj.origRightColor;
	cellObj.style.borderTopColor = rowObj.origTopColor;
	cellObj.style.borderBottomColor = rowObj.origBottomColor;
}
function updateCellColor(cellObj, selected)
{
	if(selected)
		cellObj.className='TableSelected';
	else
	{
		// Try to get className on next or previous cell
		var nextsib = cellObj.nextSibling;
		// on Mozilla, nextSibling or prevSibling give a '#text' type object
		while(nextsib != null && nextsib.nodeName != "TD")
			nextsib = nextsib.nextSibling;
		if(nextsib != null)
		{
			cellObj.className = nextsib.className;
			return;
		}
		var prevsib = cellObj.previousSibling;
		while(prevsib != null && prevsib.nodeName != "TD")
			prevsib = prevsib.previousSibling;
		if(prevsib != null)
		{
			cellObj.className = prevsib.className;
			return;
		}
		
		cellObj.className='Table0';
	}
}
function updateRowColor(rowObj, selected)
{
	if(!rowObj.isSelected)
		saveOrigColors(rowObj.cells[0]);

	for(var i=0; i<rowObj.cells.length; i++)
	{
		if(selected)
		{
			rowObj.cells[i].style.backgroundColor=treeSelectedBackground;
			rowObj.cells[i].style.borderColor=treeSelectedBackground;
		}
		else
		{
//			rowObj.cells[i].style.backgroundColor=rowObj.className;
			//rowObj.cells[i].style.borderColor=rowObj.className;
			rowObj.cells[i].style.backgroundColor=rowObj.origBackground;
			restoreOrigBorderColors(rowObj.cells[i]);
		}
// do not highlight border
/*
                if(i > 0)
                        rowObj.cells[i].style.borderLeftColor=color;
                if(i < rowObj.cells.length-1)
                        rowObj.cells[i].style.borderRightColor=color;
*/
	}
	rowObj.isSelected = selected;
}

/**
 * Updates selection
 * returns whether the selection has changed or not
 */
function updateTableSelection(evt, cellObj, tableId, rowId, colNb, ctxMenuEvent)
{
	var tableSettings = _tableSettings[tableId];
	if(tableSettings.mode == NO_SELECTION_MODE)
		return false;

	var rowObj = cellObj ? getFatherNodeWithId("TR", cellObj) : null;
	var tableObj = cellObj ? getFatherNodeWithId("TABLE", rowObj) : null;
	var isRowSelectionMode = (tableSettings.mode == LINE_SELECTION_MODE);
	var cellId = colNb+"-"+rowId;
	var currentSelection = document.forms[tableSettings.formName].elements[tableId+"&Selection"].value;

	var itemId = isRowSelectionMode ? rowId : cellId;

	if(!tableSettings.multipleSelection)
	{
		// --- single selection
		if(currentSelection == itemId)
			return false;

		if(cellObj)
		{
			// --- unselect previous item
			if(currentSelection && currentSelection.length > 0)
			{
				if(isRowSelectionMode)
				{
					var curSelRow = getRowFromId(tableObj, currentSelection);
					if(curSelRow) updateRowColor(curSelRow, false);
				}
				else
				{
					var curSelCell = getCellFromId(tableObj, currentSelection);
					if(curSelCell) updateCellColor(curSelCell, false);
				}
			}
			// --- select new item
			isRowSelectionMode ? updateRowColor(rowObj, true) : updateCellColor(cellObj, true);
		}

		document.forms[tableSettings.formName].elements[tableId+"&Selection"].value = itemId;
		return true;
	}

	// --- multiple selection
	var arrayOfSelectedIDs = currentSelection.split(";");
	var itemIndex = indexOfElt(arrayOfSelectedIDs, itemId);
	var lastIdInput = document.forms[tableSettings.formName].elements[tableId+"&ShiftSelectedID"];
	var lastShiftId = lastIdInput ? lastIdInput.value : null;
	if(lastShiftId == "") lastShiftId = null;

//alert("multisel item=["+itemId+"] current=["+currentSelection+"] ("+arrayOfSelectedIDs.length+")");

	// --- on contextual menu, if node is already selected, do not change selection
	if(ctxMenuEvent && itemIndex >= 0)
		return false;

	// --- update selection
	if(evt.ctrlKey)
	{
		if(itemIndex >= 0)
		{
			// --- CTRL click on a selected item: remove it from selection
			if(cellObj)
			{
				isRowSelectionMode ? updateRowColor(rowObj, false) : updateCellColor(cellObj, false);
			}
			arrayOfSelectedIDs.splice(itemIndex, 1);
		}
		else
		{
			// --- CTRL click on an uselected item: add it to selection
			if(cellObj)
			{
				isRowSelectionMode ? updateRowColor(rowObj, true) : updateCellColor(cellObj, true);
			}
			arrayOfSelectedIDs.push(itemId);
		}

		// --- update last selected ID
		if(lastIdInput)
			lastIdInput.value = itemId;
	}
	else if(evt.shiftKey && lastShiftId && isRowSelectionMode && tableObj)
	{
		// --- update selection (however the row was sel or unsel)
		// --- find row indexes
		arrayOfSelectedIDs = new Array();
		var select = false;
//		var rows = tableObj.getElementsByTagName("TR");
		var rows = tableObj.rows;
		for(var i=0; i<rows.length; i++)
		{
			if(rows[i].id)
			{
				var selected = select;
				if(rows[i].id == lastShiftId || rows[i].id == itemId)
				{
					// --- cell is one of the 2 bounds
					selected = true;
					select = !select;
				}
				updateRowColor(rows[i], selected);
				if(selected)
					arrayOfSelectedIDs.push(rows[i].id);
			}
		}
	}
	else // single click or else
	{
		// --- if already selected and single selection, do not change selection
		if(itemIndex >= 0 && arrayOfSelectedIDs.length == 1)
			return false;

		// --- unselect every other item
		if(cellObj)
		{
			for(var i=0; i<arrayOfSelectedIDs.length; i++)
			{
				if(i == itemIndex)
					continue;
				if(isRowSelectionMode)
				{
					var r = getRowFromId(tableObj, arrayOfSelectedIDs[i]);
					if(r) updateRowColor(r, false);
				}
				else
				{
					var c = getCellFromId(tableObj, arrayOfSelectedIDs[i]);
					if(c) updateCellColor(c, false);
				}
			}
		}

		// --- select cur item
		arrayOfSelectedIDs = [itemId];
		if(cellObj)
		{
			isRowSelectionMode ? updateRowColor(rowObj, true) : updateCellColor(cellObj, true);
		}

		// --- update last selected ID
		if(lastIdInput)
			lastIdInput.value = itemId;
	}

	// --- update selection hidden input
	var newSelection = arrayOfSelectedIDs.join(";");
	document.forms[tableSettings.formName].elements[tableId+"&Selection"].value = newSelection;

	// selection has changed
	return true;
}

/*
 * Raises contextual menu on a table cell
 */
/*
function tableCtxMenu(evt, cellObj, tableId, rowId, colNb)
{
	var tableSettings = _tableSettings[tableId];
	var cellId = colNb+"-"+rowId;
	// select?
	var selectionHiddenInput = document.forms[tableSettings.formName].elements[tableId+"&Selection"];
	var selCmd = selectionHiddenInput ? "Selection="+selectionHiddenInput.value : null;
	showCtxMenu(null, tableId, cellId);
}
*/
/*********************************************************************
 * Shortened table functions
 *********************************************************************/
// Cell Highlight (!NS4)
function _tH(cell)
{
	saveOrigColors(cell);
	cell.style.borderColor = treeSelectedBackground;
}

// Cell Unhighlight (!NS4)
function _tU(cell)
{
	//cell.style.borderColor = row.className;
	restoreOrigBorderColors(cell);
}

// Line Highlight (!NS4)
function _tLH(row)
{
	saveOrigColors(row.cells[0]);

	row.cells[0].style.borderLeftColor=treeSelectedBackground;
	row.cells[row.cells.length-1].style.borderRightColor=treeSelectedBackground;
	for (i=0; i<row.cells.length; i++)
	{
		row.cells[i].style.borderTopColor=treeSelectedBackground;
		row.cells[i].style.borderBottomColor=treeSelectedBackground;
	}
}

// Line Unhighlight (!NS4)
function _tLU(row)
{
	if(row.isSelected)
		return;
	
	row.cells[0].style.borderLeftColor=row.origLeftColor;
	row.cells[row.cells.length-1].style.borderRightColor=row.origRightColor;
	for (i=0; i<row.cells.length; i++) {
		//row.cells[i].style.borderColor=row.className;
		row.cells[i].style.borderTopColor=row.origTopColor;
		row.cells[i].style.borderBottomColor=row.origBottomColor;
	}
/*
// --- unhighlight border
	row.cells[0].style.borderLeftColor=row.className;
	row.cells[row.cells.length-1].style.borderRightColor=row.className;
	for (i=0; i<row.cells.length; i++)
	{
		row.cells[i].style.borderTopColor=row.className;
		row.cells[i].style.borderBottomColor=row.className;
	}
*/
}

// Double Click (!NS4)
function _tDC(cellObj)
{
	var table = getFatherNodeWithId("TABLE", cellObj);
	var cellId = getCellId(table, cellObj);
	var tableSettings = _tableSettings[table.id];
	tableAction(table.id, "Action/"+cellId, tableSettings.formName);
}

function tableAction(tableId, message, formName)
{
	if( window.event ) { // IR 571985:  window.event does not exist for Firefox Mozilla 2.0
		// IR #B0564747: In multi-select mode, do not trigger any Action Commands...
		if (window.event.shiftKey)
		{
			var aElem = (window.event.srcElement ? window.event.srcElement : window.event.target);
			var tdElem = getFatherNode("TD", aElem);

			// Pass the mouse click to the containing table cell...
			tdElem.click();
			window.event.cancelBubble = true;
		}
		else if (!window.event.ctrlKey)
		{
			submitHidden(tableId+"&Action", message, formName);
		}
	}
	else {
		// TODO: Any checks for IR 564747?
		submitHidden(tableId+"&Action", message, formName);
	}

	return false;
}

// Cell Edit (!NS4)
function editCell(cellObj)
{
	if(_editBox)
	{
		// --- another cell was being edited: submit
		if(submitEditBox())
			return;
	}
	// --- open edit box in a popup
	var inputObj= document.createElement( "INPUT" );
	inputObj.className = 'textfield';
//doesn't work with Mozilla	inputObj.value = cellObj.innerText;
	inputObj.style.width = cellObj.offsetWidth;
	//PSC: firstChild might be an icon
//	inputObj.value = cellObj.firstChild.nodeValue;
	inputObj.value = cellObj.lastChild.nodeValue;
	inputObj.onkeypress = processEditCellKey;

//	_editBox = new PopupWindow();
//	var pos = getAbsPos(cellObj);
//	_editBox.move(pos[0], pos[1]);
	var scrollContainer = getScrollContainer(cellObj);
	_editBox = new PopupWindow(scrollContainer);
	_editBox.win.appendChild(inputObj);
	var pos = getAbsPos(cellObj, scrollContainer);
	_editBox.move(pos[0], pos[1]);
	_editBox.cell = cellObj;
	_editBox.closeOnClickOutside("submitEditBox()");
	_editBox.setVisibility(true);
	if(isIECompat)
	{
		inputObj.focus();
// this causes a scroll down on IE		inputObj.select();
		//	inputObj.onfocusout = submitEditBox;
		// --- cancel other event handlers
		window.event.cancelBubble = true;
	}
	else
	{
// this causes a scroll down on Mozilla		inputObj.focus();
		inputObj.select();
	}

	// --- cancel other event handlers
	if(window.event)
		window.event.cancelBubble = true;
}

/**
 * Cell Click (!NS4)
 */
function _tC(evt, cellType)
{
	var cellObj = getFatherNode("TD", evt.srcElement ? evt.srcElement : evt.target);
//alert("Click. Event: "+evt+" target: "+evt.target+" cell: "+cellObj);
	var rowObj = getFatherNode("TR", cellObj);
	var table = getFatherNodeWithId("TABLE", rowObj);
//	var isCtxMenuButton = (window.event.button == 2);
	var isCtxMenuButton = false;

	return cellClick(evt, cellObj, table.id, rowObj.id, getModelColumn(table, cellObj.cellIndex), cellType, isCtxMenuButton);
}

/**
 * Menu (!NS4)
 */
function _tM(evt)
{
	var cellObj = getFatherNode("TD", evt.srcElement ? evt.srcElement : evt.target);
	var rowObj = getFatherNode("TR", cellObj);
	var table = getFatherNodeWithId("TABLE", rowObj);

	cellClick(evt, cellObj, table.id, rowObj.id, getModelColumn(table, cellObj.cellIndex), false, true);
	return false;
}

/**
 * Cell Click (NS4)
 */
function _tNSClick(evt, tableId, rowId, colNb, cellType)
{
	var tableSettings = _tableSettings[tableId];
	var cellId = colNb+"-"+rowId;
	var isCtxMenuButton = (evt.which == 3);

	return cellClick(evt, null, tableId, rowId, colNb, cellType, isCtxMenuButton);
}

function cellClick(evt, cellObj, tableId, rowId, colNb, cellType, isCtxMenuButton)
{
	var tableSettings = _tableSettings[tableId];
	var cellId = colNb+"-"+rowId;

	// --- contextual menu?
	if(isCtxMenuButton && tableSettings.hasCtxMenu)
	{
		// --- update selection
		updateTableSelection(evt, cellObj, tableId, rowId, colNb, true);
		var params = new Array();
		if(tableSettings.mode != NO_SELECTION_MODE)
			params["Selection"] = document.forms[tableSettings.formName].elements[tableId+"&Selection"].value;
		showCtxMenu(null, tableId, cellId, params, evt, tableSettings.formName);
		return;
	}

	// --- update selection
	var updated = updateTableSelection(evt, cellObj, tableId, rowId, colNb, false);
	// do not re-send selection
//	if(tableSettings.submitOnSelect && (updated || (tableSettings.mode == CELL_SELECTION_MODE && (cellType & tCHECK) != 0)))
	if(tableSettings.submitOnSelect && updated)
	{
		sendData(tableSettings.formName);
		return;
	}

	// --- in NO_SELECTION_MODE, Cell Action is triggered at first click
	if(tableSettings.mode == NO_SELECTION_MODE && tableSettings.hasCellAction)
	{
		tableAction(tableId, "Action/"+cellId, tableSettings.formName);
		return;
	}

	// --- edit cell
	if((cellType & tEDITABLE) != 0)
	{
		editCell(cellObj);
		return;
	}
}

/*********************************************************************
 * functions for column filter
 *********************************************************************/
var _filterBox;
function JdgTable_Filter_Show(evt, tableId, columnIdx, curFilterValue, advEditorCommand)
{
	var target = window.event ? event.srcElement : evt.target;
	
	var scrollContainer = getScrollContainer(target);
	_filterBox = new PopupWindow(scrollContainer);
	
	// --- make inner HTML
	var html = "<table border=0 cellspacing)0 cellpadding=0><tr>";
	html += "<td><input id=JdgFilterInput class=textfield onkeypress='JdgTable_ProcFilterKey(event)'></td>";
	html += "<td><img border=0 src='"+JdgTable_Filter_DELETE_URI+"' title='"+JdgTable_Filter_DELETE_ALT+"' onclick='JdgTable_Filter_Delete()'></td>";
	html += "<td><img border=0 src='"+JdgTable_Filter_OK_URI+"' title='"+JdgTable_Filter_OK_ALT+"' onclick='JdgTable_Filter_Submit()'></td>";
	if(advEditorCommand != null)
		html += "<td><img border=0 src='"+JdgTable_Filter_ADV_URI+"' title='"+JdgTable_Filter_ADV_ALT+"' onclick='JdgTable_Filter_Adv()'></td>";
	html += "</tr></table>";
	
	_filterBox.setContent(html);
	
	// --- init
	var inputObj = document.getElementById('JdgFilterInput');
	inputObj.JdgTableId = tableId;
	inputObj.JdgColumn = columnIdx;
	inputObj.JdgAdvEditor = advEditorCommand;
	if(curFilterValue)
		inputObj.value = curFilterValue;
	inputObj.JdgOrigValue = curFilterValue;
	
	// --- move and show
	var pos = getAbsPos(target, scrollContainer);
	_filterBox.move(pos[0]+target.offsetWidth/2, pos[1]+target.offsetHeight/2);
	_filterBox.closeOnClickOutside("JdgTable_Filter_Close()");
	_filterBox.setVisibility(true);
	_filterBox.fitOnScreen(true, false);
	
	// --- grab focus in textfield
	if(isIECompat) {
		inputObj.focus();
// this causes a scroll down on IE		inputObj.select();
	} else {
// this causes a scroll down on Mozilla		inputObj.focus();
		inputObj.select();
	}
}
// --- process key: ENTER or TAB --> Ok, ESCAPE --> Cancel
function JdgTable_ProcFilterKey(evt)
{
	var code = window.event ? window.event.keyCode : evt.which;
	if(code==13 || code==9)// RETURN or TAB
		JdgTable_Filter_Submit();
	else if(code==27)// ESCAPE
		JdgTable_Filter_Close();
}
// --- submits the filter value
function JdgTable_Filter_Submit()
{
	if(!_filterBox)
		return;
	
	var inputObj = document.getElementById('JdgFilterInput');
	if(inputObj == null)
	{
		alert("error: could not find filter input.");
		return;
	}
	// --- close
	JdgTable_Filter_Close();
	
	// --- if value unchanged, skip
	var newval = inputObj.value;
	if(newval.length == 0) newval = null;
	if(newval == inputObj.JdgOrigValue) return false;
	
	// --- submit new filter
	var tableSettings = _tableSettings[inputObj.JdgTableId];
	tableAction(inputObj.JdgTableId, "Filter/"+inputObj.JdgColumn+"/"+inputObj.value, tableSettings.formName);
	return true;
}
function JdgTable_Filter_Adv()
{
	if(!_filterBox)
		return;
	
	var inputObj = document.getElementById('JdgFilterInput');
	if(inputObj == null)
	{
		alert("error: could not find filter input.");
		return;
	}
	// --- close
	JdgTable_Filter_Close();

	// --- table action: show adv filter
	var tableSettings = _tableSettings[inputObj.JdgTableId];
	tableAction(inputObj.JdgTableId, "AdvFilter/"+inputObj.JdgColumn+"/"+inputObj.JdgAdvEditor+"/"+inputObj.value, tableSettings.formName);
	return true;
}
function JdgTable_Filter_Delete()
{
	if(!_filterBox)
		return;
	
	var inputObj = document.getElementById('JdgFilterInput');
	if(inputObj == null)
	{
		alert("error: could not find filter input.");
		return;
	}
	inputObj.value = '';
	// --- grab focus in textfield
	if(isIECompat) {
		inputObj.focus();
// this causes a scroll down on IE		inputObj.select();
	} else {
// this causes a scroll down on Mozilla		inputObj.focus();
		inputObj.select();
	}
}
function JdgTable_Filter_Close()
{
	if(!_filterBox)
		return;
	_filterBox.close();
	_filterBox = null;
}
/*********************************************************************
 * functions for editable cells
 *********************************************************************/
var _editBox;

/**
 * Function triggered at each key pressed in the edit field
 * Returns when Return is pressed
 */
function processEditCellKey(evt)
{
	var code = window.event ? window.event.keyCode : evt.which;
	var inputObj = window.event ? window.event.srcElement : evt.target;
	if(code==13 || code==9)// RETURN or TAB
	{
		submitEditBox();
	}
	else if(code==27)// ESCAPE
	{
		closeEditBox();
	}
}
function submitEditBox()
{
	if(!_editBox)
		return;
	
	var newText = _editBox.win.firstChild.value;
	var cellObj = _editBox.cell;
//		alert("New value: "+newText);
	closeEditBox();
//	if(newText == cellObj.innerText)
//	if(newText == cellObj.firstChild.nodeValue)
	if(newText == cellObj.lastChild.nodeValue)
	{
		// --- value not changed: do nothing
		return false;
	}
	var table = getFatherNodeWithId("TABLE", cellObj);
	var cellId = getCellId(table, cellObj);
	var tableSettings = _tableSettings[table.id];
	tableAction(table.id, "SetCell/"+cellId+":"+newText, tableSettings.formName);
	return true;
}
function closeEditBox()
{
	if(!_editBox)
		return;

	_editBox.close();
	_editBox = null;
}

/*

// Cancels the event
function _tCancel()
{
	window.event.cancelBubble = true;
}

// Focus In Input cell
function _tIFI()
{
	var inputObj = event.srcElement;
	inputObj.className='inputcellfocus'
}
// Focus Out Input cell
function _tIFO()
{
	var inputObj = event.srcElement;
	inputObj.className='inputcell'
}
*/

/*********************************************************************
 * functions for table navigation
 *********************************************************************/
var maxdelay = 250;
var mindelay = 50;
var tresholdincr = 5;
var incrdivider = 20;

var rollSpan;
var rollInitValues;
var rollCurFirstIndex;
var rollStartPosition;
var rollCurPosition;

var dndeffect="move";

function get_i_to_j_of_n_values(txt)
{
	var idx1 = txt.indexOf('-');
	var i1 = parseInt(txt.substr(0, idx1));
	var idx2 = txt.indexOf('/');
	var i2 = parseInt(txt.substr(idx1+1, idx2));
	var n = parseInt(txt.substr(idx2+1));

	return [i1, i2, n];
}

function startRoll()
{
	rollSpan = window.event.srcElement;
	rollInitValues = get_i_to_j_of_n_values(rollSpan.innerHTML);
	rollCurFirstIndex = rollInitValues[0];

	rollStartPosition = window.event.clientX;
	rollIncr = 0;
	window.event.dataTransfer.effectAllowed=dndeffect;
	setTimeout("processRoll()", mindelay);
}
function processRoll()
{
	if(!rollSpan)
		return;

	// --- compute increment
	var rollIncr = Math.round((rollCurPosition - rollStartPosition) / incrdivider);
	// --- compute delay
	var delay = rollIncr >= tresholdincr ? mindelay : maxdelay - Math.abs(rollCurPosition - rollStartPosition) * (maxdelay - mindelay)/(tresholdincr * incrdivider)

	setTimeout("processRoll()", delay);

	if(!rollIncr)
		return;

	rollCurFirstIndex = rollCurFirstIndex + rollIncr;
	var newLastIndex = rollCurFirstIndex + (rollInitValues[1] - rollInitValues[0]);
	if(rollCurFirstIndex < 1)
	{
		newLastIndex = newLastIndex + 1 - rollCurFirstIndex;
		rollCurFirstIndex = 1;
	}
	else if(newLastIndex > rollInitValues[2])
	{
		rollCurFirstIndex = rollCurFirstIndex - newLastIndex + rollInitValues[2];
		newLastIndex = rollInitValues[2];
	}

	rollSpan.innerHTML = rollCurFirstIndex+"-"+newLastIndex+"/"+rollInitValues[2];
}

function endRoll()
{
	var src = rollSpan;
	rollSpan = null;
	if(rollCurFirstIndex != rollInitValues[0])
	{
//alert("go to "+rollCurFirstIndex+" (prev: "+rollInitValues[0]+")");
		var table = getFatherNodeWithId("TABLE", src);
		var tableSettings = _tableSettings[table.id];
		tableAction(table.id, "Go/"+(rollCurFirstIndex-1), tableSettings.formName);
	}
}

function updateRollPos(evt)
{
	var even = window.event ? window.event : evt ;
	rollCurPosition = even.clientX;
}

function acceptDropFromRoll()
{
//alert("drag over BODY");
	// --- cancel default action
	window.event.returnValue=false;
	window.event.dataTransfer.dropEffect=dndeffect;
}

function startRollMoz(evt)
{
	clicked = true;
	//rollSpan = evt.srcElement;
	rollSpan = evt.srcElement ? evt.srcElement : evt.target;
	
	rollInitValues = get_i_to_j_of_n_values(rollSpan.innerHTML);
	rollCurFirstIndex = rollInitValues[0];
	

	rollStartPosition = evt.clientX;
	rollIncr = 0;

	document.onmouseup=endRollMoz;
	//document.onmouseout=endRollMoz;
	document.onmousemove=updateRollPos;
	
	setTimeout("processRoll()", mindelay);
	return false;
}

function endRollMoz()
{
	document.onmousemove=null;
	document.onmouseup=null;
	endRoll();
	clicked = false;
	rollSpan = null;
	
}

} // --- end of js file load
