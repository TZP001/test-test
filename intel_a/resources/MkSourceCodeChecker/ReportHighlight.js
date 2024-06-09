// Global variables declaration

// Browser Infos
// ------
var _FirefoxAppName = "Netscape";
var _IEAppName = "Microsoft Internet Explorer";
var _detectedBrowserName = "";

// Source Code Text area
// ------
var _srcCodeTextArea;
var _srcCodeFrame;   // containing source code text area
var _moveUserMouse = false;
var _fRatioHeight = 0.95;
var _fRatioWidth = 0.95;
var _isrcCodeScrollConfort = 3;

// Lines text area
// ------
var _linesTextArea;
var _iLinesTextWidth = 50;
var _iLinesTextLeftMargin = 15;
var _linePattern = /.*(\r\n|\r|\n)/g; // regular expression with EOL, as global search

// Both
// ------
var _iLineHeight = 15;

// Word Search
// ------
var _iMaxWordLineScope = 3;

// Create lines text area element and set it.
// Set source code text area
// Positionning of both text area
// Set of mouse events
// ------
function createAndSetTextAreas(myId) {
    // Set textarea elements
    _linesTextArea = document.createElement('TEXTAREA');
    _srcCodeTextArea = document.getElementById(myId);

    // Get source code content           
    var srcCodeText = _srcCodeTextArea.value;

    if (srcCodeText) {
        // Get total lines number
        var iLineNumber = countLines(srcCodeText);

        // Create line numbering string
        var string = '';
        for (var no = 1; no <= (iLineNumber + 1); no++) {
            if (string.length > 0) string += '\n';
            string += no;
        }

        // Get height of the frame containing the source code and prevent from scolling vertically
        _srcCodeFrame = parent.document.getElementsByName('sourceFile')[0];
        _srcCodeFrame.style.overflowY = 'hidden';

        // Set source code text area height & width considering frame container
        _srcCodeTextArea.style.height = (_srcCodeFrame.scrollHeight * _fRatioHeight) + "px";
        _srcCodeTextArea.style.width = (_srcCodeFrame.scrollWidth * _fRatioWidth) + "px";

        // Set lines textarea object
        _linesTextArea.className = 'textAreaWithLines';
        _linesTextArea.style.height = (_srcCodeTextArea.offsetHeight) + "px";  // Height of line numbering
        _linesTextArea.style.width = _iLinesTextWidth + "px";                 // Width of line numbering
        _linesTextArea.style.position = "absolute";
        _linesTextArea.style.overflow = 'hidden';                                // Hide scrollbar
        _linesTextArea.style.textAlign = 'right';                                 // Number align
        _linesTextArea.style.paddingRight = '0.02em';                                // Right padding rendering
        _linesTextArea.style.marginLeft = _iLinesTextLeftMargin + "px";
        _linesTextArea.style.lineHeight = _iLineHeight + "px";                     // Set line height in pixels
        _linesTextArea.innerHTML = string;                                  // Firefox renders \n linebreak
        _linesTextArea.innerText = string;                                  // IE6 renders \n line break
        _linesTextArea.style.zIndex = 0;                                       // "Calque" zero
        _linesTextArea.readOnly = true;

        // Set source code textarea object
        _srcCodeTextArea.style.zIndex = 1;                                       // "Calque" one
        _srcCodeTextArea.style.position = "relative";
        _srcCodeTextArea.style.lineHeight = _iLineHeight + "px";                     // Set line height in pixels
        _srcCodeTextArea.parentNode.insertBefore(_linesTextArea, _srcCodeTextArea.nextSibling);
        _srcCodeTextArea.readOnly = true;
        _srcCodeTextArea.focus();

        // Display lines
        setLinesTextAreaPosition();

        // Update lines display on user actions 
        _srcCodeTextArea.onkeydown = function() { setLinesTextAreaPosition(); }
        _srcCodeTextArea.onmouseup = function() { setLinesTextAreaPosition(); _moveUserMouse = false; }
        _srcCodeTextArea.onmousemove = function() { if (_moveUserMouse) { setLinesTextAreaPosition(); } }
        _srcCodeTextArea.onscroll = function() { setLinesTextAreaPosition(); _moveUserMouse = false; }
        _srcCodeTextArea.onmousedown = function() { setLinesTextAreaPosition(); _moveUserMouse = true; }
    }
}

// Resize source code viex text area considering container frame size
// ------
function resizeSrcCodeView() {
    // Set source code text area height & width
    _srcCodeTextArea.style.height = (_srcCodeFrame.scrollHeight * _fRatioHeight) + "px";
    _srcCodeTextArea.style.width = (_srcCodeFrame.scrollWidth * _fRatioWidth) + "px";

    // Set new lines text area height
    _linesTextArea.style.height = (_srcCodeTextArea.offsetHeight) + "px";    // Height of line numbering
}

// Positionning source code textarea considering lines text area width
// ------
function setLinesTextAreaPosition() {
    _linesTextArea.scrollTop = _srcCodeTextArea.scrollTop;
    _linesTextArea.style.top = (_srcCodeTextArea.offsetTop) + "px";
    _linesTextArea.style.left = (_srcCodeTextArea.offsetLeft - _iLinesTextWidth - _iLinesTextLeftMargin) + "px";
}

// Scroll text area to given line
// ------
function srcCodeMoveToLine(iLine) {
    var iConfortView = _isrcCodeScrollConfort;
    var iTargetLine = iLine - iConfortView;

    // Two lines above max for better visibility
    while ((iTargetLine < 0) && (iConfortView > 0)) {
        iConfortView--;
        iTargetLine = iLine - iConfortView;
    }

    // Go to given line
    parent.sourceFile._linesTextArea.scrollTop = parent.sourceFile._srcCodeTextArea.scrollTop = (iTargetLine) * _iLineHeight;
}

// Count lines of given text
// ------
function countLines(aText) {
    // Getting text line by line (g = global search) using line pattern
    _linePattern.lastIndex = 0;
    var lineCount = 0;
    var matchLine, lineIndex, matchText;

    // For each line, get line text and start index
    while ((matchLine = _linePattern.exec(aText))) {
        lineCount++;
        lineIndex = matchLine.index;
        matchText = matchLine[0];
    }

    return lineCount;
}

// Scroll to the given line and "highlight" (select...) given word or whole line
// ------
function srcCodeHighlight(aWord, iLine) {
    var iGlobalWordIndex = -1;
    var intLine = parseInt(iLine);

    // Get browser name
    _detectedBrowserName = navigator.appName;
    //alert("_detectedBrowserName: "+_detectedBrowserName);

    // Go to given line (two lines above for better visibility if possible)
    srcCodeMoveToLine(intLine);

    // Get source code text
    var aSrcCodeText = parent.sourceFile._srcCodeTextArea.value;

    // If no word is given, select the whole line
    if (aWord.length == 0) {
        selectLineAtLineNum(aSrcCodeText, intLine);
    }
    else {
        // Get global index of "aWord" inside "aSrcCodeText" at line "intLine" 
        iGlobalWordIndex = selectWordAtLineNum(aSrcCodeText, aWord, intLine);

        // "aWord" was not found at the given line. Search above or below.
        if (iGlobalWordIndex == -1) {
            var iWordLineScope = 1;
            while ((iWordLineScope <= _iMaxWordLineScope) && (iGlobalWordIndex == -1)) {
                //alert("Look above");
                // Try line above
                iGlobalWordIndex = selectWordAtLineNum(aSrcCodeText, aWord, (intLine - iWordLineScope));

                if (iGlobalWordIndex == -1) {
                    //alert("Look below");
                    // Try line below
                    iGlobalWordIndex = selectWordAtLineNum(aSrcCodeText, aWord, (intLine + iWordLineScope));
                }

                // Increase Scope
                iWordLineScope++;
            }
        }

        // "aWord" was not found around the given line. Select the whole given line.
        if (iGlobalWordIndex == -1) {
            //alert("Not found!:");
            selectLineAtLineNum(aSrcCodeText, intLine);
        }
    }
}

// Highlight (Select...) "aWord" inside "aSrcCodeText" at line "intLine"
// -------- 
function selectWordAtLineNum(aText, aWord, intLine) {
    var iLineWordIndex = -1;
    var iGlobalWordIndex = -1;

    // Getting text line by line (g = global search) using line pattern
    _linePattern.lastIndex = 0;
    var lineCount = 0;
    var matchLine, lineIndex, matchText;

    // For each line, get line text and start index
    while ((matchLine = _linePattern.exec(aText)) && (lineCount != intLine)) {
        lineCount++;
        lineIndex = matchLine.index;
        matchText = matchLine[0];
    }

    if (matchText) {
        // Get word index at the reached line
        var regex = new RegExp("(" + aWord + ")", "g")
        iLineWordIndex = matchText.search(regex);

        if (iLineWordIndex != -1) {
            // Put focus on source code text area for word selection
            parent.sourceFile._srcCodeTextArea.focus();

            // Firefox case
            if (parent.sourceFile._srcCodeTextArea.setSelectionRange) {
                // "Firefox" global index
                iGlobalWordIndex = iLineWordIndex + lineIndex;

                // Make selection for highlight
                parent.sourceFile._srcCodeTextArea.setSelectionRange(iGlobalWordIndex, iGlobalWordIndex + aWord.length);
            }
            else // IE6 case
            {
                // "IE" global index
                iGlobalWordIndex = iLineWordIndex + lineIndex - intLine + 1;

                if (iGlobalWordIndex > 0) {
                    // Create selection for highlight
                    var oTextRange = parent.sourceFile._srcCodeTextArea.createTextRange();

                    // Set selection for highlight
                    oTextRange.collapse(true);
                    oTextRange.moveEnd('character', iGlobalWordIndex + aWord.length);
                    oTextRange.moveStart('character', iGlobalWordIndex);
                    oTextRange.select();
                }
                else {
                    iGlobalWordIndex = -1;
                }
            }
        }
        else {
            iGlobalWordIndex = -1;
        }
    }

    return iGlobalWordIndex;
}

// Highlight (Select...) a whole line inside "aSrcCodeText" at line "intLine"
// --------
function selectLineAtLineNum(aText, intLine) {
    // Get line start global index
    // ---------------------------
    var lineStartIndex, lineStopIndex;
    // Getting text line by line (g = global search) using line pattern
    _linePattern.lastIndex = 0;
    var lineCount = 0;
    var matchLine, lineIndex, matchText;
    var browserOffset = 0;

    // Get line start global index
    // ---------------------------
    while ((matchLine = _linePattern.exec(aText)) && (lineCount != intLine)) {
        lineCount++;
        lineIndex = matchLine.index - browserOffset;
        if (_detectedBrowserName == _IEAppName) {
            browserOffset++;
        }
        matchText = matchLine[0];
    }
    lineStartIndex = lineIndex;
    //alert(lineStartIndex);

    // Get next line start global index
    // ---------------------------
    // Getting text line by line (g = global search) using line pattern
    _linePattern.lastIndex = 0;
    lineCount = 0;

    // For each line, get line text and start index
    while ((matchLine = _linePattern.exec(aText)) && (lineCount != (intLine + 1))) {
        lineCount++;
        lineIndex = matchLine.index;
        matchText = matchLine[0];
    }
    lineStopIndex = lineIndex - 1 - browserOffset;
    //alert(lineStopIndex);

    // Select between previous start index and highlight
    // Put focus on source code text area for word selection
    parent.sourceFile._srcCodeTextArea.focus();

    // Firefox case
    if (parent.sourceFile._srcCodeTextArea.setSelectionRange) {
        // Make selection for highlight
        parent.sourceFile._srcCodeTextArea.setSelectionRange(lineStartIndex, lineStopIndex);
    }
    else // IE6 case
    {
        // "IE" global index
        iGlobalWordIndex = lineStartIndex - intLine + 1;

        if (iGlobalWordIndex > 0) {
            // Create selection for highlight
            var oTextRange = parent.sourceFile._srcCodeTextArea.createTextRange();

            // Set selection for highlight
            oTextRange.collapse(true);
            oTextRange.moveEnd('character', lineStopIndex);
            oTextRange.moveStart('character', lineStartIndex);
            oTextRange.select();
        }
        else {
            iGlobalWordIndex = -1;
        }
    }
}

// Load first report page into report menu
// --------
function loadit( element)
{

	var tabs=document.getElementById('tabs').getElementsByTagName("a");
	for (var i=0; i < tabs.length; i++)
	{
		if(tabs[i].href == element.href) 
			tabs[i].className="selected";
		else
			tabs[i].className="";
	}
}



