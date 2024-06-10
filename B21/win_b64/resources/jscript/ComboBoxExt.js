   // +---------------------------------------------------------------------------
   // ! This is Javascript code for a new ComboBox widget / added by SNI (Feb 2006)
   // ! Works with IE (5 & 4), Netscape (4 & 6)
   // +---------------------------------------------------------------------------
   // prereqs:
   //  - CATJDialog.js
   //  - Popupwindow.js

   // --- load js file only once
   if ((typeof LOAD_COMBOBOXEXT_JS) == "undefined")
   {
      LOAD_COMBOBOXEXT_JS = true;

      var CUR_COMBO_FIELD;
      var COMBO_ITEMS_NB = 12;

      var my_htmlname;

      var http ;
      var my_values;
      var _classname;
      var _isTranslated;
      
      /**
       * Function called when combo box is loaded initially
       */
      function initComboExt(formName, comboName, editable, isTranslated, values, selIdx, submitOnSelect, className)
      {

         //TODO: manage UP and DOWN keys?
         var combo = document.forms[formName].elements[comboName];
         my_htmlname = comboName;
         if (!combo)
            return;

         combo.combo_editable = editable;
         combo.combo_items = values;
         combo.combo_translated = isTranslated;
         combo.combo_selidx = selIdx;
         combo.combo_submit = submitOnSelect;
         combo.classname = className ? className : "Combo";
         _classname = combo.classname;

      }
      /**
       * Function called when drop down arrow is selected
       */
      function touchComboExt(evt, formName, inputName)
      {
         var combo = inputName ? document.forms[formName].elements[inputName] : (window.event ? event.srcElement : evt.target);

         if (!combo)
         {
            return;
         }
         // --- if combo already open
         if (CUR_COMBO_FIELD)
         {
            // --- is it the same?
            if (combo == CUR_COMBO_FIELD)
            {
               // --- yes: close
               hideComboExt();
               //return;
            }
            else
            {
               alert('combo ! = CUR_COMBO_FIELD');
               // --- no: clean previous combo and continue
               hideComboExt();
            }
         }
         // --- open combo
         CUR_COMBO_FIELD = combo;
         MenuCommandExt(evt, formName, inputName, CUR_COMBO_FIELD.combo_translated, CUR_COMBO_FIELD.classname, CUR_COMBO_FIELD.combo_items);

      }



      /**
       * Function called when a Menu item has been selected
       */
      function MenuCommandExt(evt, formname, inputname, isTranslated, className, values)
      {

         setWaitingCursor(true);
         var params = new Array();
         params["WidgetPath"] = inputname;
         params["text"] = CUR_COMBO_FIELD.value;

         _isTranslated = isTranslated;

         // Send request to ComboServlet
         var getUrl = comboServletURI;
         var separ = (comboServletURI.indexOf("?") < 0) ? "?" : "&";
         for (var paramName in params)
         {
            getUrl = getUrl + separ + paramName + "=" + encodeURI(params[paramName]);
            if (separ == "?")
               separ = "&";
         }
         my_values = null;

         sendRequest(getUrl);
         setWaitingCursor(false);

      }
      
      /*
       * Create AJAX request
       */
      function createRequestObject()
      {
         var ro;
         var browser = browserClass;
         if (browser == "MSIE")
         {
            ro = new ActiveXObject("Microsoft.XMLHTTP");
         }
         else
         {
            ro = new XMLHttpRequest();
         }
         return ro;
      }
      
      /*
       * Send request to servlet
       */
      function sendRequest(action)
      {
         if ( http == null )
              http = createRequestObject();
         http.open('get', action);
         http.onreadystatechange = handleResponse;
         http.send(null);
      }
      /*
       * Handle response from servlet
       */
      function handleResponse()
      {
         if (http.readyState == 4)
         {
            //var response = http.responseXML;
            //alert("response "+response);
            my_values = new Array();
            
            //my_values = response.split(',');
            var items = http.responseXML.getElementsByTagName("item");
            for (loop = 0; loop < items.length; loop++) 
            {
                 my_values[loop] = items[loop].childNodes[0].nodeValue;
            }
             //alert("my_values "+my_values);
            if (CUR_COMBO_FIELD != null && my_values.length > 1)
            {
	            setWaitingCursor(true);
	            var htmlCode = renderComboItemsExt(_isTranslated, my_values, _classname);
	            CUR_COMBO_FIELD.combo_items = my_values;
	            var scrollContainer = getScrollContainer(CUR_COMBO_FIELD);
	            var comboContainer = getFatherNode("TABLE", CUR_COMBO_FIELD);
	            CUR_COMBO_FIELD.combo_win = new PopupWindow(scrollContainer);
	
	            CUR_COMBO_FIELD.combo_win.setContent(htmlCode);
	            var table = CUR_COMBO_FIELD.combo_win.win.getElementsByTagName("TABLE")[0];
	            var popupWidth = comboContainer.offsetWidth;
	            var popupHeight = CUR_COMBO_FIELD.combo_win.win.offsetHeight;
	            var popupVScroll = false;
	
	            // --- resize drop down list if more items than COMBO_ITEMS_NB
	            var nbItems = CUR_COMBO_FIELD.combo_translated ? (CUR_COMBO_FIELD.combo_items.length / 2) : CUR_COMBO_FIELD.combo_items.length;
	            if (nbItems > COMBO_ITEMS_NB)
	            {
	               var firstHiddenRowPos = getAbsPos(table.rows[COMBO_ITEMS_NB], table);
	               popupHeight = firstHiddenRowPos[1];
	               popupVScroll = true;
	            }
	            // --- place drop down list
	            var comboPos = getAbsPos(comboContainer, scrollContainer);
	            // 1: try under the comboContainer
	            var heightUnder = scrollContainer.scrollTop + scrollContainer.clientHeight - comboContainer.offsetHeight - comboPos[1] - 3;

	            if (heightUnder >= popupHeight)
	            {
	               // enough room under
	               CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] + comboContainer.offsetHeight);
	            }
	            else
	            {
	               // 2: try above
	               var heightAbove = comboPos[1] - scrollContainer.scrollTop - 3;
	               if (heightAbove >= popupHeight)
	               {
	                  // enough room above
	                  CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] - popupHeight);
	               }
	               else
	               {
	                  // 3: display in place with most room and add scrollbars
	                  popupVScroll = true;
	                  if (heightAbove > heightUnder)
	                  {
	                     // place above
	                     popupHeight = heightAbove;
	                     CUR_COMBO_FIELD.combo_win.move(comboPos[0], comboPos[1] - popupHeight);
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
	            if (popupVScroll)
	               CUR_COMBO_FIELD.combo_win.setScrolls(0, 2);
	
	            // --- highlight and scroll to current selection
	            //if(table && (typeof CUR_COMBO_FIELD.combo_selidx != 'undefined') && table.rows[CUR_COMBO_FIELD.combo_selidx])
	            if (table
	               && (typeof CUR_COMBO_FIELD.combo_selidx != 'undefined')
	               && CUR_COMBO_FIELD.combo_selidx >= 0
	               && CUR_COMBO_FIELD.combo_selidx < table.rows.length
	               && table.rows[CUR_COMBO_FIELD.combo_selidx])
	            {
	               highlightComboItemExt(table.rows[CUR_COMBO_FIELD.combo_selidx].cells[0]);
	               CUR_COMBO_FIELD.combo_win.win.scrollTop = table.rows[CUR_COMBO_FIELD.combo_selidx].offsetTop;
	               //    table.cells[CUR_COMBO_FIELD.combo_selidx].scrollIntoView(true);
	            }
	
	            // --- hide combo if click in page
	            CUR_COMBO_FIELD.combo_win.closeOnClickOutside("hideComboExt()");
	
	            // --- show combo popup
	            CUR_COMBO_FIELD.combo_win.setVisibility(true);
	            
	            setWaitingCursor(false);
            }
         }
      }

      function renderComboItemsExt(isTranslated, values, className)
      {

         var htmlCode = "";
         htmlCode = htmlCode + "<TABLE name='COMBOITEMS' CELLSPACING=0 width=100% class=" + className + ">";
         for (var i = 0; i < values.length; i++)
         {
            htmlCode = htmlCode + "<TR>";
            htmlCode = htmlCode + "<TD NOWRAP style='cursor:default' class=" + className;
            htmlCode = htmlCode + " name='COMBOITEM@" + i + "'";
            htmlCode = htmlCode + " onMouseOver=\"highlightComboItemExt(this);\"";
            htmlCode = htmlCode + " onMouseOut=\"unhighlightComboItemExt(this);\"";
            htmlCode = htmlCode + " onMouseDown=\"selectComboItemExt(this)\"";
            htmlCode = htmlCode + " onMouseUp=\"selectComboItemExt(this)\"";
            htmlCode = htmlCode + ">" ;
            if (isTranslated)
               i++;
            if (values[i] == "")
               htmlCode = htmlCode + "&nbsp;";
            else
               htmlCode = htmlCode + encodeAsHTML(values[i], true);
            htmlCode = htmlCode + "</TD></TR>";
         }
         htmlCode = htmlCode + "</TABLE>";
         return htmlCode;
      }
      
      function hideComboExt()
      {

         if (!CUR_COMBO_FIELD)
            return;
         if (CUR_COMBO_FIELD.combo_win)
         {
            CUR_COMBO_FIELD.combo_win.close();
            CUR_COMBO_FIELD.combo_win = null;
         }
         CUR_COMBO_FIELD = null;
      }

      function highlightComboItemExt(cellObj)
      {

         // var cellObj = window.event ? window.event.srcElement : evt.target;
         var rowObj = getFatherNode("TR", cellObj);
         var tableObj = getFatherNode("TABLE", cellObj);
         if (tableObj.highlighted_row)
            tableObj.highlighted_row.cells[0].className = CUR_COMBO_FIELD.classname;
         rowObj.cells[0].className = CUR_COMBO_FIELD.classname + 'H';
         tableObj.highlighted_row = rowObj;
      }
      function unhighlightComboItemExt(cellObj)
      {

         // var cellObj = window.event ? window.event.srcElement : evt.target;
         var rowObj = getFatherNode("TR", cellObj);
         var tableObj = getFatherNode("TABLE", cellObj);
         if (tableObj.highlighted_row)
            tableObj.highlighted_row.cells[0].className = CUR_COMBO_FIELD.classname;
         rowObj.cells[0].className = CUR_COMBO_FIELD.classname;
         tableObj.highlighted_row = rowObj;
      }
      function selectComboItemExt(cellObj)
      {

         // var cellObj = window.event ? window.event.srcElement : evt.target;
         if (!CUR_COMBO_FIELD)
            return;
         var combo = CUR_COMBO_FIELD;
         hideComboExt();
         combo.focus();
         combo.combo_selidx = cellObj.parentNode.rowIndex;
         if (combo.combo_translated)
         {
            combo.value = combo.combo_items[combo.combo_selidx * 2 + 1];
            combo.form.elements[combo.name + "&Tag"].value = combo.combo_items[combo.combo_selidx * 2];
         }
         else
         {
            combo.value = combo.combo_items[combo.combo_selidx];
         }
         if (combo.combo_submit)
            sendData(combo.form.name);
      }

   } //end js
