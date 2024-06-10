// +---------------------------------------------------------------------------
// ! This is Javascript code for Trees management
// ! 
// +---------------------------------------------------------------------------
// prereqs:
//  - CATJDialog.js

// --- load js file only once
if((typeof LOAD_TREE_JS) == "undefined") {
LOAD_TREE_JS = true;

var DEBUG=false;
var PERFO=false;

// --- selects the mode
// it seems that separating the icon from the text label is much faster
var ICON_WITH_LABEL = 0;
var ICON_WITH_ANCHOR = 1;
var ICON_ALONE = 2;

var iconMode = ICON_ALONE;
var labelCellIndex = 2;
var CHILDREN_ID = "_C_";

// --- this array centralizes tables settings
var _treeSettings = new Array();

/*********************************************************************
 * TreeSettings: hold settings relative to a tree widget
 *********************************************************************/
// --- TreeSettings class constructor
function TreeSettings(treeArray, multipleSel, submitOnSelect, hasCtxMenu, pathMode, displayRoot, formName)
{
	this.treeArray = treeArray;
	this.multipleSelection = multipleSel;
	this.submitOnSelect = submitOnSelect;
	this.hasCtxMenu = hasCtxMenu;
	this.pathMode = pathMode;
	this.displayRoot = displayRoot;
	this.formName = formName;
}
// --- Returns tree settings
function getTreeSettings(treeId)
{
	return _treeSettings[treeId];
}
/*********************************************************************
 * General DOM elements search functions
 *********************************************************************/
function getTableById(tableId)
{
	var tables = document.getElementsByTagName("TABLE");
	for(var i=0; i<tables.length; i++)
	{
		if(tables[i].id == tableId)
			return tables[i];
	}
	return null;
}
function findRowWithId(table, id)
{
// no: doesn't work with an id that is only numbers
//	if(isIECompat)
//		return table.rows[id];
//alert("looking for row ["+id+"] in ["+table+" ("+table.id+")] - TR elements: "+table.getElementsByTagName("TR").length);
	for(var i=0; i<table.rows.length; i++)
	{
		if(table.rows[i].id == id)
			return table.rows[i];
	}
	return null;
}
// --- returns the tree node id (keypath or key depending on the tree model)
function JdgTree_getNodeId(rowObj, treeSettings)
{
	if(!treeSettings)
	{
		var treeRoot = getFatherNodeWithId("TABLE", rowObj);
		treeSettings = getTreeSettings(treeRoot.id);
	}

	// --- in non path mode, the node id is node.id
	if(!treeSettings.pathMode)
		return rowObj.id;

	// --- in path mode, the node id is the path to the node
	var path = null;
	while(true)
	{
		if(path)
			path = rowObj.id+"/"+path;
		else
			path = rowObj.id;

		var pTab = getFatherNode("TABLE", rowObj.parentNode);
		if(!pTab || pTab.id)
			break;
		rowObj = getFatherNode("TR", pTab.parentNode).previousSibling;
	}
	if(!treeSettings.displayRoot)
	{
		// --- append root id to the key path
		path = treeSettings.rootID+"/"+path;
	}
	return path;
}
// --- returns the DOM element (TR) representing the node with give ID
function JdgTree_getNodeById(treeRoot, nodeId)
{
	if(!nodeId || nodeId.length == 0)
		return null;
	
	var treeSettings = getTreeSettings(treeRoot.id);

	if(!treeSettings.pathMode)
	{
		// --- in non path mode, the node id is unique (get element by tag)
		var rows = treeRoot.getElementsByTagName("TR");
		for(var j=0; j<rows.length; j++)
		{
			if(rows[j].id && rows[j].id == nodeId)
			{
				return rows[j];
			}
		}
		return null;
	}
	else
	{
		// --- in path mode, the node id is a path to the node
		var arrayOfIDs = nodeId.split("/");
		var curTable = treeRoot;
		var curRow = null;
		var startIdx = treeSettings.displayRoot ? 0 : 1;
		for(var i=startIdx; i<arrayOfIDs.length; i++)
		{
			if(!curTable)
			{
				if(DEBUG) alert("No children table. Node "+nodeId+" not found ("+arrayOfIDs[i]+")!");
				return null;
			}
			curRow = findRowWithId(curTable, arrayOfIDs[i]);
			if(!curRow)
			{
				if(DEBUG) alert("No children row. Node "+nodeId+" not found ("+arrayOfIDs[i]+")!");
				return null;
			}
			var nextRow = curRow.nextSibling;
			if(nextRow && nextRow.id == CHILDREN_ID)
				curTable = nextRow.cells[1].firstChild;
		}
		return curRow;
	}
/*
	for(var i=0; i<treeRoot.rows.length; i++)
	{
		var id = treeRoot.rows[i].id;
		if(!id)
			continue;
		if(id == nodeId)
			return treeRoot.rows[i];
		if(id == CHILDREN_ID)
		{
			// --- search in depth
			var res = JdgTree_getNodeById(treeRoot.rows[i].cells[1].firstChild, nodeId);
			if(res)
				return res;
		}
	}
	return null;
*/
}
/*********************************************************************
 * General functions for the tree array representation
 *********************************************************************/
var JdgTree_LEAF_TYPE = 0;
var JdgTree_COLLAPSED_NODE_TYPE = 1;
var JdgTree_EXPANDED_NODE_TYPE = 2;

var JdgTree_TYPE_IDX = 0;
var JdgTree_ID_IDX = 1;
var JdgTree_LABEL_IDX = 2;
var JdgTree_ICON_IDX = 3;
var JdgTree_CHILDREN_IDX = 4;

function JdgTree_getDataCachingInput(formName, treeId)
{
	return document.forms[formName].elements["Data&"+treeId];
}
function Jdg_SerializeString(str)
{
	var ret = null;
	for(var i=0; i< str.length; i++)
	{
		var c = str.charAt(i);
		switch(c)
		{
			case '\"':
				if(ret == null) ret = str.substr(0, i);
				ret+="\\\"";
				break;
			case '\\':
				if(ret == null) ret = str.substr(0, i);
				ret+="\\\\";
				break;
			case '\n':
				if(ret == null) ret = str.substr(0, i);
				ret+="\\n";
				break;
			case '\t':
				if(ret == null) ret = str.substr(0, i);
				ret+="\\t";
				break;
			default:
				if(ret != null) ret+=c;
				break;
		}
	}
	if(ret) return ret;
	return str;
}
function Jdg_SerializeArray(arr)
{
	var ret = "[";
	for(var i=0; i<arr.length; i++)
	{
		if(i > 0)
			ret += ",";
		if(arr[i] == null)
			ret += "null";
		else
		{
			var type = (typeof arr[i]);
			if(type == "string")
				ret += "\""+Jdg_SerializeString(arr[i])+"\"";
			else if(type == "number" || type == "boolean")
				ret += arr[i];
			else //if(arr[i] instanceof Array)
				ret += Jdg_SerializeArray(arr[i]);
		}
	}
	ret += "]";
	return ret;
}
// --- finds and replaces a node in its array representation
function JdgTree_replaceNodeInArray(treeSettings, keypath, newNodeArray)
{
	var ret = JdgTree_getNodeArray(treeSettings, keypath);
	if(ret == null)
	{
		// --- node not found
alert("Node not found: "+keypath);
		return false;
	}
	if(ret.length == 1)
	{
		// --- this is treeSettings.treeArray
		treeSettings.treeArray = newNodeArray;
		return true;
	}
	// --- general case: a child node
	ret[1][JdgTree_CHILDREN_IDX][ret[2]] = newNodeArray;
	return true;
}
// --- finds and collapses a node in its array representation
function JdgTree_collapseNodeInArray(treeSettings, keypath)
{
	var ret = JdgTree_getNodeArray(treeSettings, keypath);
	if(ret == null)
	{
		// --- node not found
alert("Node not found: "+keypath);
		return false;
	}
//	ret[0][JdgTree_EXPANDED_IDX] = false;
	ret[0][JdgTree_TYPE_IDX] = JdgTree_COLLAPSED_NODE_TYPE;
	ret[0].splice(JdgTree_CHILDREN_IDX, 1);
	return true;
}
// --- Returns [nodeArray, parentNodeArray, index]
function JdgTree_getNodeArray(treeSettings, keypath)
{
	if(!treeSettings.pathMode)
	{
		if(keypath == treeSettings.treeArray[JdgTree_ID_IDX])
			return [treeSettings.treeArray];
		return Jdg_recurFindNodeArray(treeSettings.treeArray, keypath);
	}
	else
	{
		// --- in path mode, the node id is a path to the node
		var arrayOfIDs = keypath.split("/");
		// --- check first node
		if(treeSettings.displayRoot)
		{
			if(treeSettings.treeArray[JdgTree_ID_IDX] != arrayOfIDs[0])
				return null;
			if(arrayOfIDs.length == 1)
			{
				return [treeSettings.treeArray];
			}
		}
		
		var curNodeArray = treeSettings.treeArray;
		for(var i=1; i<arrayOfIDs.length; i++)
		{
			// --- check that cur node array is a node and is expanded
//			if(!curNodeArray[JdgTree_TYPE_IDX] || !curNodeArray[JdgTree_EXPANDED_IDX])
			if(!curNodeArray[JdgTree_TYPE_IDX] == JdgTree_EXPANDED_NODE_TYPE)
				return null;
			var nextArrayIndex = -1;
			for(var j=0; j<curNodeArray[JdgTree_CHILDREN_IDX].length; j++)
			{
				if(curNodeArray[JdgTree_CHILDREN_IDX][j][JdgTree_ID_IDX] == arrayOfIDs[i])
				{
					// --- this is the next node
					nextArrayIndex = j;
					break;
				}
			}
			if(nextArrayIndex < 0)
				return null;
			if(i == arrayOfIDs.length-1)
			{
				// --- this is the final searched
//alert("Path mode - Found: "+Jdg_SerializeArray(treeSettings.treeArray));
				return [curNodeArray[JdgTree_CHILDREN_IDX][nextArrayIndex], curNodeArray, nextArrayIndex];
			}
			curNodeArray = curNodeArray[JdgTree_CHILDREN_IDX][nextArrayIndex];
		}
//alert("Path mode - node not found: "+keypath);
	}
}
// --- Returns [nodeArray, parentNodeArray, index]
function Jdg_recurFindNodeArray(nodeArray, nodeid)
{
//	if(!nodeArray[JdgTree_TYPE_IDX] || !nodeArray[JdgTree_EXPANDED_IDX] || !nodeArray[JdgTree_CHILDREN_IDX])
	if(nodeArray[JdgTree_TYPE_IDX] != JdgTree_EXPANDED_NODE_TYPE)
		return null;
	for(var i=0; i<nodeArray[JdgTree_CHILDREN_IDX].length; i++)
	{
		if(nodeArray[JdgTree_CHILDREN_IDX][i][JdgTree_ID_IDX] == nodeid)
		{
			// --- this is the node
			return [nodeArray[JdgTree_CHILDREN_IDX][i], nodeArray, i];
		}
//		else if(nodeArray[JdgTree_CHILDREN_IDX][i][JdgTree_TYPE_IDX])
		else if(nodeArray[JdgTree_CHILDREN_IDX][i][JdgTree_TYPE_IDX] == JdgTree_EXPANDED_NODE_TYPE)
		{
			// --- node element
			var ret = Jdg_recurFindNodeArray(nodeArray[JdgTree_CHILDREN_IDX][i], nodeid);
			if(ret != null) return ret;
		}
	}
	return null;
}
/*********************************************************************
 * General DOM elements manipulation functions
 *********************************************************************/
/*
 * (re)makes the tree from treeArray structure
 * node: (true, [ID], [label], [icon], [expanded (bool)], [si expanded: children (Array)])
 * leaf: (false, [ID], [label], [icon])
 */
function JdgTree_makeTree(treeArray, treeId, displayRoot, multipleSel, hasCtxMenu, submitOnSelect, pathMode, formName)
{
	if(!treeArray)
		return;
	if(PERFO) perfoInit("Make Tree ["+treeId+"]");
	if(PERFO) perfoStep("Retreive Table");
	var table = getTableById(treeId);
	if(table == null)
	{
		if(DEBUG) alert("Table ["+treeId+"] not found!");
		return;
	}
	
	// --- 1: store TreeSettings
	var hasDataCaching = JdgTree_getDataCachingInput(formName, treeId) != null;
	_treeSettings[treeId] = new TreeSettings(hasDataCaching ? treeArray : null, multipleSel, submitOnSelect, hasCtxMenu, pathMode, displayRoot, formName);
	
	// --- 2: build tree
	var tableBody = table.tBodies[0];
	if(!tableBody)
	{
		// --- Mozilla: a TR obj has to be added to the table 
		// --- object in order to be added to the 'rows' collection
		tableBody = document.createElement("TBODY");
		table.appendChild(tableBody);
	}
	if(displayRoot)
	{
		if(PERFO) perfoStep("Nodes Creation");
		var newNodeArray = JdgTree_createDOM(treeId, treeArray, false, hasCtxMenu, submitOnSelect);
		// --- add rows into table
		if(PERFO) perfoStep("Replacement");
		for(var j=0; j<newNodeArray.length; j++)
//TBODY			(browserClass == IE_BROWSER_CLASS) ? table.tBodies[0].appendChild(newNodeArray[j]) : table.appendChild(newNodeArray[j]);
			tableBody.appendChild(newNodeArray[j]);
	}
	else
	{
		if(pathMode)
		{
			// --- store root ID to build complete key path
			s = getTreeSettings(treeId);
			s.rootID = treeArray[JdgTree_ID_IDX];
		}
		if(PERFO) perfoStep("Nodes Creation and Replacement");
		if(treeArray.length >= 5) // --- root has children
		{
			for(var i=0; i<treeArray[JdgTree_CHILDREN_IDX].length; i++)
			{
				var drawVerticalBar = (i<treeArray[JdgTree_CHILDREN_IDX].length-1);
				var newNodeArray = JdgTree_createDOM(treeId, treeArray[JdgTree_CHILDREN_IDX][i], drawVerticalBar, hasCtxMenu, submitOnSelect);
				for(var j=0; j<newNodeArray.length; j++)
//TBODY					(browserClass == IE_BROWSER_CLASS) ? table.tBodies[0].appendChild(newNodeArray[j]) : table.appendChild(newNodeArray[j]);
					tableBody.appendChild(newNodeArray[j]);
			}
		}
	}
	if(PERFO) perfoResults();

	// --- add rows into table
//	for(var j=0; j<newNodeArray.length; j++)
//TBODY		(browserClass == IE_BROWSER_CLASS) ? table.tBodies[0].appendChild(newNodeArray[j]) : table.appendChild(newNodeArray[j]);
//		tableBody.appendChild(newNodeArray[j]);

	// --- 3: update selection colors
	JdgTree_updateSelectionColors(table, true);
}

/*
 * Refreshes the sub-tree from the node given in treeArray
 * node: (true, [ID], [label], [icon], [expanded (bool)], [si expanded: children (Array)])
 * leaf: (false, [ID], [label], [icon])
 */
function JdgTree_refreshNode(keypath, treeArray, treeId, hasCtxMenu, submitOnSelect, fitToView)
{
	if(DEBUG) alert("JdgTree_refreshNode(keypath: "+keypath+", array: "+treeArray+", tree id: "+treeId+", hasCtxMenu: "+hasCtxMenu+", submitOnSelect: "+submitOnSelect+", fitToView: "+fitToView+")");
	var nodeId = keypath;
	if(PERFO) perfoInit("Refresh Node ["+nodeId+"/"+treeId+"]");
	if(PERFO) perfoStep("Retreive Cell");
	var treeRoot = getTableById(treeId);
	if(treeRoot == null)
	{
		if(DEBUG) alert("Table ["+treeId+"] not found!");
		return;
	}
	var treeSettings = getTreeSettings(treeRoot.id);
	var rowNode = null;
	if(treeSettings.curRow && treeSettings.curRow.id == nodeId)
	{
		rowNode = treeSettings.curRow;
		treeSettings.curRow = null;
	}
	else
	{
		// --- TODO: look for all nodes with same Id
		rowNode = JdgTree_getNodeById(treeRoot, nodeId);
	}
	
	if(rowNode == null)
	{
		if(DEBUG) alert("Tree Node ["+treeArray[JdgTree_ID_IDX]+"/"+treeId+"] not found!");
		return;
	}
	
	// --- update DataCaching
	var dataCachingInput = JdgTree_getDataCachingInput(treeSettings.formName, treeId);
	if(treeSettings.treeArray && dataCachingInput)
	{
		JdgTree_replaceNodeInArray(treeSettings, keypath, treeArray);
		dataCachingInput.value = Jdg_SerializeArray(treeSettings.treeArray);
	}
	
	// --- vertical bar is not drawn for last row node
	if(PERFO) perfoStep("Draw Vertical Bar");
	var drawVerticalBar = false;
	if(rowNode.nextSibling)
	{
		if(rowNode.nextSibling.id && rowNode.nextSibling.id == CHILDREN_ID)
		{
			// --- next row is children: skip to next row
			if(rowNode.nextSibling.nextSibling)
				drawVerticalBar = true;
		}
		else
			drawVerticalBar = true;
	}

	// --- make sub-table
	if(PERFO) perfoStep("Node Creation");

	var newNodeArray = JdgTree_createDOM(treeId, treeArray, drawVerticalBar, hasCtxMenu, submitOnSelect);

	// --- add children node
	if(newNodeArray.length == 2)
	{
		// --- replace or add children row
		if(rowNode.nextSibling && rowNode.nextSibling.id && rowNode.nextSibling.id == CHILDREN_ID)
		{
			// --- replace children row
			if(PERFO) perfoStep("Children Node Replacement");
//!NS6			rowNode.nextSibling.replaceNode(newNodeArray[1]);
			rowNode.parentNode.replaceChild(newNodeArray[1], rowNode.nextSibling);
			
		}
		else
		{
			// --- append children row right after rowNode
			if(PERFO) perfoStep("Children Node Insertion");
//!NS6			rowNode.insertAdjacentElement("AfterEnd", newNodeArray[1]);
			if(rowNode.nextSibling)
				rowNode.parentNode.insertBefore(newNodeArray[1], rowNode.nextSibling);
			else
				rowNode.parentNode.appendChild(newNodeArray[1]);
		}
	}
	else
	{
		//--- remove children row if any
		if(rowNode.nextSibling && rowNode.nextSibling.id && rowNode.nextSibling.id == CHILDREN_ID)
		{
			if(PERFO) perfoStep("Children Node Removal");
//!NS6			rowNode.nextSibling.removeNode(true);
			rowNode.parentNode.removeChild(rowNode.nextSibling);
		}
	}

	if(PERFO) perfoStep("Node Replacement");
	// --- refresh node
//!NS6	rowNode.replaceNode(newNodeArray[0]);
	rowNode.parentNode.replaceChild(newNodeArray[0], rowNode);

	rowNode = null;

	if(newNodeArray.length == 2 && fitToView)
	{
		// --- fit node and children into view
		if(PERFO) perfoStep("Get Container Table");

		// --- compute offset from root TABLE (ID != "")
		var container = getScrollContainer(newNodeArray[0]);
		var absPosition = getAbsPos(newNodeArray[0], container);
		var top = absPosition[1];
		var bottom = absPosition[1] + newNodeArray[0].offsetHeight+ newNodeArray[1].offsetHeight;

/*
		if(DEBUG)
		{
			// --- position
			var msg = "Position:"
			//	+"\nRoot Table: "+rootTab.nodeName+"(ID: "+rootTab.id+")"
				+"\nContainer: "+container.nodeName+"(ID: "+container.id+", Class: "+container.className+")"
				+"\nNode offsetTop: "+newNodeArray[0].offsetTop
				+"\nNode offsetHeight: "+newNodeArray[0].offsetHeight
			//	+"\nOffset From Root: "+offset
				+"\nTop: "+top
				+"\nBottom: "+bottom
			//	+"\nabs Top: "+absPosition[1]
				+"\nContainer scrollTop: "+container.scrollTop
				+"\nContainer offsetHeight: "+container.offsetHeight
				+"\nContainer scrollHeight: "+container.scrollHeight
				+"\nContainer clip: "+container.clip
				+"\nContainer pageYOffset: "+container.pageYOffset
				+"\nContainer scroll: "+container.scroll
				+"\nContainer scrollTo: "+container.scrollTo;
			
			// --- scroll offset
			msg = msg + "\nScroll offset:"
			var obj = newNodeArray[0];
			while(true)
			{
				msg = msg + "\n "+obj.nodeName+" ("+obj.id+"): offsetTop="+obj.offsetTop+", scrollTop="+obj.scrollTop;
				obj = obj.parentNode;
				if(!obj) break;
			}
			alert(msg);
		}
*/
		// --- tree in any page: scroll provided by a DIV
		if(PERFO) perfoStep("Fit To View");
		if(top  + newNodeArray[0].offsetHeight < container.scrollTop || top > container.scrollTop + container.offsetHeight)
		{
			// --- node is out of view: scroll to node
				container.scrollTop = top;
		}
		else if(bottom > container.scrollTop + container.offsetHeight)
		{
			// --- last leaf is out of view: adjust
			if(bottom - top <= container.offsetHeight)
			{
				// --- node and children can fit into view:
				// --- align bottom to view
//					newNodeArray[1].scrollIntoView(false);
				container.scrollTop = bottom - container.offsetHeight + 1;
			}
			else
			{
				// --- node and children cannot fit into view:
				// --- align top to view
//					newNodeArray[0].scrollIntoView(true);
				container.scrollTop = top;
			}
		}
	}

	// --- 3: update selection colors
	if(PERFO) perfoStep("Update Colors");
	JdgTree_updateSelectionColors(treeRoot, true);

	if(PERFO) perfoResults();
}

/*
 * Creates the HTML structure for rendering tree given in treeArray
 * Returns an array:
 *  - first element is the TR object for the node
 *  - second element is the TR object for children (if any)
 * node: (true, [ID], [label], [icon], [expanded (bool)], [si expanded: children (Array)])
 * leaf: (false, [ID], [label], [icon])
 */
function JdgTree_createDOM(treeId, treeArray, vBar, hasCtxMenu, submitOnSelect)
{
	// --- make row
  	var nodeRow= document.createElement("TR");
	nodeRow.id=treeArray[JdgTree_ID_IDX];

	// --- Anchor Cell
	var nodeAnchorCell= document.createElement("TD");
//NS6?	nodeAnchorCell.className = vBar ? "TreeV" : "Tree";
	nodeAnchorCell.className = "Tree";
  	if(iconMode == ICON_WITH_ANCHOR)
		nodeAnchorCell.noWrap=true;
	nodeRow.appendChild( nodeAnchorCell );

  	// --- Icon Cell
  	var iconCell = null;
  	if(iconMode == ICON_ALONE)
  	{
		iconCell= document.createElement("TD");
iconCell.unselectable='on';
		iconCell.className='TreeNode';
		iconCell.onmouseover = JdgTree_highlightNode;
		iconCell.onmouseout = JdgTree_unhighlightNode;
	  	if(hasCtxMenu)
			iconCell.oncontextmenu = JdgTree_ctxMenu;
		iconCell.onclick = submitOnSelect ? JdgTree_selectAndSubmit : JdgTree_select;
		nodeRow.appendChild( iconCell );
	}

  	// --- Label Cell
	var nodeLabelCell= document.createElement("TD");
nodeLabelCell.unselectable='on';
	nodeLabelCell.className='TreeNode';
  	nodeLabelCell.name = "_CELL&"+treeArray[JdgTree_ID_IDX];
	nodeLabelCell.onmouseover = JdgTree_highlightNode;
	nodeLabelCell.onmouseout = JdgTree_unhighlightNode;
  	if(hasCtxMenu)
		nodeLabelCell.oncontextmenu = JdgTree_ctxMenu;
	nodeLabelCell.onclick = submitOnSelect ? JdgTree_selectAndSubmit : JdgTree_select;
	nodeLabelCell.noWrap=true;
	nodeLabelCell.width = "100%";
	nodeRow.appendChild( nodeLabelCell );
	
	// --- compute type code
	var typeCode;
//	if(treeArray[JdgTree_TYPE_IDX])
	if(treeArray[JdgTree_TYPE_IDX] != JdgTree_LEAF_TYPE)
	{
		// --- folder
		// --- first char: 'T' or 'L' depending on vBar
		// --- second char: 'M' or 'P' depending if the folder is expanded or not
//		typeCode = (vBar ? "T" : "L") + (treeArray[JdgTree_EXPANDED_IDX] ? "M" : "P");
		typeCode = (vBar ? "T" : "L") + (treeArray[JdgTree_TYPE_IDX] == JdgTree_EXPANDED_NODE_TYPE ? "M" : "P");
	}
	else
	{
		// --- file
		typeCode = (vBar ? "T" : "L");
	}
	
	// --- Anchor Image
	var anchorImg = document.createElement("IMG");
//	var anchorImg = new Image();
  	anchorImg.src = treeIconRoot+'Tree_'+typeCode+'.gif';
  	// for WinRunner to identify the anchor
  	anchorImg.name = "_ANCHOR&"+treeArray[JdgTree_ID_IDX];
//?  	anchorImg.className="Tree_"+(treeArray[JdgTree_EXPANDED_IDX] ? "T" : "L");
  	// --- register to collapse / expand events
//  	if(treeArray[JdgTree_TYPE_IDX])
//  		anchorImg.onclick = treeArray[JdgTree_EXPANDED_IDX] ? JdgTree_collapse : JdgTree_expand;
  	if(treeArray[JdgTree_TYPE_IDX] != JdgTree_LEAF_TYPE)
  		anchorImg.onclick = treeArray[JdgTree_TYPE_IDX] == JdgTree_EXPANDED_NODE_TYPE ? JdgTree_collapse : JdgTree_expand;
	
	nodeAnchorCell.appendChild( anchorImg );

  	// --- Icon
	if(treeArray[JdgTree_ICON_IDX] != null)
	{
		var iconImg= document.createElement("IMG");// equiv. to new Image();
//		iconImg.src=imagesRoot+treeArray[JdgTree_ICON_IDX]+".gif";
		if( treeArray[JdgTree_ICON_IDX].indexOf("/") == 0 || treeArray[JdgTree_ICON_IDX].indexOf("http") == 0 )
			iconImg.src = treeArray[JdgTree_ICON_IDX];
		else
			iconImg.src=imagesRoot+treeArray[JdgTree_ICON_IDX];
//		iconImg.align='middle';
	  	// for WinRunner to identify the anchor
	  	iconImg.name = "_ICON&"+treeArray[JdgTree_ID_IDX];
		
		if(iconMode == ICON_ALONE)
			iconCell.appendChild( iconImg );
		else if(iconMode == ICON_WITH_ANCHOR)
			nodeAnchorCell.appendChild( iconImg );
//		else // ICON_WITH_LABEL
//			nodeLabelCell.appendChild( iconImg );
	}

	// --- Label
	var labelArea = document.createElement("SPAN");
  	// for WinRunner to identify the anchor
  	labelArea.name = "_LABEL&"+treeArray[JdgTree_ID_IDX];
	labelArea.unselectable='on';
	labelArea.className = "Tree";
	if(iconMode == ICON_WITH_LABEL)
	{
		labelArea.appendChild(iconImg);
		labelArea.innerHTML += ' '+treeArray[JdgTree_LABEL_IDX];
	}
	else
		labelArea.innerHTML = treeArray[JdgTree_LABEL_IDX];

	nodeLabelCell.appendChild(labelArea);

	// --- make children if any
	var childrenRow = null;
//	if(treeArray[JdgTree_TYPE_IDX])
	if(treeArray[JdgTree_TYPE_IDX] != JdgTree_LEAF_TYPE)
	{
//		if(treeArray[JdgTree_EXPANDED_IDX] && treeArray[JdgTree_CHILDREN_IDX].length > 0)
		if(treeArray[JdgTree_TYPE_IDX] == JdgTree_EXPANDED_NODE_TYPE && treeArray[JdgTree_CHILDREN_IDX].length > 0)
		{
			childrenRow = document.createElement("TR");
			childrenRow.id = CHILDREN_ID;

			var vBarCell = document.createElement("TD");
			childrenRow.appendChild( vBarCell );

			// --- draw vertical bar (doesn't work on NS6)
			if(vBar)
			{
				// --- 1st solution: set cell class with background
				vBarCell.className = "TreeV";

				// --- 2nd solution: set background on cell
				// it looks like Netscape needs a space char into the cell
				vBarCell.innerText = " ";
//COLOR				vBarCell.background = treeIconRoot+'Tree_V.gif';

/*
				// --- 3rd solution: put an image (height=100%) in the cell - DHTML
				var vBarImg = document.createElement( "IMG" );
				//var vBarImg = new Image();
//				vBarImg.height = "100%";
				vBarImg.style.height = "100%";
				vBarImg.src = treeIconRoot+'Tree_V.gif';
				vBarCell.appendChild(vBarImg);
//				vBarCell.width = "16";
//				vBarCell.height = "100%";
				vBarCell.style.height = "100%";

				// --- 4th solution: put an image (height=100%) in the cell - HTML
				//vBarCell.height = "100%";
				//vBarCell.innerHTML = "<IMG width='100%' height='100%' src='"+treeIconRoot+'Tree_V.gif'+"'>";
*/			}
			
			var childrenCell = document.createElement("TD");
			if(iconMode == ICON_ALONE)
				childrenCell.colSpan = 2;
			childrenRow.appendChild( childrenCell );
			
			var childrenTable = document.createElement("TABLE");
			childrenTable.className = "Tree";
			childrenTable.cellSpacing = 0;
			childrenTable.cellPadding = 0;
			childrenCell.appendChild( childrenTable );

			var childrenBody = document.createElement("TBODY");
			childrenTable.appendChild( childrenBody );

			for(var i=0; i<treeArray[JdgTree_CHILDREN_IDX].length; i++)
			{
				// --- do not draw vertical bar for last child
				var vBarForChild = (i < treeArray[JdgTree_CHILDREN_IDX].length - 1);
				var childNodeArray = JdgTree_createDOM(treeId, treeArray[JdgTree_CHILDREN_IDX][i], vBarForChild, hasCtxMenu, submitOnSelect);
				
				for(var j=0; j<childNodeArray.length; j++)
					childrenBody.appendChild(childNodeArray[j]);
			}
		}
	}
	
	if(childrenRow)
		return [nodeRow, childrenRow];
	else
		return [nodeRow];
}
// --- sends a message to the tree servlet
function JdgTree_sendMessage(treeID, params, treeSettings)
{
//alert("JdgTree_sendMessage("+treeID+", "+cellID+", "+msg+")");
	setWaitingCursor(true);
	if(!treeSettings)
		treeSettings = getTreeSettings(treeID);
//HTML_REDSEIGN	params["ID"] = document.forms[treeSettings.formName].name;
	params[JDG_FRAMEID_NAME] = jdgGetFrameID(treeSettings.formName);
	params[JDG_FORMNAME_NAME] = treeSettings.formName;
	params["Root"] = treeID;
//HTML_REDSEIGN	params["ParentWindow"] = window.name;
	executeRequest(treeServletURI, params);
}
/*********************************************************************
 * Event handler functions
 *********************************************************************/
// --- collapse handler function
function JdgTree_collapse(evt)
{
	var srcObj = window.event ? event.srcElement : evt.target;
	var srcNode = getFatherNodeWithId("TR", srcObj);
	var treeRoot = getFatherNodeWithId("TABLE", srcNode);
	var treeSettings = getTreeSettings(treeRoot.id);
	treeSettings.curRow = srcNode;
	var anchorCell = srcNode.cells[0];
	var anchorImg = anchorCell.firstChild;
	var nodeid = JdgTree_getNodeId(srcNode, treeSettings);
	
	// --- unset collapse handler
	anchorImg.onclick = "";
	
	var params = new Array();
	params["Action"] = "Collapse";
	params["Node"] = nodeid;

	// --- if collapsed node has children
	if(srcNode.nextSibling && srcNode.nextSibling.id && srcNode.nextSibling.id == CHILDREN_ID)
	{
		// --- update selection (unselect collapsed children nodes)
		var updated = JdgTree_removeNodeFromSelection(treeRoot, srcNode);
//		var selArg = updated ? "&Sel="+JdgTree_getSelection(treeRoot) : "";
		if(updated)
			params["Sel"] = JdgTree_getSelection(treeRoot);
		
		// --- destroy children nodes
		srcNode.parentNode.removeChild(srcNode.nextSibling);
	}
	
	// --- send message
	JdgTree_sendMessage(treeRoot.id, params, treeSettings);
	
	// --- change image and handler
	anchorImg.onclick = JdgTree_expand;
	var dotIdx = anchorImg.src.lastIndexOf(".");
	var newIcon = anchorImg.src.substr(0, dotIdx-1)+"P"+anchorImg.src.substr(dotIdx);
	anchorImg.src = newIcon;

	// --- update DataCaching
	var dataCachingInput = JdgTree_getDataCachingInput(treeSettings.formName, treeRoot.id);
	if(treeSettings.treeArray && dataCachingInput)
	{
		JdgTree_collapseNodeInArray(treeSettings, nodeid);
		dataCachingInput.value = Jdg_SerializeArray(treeSettings.treeArray);
	}
}
// --- expand handler function
function JdgTree_expand(evt)
{
	var srcObj = window.event ? event.srcElement : evt.target;
	var srcNode = getFatherNodeWithId("TR", srcObj);
	var treeRoot = getFatherNodeWithId("TABLE", srcNode);
	var treeSettings = getTreeSettings(treeRoot.id);
	treeSettings.curRow = srcNode;
	var anchorCell = srcNode.cells[0];
	var anchorImg = anchorCell.firstChild;

	// --- unset expand handler
	anchorImg.onclick = "";
	if(isIECompat) event.cancelBubble= true;
	
	// --- change anchor icon
//	anchorImg.src= treeIconRoot+anchorImg.className+"W.gif";
	anchorImg.title= "Expanding..."; // --- tooltip on image
	
	var params = new Array();
	params["Action"] = "Expand";
	params["Node"] = JdgTree_getNodeId(srcNode, treeSettings);

	JdgTree_sendMessage(treeRoot.id, params, treeSettings);
	return false;
}
// --- contextual menu handler function
function JdgTree_ctxMenu(evt)
{
	var srcObj = window.event ? event.srcElement : evt.target;
	var srcNode = getFatherNodeWithId("TR", srcObj);
	var treeRoot = getFatherNodeWithId("TABLE", srcNode);
	var treeSettings = getTreeSettings(treeRoot.id);
	JdgTree_select(evt , srcNode, treeRoot, true);
	var params = new Array();
	params["Selection"] = JdgTree_getSelection(treeRoot);
	showCtxMenu(null, treeRoot.id, JdgTree_getNodeId(srcNode, treeSettings), params, evt, treeSettings.formName);
	return false;
}
// --- node selection handler function
function JdgTree_selectAndSubmit(evt)
{
	var srcObj = window.event ? event.srcElement : evt.target;
	var srcNode = getFatherNodeWithId("TR", srcObj);
	var treeRoot = getFatherNodeWithId("TABLE", srcNode);
	if(JdgTree_select(evt, srcNode, treeRoot))
	{
		var params = new Array();
		params["Action"] = "Select";
		params["Sel"] = JdgTree_getSelection(treeRoot);
		JdgTree_sendMessage(treeRoot.id, params);
	}
}
// --- Selects the node and returns whether selection has changed or not
// --- it can be used as an handler
function JdgTree_select(evt, node, treeRoot, ctxMenuEvent)
{
	if(!evt)
		evt = window.event;
	if(!node)
	{
		var srcObj = window.event ? event.srcElement : evt.target;
		node = getFatherNodeWithId("TR", srcObj);
	}
	if(!treeRoot)
		treeRoot = getFatherNodeWithId("TABLE", node);
	
	var treeSettings = getTreeSettings(treeRoot.id);
	var currentSelection = document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value;
	var nodeId = JdgTree_getNodeId(node, treeSettings);

	if(!treeSettings.multipleSelection)
	{
		// --- single selection
		if(currentSelection == nodeId)
			return false;
		if(currentSelection && currentSelection.length > 0)
		{
			var curSelNode = JdgTree_getNodeById(treeRoot, currentSelection);
			if(curSelNode)
				JdgTree_updateNodeColor(curSelNode, false);
		}
		JdgTree_updateNodeColor(node, true);
		document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value = nodeId;
		return true;
	}
	
	// --- multiple selection
	var arrayOfSelectedIDs = currentSelection.split(";");
	var nodeIndex = indexOfElt(arrayOfSelectedIDs, nodeId);
	
	// --- on contextual menu, if node is already selected, do not change selection
	if(ctxMenuEvent && nodeIndex >= 0)
		return false;

	// --- update selection
	//alert(Node found at : "+nodeIndex);
	if(evt.ctrlKey)
	{
		if(nodeIndex >= 0)
		{
			// --- remove from selection
			JdgTree_updateNodeColor(node, false);
			arrayOfSelectedIDs.splice(nodeIndex, 1);
		}
		else
		{
			// --- add to selection
			JdgTree_updateNodeColor(node, true);
			arrayOfSelectedIDs.push(nodeId);
		}
		
		// --- update last selected ID
		treeSettings.lastShiftId = nodeId;
	}
	else if(evt.shiftKey && treeSettings.lastShiftId != null)
	{
		// --- update selection (however the row was sel or unsel)
		// --- find row indexes
		arrayOfSelectedIDs = new Array();
		var select = false;
		var rows = treeRoot.getElementsByTagName("TR");
		for(var i=0; i<rows.length; i++)
		{
			if(rows[i].id && rows[i].id != CHILDREN_ID)
			{
				var selected = select;
				var rowId = JdgTree_getNodeId(rows[i], treeSettings);
				if(rowId == treeSettings.lastShiftId || rowId == nodeId)
				{
					// --- cell is one of the 2 bounds
					selected = true;
					select = !select;
				}
				JdgTree_updateNodeColor(rows[i], selected);
				if(selected)
					arrayOfSelectedIDs.push(rowId);
			}
		}

		// --- update last selected ID
//		treeSettings.lastShiftId = nodeId;
	}
	else // single click
	{
		// --- if already selected and single selection, do not change selection
		if(nodeIndex >= 0 && arrayOfSelectedIDs.length == 1)
			return false;
		
		// --- unselect every other item
		for(var i=0; i<arrayOfSelectedIDs.length; i++)
		{
			if(i == nodeIndex)
				continue;
			var n = JdgTree_getNodeById(treeRoot, arrayOfSelectedIDs[i]);
			if(n) JdgTree_updateNodeColor(n, false);
		}

		// --- select cur item
		arrayOfSelectedIDs = [nodeId];
		JdgTree_updateNodeColor(node, true);

		// --- update last selected ID
		treeSettings.lastShiftId = nodeId;
	}
	
	// --- update lines colors
/*
	if(needUpdate)
	{
		for(var i=0; i<table.rows.length; i++)
		{
			if(table.rows[i].id && table.rows[i].id != null)
			{
				var selected = (indexOfElt(arrayOfSelectedIDs, table.rows[i].id) >= 0);
				updateRowColor(table.rows[i], selected);
			}
		}
	}
*/
	// --- is submit required?
	var newSelection = arrayOfSelectedIDs.join(";");
	document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value = newSelection;
	
	// selection has changed
	return true;
}
/*********************************************************************
 * Color highlighting / selection
 *********************************************************************/
function JdgTree_updateNodeColor(node, selected)
{
//COLOR	node.cells[labelCellIndex].firstChild.style.backgroundColor = selected ?treeSelectedBackground : treeNormalBackground;
	node.cells[labelCellIndex].firstChild.style.backgroundColor = selected ? treeSelectedBackground : "transparent";
}
function JdgTree_highlightNode(evt)
{
	var srcObj = window.event ? event.srcElement : evt.target;
	var row = getFatherNode("TR", srcObj);
	// --- highlight the label area
//	row.cells[labelCellIndex].firstChild.style.borderColor = treeSelectedBackground;
	row.cells[labelCellIndex].firstChild.style.textDecoration = "underline";
}
function JdgTree_unhighlightNode(evt)
{
	var srcObj = window.event ? event.srcElement : evt.target;
	var row = getFatherNode("TR", srcObj);
	// --- unhighlight the label area
//	row.cells[labelCellIndex].firstChild.style.borderColor = treeNormalBackground;
	row.cells[labelCellIndex].firstChild.style.textDecoration = "none";
}
function JdgTree_updateSelectionColors(treeRoot, selectFlag)
{
	var firstNode = null;
	var treeSettings = getTreeSettings(treeRoot.id);
	var currentSelection = document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value;

//alert("selection: "+currentSelection);
	var arrayOfSelectedIDs = currentSelection.split(";");
	for(var i=0; i<arrayOfSelectedIDs.length; i++)
	{
		if(arrayOfSelectedIDs[i] == null || arrayOfSelectedIDs[i].length == 0)
			continue;
		
//perfoStep("JdgTree_getNodeById('"+arrayOfSelectedIDs[i]+"')");
		var rowNode = JdgTree_getNodeById(treeRoot, arrayOfSelectedIDs[i]);
		if(rowNode != null)
		{
//alert(" -> node ["+arrayOfSelectedIDs[i]+"]: "+rowNode.id);
			if(firstNode == null)
				firstNode = rowNode;
//perfoStep("JdgTree_updateNodeColor('"+arrayOfSelectedIDs[i]+"')");
			JdgTree_updateNodeColor(rowNode, selectFlag);
		}
	}
	return firstNode;
}

/*********************************************************************
 * Selection management functions
 *********************************************************************/
function JdgTree_getSelection(treeRoot)
{
	var treeSettings = getTreeSettings(treeRoot.id);
	return document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value;
}

function JdgTree_removeNodeFromSelection(treeRoot, srcNode)
{
	var updated = false;
	var treeSettings = getTreeSettings(treeRoot.id);
	var currentSelection = document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value;
	var arrayOfSelectedIDs = currentSelection.split(";");

	if(treeSettings.pathMode)
	{
		// --- in path mode, remove all keypaths starting with [srcNode keypath]+'/'
		var nodeKeyPath = JdgTree_getNodeId(srcNode, treeSettings)+'/';
		var i=0;
		while(i<arrayOfSelectedIDs.length)
		{
//			if(arrayOfSelectedIDs[i].startsWith(nodeKeyPath))
			if(startsWith(arrayOfSelectedIDs[i], nodeKeyPath))
			{
				arrayOfSelectedIDs.splice(i, 1);
				updated = true;
			}
			else
			{
				// --- next
				i++;
			}
		}
	}
	else
	{
		// --- in non path mode, we have to go through the children and check ID by ID
		var childrenRow = srcNode.nextSibling;
		if(childrenRow && childrenRow.id == CHILDREN_ID)
		{
			var childrenTab = childrenRow.cells[1].firstChild;
			var rows = childrenTab.getElementsByTagName("TR");
			for(var j=0; j<rows.length; j++)
			{
				if(rows[j].id == CHILDREN_ID)
					continue;
				var rowID = rows[j].id; // JdgTree_getNodeId(srcNode, treeSettings)
				var rowIdx = indexOfElt(arrayOfSelectedIDs, rowID);
				if( rowIdx >= 0)
				{
					arrayOfSelectedIDs.splice(rowIdx, 1);
					updated = true;
				}
			}
		}
	}

	// --- update if need be
	if(updated)
	{
		var newSel = arrayOfSelectedIDs.join(";");
		document.forms[treeSettings.formName].elements[treeRoot.id+"&Selection"].value = newSel;
	}
	
	return updated;
}

/**
 * updates tree selection
 * @param scroll: boolean (scroll to selected node or not)
 */
function JdgTree_setSelection(formName, treeId, newSelection, scroll)
{
	var treeRoot = getTableById(treeId);

	// --- first unselect all nodes
	JdgTree_updateSelectionColors(treeRoot, false);
	
	// --- update selection input
	document.forms[formName].elements[treeRoot.id+"&Selection"].value = newSelection;

	// --- then select all new nodes
	var firstNode = JdgTree_updateSelectionColors(treeRoot, true);
	
	// --- scroll to first selected node
	if(scroll && firstNode)
	{
		firstNode.scrollIntoView(true);
		// --- now update parent scroll position (FRAME or DIV)
		var div = getFatherNodeWithId("DIV", firstNode);
		if(div != null)
			updateDivScrollPos(div, formName);
		else
			storeWinScrollPos(formName);
	}
}

/*********************************************************************
 * Perfo Functions
 *********************************************************************/
var perfoActive = true;
var perfoTimes = null;
var perfoName = null;
var lastStep = null;
var lastDate = null;

function perfoInit(title)
{
	if(!perfoActive) return;

	perfoName = title;
	perfoTimes = new Array();
}

function perfoStep(name)
{
	if(!perfoActive || perfoTimes == null) return;
	
	var now = new Date();

	// --- 1: stop previous step
	if(lastStep != null)
	{
		var nbAndTime = perfoTimes[lastStep];
		if(nbAndTime)
		{
			nbAndTime[0]++;
			nbAndTime[1] += (now - lastDate);
		}
		else
			perfoTimes[lastStep] = [1, (now - lastDate)];
	}
	
	// --- 2: start  new step
	lastStep = name;
	lastDate = now;
}

function perfoResults()
{
	if(!perfoActive | perfoTimes == null) return;
	
	perfoStep();
	var total = 0;
	var text = "Timings (in ms) for: "+perfoName;
	for(var key in perfoTimes)
	{
		var nbAndTime = perfoTimes[key];
		text = text+"\n - "+key+" ("+nbAndTime[0]+"): "+nbAndTime[1];
		total+=nbAndTime[1];
	}
	text = text+"\n\nTOTAL time: "+total;
	perfoTimes = null;
	alert(text);
}

} // --- end of js file load
